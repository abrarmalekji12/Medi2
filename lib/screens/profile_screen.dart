import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import 'edit_user_profile.dart';

int radioval = current.permUser.locationIndex + 1;

class ProfileScreen extends StatefulWidget {
  static const profileScreenRoute = '/profile_Scren';
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Widget textArea(String type, String name, [int id = -1]) {
    return Column(
      children: <Widget>[
        Container(
          //color:Colors.green,
          child: type.isNotEmpty
              ? Padding(
                padding: const EdgeInsets.only(left:15),
                child: Align(
                  alignment: Alignment.centerLeft,
                                child: Text('$type',
                      style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.w800)),
                ),
              )
              : Radio(
                  value: id,
                  groupValue: radioval,
                  activeColor: Colors.blue,
                  onChanged: (val) {
                    radioval = val;
                    current.setUserLocationIndex(val - 1);
                    setState(() {});
                  },
                ),
        ),
        SizedBox(height:5,),
        Padding(
          padding: const EdgeInsets.only(left:25),
          child: Align(
            alignment: Alignment.bottomLeft,
                    child: Text(name,
                overflow: TextOverflow.visible,
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 20,
                )),
          ),
        ),
      ],
    );
  }

  Widget getAddressTile(String name, BuildContext ctx, int id) {
    return InkWell(
        onTap: () {
          radioval = id;
          current.setUserLocationIndex(id - 1);
          setState(() {});
        },
        // width: size,
        child: Row(
          children: <Widget>[
            Container(
                padding: EdgeInsets.only(left: 20),
                //color:Colors.green,
                child: Container(
                  child: Radio(
                    value: id,
                    groupValue: radioval,
                    activeColor: Colors.blue,
                    onChanged: (val) {
                      radioval = val;
                      current.setUserLocationIndex(val - 1);
                      setState(() {});
                    },
                  ),
                )),
            Padding(
              padding: EdgeInsets.all(6),
            ),
            Container(
                width: dw(70),
                child: Text(name,
                    overflow: TextOverflow.visible,
                    style: TextStyle(
                      fontFamily: 'OpenSans',
                      fontSize: 20,
                    ))),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(title: Text('User Profile')),
        body: Container(
            child: ListView(children: <Widget>[
              Container(
                  height: 270,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color:  Color.fromRGBO(27, 113, 127,1),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(90),
                      )),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Spacer(),
                      Align(
                        alignment: Alignment.center,
                        child:
//                        Image.network(current.getImage())
                            Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 150,
                        ),
                      ),
                      Spacer(),
                      Align(
                          alignment: Alignment.bottomRight,
                          child: Padding(
                              padding: EdgeInsets.only(right: 30, bottom: 15),
                              child: InkWell(
                                  onTap: () {
                                    Navigator.of(context).pushNamed(
                                        UserEditProfile.editRoute);
                                    // print('hello');
                                  },
                                  child: Container(
                                    width: 90,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        border:
                                            Border.all(color: Colors.black45),
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black45,
                                            blurRadius: 10,
                                          )
                                        ]),
                                    child: Padding(
                                        padding: EdgeInsets.all(10),
                                        child: Text('Edit',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontFamily: 'OpenSans',
                                              color: Colors.black,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ))),
                                  ))))
                    ],
                  )),
                  SizedBox(height:20,),
          Column(
            children: <Widget>[
              textArea(
                'Name',
                '${current.permUser.name}',
              ),
              SizedBox(height: 10),
              textArea(
                'Phone no',
                '${current.permUser.phone}',
              ),
              SizedBox(height: 10),
              textArea(
                'Email',
                current.permUser.email,
              ),
              SizedBox(height: 10),
              new Text(
                "select your current address",
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 20,
                  fontFamily: 'OpenSans'
                ),
              ),
              Padding(padding: EdgeInsets.all(3)),
              current.permUser.locationIndex == -1
                  ? Container(
                      child: Text(
                        "You can add new Address",
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  :  Column(
                        children: current.permUser.totalLocations.map((value) {
                          return Container(
                           
                            child: Column(children: [
                              getAddressTile(
                                value.address,
                                context,
                                value.locationId,
                              ),
                              new Padding(padding: EdgeInsets.all(3)),
                              Divider(
                                thickness: 1,
                                color: Colors.grey,
                              )
                            ]),
                          );
                        }).toList(),
                      )
            ],
          ),
        ])));
  }
}
