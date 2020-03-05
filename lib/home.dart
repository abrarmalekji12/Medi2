import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'main.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'database/Model.dart';

FirebaseStorage _storage;
Container indicator;
TextEditingController editAdd=new TextEditingController();
List<String> hosp, doc;
TextStyle title;
class MyHome extends StatefulWidget {
  static String HomeRoute="/home";
  @override
  _MyHomeState createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  BuildContext scaffcontext;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    title=new TextStyle(
        fontSize:24, fontFamily: "georgia", color: Colors.black,fontWeight:FontWeight.w700);
    _storage = FirebaseStorage.instance;
    hosp = [];
    doc = [];
    indicator=new Container(
      height:100,
      width: 100,
      child: new Center(
          child: new CircularProgressIndicator(
            value: null,
            strokeWidth: 3,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.red),)),
    );
    for (int i = 1; i < 5; i++) {
      hosp.add(null);
      doc.add(null);
    }
    for (int i = 1; i < 5; i++) {
      _storage.ref().child("MediSwift").child("Hosp")
          .child("h$i.jpg")
          .getDownloadURL()
          .then((val) {
        hosp[i - 1] = val;
        setState(() {

        });
      });
      _storage.ref().child("MediSwift").child("doc")
          .child("d$i.jpg")
          .getDownloadURL()
          .then((val) {
        doc[i - 1] = val;
        setState(() {

        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery
        .of(context)
        .size
        .width;
    height = MediaQuery
        .of(context)
        .size
        .height;
    return new Scaffold(
      backgroundColor: Colors.white,
      appBar:  AppBar(
        backgroundColor: Colors.white,
        centerTitle: false,
        title: new InkWell(
          onTap: () {
            showModalBottomSheet(
                context: scaffcontext,
                builder: (co) {
                  return Container(
                    width: dw(100),
                    height: dh(50),
                    child: ListView(
                      children: <Widget>[
                        Container(
                          width: 200,
                          height: 70,
                          padding: EdgeInsets.all(10),
                          child: PlacesAutocompleteField(
                            apiKey:
                            google_api_ky,
                            controller: editAdd,
                            onChanged: (val) {
                              Location.fromAddress(val);
                              Navigator.pop(context);
                            },
                            mode: Mode.overlay,
                            inputDecoration: InputDecoration(
                              contentPadding: EdgeInsets.all(5),
                              helperStyle: TextStyle(
                                  color: Colors.red, fontSize: 15),
                            ),
                          ),
                        ),
                        new Padding(padding: EdgeInsets.all(5)),
                        current.isLogged()?Container(
                          width: dw(100),
                          height: dh(41),
                          child: ListView(
                            children: current.permUser.totalLocations
                                .map((value) {
                              print("heyyyy ${value.locationId}");
                              return InkWell(
                                onTap: () {
                                  current.permUser.locationIndex=value.locationId-1;
                                  current.setUserLocationIndex(value.locationId-1);
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  width: dw(70),
                                  child: new Text(
                                    value.address,
                                    style: new TextStyle(
                                        color: Colors.black,
                                        fontSize: 20,
                                        fontFamily: "georgia"),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ):Container()
                      ],
                    ),
                  );
                },
                backgroundColor: Colors.white);
          },
          child: Container(
            width: dw(65),
            alignment: Alignment.center,
            child: Row(
              children: <Widget>[
                Icon(
                  Icons.location_on,
                  color: Colors.blueAccent,
                  size: 30,
                ),
                SizedBox(width:5),
                Expanded(
                  child: Text(
                    (current.isLogged())
                        ? "${current.permUser.totalLocations[current.permUser.locationIndex].address}"
                        : "location",
                    style: TextStyle(
//                    fontFamily: 'JosefinSans',
                      fontSize: 18,
                      color: Colors.black
                    ),overflow: TextOverflow.fade,
                  ),
                ),
              ],
            ),
          ),
        ),
        //   backgroundColor: Colors.lightGreen
      ),
      drawer: new Drawer(
      ),
      body:Builder(
        builder: (con){
          scaffcontext=con;
          return Container();
        },
      ),
    );
  }
}
