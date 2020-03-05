import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:mediswift/database/Model.dart';
import 'dart:io';
import 'package:provider/provider.dart';

import '../main.dart';

int radioIndex = 0;
String errorName = "", errorMob = "", errorAddress = "";
bool addressField = true;
TextEditingController editPhone;
TextEditingController name;
TextEditingController editAdd;

class UserEditProfile extends StatefulWidget {
  static const editRoute = '/edituser';

  @override
  _UserEditProfileState createState() => _UserEditProfileState();
}

class _UserEditProfileState extends State<UserEditProfile> {
  Future<File> imageFile;
  final imageUrl = TextEditingController();
  final focusName = FocusNode();

  final focuseMail = FocusNode();

  final focusPhone = FocusNode();

  final focusad = FocusNode();

  var _isinit = true;
  var initValues = {
    'userPic': "",
    'userName': current.permUser.name,
    'userPhoneNo': current.permUser.phone
  };

//  bool validateEmail(String value) {
//    Pattern pattern =
//        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
//    RegExp regex = new RegExp(pattern);
//    return (!regex.hasMatch(value)) ? false : true;
//  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    editPhone = TextEditingController(text: current.permUser.phone);
    name = TextEditingController(text: current.permUser.name);
    editAdd = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text('Edit Profile'),
          actions: <Widget>[
            IconButton(
              tooltip: 'save details',
              icon: Icon(
                Icons.save,
              ),
              onPressed: saveData,
            ),
          ],
        ),
        body: Container(
            padding: const EdgeInsets.all(16),
            child: Container(
              padding: EdgeInsets.all(10),
              child: Column(
                children: <Widget>[
                  TextField(
                    onChanged: (val) {
                      errorName = "";
                      setState(() {
                        if (val.length < 5)
                          errorName =
                              "name is short,atleast five characters is required";
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'name',
                      helperText: errorName.isNotEmpty ? errorName : null,
                      helperStyle: TextStyle(color: Colors.red, fontSize: 15),
                      enabledBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: Color.fromRGBO(27, 113, 127,1), width: 2),
                      ),
                    ),

                    textInputAction: TextInputAction.next,
                    controller: name,
//    if (value.isEmpty) {
//    return 'name required';
                  ),
                  SizedBox(height: 10),
                  TextField(
                    onChanged: (val) {
                      errorMob = "";
                      setState(() {
                        if (val.length < 10 || val.length > 10)
                          errorMob = "phone number should have 10 digits";
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Phone no',
                      helperText: errorMob.isNotEmpty ? errorMob : null,
                      helperStyle: TextStyle(color: Colors.red, fontSize: 15),
                      enabledBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: Color.fromRGBO(27, 113, 127, 1), width: 2),
                      ),
                    ),
                    textInputAction: TextInputAction.next,
//    focusNode: focusPhone,
                    controller: editPhone,
                    keyboardType: TextInputType.number,
//    if (value.isEmpty)
//    return 'please provide phone no';
//    else if (value.length < 10 || value.length > 10)
//    return 'please,provide correct phone number';
                  ),
                  SizedBox(height: 10),
                  Container(
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Radio(
                              activeColor: Colors.black,
                              value: 0,
                              onChanged: (value) {
                                radioIndex = value;
                                addressField = value == 0;
                                setState(() {});
                              },
                              groupValue: radioIndex,
                            ),
                            Container(
                              width: 200,
                              height: 70,
                              child: PlacesAutocompleteField(
                                apiKey:
                                    'AIzaSyBH57M3ugU6cC7JaP2ClwreU8eNrgT-oDA',
                                controller: editAdd,
                                onChanged: (val) {
                                  errorAddress = "";
                                  if (!addressField) {
                                    addressField = true;
                                    radioIndex = 0;
                                  }
                                  setState(() {
                                    if (val.length < 0)
                                      errorAddress = "address  required";
                                  });
                                },
                                mode: Mode.fullscreen,
                                inputDecoration: InputDecoration(
                                  enabled: addressField,
                                  helperText:
                                      errorAddress.isNotEmpty && radioIndex == 0
                                          ? errorAddress
                                          : null,
                                  helperStyle: TextStyle(
                                      color: Colors.red, fontSize: 15),
                                ),
//                      initialValue: initValues['userAdd'],
                              ),
                            ),
                          ],
                        ),
                        new Padding(padding: EdgeInsets.all(5)),
                        Container(
                          width: dw(100),
                          height: dh(41),
                          child: ListView(
                            children:
                                current.permUser.totalLocations.map((value) {
                              print("heyyyy ${value.locationId}");
                              return InkWell(
                                onTap: () {
                                  setState(() {
                                    radioIndex = value.locationId;
                                    addressField = false;
                                  });
                                },
                                child: Container(
                                  color: Colors.grey.shade300,
                                  margin: EdgeInsets.only(bottom: 10),
                                  child: Row(
                                    children: <Widget>[
                                      Radio(
                                        activeColor: Colors.pinkAccent,
                                        value: value.locationId,
                                        groupValue: radioIndex,
                                        onChanged: (value) {
                                          radioIndex = value;
                                          addressField = radioIndex == 0;
                                          setState(() {});
                                        },
                                      ),
                                      Expanded(
                                        child: Container(
                                          width: dw(70),
                                          child: new Text(
                                            value.address,
                                            style: new TextStyle(
                                                color: Colors.black,
                                                fontSize: 20,
                                                fontFamily: "georgia"),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
//    FlatButton(
//    child: Container(
//    padding: EdgeInsets.symmetric(
//    horizontal: 35, vertical: 10),
//    decoration: BoxDecoration(
//    border: Border.all(color: Colors.blue, width: 1),
//    borderRadius: BorderRadius.circular(15),
//    color: Colors.greenAccent,
//    boxShadow: [
//    BoxShadow(
//    color: Colors.black,
//    blurRadius: 15,
//    )
//    ]),
//    child: Text('Save', style: TextStyle(fontSize: 21))),
//    onPressed: saveData
//    ),
                ],
              ),
            )));
  }

  void saveData() {
    if (errorMob.isNotEmpty || errorName.isNotEmpty) return;
    if (radioIndex == 0) if (errorAddress.isNotEmpty) return;
    current.saveUserProfileDetails(name: name.text, phone: editPhone.text);
    if (radioIndex == 0) {
      if (editAdd.text != initValues['userAdd']) {
        Location.fromAddress(editAdd.text);
        current.permUser.locationIndex =
            current.permUser.totalLocations.length - 1;
        current
            .setUserLocationIndex(current.permUser.totalLocations.length - 1);
      }
    } else {
      current.permUser.locationIndex = radioIndex - 1;
      current.setUserLocationIndex(radioIndex - 1);
    }
  }
}
