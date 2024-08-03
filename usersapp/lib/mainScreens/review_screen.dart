import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class SellersListScreen extends StatefulWidget {
  @override
  _SellersListScreenState createState() => _SellersListScreenState();
}

class _SellersListScreenState extends State<SellersListScreen> {
  TextEditingController reviewController = TextEditingController();
  double rating = 0.0; // Initialize the rating variable
  String? selectedSellerId; // Initialize the selected seller ID

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sellers List'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('sellers').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child:
                  CircularProgressIndicator(), // Loading indicator while data is being fetched
            );
          }

          List<Map<String, dynamic>> sellersData = [];
          // Extracting document data (ID and Seller Name) from the snapshot
          snapshot.data!.docs.forEach((doc) {
            sellersData.add({
              'id': doc.id,
              'sellerName': doc['sellerName'],
            });
          });

          return Padding(
            padding:
                const EdgeInsets.all(16.0), // Add padding to the main content
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                DropdownButton<String>(
                  hint: Text('Select a Seller'),
                  value: selectedSellerId, // Initially no value is selected
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedSellerId =
                          newValue; // Update the selected seller ID
                    });
                  },
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 16.0,
                  ),
                  underline: Container(
                    height: 2,
                    color: Colors.blue,
                  ),
                  items: sellersData.map<DropdownMenuItem<String>>(
                      (Map<String, dynamic> seller) {
                    return DropdownMenuItem<String>(
                      value: seller['id'],
                      child: Text(
                        seller['sellerName'],
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14.0,
                        ),
                      ),
                    );
                  }).toList(),
                ),
                SizedBox(height: 16.0),
                RatingBar.builder(
                  initialRating: rating,
                  minRating: 1,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemSize: 40.0,
                  itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                  itemBuilder: (context, _) => Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (newRating) {
                    setState(() {
                      rating = newRating; // Update the rating state
                    });
                  },
                ),
                SizedBox(height: 16.0),
                TextField(
                  controller: reviewController,
                  decoration: InputDecoration(
                    hintText: 'Enter your review',
                    labelText: 'Review',
                    border:
                        OutlineInputBorder(), // Add a border to the text field
                  ),
                  maxLines: 3,
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    if (selectedSellerId != null &&
                        reviewController.text.isNotEmpty) {
                      FirebaseFirestore.instance.collection('reviews').add({
                        'sellerId': selectedSellerId,
                        'rating': rating,
                        'review': reviewController.text,
                      }).then((_) {
                        // Clear the review text and reset the rating
                        reviewController.clear();
                        setState(() {
                          rating = 0.0;
                          selectedSellerId = null;
                        });

                        // Show a SnackBar and then navigate back to the home screen
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Review submitted successfully!'),
                            duration: Duration(seconds: 2),
                          ),
                        );

                        // Navigate back immediately after showing the SnackBar
                        Navigator.pop(context);
                      }).catchError((error) {
                        // Handle errors if the review submission fails
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Failed to submit review: $error'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      });
                    } else {
                      // Show an error if no seller is selected or the review text is empty
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              'Please select a seller and enter a review.'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    }
                  },
                  child: Text('Submit Review'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
