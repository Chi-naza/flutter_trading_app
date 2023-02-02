import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:naxtrust_trade/screens/completeBuy.dart';

class buy extends StatefulWidget {
  @override
  State<buy> createState() => _buyState();
}

class _buyState extends State<buy> {
  var listPaymentWay = ['Crypto', 'Fiat'];
  var listReceiving = ['Local Bank', 'use Paypal', 'use Other'];

  var chooseValue;
  var chooseReceiving;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    chooseValue = listPaymentWay[0];
    chooseReceiving = listReceiving[0];
  }

  @override
  Widget build(BuildContext context) {
    List<DropdownMenuItem<String>> widgetPayment = [];
    List<DropdownMenuItem<String>> widgetReceiving = [];
    for (var i in listPaymentWay) {
      widgetPayment.add(DropdownMenuItem(
        child: Text(i),
        value: i,
      ));
    }
    for (var i in listReceiving) {
      widgetReceiving.add(DropdownMenuItem(
        child: Text(i),
        value: i,
      ));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Buy'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: StreamBuilder(stream: () async* {
            while (true) {
              yield jsonDecode((await get(
                      Uri.parse('https://naxtrust.com/ntc/trading/getp2papp')))
                  .body);
              await Future.delayed(Duration(seconds: 30));
            }
          }(), builder: (context, snapshot) {
            if (snapshot.hasData) {
              var p2pResult = snapshot.data as List;
              var dataWidget = <Widget>[];
              for (var i in p2pResult) {
                dataWidget.addAll([
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Currency Type: ${i['sellingMethod']}'),
                      SizedBox(
                        height: 20,
                      ),
                      Text('Currency Exchange:  ${i['currencyExchange']}'),
                      SizedBox(
                        height: 20,
                      ),
                      Text('Currency Name: ${i['currency']}'),
                      SizedBox(
                        height: 20,
                      ),
                      Text('Dollar Rate: \$${i['dollar_rate']}'),
                      SizedBox(
                        height: 20,
                      ),
                      Text('Amount Selling: \$${i['amount']}'),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          backgroundColor: Colors.blueAccent,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.all(8.0),
                          // splashColor: Colors.grey,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(5),
                            child: Text(
                              "Buy",
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (ctx) => completeBuy(data: i)));
                          },                          
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      )
                    ],
                  )
                ]);
              }
              return Column(
                children: dataWidget,
              );
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          }),
        ),
      ),
    );
  }
}
