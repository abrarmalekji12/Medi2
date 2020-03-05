import 'package:flutter/material.dart';
import 'package:mediswift/database/Model.dart';
import 'package:provider/single_child_widget.dart';
import 'package:shimmer/shimmer.dart';

import '../main.dart';
bool  isLoading=true;
TextEditingController _cardno = TextEditingController(),
    _cardname = TextEditingController(),
    _type = TextEditingController(),
    _cvv = TextEditingController(),
    _expire= TextEditingController()
;

class PaymentDetailsScreen extends StatefulWidget {
  static const paymentDetialsRoute = '/payment_details_screen';
  bool loading = true;

  @override
  _PaymentDetailsScreenState createState() => _PaymentDetailsScreenState();
}


class _PaymentDetailsScreenState extends State<PaymentDetailsScreen> {
  createDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return Container(
            child: Dialog(
              backgroundColor: Colors.transparent,
              child: Container(
                padding: EdgeInsets.all(7),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                      color: Color.fromRGBO(27, 113, 127, 1), width: 4),
                  color: Colors.white.withOpacity(1),
                ),
                width: MediaQuery.of(context).size.width,
                height: dh(50),
                child: Column(
                  children: <Widget>[
                    Container(
                      width: double.infinity,
                      height: 70,
                      padding: EdgeInsets.only(left: 10, right: 10),
                      child: TextField(
                        keyboardType: TextInputType.number,
                        maxLength: 16,
                        controller: _cardno,
                        decoration: InputDecoration(
                          labelText: 'CARD NUMBER',
                          labelStyle: TextStyle(
                              fontSize: 15,
                              color: Color.fromRGBO(27, 113, 127, 1)),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromRGBO(27, 113, 127, 1)),
                          ),
                        ),
                        // style: TextStyle(
                        //   fontSize: 20,
                        // )
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      height: 70,
                      padding: EdgeInsets.only(left: 10, right: 10),
                      child: TextField(
                        onChanged: (val) {},
                        keyboardType: TextInputType.text,
                        controller: _type,
                        decoration: InputDecoration(
                          labelText: 'TYPE',
                          labelStyle: TextStyle(
                              fontSize: 15,
                              color: Color.fromRGBO(27, 113, 127, 1)),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromRGBO(27, 113, 127, 1)),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      height: 70,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: TextField(
                          onChanged: (val){},
                          controller: _cardname,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            labelText: 'CARD HOLDER',
                            labelStyle: TextStyle(
                                fontSize: 15,
                                color: Color.fromRGBO(27, 113, 127, 1)),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.black,
                              ),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color.fromRGBO(27, 113, 127, 1)),
                            ),
                          ),
                          // style: TextStyle(
                          //   fontSize: 20,
                          // )
                        ),
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(left: 10, right: 10),
                          width: MediaQuery.of(context).size.width * 0.5,
                          child: TextField(
                            onChanged: (val){},
                            controller: _expire,
                            keyboardType: TextInputType.text,
                            maxLength:5,
                            decoration: InputDecoration(
                              labelText: 'EXPIRE DATE',
                              labelStyle: TextStyle(
                                  fontSize: 15,
                                  color: Color.fromRGBO(27, 113, 127, 1)),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color.fromRGBO(27, 113, 127, 1)),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.only(left: 10, right: 10),
                            width: MediaQuery.of(context).size.width / 4,
                            child: TextField(
                              keyboardType: TextInputType.number,
                              onChanged: (val){},
                              controller: _cvv,
                              decoration: InputDecoration(
                                labelStyle: TextStyle(
                                    fontSize: 15,
                                    color: Color.fromRGBO(27, 113, 127, 1),
                                    fontFamily: 'OpenSans'),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Color.fromRGBO(27, 113, 127, 1)),
                                ),
                                labelText: 'CVV',
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    FloatingActionButton(
                      child: Icon(
                        Icons.add,
                        size: 30,
                      ),
                      onPressed: (){
                        PaymentCard card=PaymentCard(cardNumber: _cardno.text,cardHolderName: _cardname.text,type: _type.text,expiryDate: _expire.text);
                        current.permUser.cards.add(card);
                        current.saveCard(card);
                        Navigator.pop(context);
                      },
                      backgroundColor: Color.fromRGBO(27, 113, 127, 1),
                    )
                  ],
                ),
              ),
            ),
          );
        }).then((val){
     setState((){}
     );
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isLoading = true;
    current.getAllCards().then((cards) {
      isLoading = false;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Payment')),
        body: Container(
          child: ListView(
            children: <Widget>[
              SizedBox(
                height: 24,
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Your Cards',
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 24,
                            fontFamily: 'JosefinSans',
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                        icon: Icon(Icons.more_horiz),
                        color: Colors.lightBlue,
                        iconSize: 30,
                        onPressed: null),
                  ],
                ),
                padding: EdgeInsets.symmetric(horizontal: 32),
              ),
              SizedBox(height: 10),
              Container(
                width: dw(100),
                height: dh(65),
                child: isLoading
                    ? Shimmer.fromColors(
                        child: Container(
                          width: dw(100),
                          color: Colors.white,
                          height: dh(60),
                        ),
                        baseColor: Colors.transparent,
                        highlightColor: Colors.white)
                    : ListView.builder(
                        itemBuilder: (context, id) {
                          return  Container(
                            height: 230,
                            width: MediaQuery.of(context).size.width,
                            margin: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Color.fromRGBO(35, 60, 103, 1)),
                            padding: EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      CircleAvatar(
                                        radius: 16,
                                        backgroundColor:
                                        Color.fromRGBO(50, 172, 121, 1),
                                        child: Icon(
                                          Icons.check,
                                          color: Colors.white,
                                          size: 18,
                                        ),
                                      ),
                                      Text(
                                        '${current.permUser.cards[id].type}',
                                        style: TextStyle(
                                          fontStyle: FontStyle.italic,
                                          fontSize: 28,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                Expanded(
                                  child: Text(
                                    '${current.permUser.cards[id].cardNumber}',
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 2.0,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 32,
                                ),
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            'CARD HOLDER',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.blue[100],
                                              fontWeight: FontWeight.w700,
                                              letterSpacing: 2.0,
                                            ),
                                          ),
                                          Text(
                                            '${current.permUser.cards[id].cardHolderName}',
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.grey[100],
                                              fontWeight: FontWeight.w700,
                                              letterSpacing: 2.0,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            'EXPIRES',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.blue[100],
                                              fontWeight: FontWeight.w700,
                                              letterSpacing: 2.0,
                                            ),
                                          ),
                                          Text(
                                            '${current.permUser.cards[id].expiryDate}',
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.grey[100],
                                              fontWeight: FontWeight.w700,
                                              letterSpacing: 2.0,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                        itemCount: current.permUser.cards.length,
                      ),
              ),
              SizedBox(height: 30),
              InkWell(
                onTap: () => createDialog(context),
                child: Container(
                    margin: EdgeInsets.only(left: 60, right: 60),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: Color.fromRGBO(27, 113, 127, 1), width: 1)),
                    child: Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 10, right: 10, top: 8, bottom: 8),
                          child: Icon(
                            Icons.add,
                            color: Color.fromRGBO(27, 113, 127, 1),
                            size: 30,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              left: 5, right: 5, top: 5, bottom: 5),
                          child: Text(
                            'Add New Card',
                            style: TextStyle(
                                fontSize: 20,
                                fontFamily: 'OpenSans',
                                fontWeight: FontWeight.bold,
                                color: Color.fromRGBO(27, 113, 127, 1)),
                          ),
                        ),
                      ],
                    )),
              )
            ],
          ),
          decoration: BoxDecoration(
              color: Color.fromRGBO(243, 245, 248, 1),
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(40), topLeft: Radius.circular(40))),
        ));
  }
}
