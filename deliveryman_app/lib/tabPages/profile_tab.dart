import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:project_files/global/global.dart';

import '../widgets/info_design_ui.dart';

class ProfileTabPage extends StatefulWidget {
  const ProfileTabPage({Key? key}) : super(key: key);

  @override
  State<ProfileTabPage> createState() => _ProfileTabPageState();
}

class _ProfileTabPageState extends State<ProfileTabPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[850],
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            //name
            Text(
              onlineDeliverymanData.name!,
              style: const TextStyle(
                fontSize: 50,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),

            Text(
              "$titleStarsRating Deliveryman",
              style: const TextStyle(
                fontSize: 18,
                color: Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(
              height: 20,
              width: 200,
              child: Divider(
                color: Colors.white,
                height: 2,
                thickness: 2,
              ),
            ),

            const SizedBox(height: 38,),

            InfoDesignUIWidget(
              textInfo: onlineDeliverymanData.phone!,
              iconData: Icons.phone_android,
            ),

            InfoDesignUIWidget(
              textInfo: onlineDeliverymanData.email!,
              iconData: Icons.email,
            ),

            InfoDesignUIWidget(
              textInfo: "${onlineDeliverymanData.car_color!} ${onlineDeliverymanData.car_model!} ${onlineDeliverymanData.car_number!}",
              iconData: Icons.directions_car,
            ),

            const SizedBox(height: 50,),

            ElevatedButton(
              onPressed: ()
              {
                fAuth.signOut();
                SystemNavigator.pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
              ),
              child: const Text(
                "Logout",
                style: TextStyle(color: Colors.black, fontSize: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
