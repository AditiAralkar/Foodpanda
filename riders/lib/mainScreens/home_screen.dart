import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:riders/assisstantMethods/get_current_location.dart';
import 'package:riders/authentication/auth_screen.dart';
import 'package:riders/global/global.dart';
import 'package:riders/mainScreens/earnings_screen.dart';
import 'package:riders/mainScreens/history_screen.dart';
import 'package:riders/mainScreens/new_orders_screen.dart';
import 'package:riders/mainScreens/not_yet_delivered_screen.dart';
import 'package:riders/mainScreens/parcel_in_progress_screen.dart';
import 'package:riders/splashScreen/splash_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Card makeDashboardItem(String title, IconData iconData, int index) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.all(8),
      child: Container(
        decoration: index == 0 || index == 3 || index == 4
            ? const BoxDecoration(
                gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 195, 169, 169),
                  Color.fromARGB(255, 195, 169, 169),
                ],
                begin: FractionalOffset(0.0, 0.0),
                end: FractionalOffset(1.0, 0.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp,
              ))
            : const BoxDecoration(
                gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 195, 169, 169),
                  Color.fromARGB(255, 195, 169, 169),
                ],
                begin: FractionalOffset(0.0, 0.0),
                end: FractionalOffset(1.0, 0.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp,
              )),
        child: InkWell(
          onTap: () {
            if (index == 0) {
              //new available order
              Navigator.push(context,
                  MaterialPageRoute(builder: (c) => NewOrdersScreen()));
            }
            if (index == 1) {
              //parcel in progress
              Navigator.push(context,
                  MaterialPageRoute(builder: (c) => ParcelInProgressScreen()));
            }
            if (index == 2) {
              //not yet delivered
              Navigator.push(context,
                  MaterialPageRoute(builder: (c) => NotYetDeliveredScreen()));
            }
            if (index == 3) {
              //history
              Navigator.push(
                  context, MaterialPageRoute(builder: (c) => HistoryScreen()));
            }
            if (index == 4) {
              //total earning
              Navigator.push(
                  context, MaterialPageRoute(builder: (c) => EarningsScreen()));
            }
            if (index == 5) {
              //logout
              firebaseAuth.signOut().then((value) {
                Navigator.push(
                    context, MaterialPageRoute(builder: (c) => AuthScreen()));
              });
            }
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            verticalDirection: VerticalDirection.down,
            children: [
              const SizedBox(
                height: 50.0,
              ),
              Center(
                child: Icon(
                  iconData,
                  color: Color.fromARGB(255, 4, 4, 4),
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
              Center(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color.fromARGB(255, 0, 0, 0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  restrictBlockedRidersFromUsingApp() async {
    await FirebaseFirestore.instance
        .collection("riders")
        .doc(firebaseAuth.currentUser!.uid)
        .get()
        .then((snapshot) {
      if (snapshot.data()!["status"] != "approved") {
        Fluttertoast.showToast(msg: "You have been Blocked.");

        firebaseAuth.signOut();
        Navigator.push(
            context, MaterialPageRoute(builder: (c) => MySplashScreen()));
      } else {
        UserLocation uLocation = UserLocation();
        uLocation.getCurrentLocation();
        getPerParcelDeliveryAmount();
        getRiderPreviousEarnings();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    restrictBlockedRidersFromUsingApp();
  }

  getRiderPreviousEarnings() {
    FirebaseFirestore.instance
        .collection("riders")
        .doc(sharedPreferences!.getString("uid"))
        .get()
        .then((snap) {
      previousRiderEarnings = snap.data()!["earnings"].toString();
    });
  }

  getPerParcelDeliveryAmount() {
    FirebaseFirestore.instance
        .collection("perDelivery")
        .doc("6SoGm6Tn5cjc0rKiswO8")
        .get()
        .then((snap) {
      perParcelDeliveryAmount = snap.data()!["amount"].toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 195, 169, 169),
              Color.fromARGB(255, 195, 169, 169),
            ],
            begin: FractionalOffset(0.0, 0.0),
            end: FractionalOffset(1.0, 0.0),
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp,
          )),
        ),
        title: Text(
          "Welcome " + sharedPreferences!.getString("name")!,
          style: const TextStyle(
            fontSize: 25.0,
            color: Color.fromARGB(255, 13, 13, 13),
            fontFamily: "Signatra",
            letterSpacing: 2,
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 1),
        child: GridView.count(
          crossAxisCount: 2,
          padding: const EdgeInsets.all(2),
          children: [
            makeDashboardItem("New Available Orders", Icons.assessment, 0),
            makeDashboardItem("Parcels in progress", Icons.airport_shuttle, 1),
            makeDashboardItem("Not Yet Delivered", Icons.assessment, 2),
            makeDashboardItem("History", Icons.assessment, 3),
            makeDashboardItem("Total Earnings", Icons.assessment, 4),
            makeDashboardItem("Logout", Icons.assessment, 5),
          ],
        ),
      ),
    );
  }
}
