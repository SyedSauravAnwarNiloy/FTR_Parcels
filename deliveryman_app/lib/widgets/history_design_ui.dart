import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/trips_history_model.dart';

class HistoryDesignUIWidget extends StatefulWidget {

  TripsHistoryModel? tripsHistoryModel;

  HistoryDesignUIWidget({this.tripsHistoryModel});

  @override
  State<HistoryDesignUIWidget> createState() => _HistoryDesignUIWidgetState();
}



class _HistoryDesignUIWidgetState extends State<HistoryDesignUIWidget>
{
  String formatDateAndTime(String dateTimeFromDB)
  {
    DateTime dateTime = DateTime.parse(dateTimeFromDB);
    
    String formattedDateTime = "${DateFormat.MMMd().format(dateTime)}, ${DateFormat.y().format(dateTime)}, ${DateFormat.jm().format(dateTime)}";

    return formattedDateTime;
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black54,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            //deliveryman name + fee Amount
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 6.0),
                  child: Text(
                    "User: ${widget.tripsHistoryModel!.userName}",
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(width: 12,),

                Text(
                  "৳ ${widget.tripsHistoryModel!.feeAmount}",
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 6,),

            //car details
            Row(
              children: [
                const Icon(
                  Icons.phone_android,
                  color: Colors.white,
                  size: 28,
                ),

                const SizedBox(width: 12,),

                Text(
                  "${widget.tripsHistoryModel!.userPhone}",
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10,),

            Row(
              children: [
                Image.asset(
                  "images/parcel.png",
                  height: 30,
                  width: 30,
                ),

                const SizedBox(width: 12,),

                Expanded(
                  child: Text(
                    "${widget.tripsHistoryModel!.parcel_type}   -   ${widget.tripsHistoryModel!.parcel_mass}kg   -   ${widget.tripsHistoryModel!.parcel_volume}cm^3",
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                    softWrap: true,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20,),
            
            //icon + pickup
            Row(
              children: [
                Image.asset(
                  "images/origin_logo.png",
                  height: 26,
                  width: 26,
                ),

                const SizedBox(width: 12,),

                Expanded(
                  child: Container(
                    child: Text(
                      "${widget.tripsHistoryModel!.originAddress}",
                      //overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                )
              ],
            ),

            const SizedBox(height: 14,),

            //icon + dropoff
            Row(
              children: [
                Image.asset(
                  "images/destination_logo.png",
                  height: 26,
                  width: 26,
                ),

                const SizedBox(width: 12,),

                Expanded(
                  child: Container(
                    child: Text(
                      "${widget.tripsHistoryModel!.destinationAddress}",
                      //overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                )
              ],
            ),

            const SizedBox(height: 12,),

            //trip date and time
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(""),
                Text(
                  formatDateAndTime(widget.tripsHistoryModel!.time!),
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 4,),

          ],
        ),
      ),
    );
  }
}
