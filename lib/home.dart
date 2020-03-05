import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:mediswift/screens/payment_screen.dart';
import 'package:mediswift/screens/profile_screen.dart';
import 'package:mediswift/screens/wallet_screen.dart';
import 'main.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'database/Model.dart';

var drawerSelected = -1;
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
  Widget createItems(
      IconData icon, String title, String subtitle, Function click) {
    return Container(
      padding: EdgeInsets.all(5),
      child: ListTile(
        onTap: click,
        leading: Icon(
          icon,
          size: 26,
          color: Colors.black54,
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 20,
            fontFamily: 'NotoSansKR',
            fontWeight: FontWeight.w700,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontFamily: 'OpenSans',
            fontWeight: FontWeight.w500,
          ),
        ),
        contentPadding: EdgeInsets.all(2),
      ),
    );
  }

  Container getItem(int i, Widget widget, IconData icon, String title,
      String subtitle, String route) {
    return Container(
      padding: EdgeInsets.only(left: 10),
      color: drawerSelected == i ? Colors.white : Colors.transparent,
      child: createItems(icon, title, subtitle, () {
        drawerSelected = i;
        Navigator.of(context).pushNamed(route);
        //pages[0]['page'] = widget;
        setState(() {});
        //'orders' 'keep track of current orders'
        // Navigator.pop(context);
      }),
    );
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
        iconTheme:IconThemeData(color: Colors.black,size: 35),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.search,color: Colors.black,size: 30,), onPressed: (){
            showSearch(context: scaffcontext, delegate:SearchBar(),).then((res){
              print("search ${res}");
            });
          })
        ],
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
                            mode: Mode.fullscreen,
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
                          height: dh(40),
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
                                    "📍 ${value.address}",
                                    style: new TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontFamily: "arial"),
                                    overflow: TextOverflow.fade,
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
      drawer:Drawer(
    child: Container(
    padding: EdgeInsets.only(top: 60, left: 0),
    child: ListView(
    children: <Widget>[
    InkWell(
    onTap: () {
    if (!current.isLogged()) {
    Navigator.pushNamed(context, "/");
    return;
    }
    drawerSelected = 0;
    Navigator.of(context)
        .pushNamed(ProfileScreen.profileScreenRoute);
    //pages[0]['page'] = new ProfileScreen();
    },
    child: new Container(
    margin: EdgeInsets.only(top: 5, bottom: 10),
    padding: EdgeInsets.all(10),
    child: Center(
    child: Row(
    children: <Widget>[
    CircleAvatar(
    backgroundColor: Colors.white,
    radius: 25,
    child: new Icon(
    Icons.person,

    color: Color.fromRGBO(27, 113, 127, 1),
    size: 35,
    )),
    Padding(
    padding: EdgeInsets.all(5),
    ),
    new Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
    Container(
    width: dw(48),
    child: new Text(
    current.isLogged()
    ? "hey ${current.permUser.name}"
        : "hey user",
    softWrap: true,
    maxLines: 1,
    overflow: TextOverflow.fade,
    style: new TextStyle(
    color: Colors.black,
    fontSize: 20,
    fontFamily: "georgia",
    ),
    textAlign: TextAlign.left,
    ),
    ),
    ],
    ),
    Icon(
    Icons.arrow_forward_ios,
    color: Colors.black,
    size: 30,
    )
    ],
    ),
    ),
    ),
    ),
    Divider(
    color: Colors.grey,
    thickness: 2,
    ),
    getItem(
    1,
   null,
    Icons.history,
    'history',
    'previous orders and payments',
   '/'),
    getItem(
    2,
    null,
    Icons.record_voice_over,
    'orders',
    'keep track of current orders',
    '/'),
    getItem(
    3,
    new PaymentDetailsScreen(),
    Icons.payment,
    'payment details',
    'link your account for quick transaction',
    PaymentDetailsScreen.paymentDetialsRoute),
    getItem(
    4,
    new WalletScreen(),
    Icons.account_balance_wallet,
    'wallet',
    'manage your personalized wallet',
    WalletScreen.walletScreenRoute,
    ),
    new Divider(
    color: Colors.grey,
    thickness: 2.0,
    ),
    getItem(
    5,
    Container(),
    Icons.settings,
    'settings',
    'change setting',
    '/'),
    Container(
    padding: EdgeInsets.only(left: 10),
    child: createItems(
    Icons.input,
    (current.isLogged()) ? "Log-out" : "Log in",
    "use another account of yours", () {
    if (current.isLogged()) {
    current.logOut();
    setState(() {});
    } else {
    Navigator.pushNamed(context, '/');
    }
    }),
    )
    ],
    ))),
      body:Builder(
        builder: (con){
          scaffcontext=con;
          return Container(
            width: dw(100),
            padding: EdgeInsets.all(13),
            child:Column(
              children: <Widget>[
                CarouselSlider.builder(itemCount: 2, itemBuilder: (cont,i){
                  return getCard();
                },initialPage: 0,onPageChanged: (i){},aspectRatio: 1.1,autoPlay: true,autoPlayAnimationDuration: Duration(seconds: 2),),

              ],
            )
          );
        },
      ),
    );
  }

