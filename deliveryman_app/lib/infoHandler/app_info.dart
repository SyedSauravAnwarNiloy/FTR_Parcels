import 'package:flutter/cupertino.dart';
import '../models/directions.dart';
import '../models/trips_history_model.dart';



class AppInfo extends ChangeNotifier
{
  Directions? userPickUpLocation, userDropOffLocation;
  int countTotalTrips = 0;
  String deliverymanTotalEarnings = "0";
  String deliverymanAverageRatings = "0";
  List<String> historyTripsKeysList = [];
  List<TripsHistoryModel> allTripsHistoryInformationList = [];

  void updatePickupLocationAddress(Directions userPickUpAddress)
  {
    userPickUpLocation = userPickUpAddress;
    notifyListeners();
  }

  void updateDropOffLocationAddress(Directions dropOffAddress)
  {
    userDropOffLocation = dropOffAddress;
    notifyListeners();
  }

  updateOverAllTripsCounter(int overAllTripsCounter)
  {
    countTotalTrips = overAllTripsCounter;
    notifyListeners();
  }

  updateOverAllTripsKeys(List<String> tripsKeysList)
  {
    historyTripsKeysList = tripsKeysList;
    notifyListeners();
  }

  updateOverAllTripsHistoryInformation(TripsHistoryModel eachTripsHistory)
  {
    allTripsHistoryInformationList.add(eachTripsHistory);
    notifyListeners();
  }

  updateDeliverymanTotalEarnings(String deliverymanEarnings)
  {
    deliverymanTotalEarnings = deliverymanEarnings;
  }

  updateDeliverymanAverageRatings(String deliverymanRatings)
  {
    deliverymanAverageRatings = deliverymanRatings;
  }

}