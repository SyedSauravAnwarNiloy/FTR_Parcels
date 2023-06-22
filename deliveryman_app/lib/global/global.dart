import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:project_files/models/deliveryman_data.dart';
import '../models/user_model.dart';



final FirebaseAuth fAuth = FirebaseAuth.instance;
User? currentFirebaseUser;
UserModel? userModelCurrentInfo;
StreamSubscription<Position>? streamSubscriptionPosition;
StreamSubscription<Position>? streamSubscriptionDeliverymanLivePosition;
Position? deliverymanCurrentPosition;
DeliverymanData onlineDeliverymanData = DeliverymanData();
String? deliverymanVehicleType = "";
String titleStarsRating = "Good";
bool isDeliverymanActive = false;
String statusText = "Now Offline";
Color statusColor = Colors.grey;