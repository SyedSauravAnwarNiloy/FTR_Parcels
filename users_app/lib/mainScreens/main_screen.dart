import 'dart:async';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:users_app/assistants/assistant_methods.dart';
import 'package:users_app/assistants/geofire_assistant.dart';
import 'package:users_app/global/global.dart';
import 'package:users_app/mainScreens/parcel_info_screen.dart';
import 'package:users_app/mainScreens/rate_deliveryman_screen.dart';
import 'package:users_app/mainScreens/search_places_screen.dart';
import 'package:users_app/mainScreens/select_online_deliverymen_screen.dart';
import 'package:users_app/models/active_nearby_available_deliverymen.dart';
import 'package:users_app/widgets/my_drawer.dart';
import 'package:users_app/widgets/pay_fee_amount_dialog.dart';
import 'package:users_app/widgets/progress_dialog.dart';

import 'package:users_app/infoHandler/app_info.dart';

class MainScreen extends StatefulWidget {
  @override
  State<MainScreen> createState() => _MainScreenState();
}



class _MainScreenState extends State<MainScreen> {

  final Completer<GoogleMapController> _controllerGoogleMap = Completer<GoogleMapController>();
  GoogleMapController? newGoogleMapController;
  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  GlobalKey<ScaffoldState> sKey = GlobalKey<ScaffoldState>();
  double searchLocationContainerHeight = 250;
  double waitingResponseFromDeliverymanContainerHeight = 0;
  double assignedDeliverymanInfoContainerHeight = 0;

  Position? userCurrentPosition;
  var geoLocator = Geolocator();

  LocationPermission? _locationPermission;
  double bottomPaddingOfMap = 0;

  List<LatLng> pLineCoordinatesList = [];
  Set<Polyline> polyLineSet = {};

  Set<Marker> markerSet = {};
  Set<Circle> circleSet = {};

  String userName = "Your Name";
  String userEmail = "Your Email";

  bool openNavigationDrawer = true;
  bool activeNearbyDeliverymanKeysLoaded = false;

  BitmapDescriptor? activeNearbyIcon;

  List<ActiveNearbyAvailableDeliverymen> onlineNearbyAvailableDeliverymenList = [];

  DatabaseReference? referenceCourierRequest;
  String deliverymanStatus = "Deliveryman is coming";

  StreamSubscription<DatabaseEvent>? tripCourierReuqestInfoStreamSubscription;
  String userCourierRequestStatus = "";
  bool requestPositionInfo = true;

  blackThemeGoogleMap()
  {
    newGoogleMapController!.setMapStyle('''
                    [
                      {
                        "elementType": "geometry",
                        "stylers": [
                          {
                            "color": "#242f3e"
                          }
                        ]
                      },
                      {
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#746855"
                          }
                        ]
                      },
                      {
                        "elementType": "labels.text.stroke",
                        "stylers": [
                          {
                            "color": "#242f3e"
                          }
                        ]
                      },
                      {
                        "featureType": "administrative.locality",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#d59563"
                          }
                        ]
                      },
                      {
                        "featureType": "poi",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#d59563"
                          }
                        ]
                      },
                      {
                        "featureType": "poi.park",
                        "elementType": "geometry",
                        "stylers": [
                          {
                            "color": "#263c3f"
                          }
                        ]
                      },
                      {
                        "featureType": "poi.park",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#6b9a76"
                          }
                        ]
                      },
                      {
                        "featureType": "road",
                        "elementType": "geometry",
                        "stylers": [
                          {
                            "color": "#38414e"
                          }
                        ]
                      },
                      {
                        "featureType": "road",
                        "elementType": "geometry.stroke",
                        "stylers": [
                          {
                            "color": "#212a37"
                          }
                        ]
                      },
                      {
                        "featureType": "road",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#9ca5b3"
                          }
                        ]
                      },
                      {
                        "featureType": "road.highway",
                        "elementType": "geometry",
                        "stylers": [
                          {
                            "color": "#746855"
                          }
                        ]
                      },
                      {
                        "featureType": "road.highway",
                        "elementType": "geometry.stroke",
                        "stylers": [
                          {
                            "color": "#1f2835"
                          }
                        ]
                      },
                      {
                        "featureType": "road.highway",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#f3d19c"
                          }
                        ]
                      },
                      {
                        "featureType": "transit",
                        "elementType": "geometry",
                        "stylers": [
                          {
                            "color": "#2f3948"
                          }
                        ]
                      },
                      {
                        "featureType": "transit.station",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#d59563"
                          }
                        ]
                      },
                      {
                        "featureType": "water",
                        "elementType": "geometry",
                        "stylers": [
                          {
                            "color": "#17263c"
                          }
                        ]
                      },
                      {
                        "featureType": "water",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#515c6d"
                          }
                        ]
                      },
                      {
                        "featureType": "water",
                        "elementType": "labels.text.stroke",
                        "stylers": [
                          {
                            "color": "#17263c"
                          }
                        ]
                      }
                    ]
                ''');
  }

