import 'package:flutter/material.dart';
import 'package:mediswift/home.dart';
import 'login.dart';
import 'main.dart';

bool eye = true;
TextEditingController _user = new TextEditingController(),
    _pass = new TextEditingController(),
    _confirm = new TextEditingController(),
    _mob = new TextEditingController(),
    _name = new TextEditingController();

class Register extends StatefulWidget {
  static String RegisterRoute = "/register";
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  static String registerRoute = "/registerRoute";
  final _form=GlobalKey<FormState>();
  signup(){

      if (_pass.text == _confirm.text )
        current
            .registerNewUser(
            _user.text, _pass.text, _mob.text, _name.text)
            .then((val) {
          if (val) {
            print('registered successfully');
            Navigator.pushReplacementNamed(
                context, MyHome.HomeRoute);
          } else
            print("Error during registration");
        });
  }
  @override
  Widget build(BuildContext context) {
    if (width == null &&
        MediaQuery.of(context).orientation == Orientation.portrait) {
      width = MediaQuery.of(context).size.width;
      height = MediaQuery.of(context).size.height;
    }
    return Scaffold(
      body: Container(
        width: dw(100),
        height: dh(100),
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage(
            "images/mediback3.jpg",),
            fit: BoxFit.fill,
//                width: dw(100),
//                height: dh(100),
          ),
        ),
        child: ListView(
          children: <Widget>[
            new Image.asset(
              "images/medilogo.png",
              fit: BoxFit.fill,
              width: dw(50),
              height: dh(25),
              colorBlendMode: BlendMode.darken,
            ),
            Container(
              color: Colors.white,
              margin:
              const EdgeInsets.only(top:0,left:20,right: 20,bottom: 10),
              child: new TextField(
                controller: _user,
                keyboardType: TextInputType.emailAddress,
                autocorrect: false,
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w500,
                  fontSize: 20
                ),
                showCursor: true,
                textAlignVertical: TextAlignVertical.center,
                autofocus: false,
                decoration: InputDecoration(
                    border: MyBorder(),

                    labelText: 'Email',
                    labelStyle: TextStyle(
                        fontFamily: 'OpenSans',
                        color: Colors.black
                    ),
                    prefixIcon: Icon(
                      Icons.email,
                      size: 30,
                      color: Colors.green,
                    )),
              ),
            ),
            Container(
              color: Colors.white,
              margin:
              const EdgeInsets.only(top:10,left:20,right: 20,bottom: 10),
              child: new TextField(
                controller: _name,
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w500,
                    fontSize: 20
                ),

                autocorrect: false,
                textAlign: TextAlign.start,
                showCursor: true,
                textAlignVertical: TextAlignVertical.center,
                autofocus: false,
                decoration: InputDecoration(
                  border: MyBorder(),
                    labelText: 'Name',
                    labelStyle: TextStyle(
                        fontFamily: 'OpenSans',
                        color: Colors.black
                    ),
                    prefixIcon: Icon(
                      Icons.person,
                      size: 30,
                      color:  Colors.green,
                    )),
              ),
            ),
            Container(
              color: Colors.white,
              margin:
              const EdgeInsets.only(top:10,left:20,right: 20,bottom: 10),
              child: new TextField(
                controller: _mob,
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w500,
                    fontSize: 20
                ),
                keyboardType: TextInputType.phone,
                autocorrect: false,
                textAlign: TextAlign.start,
                showCursor: true,
                textAlignVertical: TextAlignVertical.center,
                autofocus: false,
                decoration: InputDecoration(
                    labelText: 'Phone No',
                    border: MyBorder(),
                    labelStyle: TextStyle(
                        fontFamily: 'OpenSans',
                        color: Colors.black

                    ),
                    prefixIcon: Icon(
                      Icons.phone,
                      size: 30,
                      color:  Colors.green,
                    )),
              ),
            ),
            Container(
              color: Colors.white,
              margin:
              const EdgeInsets.only(top:10,left:20,right: 20,bottom: 10),
              child: new TextField(
                controller: _pass,

                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w500,
                    fontSize: 20
                ),
                keyboardType: TextInputType.visiblePassword,
                autocorrect: false,
                textAlign: TextAlign.start,
                showCursor: true,
                textAlignVertical: TextAlignVertical.center,
                autofocus: false,
                obscureText: eye,
                decoration: InputDecoration(
                    border: MyBorder(),
                    labelText: 'Password',
                    labelStyle: TextStyle(
                        fontFamily: 'OpenSans',
                        color: Colors.black
                    ),
                    prefixIcon: Icon(
                      Icons.security,
                      size: 30,
                      color: Colors.green,
                    )),
              ),
            ),
            Container(
              color: Colors.white,
              margin:
              const EdgeInsets.only(top:10,left:20,right: 20,bottom: 10),
              child: new TextField(
                controller: _confirm,
                keyboardType: TextInputType.text,
                autocorrect: false,
                textAlign: TextAlign.start,
                showCursor: true,
                obscureText: eye,
                textAlignVertical: TextAlignVertical.center,
                autofocus: false,
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w500,
                    fontSize: 20
                ),
                decoration: InputDecoration(
                    border: MyBorder(),
                    labelText: 'Conform Password',
                    labelStyle: TextStyle(
                        fontFamily: 'OpenSans',
                        color: Colors.black
                    ),
                    prefixIcon: Icon(
                      Icons.security,
                      size: 30,
                      color:  Colors.green,
                    )),
              ),
            ),
            SizedBox(height:5),
            new Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              new Checkbox(
                  value: !eye,
                  onChanged: (res) {
                    eye = !eye;
                    setState(() {});
                  },
                  activeColor: Color.fromRGBO(27, 113, 127,1),),
              Padding(
                padding: EdgeInsets.only(right:15),
                child: new Text(
                  "show password",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                  ),
                ),
              )
            ]),
            new Container(
              padding: EdgeInsets.only(left:20,right:20,top:5),
              child: new FlatButton(
                onPressed: signup,
                child: new Text(
                  "Sign up",
                  style: new TextStyle(color: Colors.white, fontSize: 25),
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    side: BorderSide(
                        style: BorderStyle.solid, color: Color.fromRGBO(27, 113, 127,1))),
                color: Color.fromRGBO(27, 113, 127,1),
                padding: EdgeInsets.all(10),
              ),
            ),
            new Padding(padding: EdgeInsets.all(10)),
            Center(
              child: new InkWell(
                child: new Text(
                  "already user, log-in",
                  style: new TextStyle(color: Colors.black, fontSize: 20),
                ),
                onTap: () {
                  Navigator.pushReplacementNamed(context, "/");
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
