import 'package:flutter/material.dart';
import 'package:usersapp/models/items.dart';

class CartItemDesign extends StatefulWidget {
  final Items? model;
  BuildContext? context;
  final int? quanNumber;

  CartItemDesign({
    this.model,
    this.context,
    this.quanNumber,
  });

  @override
  _CartItemDesignState createState() => _CartItemDesignState();
}

class _CartItemDesignState extends State<CartItemDesign> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.cyan,
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Row(
            children: [
              // image
              Image.network(
                widget.model!.thumbnailUrl!,
                width: 140,
                height: 120,
                fit: BoxFit.cover,
              ),
              const SizedBox(width: 6),

              // Expanded widget to prevent overflow
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // title
                    Text(
                      widget.model!.title!,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontFamily: "Kiwi",
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 1),

                    // quantity number
                    Row(
                      children: [
                        const Text(
                          "x ",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 25,
                            fontFamily: "Acme",
                          ),
                        ),
                        Text(
                          widget.quanNumber.toString(),
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 25,
                            fontFamily: "Acme",
                          ),
                        ),
                      ],
                    ),

                    // price
                    Row(
                      children: [
                        const Text(
                          "Price: ",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey,
                          ),
                        ),
                        const Text(
                          "₹ ",
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 16.0,
                          ),
                        ),
                        Text(
                          widget.model!.price.toString(),
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
