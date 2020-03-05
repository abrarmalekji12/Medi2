import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geocoder/services/distant_google.dart';
import 'package:geolocator/geolocator.dart';

import '../main.dart';

class Model {
  User permUser;
  Map<dynamic, dynamic> data;
  FirebaseDatabase _database;
  FirebaseStorage _storage;
  FirebaseAuth _auth;
  FirebaseUser _user;

  Model() {
    _database = FirebaseDatabase.instance;
    _storage = FirebaseStorage.instance;
    _auth = FirebaseAuth.instance;
  }

  Future<User> loadUser() async {
    print("Called load user\n");
    var did = await _database.reference().child('auth_user').child(
        "${_user.uid}").once();
    var ab = (await _database.reference().child('users')
        .child("${did.value}")
        .once()).value;
    this.data = ab;
    permUser = User.fromJson(data, did.value);
    print("loaded without error");
    var geo=Geolocator();
    var loc=await geo.getCurrentPosition(locationPermissionLevel:GeolocationPermission.locationAlways,desiredAccuracy: LocationAccuracy.best);
    Location  location=Location(loc.latitude, loc.longitude);
    await location.getAddress();
    permUser.totalLocations.add(location);
    permUser.locationIndex=permUser.totalLocations.length-1;
    return permUser;
  }

  Future<bool> logIn(String email, String pass) async {
    print("login called");
    var re = await _auth
        .signInWithEmailAndPassword(email: email, password: pass)
        .catchError((error) {
      return null;
    });
    if (re == null) {
      return false;
    }
    _user = re;
    if (_user != null) {
      await loadUser();
      return true;
    }
    return false;
  }

  bool isLogged() {
    return _user != null;
  }

  Future<bool> registerNewUser(String email, String pass, String mob,
      String name) async {
    FirebaseUser result = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: pass,
    )
        .catchError((error) {
      print("Error register " + error.message);
      return null;
    });
    if (result == null) return false;
    _user = result;
    int len = (await _database.reference().child("auth_user")
        .child("len")
        .once()).value;
    int i = -1;
    if (len != null) {
      _database.reference().child("auth_user").child(_user.uid).set(len);
      _database.reference().child("auth_user").child('len').set(len + 1);
      i = len;
    } else {
      _database.reference().child("auth_user").child(_user.uid).set(0);
      _database.reference().child("auth_user").child('len').set(1);
      i = 0;
    }
    permUser = User(name, mob, i, email);
    var a = Geolocator();
    var loc = await a.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    Location location = Location(loc.latitude, loc.longitude);
    await location.getAddress();
    permUser.totalLocations.add(location);
    permUser.locationIndex = 0;
    setUserLocationIndex(0);
    saveUserLocation(location);
    _database.reference().child("users").child("$i").set(permUser.toJson());
    return true;
  }

  void saveUserLocationWithIndex(Location location, int index) {
    var a = _database.reference().child("users").child("${permUser.id}");
    a.child("totalLocations").child("${permUser.totalLocations.length}").set(
        location.toJson());
    a.child("totalLocations").child("0").set(permUser.totalLocations.length);
    a.child("locationIndex").set(index);
  }

  void saveUserLocation(Location location) {
    var a = _database.reference().child("users").child("${permUser.id}");
    a.child("totalLocations").child("${permUser.totalLocations.length}").set(
        location.toJson());
    a.child("totalLocations").child("0").set(permUser.totalLocations.length);
  }

  void setUserLocationIndex(int index) {
    _database.reference().child("users").child("${permUser.id}").child(
        "locationIndex").set(index);
  }

  Logout() {
    permUser = null;
    _auth.signOut();
    print("sign out");
  }
}


