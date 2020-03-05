import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../main.dart';

bool loading=true;
class WalletScreen extends StatefulWidget {
  static const walletScreenRoute = 'wallet_Screen_Route';
  @override
  _WalletScreenState createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loading=true;
    var then = current.getAllTransaction().then((val){
      loading=false;
      current.permUser.transactions=val;
      setState(() {

      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      color: Color.fromRGBO(27, 113, 127, 1),
      height: MediaQuery.of(context).size.height,
      width: double.infinity,
      child: Stack(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(top:30),
            margin: EdgeInsets.symmetric(horizontal: 32, vertical: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      '₹0',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 36,
                          fontWeight: FontWeight.w700),
                    ),
                    Container(
                        child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.notifications,
                          color: Colors.lightBlue[100],
                        ),
                        SizedBox(width: 16),
                        CircleAvatar(
                            radius: 25,
                            backgroundColor: Colors.white,
                            child: ClipOval(
                              child: Image.asset(
                                  'assets/images/gokul/gokul.png',
                                  fit: BoxFit.contain),
                            ))
                      ],
                    ))
                  ],
                ),
                Text(
                  'Available Balance',
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      color: Colors.blue[100]),
                ),
                SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Container(
                      child: Column(
                        children: <Widget>[
                          Container(
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(243, 245, 248, 1),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(18)),
                            ),
                            child: Icon(
                              Icons.add,
                              color: Colors.blue[900],
                              size: 30,
                            ),
                            padding: EdgeInsets.all(12),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Add Money',
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                                color: Colors.blue[100]),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          DraggableScrollableSheet(builder: (context, scrollController) {
            return Container(
              decoration: BoxDecoration(
                color: Color.fromRGBO(243, 245, 248, 1),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40)),
              ),
              child: SingleChildScrollView(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 24),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "Recent Transaction",
                          style: TextStyle(
                              fontWeight: FontWeight.w900,
                              color: Colors.black,
                              fontSize: 24),
                        ),
                        Text(
                          'See All',
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                              color: Colors.grey[800]),
                        ),
                      ],
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 32),
                  ),
                  SizedBox(height: 24),
                  loading?Shimmer.fromColors(
                      child: Container(
                        width: dw(100),
                        color: Colors.grey,
                        height: dh(100),
                      ),
                      baseColor: Colors.transparent,
                      highlightColor: Colors.white):
                  ListView.builder(
                    itemBuilder: (context,index){
                      return Container(
                        margin: EdgeInsets.all(10),
                        padding:EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(20)),

                        ),
                        child: Row(
                          children: <Widget>[
                            Container(
                                    decoration: BoxDecoration(
                                      color: Colors.grey[100],

                                        borderRadius: BorderRadius.all(Radius.circular(18)),


                                    ),
                                    child: Icon(Icons.date_range,color: Colors.lightBlue[900],),
                                    padding: EdgeInsets.all(12),

                            ),
                            SizedBox(width:16),
                            Expanded(child:

                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                              Text('payment',style: TextStyle(fontSize: 18,fontWeight: FontWeight.w700,color:Colors.grey[900]),),
                              Text('payment to ',style: TextStyle(fontSize: 15,fontWeight: FontWeight.w700,color:Colors.grey[500]),),
                            ],)),

                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                              Text('-₹${current.permUser.transactions[index].money}',style: TextStyle(fontSize: 18,fontWeight: FontWeight.w700,color:Colors.lightGreen),),
                              Text('${current.permUser.transactions[index].time}',style: TextStyle(fontSize: 15,fontWeight: FontWeight.w700,color:Colors.grey[500]),),
                            ],)

                          ],
                        ),
                      );
                    },
                    shrinkWrap: true,
                    itemCount: current.permUser.transactions.length,
                    padding:EdgeInsets.all(10),
                     controller: ScrollController(keepScrollOffset: false),
                  ),


                ],
              ),
              controller: scrollController,
              ),
            );
          },
          initialChildSize: 0.65,
          minChildSize: 0.40,
            maxChildSize:1,
          )
        ],
      ),
    ));
  }
}
