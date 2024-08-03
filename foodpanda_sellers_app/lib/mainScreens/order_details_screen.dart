import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project/model/address.dart';
import 'package:project/widgets/progress_bar.dart';
import 'package:project/widgets/shipment_address_design.dart';
import 'package:project/widgets/status_banner.dart';

class OrderDetailsScreen extends StatefulWidget {
  final String? orderID;
  const OrderDetailsScreen({super.key, this.orderID});

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  String orderStatus = "";
  String orderByUser = "";
  String sellerId = "";

  getOrderInfo() {
    FirebaseFirestore.instance
        .collection("orders")
        .doc(widget.orderID)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        // Cast to Map<String, dynamic>
        final data = documentSnapshot.data() as Map<String, dynamic>?;

        // Use null-aware operators to avoid null exceptions
        orderStatus = data?["status"]?.toString() ?? "";
        orderByUser = data?["orderBy"]?.toString() ?? "";
        sellerId = data?["sellerUID"]?.toString() ?? "";

        setState(() {}); // Call setState to update the UI after fetching data
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getOrderInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance
              .collection("orders")
              .doc(widget.orderID)
              .get(),
          builder: (c, snapshot) {
            Map<String, dynamic>? dataMap;
            if (snapshot.hasData) {
              dataMap = snapshot.data?.data()
                  as Map<String, dynamic>?; // Use null-aware casting
              orderStatus =
                  dataMap?["status"].toString() ?? ""; // Ensure non-null
            }
            return snapshot.hasData && dataMap != null
                ? Container(
                    child: Column(
                      children: [
                        StatusBanner(
                          status: dataMap["isSuccess"] ??
                              false, // Default value if null
                          orderStatus: orderStatus,
                        ),
                        const SizedBox(height: 10.0),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "₹ ${dataMap["totalAmount"] ?? 0}", // Default value if null
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Order Id = ${widget.orderID ?? 'N/A'}", // Handle null case
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Order at: ${dataMap["orderTime"] != null ? DateFormat("dd MMMM, yyyy - hh:mm aa").format(DateTime.fromMillisecondsSinceEpoch(int.parse(dataMap["orderTime"]))) : 'N/A'}",
                            style: const TextStyle(
                                fontSize: 16, color: Colors.grey),
                          ),
                        ),
                        const Divider(thickness: 4),
                        orderStatus == "ended"
                            ? Image.asset("images/delivered.jpg")
                            : Image.asset("images/packing.png"),
                        const Divider(thickness: 4),
                        FutureBuilder<DocumentSnapshot>(
                          future: FirebaseFirestore.instance
                              .collection("users")
                              .doc(orderByUser)
                              .collection("userAddress")
                              .doc(dataMap["addressID"])
                              .get(),
                          builder: (c, snapshot) {
                            return snapshot.hasData
                                ? ShipmentAddressDesign(
                                    model: Address.fromJson(snapshot.data!
                                        .data()! as Map<String, dynamic>),
                                    orderStatus: orderStatus,
                                    orderId: widget.orderID,
                                    sellerId: sellerId,
                                    orderByUser: orderByUser,
                                  )
                                : Center(child: circularProgress());
                          },
                        ),
                      ],
                    ),
                  )
                : Center(child: circularProgress());
          },
        ),
      ),
    );
  }
}