class User{
int id;
String name;
String phone;
String email;
String  bod;
List<PaymentCard> cards;
List<Location> totalLocations;
List<Review> reviews;
List<Transaction> transactions;
int locationIndex;
  User(this.name, this.phone, this.id,this.email){
    totalLocations=[];
    reviews=[];
    cards=[];
    transactions=[];
    locationIndex=-1;
  }
//list of favourite doctors
//list of favourite hospitals
//list of Appointment
//list of  approved
  User.fromJson(json,int i){
    id=i;
    phone=json['mob'];
    name=json['name'];
    locationIndex=json['locationIndex'];
    cards=[];
    totalLocations=[];
    if(locationIndex!=-1)
      for(int i=1;i<=json['totalLocations'][0];i++)
        totalLocations.add(Location.fromJson(json['totalLocations'][i], i));
  }
  toJson() {
    var tl=[];
    tl.add(totalLocations.length);
    tl.addAll(totalLocations.map((val)=>val.toJson()).toList());
    return {
      'phone': phone,
      'name':name,
      'locationIndex': locationIndex,
      'totalLocations': tl,
      'cards':[cards.length]+cards.map((val)=>val.cardId).toList(),
      'transactions':[transactions.length]+transactions.map((val)=>val.transactionId).toList(),
      'reviews':[reviews.length]+reviews.map((val)=>val.reviewId).toList()
    };
}
}
class Doctor{

}
class Hospital{

}
class Appointment{

}
class Review {
  int reviewId;
  int userId;
  int hospId;
  int docId;
  int aptId;
  int rating;
  String review;
  Review.fromJson(json){
    reviewId=json['reviewId'];
    userId=json['userId'];
    hospId=json['hospId'];
    docId=json['docId'];
    aptId=json['aptId'];
    rating=json['rating'];
    review=json['review'];
  }
  toJson()=>{
    'userId':userId,
    'hospId':hospId,
    'docId':docId,
    'rating':rating,
    'aptId':aptId,
    'review':review
  };
}
class Location {
  int locationId;
  double latitude, longitude;
  String address;
  Location.fromJson(data,int id){
    locationId=id;
    latitude=data['latitude'];
    longitude=data['longitude'];
    address=data['address'];
  }
  Location(this.latitude, this.longitude);

  Location.fromAddress(String add)  {
    this.address=add;
  }
   Future<void> getAddress() async {
     var map = GoogleGeocoding(google_api_ky);
     var ads = await map.findAddressesFromCoordinates(
         Coordinates(latitude, longitude));
     if (ads.length > 0) {
       print("MAP ${ads[0].toMap()}");
       address =
       "${ads[0].subLocality},${ads[0].locality},${ads[0].addressLine}";
     }
   }

  toJson() {
    return {'latitude': latitude, 'longitude': longitude,'address':address};
  }
}

class PaymentCard {
  int cardId;
  String type;
  String cardNumber;
  String cardHolderName;
  String expiryDate;

  PaymentCard(
      {this.type, this.cardNumber, this.cardHolderName, this.expiryDate});

  PaymentCard.fromJson(var a){
    this.cardId = a['cardId'];
    this.cardHolderName = a['cardHolderName'];
    this.type = a['type'];
    this.cardNumber = a['cardNumber'];
    this.expiryDate = a['expiryDate'];
  }

  toJson() {
    return {
      "cardNumber": this.cardNumber,
      "cardHolderName": this.cardHolderName,
      "type": this.type,
      "expiryDate": this.expiryDate
    };
  }
}
class Transaction{
  int transactionId;
  int aptId;//TODO orderid // subscriptionId
  int userId;
  double money;
  PaymentCard card;
  String time;//TODO 2:45AM|4/5/2020
  int status;//0 , 1 ,2
  Transaction({@required this.userId,@required this.aptId,@required this.status,@required this.money,@required this.card,@required this.time});
  Transaction.fromJson(var data,PaymentCard tempcard) {
    aptId=data['connectId'];
    userId=data['userId'];
    money=double.parse(data['money'].toString());
    card=tempcard;
    time=data['time'];
    status= data['status'];
  }
  toJson(){
    return {
      'connectId' :this.aptId,
      'money':this.money,
      'status':this.status,
      'userId':this.userId,
      'card':this.card.cardId,
      'time':this.time
    };
  }
}