  checkIfLocationPermissionAllowed() async
  {
    _locationPermission = await Geolocator.requestPermission();

    if(_locationPermission == LocationPermission.denied)
      {
        _locationPermission = await Geolocator.requestPermission();
      }
  }

  locateUserPosition() async
  {
    Position cPosition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    userCurrentPosition = cPosition;

    LatLng latLngPosition = LatLng(userCurrentPosition!.latitude, userCurrentPosition!.longitude);

    CameraPosition cameraPosition = CameraPosition(target: latLngPosition, zoom: 14);

    newGoogleMapController!.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    if(!mounted) return;
    String humanReadableAddress = await AssistantMethods.searchAddressForGeographicCoordinates(userCurrentPosition!, context);
    //print("This is your address = " + humanReadableAddress);

    userName = userModelCurrentInfo!.name!;
    userEmail = userModelCurrentInfo!.email!;

    initializedGeoFireListener();

    if(!mounted) return;
    AssistantMethods.readTripsKeysForOnlineUser(context);
  }

  @override
  void initState() {
    super.initState();

    checkIfLocationPermissionAllowed();
  }

  saveCourierRequestInformation(Map parcelInfoMap)
  {
    // save courier request information
    referenceCourierRequest = FirebaseDatabase.instance.ref().child("all courier requests").push();

    var originLocation = Provider.of<AppInfo>(context, listen: false).userPickUpLocation;
    var destinationLocation = Provider.of<AppInfo>(context, listen: false).userDropOffLocation;

    Map originLocationMap =
    {
      "latitude": originLocation!.locationLatitude.toString(),
      "longitude": originLocation!.locationLongitude.toString(),
    };

    Map destinationLocationMap =
    {
      "latitude": destinationLocation!.locationLatitude.toString(),
      "longitude": destinationLocation!.locationLongitude.toString(),
    };

    String feeAmount = parcelInfoMap.remove("parcel_fee");

    Map userInformationMap =
    {
      "parcelInformation": parcelInfoMap,
      "origin": originLocationMap,
      "destination": destinationLocationMap,
      "time": DateTime.now().toString(),
      "userName": userModelCurrentInfo!.name,
      "userPhone": userModelCurrentInfo!.phone,
      "originAddress": originLocation.locationName,
      "destinationAddress": destinationLocation.locationName,
      "deliverymanId": "waiting",
    };

    referenceCourierRequest!.set(userInformationMap);

    tripCourierReuqestInfoStreamSubscription = referenceCourierRequest!.onValue.listen((eventSnap)
    async {
      if(eventSnap.snapshot.value == null)
        {
          return;
        }

      if((eventSnap.snapshot.value as Map)["car_details"] != null)
        {
          setState(() {
            deliverymanCarDetails = (eventSnap.snapshot.value as Map)["car_details"].toString();
          });
        }

      if((eventSnap.snapshot.value as Map)["deliverymanPhone"] != null)
      {
        setState(() {
          deliverymanPhone = (eventSnap.snapshot.value as Map)["deliverymanPhone"].toString();
        });
      }

      if((eventSnap.snapshot.value as Map)["deliverymanName"] != null)
      {
        setState(() {
          deliverymanName = (eventSnap.snapshot.value as Map)["deliverymanName"].toString();
        });
      }

      if((eventSnap.snapshot.value as Map)["status"] != null)
        {
          userCourierRequestStatus = (eventSnap.snapshot.value as Map)["status"].toString();
        }

      if((eventSnap.snapshot.value as Map)["deliverymanLocation"] != null)
        {
          double deliverymanCurrentPositionLat = double.parse((eventSnap.snapshot.value as Map)["deliverymanLocation"]["latitude"].toString());
          double deliverymanCurrentPositionLng = double.parse((eventSnap.snapshot.value as Map)["deliverymanLocation"]["longitude"].toString());
          
          LatLng deliverymanCurrentPositionLatLng = LatLng(deliverymanCurrentPositionLat, deliverymanCurrentPositionLng);

          //status = accepted
          if(userCourierRequestStatus == "accepted")
            {
              updateArrivalTimeToParcelPickupLocation(deliverymanCurrentPositionLng);
            }

          //status = arrived
          if(userCourierRequestStatus == "arrived")
          {
            setState(() {
              deliverymanStatus = "Deliveryman has arrived";
            });
          }

          //status = onTrip
          if(userCourierRequestStatus == "onTrip")
          {
            updateReachingTimeToDestinationLocation(deliverymanCurrentPositionLatLng);
          }

          //status = ended
          if(userCourierRequestStatus == "ended")
          {
            if((eventSnap.snapshot.value as Map)["feeAmount"] != null)
              {
                double feeAmount = double.parse((eventSnap.snapshot.value as Map)["feeAmount"].toString());

                var response = await showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext c)=> PayFeeAmountDialog(
                      feeAmount: feeAmount,
                    ),
                );

                if(response == "fee Paid")
                  {
                    //user can rate the deliveryman
                    if((eventSnap.snapshot.value as Map)["deliverymanId"] != null)
                      {
                        String assignedDeliverymanId = (eventSnap.snapshot.value as Map)["deliverymanId"].toString();

                        if(!mounted) return;
                        Navigator.push(context, MaterialPageRoute(builder: (c)=> RateDeliverymanScreen(
                          assignedDeliverymanId: assignedDeliverymanId,
                        )));

                        referenceCourierRequest!.onDisconnect();

                        tripCourierReuqestInfoStreamSubscription!.cancel();
                      }
                  }
              }
          }
        }
    });

    onlineNearbyAvailableDeliverymenList = GeoFireAssistant.activeNearbyAvailableDeliverymenList;
    searchNearestOnlineDeliverymen(feeAmount);
  }

  updateArrivalTimeToParcelPickupLocation(deliverymanCurrentPositionLatLng) async
  {
    if(requestPositionInfo == true)
      {
        requestPositionInfo = false;

        LatLng userParcelPickupPosition = LatLng(userCurrentPosition!.latitude, userCurrentPosition!.longitude);

        var directionDetailsInfo = await AssistantMethods.obtainOriginToDestinationDirectionDetails(
          deliverymanCurrentPositionLatLng,
          userParcelPickupPosition,
        );

        if(directionDetailsInfo == null)
          {
            return;
          }

        setState(() {
          deliverymanStatus = "Deliveryman is coming :: ${directionDetailsInfo.duration_text}";
        });

        requestPositionInfo = true;
      }
  }

  updateReachingTimeToDestinationLocation(deliverymanCurrentPositionLatLng) async
  {
    if(requestPositionInfo == true)
    {
      requestPositionInfo = false;

      var dropoffLocation = Provider.of<AppInfo>(context, listen: false).userDropOffLocation;

      LatLng destinationPosition = LatLng(
          dropoffLocation!.locationLatitude!,
          dropoffLocation!.locationLongitude!
      );

      var directionDetailsInfo = await AssistantMethods.obtainOriginToDestinationDirectionDetails(
        deliverymanCurrentPositionLatLng,
        destinationPosition,
      );

      if(directionDetailsInfo == null)
      {
        return;
      }

      setState(() {
        deliverymanStatus = "Delivery in progress :: ${directionDetailsInfo.duration_text}";
      });

      requestPositionInfo = true;
    }
  }

  searchNearestOnlineDeliverymen(String feeAmount) async
  {
    if(onlineNearbyAvailableDeliverymenList.length == 0)
      {
        // cancel/delete the courier request
        referenceCourierRequest!.remove();

        setState(() {
          polyLineSet.clear();
          markerSet.clear();
          circleSet.clear();
          pLineCoordinatesList.clear();
        });

        Fluttertoast.showToast(msg: "No online nearest Deliverymen available. Search again for deliverymen after some time. Restarting app now.");
        Future.delayed(const Duration(milliseconds: 4000), ()
        {
          SystemNavigator.pop();
        });


        return;
      }

    await retrieveOnlineDeliverymenInformation(onlineNearbyAvailableDeliverymenList);

    var response = await Navigator.push(context, MaterialPageRoute(builder: (c)=>
        SelectNearestActiveDeliverymenScreen(referenceCourierRequest: referenceCourierRequest, passedFeeAmount: feeAmount)));
    if(response == "Deliveryman Chosen.")
      {
        FirebaseDatabase.instance.ref()
            .child("deliverymen")
            .child(chosenDeliverymanId!)
            .once().then((snap)
        {
          if(snap.snapshot.value != null)
            {
              //send notification to that specific deliveryman
              sendNotificationToDeliverymanNow(chosenDeliverymanId!);

              //Waiting response from selected deliveryman ui
              showWaitingResponseFromDeliverymanUI();

              //Response from deliveryman
              FirebaseDatabase.instance.ref()
                  .child("deliverymen")
                  .child(chosenDeliverymanId!)
                  .child("newCourierRequest")
                  .onValue.listen((eventSnapshot)
              {
                //deliveryman cancel courier request :: push notification
                if(eventSnapshot.snapshot.value == "idle")
                  {
                    Fluttertoast.showToast(msg: "The deliveryman has cancelled your request. Please choose another deliveryman.");

                    Future.delayed(const Duration(milliseconds: 3000), ()
                    {
                      Fluttertoast.showToast(msg: "Restarting app now");
                      SystemNavigator.pop();
                    });
                  }

                //deliveryman accept courier request :: push notification
                if(eventSnapshot.snapshot.value == "accepted")
                {
                  //ui displaying assigned deliveryman information
                  showUIForAssignedDeliverymanInfo();
                }
              });
            }
          else
            {
              Fluttertoast.showToast(msg: "This deliveryman does not exist. Try Again");
            }
        });
      }
  }

  showUIForAssignedDeliverymanInfo()
  {
    setState(() {
      waitingResponseFromDeliverymanContainerHeight = 0;
      searchLocationContainerHeight = 0;
      assignedDeliverymanInfoContainerHeight = 250;


    });
  }

  showWaitingResponseFromDeliverymanUI()
  {
    setState(() {
      searchLocationContainerHeight = 0;
      waitingResponseFromDeliverymanContainerHeight = 250;
    });
  }

  sendNotificationToDeliverymanNow(String chosenDeliverymanId)
  {
    // assign/set courier request id to newCourierStatus in deliverymen parent node for that specific chosen Deliveryman
    FirebaseDatabase.instance.ref()
        .child("deliverymen")
        .child(chosenDeliverymanId!)
        .child("newCourierStatus").set(referenceCourierRequest!.key);

    //automate the push notification
    FirebaseDatabase.instance.ref()
        .child("deliverymen")
        .child(chosenDeliverymanId)
        .child("token").once().then((snap)
    {
      if(snap.snapshot.value != null)
        {
          String deviceRegistrationToken = snap.snapshot.value.toString();

          //send notification Now
          AssistantMethods.sendNotificationToDeliverymanNow(
              deviceRegistrationToken,
              referenceCourierRequest!.key.toString(),
              context,
          );

          Fluttertoast.showToast(msg: "Notification sent");
        }
      else
        {
          Fluttertoast.showToast(msg: "Error contacting deliveryman. Please choose another deliveryman");
          return;
        }

    });
  }

  retrieveOnlineDeliverymenInformation(List onlineNearestDeliverymenList) async
  {
    DatabaseReference ref = FirebaseDatabase.instance.ref().child("deliverymen");
    for(int i=0; i<onlineNearestDeliverymenList.length; i++)
      {
        await ref.child(onlineNearestDeliverymenList[i].deliverymanId.toString())
        .once()
        .then((dataSnapshot)
            {
              var deliverymenKeyInfo = dataSnapshot.snapshot.value;
              dList.add(deliverymenKeyInfo);
            });
      }
  }

  @override
  Widget build(BuildContext context) {
    createActiveNearbyDeliverymanIconMarker();

    return Scaffold(
      key: sKey,
      drawer: Container(
        width: 285,
        child: Theme(
          data: Theme.of(context).copyWith(
            canvasColor: Colors.grey[850],
          ),
          child: MyDrawer(
            name: userName,
            email: userEmail,
          ),
        ),
      ),
      body: Stack(
        children: [
          GoogleMap(
            padding: EdgeInsets.only(bottom: bottomPaddingOfMap),
            mapType: MapType.normal,
            myLocationEnabled: true,
            zoomGesturesEnabled: true,
            zoomControlsEnabled: true,
            initialCameraPosition: _kGooglePlex,
            polylines: polyLineSet,
            markers: markerSet,
            circles: circleSet,
            onMapCreated: (GoogleMapController controller)
            {
              _controllerGoogleMap.complete(controller);
              newGoogleMapController = controller;

              //for black theme google map
              blackThemeGoogleMap();

              setState(() {
                bottomPaddingOfMap = 250;
              });

              locateUserPosition();
            },
          ),

          //custom drawer button
          Positioned(
            top: 36,
            left: 32,
            child: GestureDetector(
              onTap: ()
              {
                if(openNavigationDrawer)
                  {
                    sKey.currentState!.openDrawer();
                  }
                else
                  {
                    //restart or refresh or minimize app programmatically
                    SystemNavigator.pop();
                  }
              },
              child: CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(
                  openNavigationDrawer ? Icons.menu : Icons.close,
                  color: Colors.black,
                )
              ),
            ),
          ),

          // ui for location search
          Positioned(
            bottom: 0,
            right: 0,
            left: 0,
            child: AnimatedSize(
              curve: Curves.easeIn,
              duration: const Duration(milliseconds: 120),
              child: Container(
                height: searchLocationContainerHeight,
                decoration: const BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    topLeft: Radius.circular(20),
                  )
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                  child: Column(
                    children: [
                      // From
                      Row(
                        children: [
                          const Icon(Icons.add_location_alt_outlined, color: Colors.red,),
                          const SizedBox(width: 15,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Set Parcel Pick-up Location",
                                style: TextStyle(color: Colors.grey, fontSize: 12),
                              ),
                              Text(
                                Provider.of<AppInfo>(context).userPickUpLocation != null
                                ? "${(Provider.of<AppInfo>(context).userPickUpLocation!.locationName!).substring(0, 30)}..."
                                : "Not getting current location",
                                style: const TextStyle(color: Colors.white, fontSize: 15),
                              )
                            ],
                          ),

                        ],
                      ),

                      const SizedBox(height: 12,),
                      const Divider(
                        height: 1,
                        thickness: 2,
                        color: Colors.grey,
                      ),
                      const SizedBox(height: 20,),

                      // To
                      GestureDetector(
                        onTap: () async
                        {
                          // go to search places screen
                          var responseFromSearchScreen = await Navigator.push(context, MaterialPageRoute(builder: (c)=> SearchPlacesScreen()));

                          if(responseFromSearchScreen == "obtainedDropOff")
                            {
                              setState(() {
                                openNavigationDrawer = false;
                              });

                              //draw routes - draw polyline
                              await drawPolyLineFromOriginToDestination();
                            }
                        },
                        child: Row(
                          children: [
                            const Icon(Icons.add_location_alt_outlined, color: Colors.blue,),
                            const SizedBox(width: 15,),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Set Parcel Destination Location",
                                  style: TextStyle(color: Colors.grey, fontSize: 12),
                                ),
                                Text(
                                  Provider.of<AppInfo>(context).userDropOffLocation != null
                                    ? Provider.of<AppInfo>(context).userDropOffLocation!.locationName!
                                    : "Receiver's Location",
                                  style: const TextStyle(color: Colors.white, fontSize: 14),
                                )
                              ],
                            ),

                          ],
                        ),
                      ),

                      const SizedBox(height: 12,),
                      const Divider(
                        height: 1,
                        thickness: 2,
                        color: Colors.grey,
                      ),
                      const SizedBox(height: 30,),
                      
                      ElevatedButton(
                        onPressed: () async {
                          if(Provider.of<AppInfo>(context, listen: false).userDropOffLocation != null)
                            {
                              var parcelInfoResponse = await Navigator.push(context, MaterialPageRoute(builder: (c)=> ParcelInfoScreen()));

                              saveCourierRequestInformation(parcelInfoResponse);
                            }
                          else
                            {
                              Fluttertoast.showToast(msg: "Please select destination location");
                            }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                        ),
                        child: const Text(
                          "Request Courier",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              )
            )
          ),

          //ui for waiting response from deliveryman
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: waitingResponseFromDeliverymanContainerHeight,
              decoration: const BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    topLeft: Radius.circular(20),
                  )
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Center(
                  child: AnimatedTextKit(
                    animatedTexts: [
                      FadeAnimatedText(
                        'Waiting for\nDeliveryman\'s response',
                        duration: const Duration(seconds: 6),
                        textAlign: TextAlign.center,
                        textStyle: const TextStyle(fontSize: 30.0, color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      ScaleAnimatedText(
                        'Please wait...',
                        duration: const Duration(seconds: 10),
                        textAlign: TextAlign.center,
                        textStyle: const TextStyle(fontSize: 32.0, color: Colors.white, fontFamily: 'Canterbury'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          //ui for displaying assigned deliveryman information
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: waitingResponseFromDeliverymanContainerHeight,
              decoration: const BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    topLeft: Radius.circular(20),
                  )
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        deliverymanStatus,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white54,
                        ),
                      ),
                    ),

                    const SizedBox(height: 20,),

                    const Divider(height: 2, thickness: 2, color: Colors.white54,),

                    const SizedBox(height: 20,),

                    //deliveryman name
                    Text(
                      deliverymanName,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white54,
                      ),
                    ),

                    const SizedBox(height: 20,),

                    //deliveryman vehicle details
                    Text(
                      deliverymanCarDetails,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white54,
                      ),
                    ),

                    const SizedBox(height: 2,),

                    const Divider(height: 2, thickness: 2, color: Colors.white54,),

                    const SizedBox(height: 20,),

                    //call deliveryman button
                    Center(
                      child: ElevatedButton.icon(
                        onPressed: ()
                        {

                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                        ),
                        icon: const Icon(
                          Icons.phone_android,
                          color: Colors.black54,
                          size: 22,
                        ),
                        label: const Text(
                          "Call Deliveryman",
                          style: TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              )
            )
          )
        ],
      )
    );
  }

  Future<void> drawPolyLineFromOriginToDestination() async
  {
    var originPosition = Provider.of<AppInfo>(context, listen: false).userPickUpLocation;
    var destinationPosition = Provider.of<AppInfo>(context, listen: false).userDropOffLocation;

    var originLatLng = LatLng(originPosition!.locationLatitude!, originPosition.locationLongitude!);
    var destinationLatLng = LatLng(destinationPosition!.locationLatitude!, destinationPosition.locationLongitude!);

    showDialog(
      context: context,
      builder: (BuildContext context) => ProgressDialog(message: "Please wait...",),
    );

    var directionDetailsInfo = await AssistantMethods.obtainOriginToDestinationDirectionDetails(originLatLng, destinationLatLng);
    setState(() {
      tripDirectionDetailsInfo = directionDetailsInfo;
    });


    Navigator.pop(context);

    PolylinePoints pPoints = PolylinePoints();
    List<PointLatLng> decodedPolyLinePointsResultList = pPoints.decodePolyline(directionDetailsInfo!.e_points!);

    pLineCoordinatesList.clear();

    if(decodedPolyLinePointsResultList.isNotEmpty)
      {
        decodedPolyLinePointsResultList.forEach((PointLatLng pointLatLng) {
          pLineCoordinatesList.add(LatLng(pointLatLng.latitude, pointLatLng.longitude));
        });
      }

    polyLineSet.clear();

    setState(() {
      Polyline polyline = Polyline(
        color: Colors.white,
        polylineId: const PolylineId("PolylineID"),
        jointType: JointType.round,
        points: pLineCoordinatesList,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        geodesic: true,
      );

      polyLineSet.add(polyline);
    });

    LatLngBounds boundsLatLng;
    if(originLatLng.latitude > destinationLatLng.latitude && originLatLng.longitude > destinationLatLng.longitude)
    {
      boundsLatLng = LatLngBounds(southwest: destinationLatLng, northeast: originLatLng);
    }
    else if(originLatLng.longitude > destinationLatLng.longitude)
    {
      boundsLatLng = LatLngBounds(
          southwest: LatLng(originLatLng.latitude, destinationLatLng.longitude),
          northeast: LatLng(destinationLatLng.latitude, originLatLng.longitude)
      );
    }
    else if(originLatLng.latitude > destinationLatLng.latitude) 
    {
      boundsLatLng = LatLngBounds(
        southwest: LatLng(destinationLatLng.latitude, originLatLng.longitude),
        northeast: LatLng(originLatLng.latitude, destinationLatLng.longitude),
      );
    }
    else
    {
      boundsLatLng = LatLngBounds(southwest: originLatLng, northeast: destinationLatLng);
    }

    newGoogleMapController!.animateCamera(CameraUpdate.newLatLngBounds(boundsLatLng, 65));

    Marker originMarker = Marker(
      markerId: const MarkerId("originID"),
      infoWindow: InfoWindow(title: originPosition.locationName, snippet: "Origin"),
      position: originLatLng,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    );

    Marker destinationMarker = Marker(
      markerId: const MarkerId("destinationID"),
      infoWindow: InfoWindow(title: destinationPosition.locationName, snippet: "Destination"),
      position: destinationLatLng,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
    );

    setState(() {
      markerSet.add(originMarker);
      markerSet.add(destinationMarker);
    });

    Circle originCircle = Circle(
      circleId: const CircleId("originID"),
      fillColor: Colors.white,
      radius: 12,
      strokeWidth: 3,
      strokeColor: Colors.red,
      center: originLatLng,
    );

    Circle destinationCircle = Circle(
      circleId: const CircleId("destinationID"),
      fillColor: Colors.white,
      radius: 12,
      strokeWidth: 3,
      strokeColor: Colors.blue,
      center: destinationLatLng,
    );

    setState(() {
      circleSet.add(originCircle);
      circleSet.add(destinationCircle);
    });
  }

  initializedGeoFireListener() {
    Geofire.initialize("activeDeliverymen");

    Geofire.queryAtLocation(
        userCurrentPosition!.latitude, userCurrentPosition!.longitude, 10)!
        .listen((map) {
      print(map);
      if (map != null) {
        var callBack = map['callBack'];

        //latitude will be retrieved from map['latitude']
        //longitude will be retrieved from map['longitude']

        switch (callBack) {
          //whenever any deliveryman becomes online
          case Geofire.onKeyEntered:
            ActiveNearbyAvailableDeliverymen activeNearbyAvailableDeliveryman = ActiveNearbyAvailableDeliverymen();
            activeNearbyAvailableDeliveryman.locationLatitude = map['latitude'];
            activeNearbyAvailableDeliveryman.locationLongitude = map['longitude'];
            activeNearbyAvailableDeliveryman.deliverymanId = map['key'];
            GeoFireAssistant.activeNearbyAvailableDeliverymenList.add(activeNearbyAvailableDeliveryman);
            if(activeNearbyDeliverymanKeysLoaded == true)
              {
                displayActiveDeliverymenOnUsersMap();
              }
            break;

          //whenever any deliveryman becomes offline
          case Geofire.onKeyExited:
            GeoFireAssistant.deleteOfflineDeliverymanFromList(map['key']);
            displayActiveDeliverymenOnUsersMap();
            break;

          case Geofire.onKeyMoved:
            ActiveNearbyAvailableDeliverymen activeNearbyAvailableDeliveryman = ActiveNearbyAvailableDeliverymen();
            activeNearbyAvailableDeliveryman.locationLatitude = map['latitude'];
            activeNearbyAvailableDeliveryman.locationLongitude = map['longitude'];
            activeNearbyAvailableDeliveryman.deliverymanId = map['key'];
            GeoFireAssistant.updateActiveNearbyAvailableDeliverymenLocation(activeNearbyAvailableDeliveryman);
            displayActiveDeliverymenOnUsersMap();
            break;

          //display those online drivers on user's map
          case Geofire.onGeoQueryReady:
            activeNearbyDeliverymanKeysLoaded = true;
            displayActiveDeliverymenOnUsersMap();
            break;
        }
      }

      setState(() {});
    });
  }

  displayActiveDeliverymenOnUsersMap()
  {
    setState(() {
      markerSet.clear();
      circleSet.clear();

      Set<Marker> deliverymenMarkerSet = Set<Marker>();
      
      for(ActiveNearbyAvailableDeliverymen eachDeliveryman in GeoFireAssistant.activeNearbyAvailableDeliverymenList)
        {
          LatLng eachDeliverymanActivePosition = LatLng(eachDeliveryman.locationLatitude!, eachDeliveryman.locationLongitude!);
          
          Marker marker = Marker(
            markerId: MarkerId(eachDeliveryman.deliverymanId!),
            position: eachDeliverymanActivePosition,
            icon: activeNearbyIcon!,
            rotation: 360,
          );

          deliverymenMarkerSet.add(marker);
        }

      setState(() {
        markerSet = deliverymenMarkerSet;
      });
    });
  }
  
  createActiveNearbyDeliverymanIconMarker()
  {
    if(activeNearbyIcon == null)
      {
        ImageConfiguration imageConfiguration = createLocalImageConfiguration(context, size: Size(2, 2));
        BitmapDescriptor.fromAssetImage(imageConfiguration, "images/DeliverymanMarker.png").then((value)
        {
          activeNearbyIcon = value;
        });
      }
  }
}
