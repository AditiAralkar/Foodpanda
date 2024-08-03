import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:usersapp/assistantMethods/address_changer.dart';
import 'package:usersapp/global/global.dart';
import 'package:usersapp/mainScreens/placed_order_screen.dart';
import 'package:usersapp/maps/maps.dart';
import 'package:usersapp/models/address.dart';
import 'package:provider/provider.dart';

class AddressDesign extends StatefulWidget
{
  final Address? model;
  final int? currentIndex;
  final int? value;
  final String? addressID;
  final double? totalAmount;
  final String? sellerUID;

  AddressDesign({
    this.model,
    this.currentIndex,
    this.value,
    this.addressID,
    this.totalAmount,
    this.sellerUID,
  });

  @override
  _AddressDesignState createState() => _AddressDesignState();
}



class _AddressDesignState extends State<AddressDesign>
{
  bool isAddressChecked = false;


  deleteAddress(String addressID)
  {

    FirebaseFirestore.instance
        .collection("users")
        .doc(sharedPreferences!.getString("uid"))
        .collection("userAddress")
        .doc(addressID)
        .delete().then((value) {
      FirebaseFirestore.instance
          .collection("userAddress")
          .doc(addressID)
          .delete();

      //Navigator.push(context, MaterialPageRoute(builder: (c)=> const MySplashScreen()));
      Fluttertoast.showToast(msg: "Address Deleted Successfully.");
    });
  }



  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ()
      {
        //select this address
        Provider.of<AddressChanger>(context, listen: false).displayResult(widget.value);
      },
      child: Card(
        color: Colors.cyan.withOpacity(0.4),
        child: Column(
          children: [

            //address info
            Row(
              children: [
                Radio(
                  groupValue: widget.currentIndex!,
                  value: widget.value!,
                  activeColor: Colors.amber,
                  onChanged: (val)
                  {
                    //provider
                    Provider.of<AddressChanger>(context, listen: false).displayResult(val);
                    print(val);
                  },
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: Table(
                        children: [
                          TableRow(
                            children: [
                              const Text(
                                "Name: ",
                                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                              ),
                              Text(widget.model!.name.toString()),
                            ],
                          ),
                          TableRow(
                            children: [
                              const Text(
                                "Phone Number: ",
                                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                              ),
                              Text(widget.model!.phoneNumber.toString()),
                            ],
                          ),
                          TableRow(
                            children: [
                              const Text(
                                "Flat Number: ",
                                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                              ),
                              Text(widget.model!.flatNumber.toString()),
                            ],
                          ),
                          TableRow(
                            children: [
                              const Text(
                                "City: ",
                                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                              ),
                              Text(widget.model!.city.toString()),
                            ],
                          ),
                          TableRow(
                            children: [
                              const Text(
                                "State: ",
                                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                              ),
                              Text(widget.model!.state.toString()),
                            ],
                          ),
                          TableRow(
                            children: [
                              const Text(
                                "Full Address: ",
                                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                              ),
                              Text(widget.model!.fullAddress.toString()),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),

            //button
            // ElevatedButton(
            //   child: const Text("Check on Maps with current location"),
            //   style: ElevatedButton.styleFrom(
            //     primary: Colors.black54,
            //   ),
            //   onPressed: ()
            //   {
            //     MapsUtils.openMapWithPosition(widget.model!.lat!, widget.model!.lng!);
            //
            //     //MapsUtils.openMapWithAddress(widget.model!.fullAddress!);
            //   },
            // ),



        ElevatedButton(
            child: const Text("Check on Maps with typed address"),
            style: ElevatedButton.styleFrom(
            primary: Colors.black54,
            ),
            onPressed: () {
              // MapsUtils.openMapWithPosition(widget.model!.lat!, widget.model!.lng!);
              MapsUtils.openMapWithAddress(widget.model!.fullAddress!);
              setState(() {
                  isAddressChecked = true; // Set the flag to true when the address is checked.
              });
            },
          ),

          // Conditionally show the "Proceed" button if the address is checked.
          if (isAddressChecked && widget.value == Provider.of<AddressChanger>(context).count)
          ElevatedButton(
            child: const Text("Proceed"),
                style: ElevatedButton.styleFrom(
                primary: Colors.green,
            ),
            onPressed: () {
            Navigator.push(
            context,
            MaterialPageRoute(
              builder: (c) => PlacedOrderScreen(
                  addressID: widget.addressID,
                  totalAmount: widget.totalAmount,
                  sellerUID: widget.sellerUID,
              ),
            ),
          );
        },
      )
      else
          Container(),


            const SizedBox(height: 10,),

            ElevatedButton(
              child: const Text("Delete address"),
              style: ElevatedButton.styleFrom(
                primary: Colors.black54,
              ),
              onPressed: () {
                deleteAddress(widget.model!.addressID!);
              },
            ),


            // Center(
            //   child: InkWell(
            //     onTap: ()
            //     {
            //       //delete item
            //       print("Address ID = ") ;
            //       print(widget.model!.addressID!);
            //       deleteAddress(widget.model!.addressID!);
            //     },
            //     child: Container(
            //       color: Colors.black54,
            //       width: MediaQuery.of(context).size.width - 10,
            //       height: 50,
            //       child: const Center(
            //         child: Text(
            //           "Delete this Address",
            //           style: TextStyle(color: Colors.white, fontSize: 15),
            //         ),
            //       ),
            //     ),
            //   ),
            // ),

    // ElevatedButton(
            //   child: const Text("Check on Maps with typed address"),
            //   style: ElevatedButton.styleFrom(
            //     primary: Colors.black54,
            //   ),
            //   onPressed: ()
            //   {
            //     //MapsUtils.openMapWithPosition(widget.model!.lat!, widget.model!.lng!);
            //     MapsUtils.openMapWithAddress(widget.model!.fullAddress!);
            //   },
            // ),
            //
            // //button
            // widget.value == Provider.of<AddressChanger>(context).count
            //     ? ElevatedButton(
            //   child: const Text("Proceed"),
            //   style: ElevatedButton.styleFrom(
            //     primary: Colors.green,
            //   ),
            //   onPressed: ()
            //   {
            //     Navigator.push(
            //         context, MaterialPageRoute(
            //         builder: (c)=> PlacedOrderScreen(
            //           addressID: widget.addressID,
            //           totalAmount: widget.totalAmount,
            //           sellerUID: widget.sellerUID,
            //         )
            //     )
            //     );
            //   },
            // )
                //: Container(),
          ],
        ),
      ),
    );
  }
}
