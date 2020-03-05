import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geocoder/services/distant_google.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mediswift/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';

class Model {
  User permUser;
  Map<int,PaymentCard> _cardStore={};
  Map<int,Hospital> hospStore={};
  Map<int,Review> reviewStore={};
  Map<int,Doctor> docStore={};
  Map<int,Appointment> aptStore={};
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
  Future<Hospital> getHosp(int i) async{
    if(hospStore.containsKey(i))
      return hospStore[i];
    var ab=await _database.reference().child('hospitals').child('$i').once();
    var shopData=ab.value;
    shopData['hospId']=i;
    List<Doctor> docs=[];
    for(int i=1;i<=shopData['doctors'][0];i++)
      docs.add(await getDoc(shopData['doctors'][i]));
    List<Review> list1=[];
    for(int i=1;i<=shopData['reviews'][0];i++)
      list1.add(await getReview(shopData['reviews'][i]));
     return hospStore[i]=Hospital.fromJson(shopData,docs ,list1);
    }
  Future<Doctor> getDoc(int i) async{
    if(docStore.containsKey(i))
      return docStore[i];
    var ab=await _database.reference().child('doctors').child('$i').once();
    var shopData=ab.value;
    shopData['docId']=i;
    return docStore[i]=Doctor.fromJson(shopData);
  }
  Future<Appointment> getApt(int i) async{
    if(aptStore.containsKey(i))
      return aptStore[i];
    var ab=await _database.reference().child('appointments').child('$i').once();
    var shopData=ab.value;
    shopData['aptId']=i;
    return aptStore[i]=Appointment.fromJson(shopData);
  }
  Future<Review> getReview(int i) async {
    if(reviewStore.containsKey(i))
      return reviewStore[i];
    var reviewsData=(await _database.reference().child("reviews").child("$i").once()).value;
    reviewsData['reviewId']=i;
    Review review=Review.fromJson(reviewsData);
    reviewStore[i]=review;
    return review;
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
  void saveCard(PaymentCard card) async{
    if(card.cardId==null)
      card.cardId=await getNextCardIndex();
    await _database.reference().child('cards').child('${card.cardId}').set(card.toJson());
    await  _database.reference().child('cards').child('0').set(card.cardId);
    if(!_cardStore.containsKey(card.cardId))
    {
      _cardStore[card.cardId]=card;
      _database.reference().child("users").child("${permUser.id}").child('cards').child("0").set(permUser.cards.length);
      _database.reference().child("users").child("${permUser.id}").child('cards').child("${permUser.cards.length}").set(card.cardId);
    }
  }

  Future<List<Transaction>> getAllTransaction() async {
    List<Transaction> list = [];
    var temp= (await _database.reference().child("transactions").orderByChild("userId").equalTo(permUser.id).once()).value;
    if(temp!=null)
      for(var next in temp)
      {
        if(next!=null){
          Transaction tm=Transaction.fromJson(next,await getCard(next['card']));
          list.add(tm);
        }
      }
    return list;
  }
  Future<int> getNextCardIndex() async{
    return (await _database.reference().child("cards").child("0").once()).value+1;
  }
  Future<List<PaymentCard>>  getAllCards() async{
    var len= (await   _database.reference().child("users").child("${permUser.id}").child('cards').once()).value;
    List<PaymentCard> ans=[];
    for(int i=1;i<=len[0];i++)
      ans.add(await getCard(len[i]));
    permUser.cards=ans;
    return ans;
  }
  logOut() {
    _auth.signOut();
    _user=null;
    permUser=null;
    SharedPreferences.getInstance().then((preff){
      preff.remove("email");
      preff.remove("password");
    });
    print("sign out");
  }
  Future<PaymentCard> getCard(int id) async
  {
    if(_cardStore.containsKey(id))
      return _cardStore[id];
    var ab=(await _database.reference().child('cards').child('$id').once()).value;
    ab['cardId']=id;
    return _cardStore[id]=PaymentCard.fromJson(ab);
  }
  void saveUserProfileDetails({String name,String phone}) {
    current.permUser.name = name;
    current.permUser.phone=phone;
    print("userr ${permUser.id}");
    _database.reference().child("users").child("${permUser.id}").update(
        {"name": name, "phone": phone}).then((val) {
      print("name saved");
    }).catchError((err) {
      print("error saving name");
    });
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
    phone=json['phone'];
    name=json['name'];
    email=json['email'];
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
      'email':email,
      'locationIndex': locationIndex,
      'totalLocations': tl,
      'cards':[cards.length]+cards.map((val)=>val.cardId).toList(),
      'transactions':[transactions.length]+transactions.map((val)=>val.transactionId).toList(),
      'reviews':[reviews.length]+reviews.map((val)=>val.reviewId).toList()
    };
}
}
class Doctor{
  int docId;
  int hospId;
//  Location location;
String email;
String imageUrl;
//String personalPhone;
String workPhone;
String name;
double fees;
int treatedCount;
int practiceYears;
List<String> eduTags;
//TODO age don't forget
String gender;
String specs;
Doctor.fromJson(json){
  docId=json['docId'];
  hospId=json['hospId'];
  imageUrl=json['imageUrl'];
  email=json['email'];
  practiceYears=json['practiceYears'];
  treatedCount=0;
  gender=json['gender'];
  specs=json['specs'];
  eduTags=json['eduTags'].toList();
  workPhone=json['workPhone'];
  name=json['name'];
  fees=json['fees'];
}
}
class Hospital{
int hospId;
String email;
String name;
String imageUrl;
List<Doctor> doctors;
String phone;
List<Review> reviews;
int totalAppointment;
Hospital.fromJson(json,List<Doctor> docs,List<Review> list){
  hospId=json['hospId'];
  email=json['email'];
  name=json['name'];
  imageUrl=json['imageUrl'];
  phone=json['phone'];
  reviews=list;
  totalAppointment=json['appointments'][0];
  doctors=docs;
}
}
class Appointment{
int aptId;
int hospId;
int docId;
int userId;
String placingTime;
int status;//  1 placed| 2  accepted | 3 finished
String acceptedTime;
Appointment.fromJson(json){
  aptId=json['aptId'];
  hospId=json['hospId'];
  docId=json['docId'];
  userId=json['userId'];
  placingTime=json['placingTime'];
  status=json['status'];
  acceptedTime=json['acceptedTime'];
}
}
class Review {
  int reviewId;
  int userId;
  int hospId;
  int aptId;
  int rating;
  String review;
  Review.fromJson(json){
    reviewId=json['reviewId'];
    userId=json['userId'];
    hospId=json['hospId'];
    aptId=json['aptId'];
    rating=json['rating'];
    review=json['review'];
  }
  toJson()=>{
    'userId':userId,
    'hospId':hospId,
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
    aptId=data['aptId'];
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


