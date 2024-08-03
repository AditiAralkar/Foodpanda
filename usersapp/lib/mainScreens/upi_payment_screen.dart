import 'package:flutter/material.dart';
import 'package:upi_india/upi_india.dart';

class UPIPaymentScreen extends StatefulWidget {
  final num totalAmount;

  UPIPaymentScreen({required this.totalAmount});

  @override
  _UPIPaymentScreenState createState() => _UPIPaymentScreenState();
}

class _UPIPaymentScreenState extends State<UPIPaymentScreen> {
  UpiIndia _upiIndia = UpiIndia();
  late Future<List<UpiApp>> apps;

  @override
  void initState() {
    super.initState();
    apps = _upiIndia.getAllUpiApps(mandatoryTransactionId: false);
  }

  void initiateTransaction(UpiApp app) async {
    UpiResponse response = await _upiIndia.startTransaction(
      app: app,
      receiverUpiId: "receiver@upi",
      receiverName: "Receiver Name",
      transactionRefId: "TransactionRefId",
      transactionNote: "Payment for order",
      amount: widget.totalAmount.toDouble(),
    );

    handleResponse(response);
  }

  void handleResponse(UpiResponse response) {
    if (response.transactionId != null) {
      // Handle successful transaction
      print("Transaction successful: ${response.transactionId}");
    } else {
      // Handle error
      print("Transaction failed"); // Update based on actual response properties
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('UPI Payment', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blueAccent,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue[100]!, Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: FutureBuilder<List<UpiApp>>(
          future: apps,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text("Error fetching UPI apps"));
            }

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text("No UPI apps found"));
            }

            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                UpiApp app = snapshot.data![index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  elevation: 4,
                  child: ListTile(
                    title: Text(
                      app.name,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    leading: CircleAvatar(
                      backgroundImage: MemoryImage(app.icon),
                      radius: 25,
                    ),
                    onTap: () => initiateTransaction(app),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
