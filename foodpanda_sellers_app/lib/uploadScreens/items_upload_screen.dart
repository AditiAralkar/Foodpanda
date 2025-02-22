import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project/global/global.dart';
import 'package:project/mainScreens/home_screen.dart';
import 'package:project/model/menus.dart';
import 'package:project/widgets/error_dialog.dart';
import 'package:project/widgets/progress_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as storageRef;



class ItemsUploadScreen extends StatefulWidget
{
  final Menus? model;
  const ItemsUploadScreen({super.key, this.model});


  @override
  _ItemsUploadScreenState createState() => _ItemsUploadScreenState();
}



class _ItemsUploadScreenState extends State<ItemsUploadScreen>
{
  XFile? imageXFile;
  final ImagePicker _picker = ImagePicker();

  TextEditingController shortInfoController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();

  bool uploading = false;
  String uniqueIdName = DateTime.now().millisecondsSinceEpoch.toString();

  defaultScreen()
  {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.cyan,
                  Colors.amber,
                ],
                begin:  FractionalOffset(0.0, 0.0),
                end:  FractionalOffset(1.0, 0.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp,
              )
          ),
        ),
        title: const Text(
          "Add New Items",
          style: TextStyle(fontSize: 30, fontFamily: "Lobster"),
        ),
        centerTitle: true,
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white,),
          onPressed: ()
          {
            Navigator.push(context, MaterialPageRoute(builder: (c)=> const HomeScreen()));
          },
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.cyan,
                Colors.amber,
              ],
              begin:  FractionalOffset(0.0, 0.0),
              end:  FractionalOffset(1.0, 0.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp,
            )
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.shop_two, color: Colors.white, size: 200.0,),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.amber),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                onPressed: ()
                {
                  takeImage(context);
                },
                child: const Text(
                  "Add New Item",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  takeImage(mContext)
  {
    return showDialog(
      context: mContext,
      builder: (context)
      {
        return SimpleDialog(
          title: const Text("Menu Image", style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold),),
          children: [
            SimpleDialogOption(
              onPressed: captureImageWithCamera,
              child: const Text(
                "Capture with Camera",
                style: TextStyle(color: Colors.grey),
              ),
            ),
            SimpleDialogOption(
              onPressed: pickImageFromGallery,
              child: const Text(
                "Select from Gallery",
                style: TextStyle(color: Colors.grey),
              ),
            ),
            SimpleDialogOption(
              child: const Text(
                "Cancel",
                style: TextStyle(color: Colors.red),
              ),
              onPressed: ()=> Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }

  captureImageWithCamera() async {
    Navigator.pop(context);

    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    double maxHeight = screenHeight * 0.5;
    double maxWidth = screenWidth * 0.5;

    imageXFile = await _picker.pickImage(
      source: ImageSource.camera,
      maxHeight: maxHeight,
      maxWidth: maxWidth,
    );

    setState(() {
      // Set the state variable for the image
      imageXFile;
    });
  }




  pickImageFromGallery() async
  {
    Navigator.pop(context);

    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    double maxHeight = screenHeight * 0.5; // You can adjust the multiplier as needed
    double maxWidth = screenWidth * 0.5;


    imageXFile = await _picker.pickImage(
      source: ImageSource.gallery,
      // maxHeight: 720 ,
      // maxWidth: 1280,
      maxHeight: maxHeight.toDouble(),
      maxWidth: maxWidth.toDouble(),
    );

    setState(() {
      imageXFile;
    });
  }


  itemsUploadFormScreen()
  {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.cyan,
                  Colors.amber,
                ],
                begin:  FractionalOffset(0.0, 0.0),
                end:  FractionalOffset(1.0, 0.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp,
              )
          ),
        ),
        title: const Text(
          "Uploading New Item",
          style: TextStyle(fontSize: 20, fontFamily: "Lobster"),
        ),
        centerTitle: true,
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white,),
          onPressed: ()
          {
            clearMenusUploadForm();
          },
        ),
        actions: [
          TextButton(
            onPressed: uploading ? null : ()=> validateUploadForm(),
            child: const Text(
              "Add",
              style: TextStyle(
                color: Colors.cyan,
                fontWeight: FontWeight.bold,
                fontSize: 18,
                fontFamily: "Varela",
                letterSpacing: 3,
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        children: [
          uploading == true ? linearProgress() : const Text(""),
          SizedBox(
            height: 230,
            width: MediaQuery.of(context).size.width * 0.8,
            child: Center(
              child: AspectRatio(
                aspectRatio: 16/9,
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: FileImage(
                          File(imageXFile!.path)
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const Divider(
            color: Colors.amber,
            thickness: 1,
          ),
          ListTile(
            leading: const Icon(Icons.perm_device_information,  color: Colors.cyan,),
            title: SizedBox(
              width: 250,
              child: TextField(
                style: const TextStyle(color: Colors.black),
                controller: shortInfoController,
                decoration: const InputDecoration(
                  hintText: "info",
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          const Divider(
            color: Colors.amber,
            thickness: 1,
          ),
          ListTile(
            leading: const Icon(Icons.title,  color: Colors.cyan,),
            title: SizedBox(
              width: 250,
              child: TextField(
                style: const TextStyle(color: Colors.black),
                controller: titleController,
                decoration: const InputDecoration(
                  hintText: "title",
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          const Divider(
            color: Colors.amber,
            thickness: 1,
          ),
          ListTile(
            leading: const Icon(Icons.description,  color: Colors.cyan,),
            title: SizedBox(
              width: 250,
              child: TextField(
                style: const TextStyle(color: Colors.black),
                controller: descriptionController,
                decoration: const InputDecoration(
                  hintText: "description",
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          const Divider(
            color: Colors.amber,
            thickness: 1,
          ),
          ListTile(
            leading: const Icon(Icons.camera,  color: Colors.cyan,),
            title: SizedBox(
              width: 250,
              child: TextField(
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.black),
                controller: priceController,
                decoration: const InputDecoration(
                  hintText: "price",
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          const Divider(
            color: Colors.amber,
            thickness: 1,
          ),
        ],
      ),
    );
  }

  clearMenusUploadForm()
  {
    setState(() {
      shortInfoController.clear();
      titleController.clear();
      priceController.clear();
      descriptionController.clear();

      imageXFile = null;
    });
  }

  validateUploadForm() async
  {
    if(imageXFile != null)
    {
      if(shortInfoController.text.isNotEmpty && titleController.text.isNotEmpty && descriptionController.text.isNotEmpty && priceController.text.isNotEmpty)
      {
        setState(() {
          uploading = true;
        });

        //upload image
        String downloadUrl = await uploadImage(File(imageXFile!.path));

        //save info to firestore
        saveInfo(downloadUrl);
      }
      else
      {
        showDialog(
            context: context,
            builder: (c)
            {
              return const ErrorDialog(
                message: "Please write title and info for menu.",
              );
            }
        );
      }
    }
    else
    {
      showDialog(
          context: context,
          builder: (c)
          {
            return const ErrorDialog(
              message: "Please pick an image for menu.",
            );
          }
      );
    }
  }

  saveInfo(String downloadUrl)
  {
    final ref = FirebaseFirestore.instance
        .collection("sellers")
        .doc(sharedPreferences!.getString("uid"))
        .collection("menus").doc(widget.model!.menuID)
        .collection("items");

    ref.doc(uniqueIdName).set({
      "itemID": uniqueIdName,
      "menuID": widget.model!.menuID,
      "sellerUID": sharedPreferences!.getString("uid"),
      "sellerName": sharedPreferences!.getString("name"),
      "shortInfo": shortInfoController.text.toString(),
      "longDescription": descriptionController.text.toString(),
      "price": int.parse(priceController.text),
      "title": titleController.text.toString(),
      "publishedDate": DateTime.now(),
      "status": "available",
      "thumbnailUrl": downloadUrl,
    }).then((value)
    {
      final itemsRef = FirebaseFirestore.instance
          .collection("items");

      itemsRef.doc(uniqueIdName).set({
        "itemID": uniqueIdName,
        "menuID": widget.model!.menuID,
        "sellerUID": sharedPreferences!.getString("uid"),
        "sellerName": sharedPreferences!.getString("name"),
        "shortInfo": shortInfoController.text.toString(),
        "longDescription": descriptionController.text.toString(),
        "price": int.parse(priceController.text),
        "title": titleController.text.toString(),
        "publishedDate": DateTime.now(),
        "status": "available",
        "thumbnailUrl": downloadUrl,
      });
    }).then((value){
      clearMenusUploadForm();

      setState(() {
        uniqueIdName = DateTime.now().millisecondsSinceEpoch.toString();
        uploading = false;
      });
    });
  }

  uploadImage(mImageFile) async
  {
    storageRef.Reference reference = storageRef.FirebaseStorage
        .instance
        .ref()
        .child("items");

    storageRef.UploadTask uploadTask = reference.child("$uniqueIdName.jpg").putFile(mImageFile);

    storageRef.TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});

    String downloadURL = await taskSnapshot.ref.getDownloadURL();

    return downloadURL;
  }

  @override
  Widget build(BuildContext context)
  {
    return imageXFile == null ? defaultScreen() : itemsUploadFormScreen();
  }
}
