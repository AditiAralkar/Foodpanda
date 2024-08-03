import 'package:flutter/material.dart';
import 'package:project/model/address.dart';
import 'package:project/splashScreen/splash_screen.dart';

class ShipmentAddressDesign extends StatelessWidget {
  final Address? model;
  final String? orderStatus;
  final String? orderId;
  final String? sellerId;
  final String? orderByUser;

  const ShipmentAddressDesign(
      {super.key,
      this.model,
      this.orderStatus,
      this.orderId,
      this.sellerId,
      this.orderByUser});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(10.0),
          child: Text(
            'Shipping Details:',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 6.0),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 90, vertical: 5),
          width: MediaQuery.of(context).size.width,
          child: Table(
            children: [
              TableRow(
                children: [
                  const Text("Name", style: TextStyle(color: Colors.black)),
                  Text(model?.name ?? 'N/A'), // Use null-aware operator
                ],
              ),
              TableRow(
                children: [
                  const Text("Phone Number",
                      style: TextStyle(color: Colors.black)),
                  Text(model?.phoneNumber ?? 'N/A'), // Use null-aware operator
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            model?.fullAddress ??
                'Address not available', // Use null-aware operator
            textAlign: TextAlign.justify,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Center(
            child: InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const MySplashScreen()));
              },
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.cyan,
                      Colors.amber,
                    ],
                    begin: FractionalOffset(0.0, 0.0),
                    end: FractionalOffset(1.0, 0.0),
                    stops: [0.0, 1.0],
                    tileMode: TileMode.clamp,
                  ),
                ),
                width: MediaQuery.of(context).size.width - 40.0,
                height: 50,
                child: Center(
                  child: Text(
                    orderStatus == "ended" ? "Go Back" : "Order Packing - Done",
                    style: const TextStyle(color: Colors.white, fontSize: 15.0),
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
