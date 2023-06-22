import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smooth_star_rating_nsafe/smooth_star_rating.dart';
import 'package:users_app/global/global.dart';

class RateDeliverymanScreen extends StatefulWidget {

  String? assignedDeliverymanId;

  RateDeliverymanScreen({this.assignedDeliverymanId});

  @override
  State<RateDeliverymanScreen> createState() => _RateDeliverymanScreenState();
}




class _RateDeliverymanScreenState extends State<RateDeliverymanScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[850],
      body: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        backgroundColor: Colors.transparent,
        child: Container(
          margin: const EdgeInsets.all(8),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 22,),

              const Text(
                "Rate Deliveryman",
                style: TextStyle(
                  fontSize: 22,
                  letterSpacing: 2,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),

              const SizedBox(height: 22,),

              const Divider(height: 4, thickness: 4,),

              const SizedBox(height: 22,),

              SmoothStarRating(
                rating: countRatingStars,
                allowHalfRating: false,
                starCount: 5,
                color: Colors.green,
                borderColor: Colors.green,
                size: 46,
                onRatingChanged: (valueOfStarsChosen)
                {
                  countRatingStars = valueOfStarsChosen;

                  if(countRatingStars == 1)
                    {
                      setState(() {
                        titleStarsRating = "Very Bad";
                      });
                    }
                  if(countRatingStars == 2)
                  {
                    setState(() {
                      titleStarsRating = "Bad";
                    });
                  }
                  if(countRatingStars == 3)
                  {
                    setState(() {
                      titleStarsRating = "Good";
                    });
                  }
                  if(countRatingStars == 4)
                  {
                    setState(() {
                      titleStarsRating = "Very Good";
                    });
                  }
                  if(countRatingStars == 5)
                  {
                    setState(() {
                      titleStarsRating = "Excellent";
                    });
                  }
                },
              ),

              const SizedBox(height: 12,),

              Text(
                titleStarsRating,
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),

              const SizedBox(height: 18,),

              ElevatedButton(
                  onPressed: ()
                  {
                    DatabaseReference rateDeliverymanRef = FirebaseDatabase.instance.ref()
                        .child("deliverymen")
                        .child(widget.assignedDeliverymanId!)
                        .child("ratings");

                    rateDeliverymanRef.once().then((snap)
                    {
                      if(snap.snapshot.value == null)
                        {
                          rateDeliverymanRef.set(countRatingStars.toString());

                          SystemNavigator.pop();
                        }
                      else
                        {
                          double pastRatings = double.parse(snap.snapshot.value.toString());
                          double newAverageRatings = (pastRatings + countRatingStars) / 2;
                          rateDeliverymanRef.set(newAverageRatings.toString());

                          SystemNavigator.pop();
                        }

                      Fluttertoast.showToast(msg: "Restarting app now");
                    });

                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(horizontal: 60),
                  ),
                  child: const Text(
                    "Submit",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  )
              ),

              const SizedBox(height: 15,),
            ],
          ),
        ),
      ),
    );
  }
}
