import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project/mainScreens/home_screen.dart';
import 'package:project/widgets/custom_text_field.dart';
import 'package:project/widgets/error_dialog.dart';
import 'package:project/widgets/loading_dialog.dart';
import 'package:firebase_storage/firebase_storage.dart' as fStorage;
import 'package:shared_preferences/shared_preferences.dart';

import '../global/global.dart';



class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
{
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  XFile? imageXFile;
  final ImagePicker _picker = ImagePicker();

  Position? position;
  List<Placemark>? placeMarks;

  String sellerImageUrl = "";
  String completeAddress = "";

  Future<void> _getImage() async
  {
    imageXFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      imageXFile;
    });
  }

  getCurrentLocation() async
  {
    LocationPermission permission = await Geolocator.requestPermission();
    Position newPosition = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
      position = newPosition;
      placeMarks = await placemarkFromCoordinates(
      position!.latitude,
      position!.longitude,
    );
    Placemark pMark = placeMarks![0];

    completeAddress = '${pMark.subThoroughfare} ${pMark.thoroughfare}, ${pMark.subLocality} ${pMark.locality}, ${pMark.subAdministrativeArea}, ${pMark.administrativeArea} ${pMark.postalCode}, ${pMark.country}';

    locationController.text = completeAddress;
  }

  Future<void> formValidation() async
  {
    if (imageXFile == null) {
      showDialog(
          context: context,
          builder: (c) {
            return const ErrorDialog(
              message: "Please select an image.",
            );
          }
      );
    }
    else {
      if (passwordController.text == confirmPasswordController.text) {
        if (confirmPasswordController.text.isNotEmpty &&
            emailController.text.isNotEmpty && nameController.text.isNotEmpty &&
            phoneController.text.isNotEmpty &&
            locationController.text.isNotEmpty) {
          //start uploading image
          showDialog(
              context: context,
              builder: (c) {
                return const LoadingDialog(
                  message: "Registering Account",
                );
              }
          );

          String fileName = DateTime
              .now()
              .millisecondsSinceEpoch
              .toString();
          fStorage.Reference reference = fStorage.FirebaseStorage.instance.ref()
              .child("sellers")
              .child(fileName);
          fStorage.UploadTask uploadTask = reference.putFile(
              File(imageXFile!.path));
          fStorage.TaskSnapshot taskSnapshot = await uploadTask
              .whenComplete(() {});
          await taskSnapshot.ref.getDownloadURL().then((url) {
            sellerImageUrl = url;

            //save info to firestore
            authenticateSellerAndSignUp();
          });
        }
        else {
          showDialog(
              context: context,
              builder: (c) {
                return const ErrorDialog(
                  message: "Please write the complete required info for Registration.",
                );
              }
          );
        }
      }
      else {
        showDialog(
            context: context,
            builder: (c) {
              return const ErrorDialog(
                message: "Password do not match.",
              );
            }
        );
      }
    }
  }

  Future saveDataToFirestore(User currentUser) async
  {
    FirebaseFirestore.instance.collection("sellers").doc(currentUser.uid).set({
      "sellerUID": currentUser.uid,
      "sellerEmail": currentUser.email,
      "sellerName": nameController.text.trim(),
      "sellerAvatarUrl": sellerImageUrl,
      "phone": phoneController.text.trim(),
      "address": completeAddress,
      "status": "approved",
      "earnings": 0.0,
      "lat": position!.latitude,
      "lng": position!.longitude,
    });

    //save data locally
    sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences!.setString("uid", currentUser.uid);
    await sharedPreferences!.setString("email", currentUser.email.toString());
    await sharedPreferences!.setString("name", nameController.text.trim());
    await sharedPreferences!.setString("photoUrl", sellerImageUrl);
  }

  void authenticateSellerAndSignUp() async
  {
    User? currentUser;
    await firebaseAuth.createUserWithEmailAndPassword(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    ).then((auth) {
      currentUser = auth.user;
    }) .catchError((error){
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (c)
          {
            return ErrorDialog(
              message: error.message.toString(),
            );
          }
      );
    });

    if (currentUser != null) {
      saveDataToFirestore(currentUser!).then((value) {
        Navigator.pop(context);
        //send user to homePage
        Route newRoute = MaterialPageRoute(builder: (c) => const HomeScreen());
        Navigator.pushReplacement(context, newRoute);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          const SizedBox(height: 10,),
          InkWell(
            onTap : ()
              {
                _getImage();
              },
            child: CircleAvatar(
              radius: MediaQuery.of(context).size.width * 0.20,
              backgroundColor: Colors.white,
              backgroundImage: imageXFile==null ? null : FileImage(File(imageXFile!.path)),
              child: imageXFile==null
                  ?
              Icon(
                Icons.add_photo_alternate,
                size: MediaQuery.of(context).size.width * 0.20,
                color: Colors.grey,
              ): null,
            ),
          ),
          const SizedBox(height: 10,),
          Form(
            key: _formKey,
            child: Column(
            children: [
              CustomTextField(
                data: Icons.person,
                controller: nameController,
                hintText: "Name",
                isObsecre: false,
              ),
              CustomTextField(
                data: Icons.email,
                controller: emailController,
                hintText: "Email",
                isObsecre: false,
              ),
              CustomTextField(
                data: Icons.lock,
                controller: passwordController,
                hintText: "Password",
                isObsecre: true,
              ),
              CustomTextField(
                data: Icons.lock,
                controller: confirmPasswordController,
                hintText: "Confirm Password",
                isObsecre: true,
              ),
              CustomTextField(
                data: Icons.phone,
                controller: phoneController,
                hintText: "Phone",
                isObsecre: false,
              ),
              CustomTextField(
                data: Icons.my_location,
                controller: locationController,
                hintText: "Cafe/Restaurant Address",
                isObsecre: false,
                enabled: true,
              ),
              Container(
                width: 400,
                height: 40,
                alignment: Alignment.center,
                child: ElevatedButton.icon(
                  label: const Text(
                    "Get my Current Location",
                    style: TextStyle(color: Colors.white),
                  ),
                  icon: const Icon(
                    Icons.location_on,
                    color: Colors.white,
                  ),
                  onPressed: ()
                  {
                    getCurrentLocation();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    )
                  ),
                ),
              ),
            ]
          ),
          ),
          const SizedBox(height: 30,),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.purple,
              padding: const EdgeInsets.symmetric(horizontal: 50,vertical: 20),
            ),
            onPressed: ()
            {
              formValidation();
            },
            child: const Text(
              "Sign Up",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 30,),
        ],
      ),
    );
  }
}