Widget getDocList(){
    return   Container(
      width: dw(100),
      height: dh(40),
      child: ListView(
        children: <Widget>[

        ],
      ),
    );
}
Widget getDocTile(){
    return Container(
      width: dw(100),
     height:100 ,
child: Row(
  children: <Widget>[
    Image.asset('images/medilogo.png',width: 60,height: 60,),
    Container(
      child: ,
    )
  ],
),
    );
}
  Widget getCard(){
    return Container(
      width: dw(100),
      height: dh(50),
      margin: EdgeInsets.all(7),
       decoration: BoxDecoration(
         color: Colors.white,
//          gradient: LinearGradient(colors: <Color>[Colors.blueAccent.shade100,Colors.green.shade100]),
         boxShadow: [BoxShadow(color: Colors.grey,blurRadius: 10,offset: Offset(10,10))],
         borderRadius: BorderRadius.all(Radius.circular(20))
       ),
        child: Column(
          children: <Widget>[
            Stack(children: <Widget>[
              Image.asset('images/medilogo.png',width: dw(80),height:150,),
              Padding(
                padding: EdgeInsets.only(top: 120),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Apollo Hospital',
                     textAlign: TextAlign.center,
                    style: TextStyle(
                      shadows: [Shadow(color: Colors.white,blurRadius: 10,offset: Offset(5, 5))],
                      fontSize: 22.0,
                      fontFamily: "arial",
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],),
            Container(
              padding: EdgeInsets.all(4),
              child: Text(
                'total 2000 patients Cured',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 19.0,
                  // fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(4),
              child: Text(
                '2 kms away',
                textAlign: TextAlign.justify,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 19.0,
                  // fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Divider(thickness: 1,color: Colors.grey,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(2.0),
                  child: Text(
                    'closing in 1 hour ',
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      fontFamily: "arial",
                      color: Colors.black,
                      fontSize: 17.0,
                      // fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(5),
                  child: RatingBarIndicator(itemBuilder: (BuildContext context, int index) {
                    return Icon(Icons.star,color: Colors.yellow);
                  },rating: 4,itemSize: 25,),
                ),
              ],),
            Divider(thickness: 1,color: Colors.grey,),
            Container(
              width: dw(60),
              child: Row(
                children: <Widget>[
                  Icon(Icons.location_on,color: Colors.blueAccent,),
                  Text(
                    'Near, temporary locality.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 17.0,
                        fontFamily: "arial"
                      // fontWeight: FontWeight.w300,
                    ),
                    overflow: TextOverflow.fade,
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
class SearchBar extends SearchDelegate{
  @override
  List<Widget> buildActions(BuildContext context) {
    // TODO: implement buildActions
    return [];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // TODO: implement buildLeading
    return Container();
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // TODO: implement buildSuggestions
    return Container();
  }
}