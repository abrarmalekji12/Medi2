import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mediswift/home.dart';
import 'package:mediswift/register.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

import 'database/Model.dart';
import 'main.dart';
String message="";
bool isLoading=false;
bool pref=true;
bool eye=true;
TextEditingController _user = new TextEditingController(),
    _pass = new TextEditingController();

class LogPage extends StatefulWidget {
  @override
  _LogPageState createState() => _LogPageState();
}

class _LogPageState extends State<LogPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    current=Model();
    if (!current.isLogged() && pref) {
      SharedPreferences.getInstance().then((SharedPreferences pre) {
        if (pre.containsKey("email")) {
          current.logIn(pre.get("email"), pre.get("password")).then((log) {
            pref = false;
            if (log) {
              Navigator.pushReplacementNamed(context, MyHome.HomeRoute);
            }
            else
              setState(() {

              });
          });
        } else {
          pref = false;
          setState(() {});
        }
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    if (width == null &&
        MediaQuery.of(context).orientation == Orientation.portrait) {
      width = MediaQuery.of(context).size.width;
      height = MediaQuery.of(context).size.height;
    }
    return pref?new Material(
      color: Colors.grey.shade400,
      child: new Container(
        alignment: Alignment.center,
        width: dw(100),
        height: dh(100),
        child: Stack(
            alignment: Alignment.center,
            children:[
              Image.asset("images/medilogo.png",
                  width: dw(70), height: dh(55)),
              Shimmer.fromColors(baseColor: Colors.transparent, highlightColor:Colors.limeAccent,
                direction: ShimmerDirection.ltr,
                enabled: true,
                child: Image.asset("images/medilogo.png",
                    width: dw(70), height: dh(55)),
              ),

            ]
        ),
      ),
    ):Scaffold(
        body: new Container(
          padding: EdgeInsets.all(20),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            image: DecorationImage(image: AssetImage(
              "images/mediback3.jpg",),
              fit: BoxFit.fill,
            ),
          ),
          child: new ListView(
            children: <Widget>[
              new Image.asset(
                "images/medilogo.png",
                fit: BoxFit.fill,
                width: dw(60),
                height: dh(25),
                colorBlendMode: BlendMode.darken,
              ),
              new Container(
                margin: EdgeInsets.only(top: 10),
                   color: Colors.white,
                  width: 350,
                  height: 70,
                  alignment: Alignment.center,
                  child: new TextField(
                    controller: _user,
                    keyboardType: TextInputType.text,
                    autocorrect: false,
                    textAlign: TextAlign.start,
                    cursorRadius: Radius.circular(8),
                    showCursor: true,
                    textAlignVertical: TextAlignVertical.center,
                    autofocus: false,
                    style: new TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontFamily: "georgia"),
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(20),
                        border: new MyBorder(),
                        prefixIcon: Icon(
                          Icons.person,
                          size: 40,
                          color: Colors.green.shade500,
                        ),
                        hintText: "gmail or mobile number",
                        hintStyle: new TextStyle(
                            color: Colors.grey,
                            fontSize: 22,
                            fontFamily: "georgia")),
                  )),
              new Padding(padding: EdgeInsets.all(20)),
              new Container(
                  width: 350,
                  height: 70,
                  alignment: Alignment.center,
                  color: Colors.white,
                  child: new TextField(
                    controller: _pass,
                    keyboardType: TextInputType.text,
                    autocorrect: false,
                    obscureText: eye,
                    textAlign: TextAlign.start,
                    cursorRadius: Radius.circular(8),
                    showCursor: true,
                    textAlignVertical: TextAlignVertical.center,
                    autofocus: false,
                    style: new TextStyle(
                        color: Colors.black,
                        fontSize: 22,
                        fontFamily: "georgia"),
                    decoration: InputDecoration(
                        border: MyBorder(),
                        contentPadding: EdgeInsets.all(20),
                        prefixIcon: Icon(
                          Icons.lock,
                          size:40,
                          color: Colors.green.shade500,
                        ),
                        hintText: "password",
                        hintStyle: new TextStyle(
                            color: Colors.grey,
                            fontSize: 22,
                            fontFamily: "georgia")),
                  )),
              new Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                new Checkbox(
                    value: !eye,
                    onChanged: (res) {
                      eye = !eye;
                      setState(() {});
                    },
                    activeColor: Colors.green.shade800),
                new Text(
                  "show password",
                  style: TextStyle(
                      fontSize: 22,
                      color: Colors.grey.shade900,
                      backgroundColor: Colors.white),
                )
              ]),
              new Container(
                child: new FlatButton(
                  onPressed: login,
                  child: new Text(
                    "Log in",
                    style: new TextStyle(color: Colors.white, fontSize: 25),
                  ),
                  shape:RoundedRectangleBorder(
                      borderRadius:BorderRadius.all(Radius.circular(10)),
                      side:BorderSide(style:BorderStyle.solid,color:Colors.lightBlueAccent.shade400)
                  ),
                  color: Colors.lightBlueAccent.shade400,
                  padding:EdgeInsets.all(10),
                ),
              ),
              new Padding(padding: EdgeInsets.all(5)),
              new InkWell(
                child: new Text(
                  "forgot password",
                  style: new TextStyle(
                      color: Colors.black,
                      fontSize: 23,
                      backgroundColor: Colors.white),
                  textAlign: TextAlign.center,
                ),
                onTap: () {},
              )
              , new Padding(padding: EdgeInsets.all(5)),
              new InkWell(
                child: new Text(
                  "New user? Register",
                  style: new TextStyle(
                      color: Colors.black,
                      fontSize: 23,
                      backgroundColor: Colors.white),
                  textAlign: TextAlign.center,
                ),
                onTap: () {
                  Navigator.pushNamed(context, Register.RegisterRoute);
                },
              )
            ],
          ),
        ));
  }
  login(){
    if(message.isEmpty)
    {
      current.logIn(_user.text, _pass.text).then((i) {
        setState(() {
          isLoading=true;
        });
        print("hey $i");
        if (!i) {
          message = "Invalid username or password";
          setState(() {});
          return;
        }
        SharedPreferences.getInstance().then((preff) {
          preff.setString("email", _user.text);
          preff.setString("password", _pass.text);
          print("success");
        });
        Navigator.pushReplacementNamed(
            context, MyHome.HomeRoute);
      }).catchError((error) {
        message ="problem occured with connection";
        setState(() {

        });
      });
    }
  }
}
