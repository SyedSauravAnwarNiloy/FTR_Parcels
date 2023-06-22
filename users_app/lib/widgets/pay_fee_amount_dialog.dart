import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PayFeeAmountDialog extends StatefulWidget {
  double? feeAmount;

  PayFeeAmountDialog({this.feeAmount});

  @override
  State<PayFeeAmountDialog> createState() => _PayFeeAmountDialogState();
}




class _PayFeeAmountDialogState extends State<PayFeeAmountDialog> {
  @override
  Widget build(BuildContext context)
  {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      backgroundColor: Colors.white,
      child: Container(
        margin: const EdgeInsets.all(6),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey[850],
          borderRadius: BorderRadius.circular(6),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 20,),

            Text(
              "Delivery Fee Amount".toUpperCase(),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 20,),

            const Divider(
              thickness: 4,
              color: Colors.white,
            ),

            const SizedBox(height: 15,),

            Text(
              widget.feeAmount.toString(),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 50,
              ),
            ),

            const SizedBox(height: 10,),

            const Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                "Please pay this amount to the deliveryman",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
            ),

            const SizedBox(height: 20,),

            Padding(
              padding: const EdgeInsets.all(18.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                ),
                  onPressed: ()
                  {
                    Future.delayed(const Duration(milliseconds: 2000), ()
                    {
                      Navigator.pop(context, "fee Paid");
                    });
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Pay Fee",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "৳${widget.feeAmount!}",
                        style: const TextStyle(
                          fontSize: 20,
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  )
              ),
            ),

            const SizedBox(height: 10,),
          ],
        ),
      ),
    );
  }
}
