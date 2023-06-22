import 'package:firebase_auth/firebase_auth.dart';
import 'package:users_app/models/user_model.dart';

import '../models/direction_details_info.dart';

final FirebaseAuth fAuth = FirebaseAuth.instance;

User? currentFirebaseUser;
UserModel? userModelCurrentInfo;

List dList = []; // deliverymen keys info list

DirectionDetailsInfo? tripDirectionDetailsInfo;

String? chosenDeliverymanId="";

String cloudMessagingServerToken = "key=AAAAU_HM3Yc:APA91bENL57ndmrHLIJI4-cyFnyALwJ3TzmuC7dYylNIRU8jOOIdSwKzi8MW6uqVHaZdwuBbNwM8Y5gXI_CDXq2sncBGxlmU90YjXovtSl2IaLn-VeGzxopKEf5tjSuc3dkNdTYUAa02";

String userDropOffAddress = "";

String deliverymanCarDetails = "";
String deliverymanName = "";
String deliverymanPhone = "";
double countRatingStars = 0.0;
String titleStarsRating="";