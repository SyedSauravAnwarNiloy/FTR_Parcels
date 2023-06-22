import 'package:firebase_database/firebase_database.dart';

class TripsHistoryModel
{
  String? time;
  String? originAddress;
  String? destinationAddress;
  String? status;
  String? feeAmount;
  String? userName;
  String? userPhone;
  String? parcel_type;
  String? parcel_mass;
  String? parcel_volume;

  TripsHistoryModel({
    this.time,
    this.originAddress,
    this.destinationAddress,
    this.status,
    this.feeAmount,
    this.userName,
    this.userPhone,
    this.parcel_type,
    this.parcel_mass,
    this.parcel_volume
  });

  TripsHistoryModel.fromSnapshot(DataSnapshot dataSnapshot)
  {
    time = (dataSnapshot.value as Map)["time"];
    originAddress = (dataSnapshot.value as Map)["originAddress"];
    destinationAddress = (dataSnapshot.value as Map)["destinationAddress"];
    status = (dataSnapshot.value as Map)["status"];
    feeAmount = (dataSnapshot.value as Map)["feeAmount"];
    userName = (dataSnapshot.value as Map)["userName"];
    userPhone = (dataSnapshot.value as Map)["userPhone"];
    parcel_type = (dataSnapshot.value as Map)["parcelInformation"]["parcel_type"];
    parcel_mass = (dataSnapshot.value as Map)["parcelInformation"]["parcel_mass"];
    parcel_volume = (dataSnapshot.value as Map)["parcelInformation"]["parcel_volume"];
  }
}