import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class sell extends StatefulWidget {
  @override
  State<sell> createState() => _sellState();
}

class _sellState extends State<sell> {
  var listPaymentWay = ['Crypto', 'Fiat'];
  var listReceiving = ['Local Bank', 'use Paypal', 'use Other'];
  var _scaffoldKey = GlobalKey<ScaffoldState>();

  var chooseValue;
  var chooseReceiving;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    chooseValue = listPaymentWay[0];
    chooseReceiving = listReceiving[0];
  }

  var amountController = TextEditingController();
  var accountNumberController = TextEditingController();
  var bankNameController = TextEditingController();
  var currencyRateController = TextEditingController();
  var currencyNameController = TextEditingController();
  var currencyExchangeController = TextEditingController();
  var phoneNumberController = TextEditingController();
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
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Sell'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: amountController,
                decoration: InputDecoration(hintText: 'Amount'),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: accountNumberController,
                decoration: InputDecoration(hintText: 'Account Number'),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: bankNameController,
                decoration: InputDecoration(hintText: 'Bank Name'),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: currencyRateController,
                decoration: InputDecoration(hintText: 'Currency Rate'),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: currencyNameController,
                decoration: InputDecoration(hintText: 'Currency Name'),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: currencyExchangeController,
                decoration: InputDecoration(hintText: 'Currency Exchange'),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: phoneNumberController,
                decoration: InputDecoration(hintText: 'Phone Number'),
              ),
              SizedBox(height: 20),
              DropdownButtonFormField<String>(
                  onChanged: (value) {
                    setState(() {
                      chooseValue = value;
                    });
                  },
                  decoration: InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white))),
                  value: chooseValue,
                  items: widgetPayment),
              SizedBox(height: 20),
              DropdownButtonFormField<String>(
                  onChanged: (value) {
                    setState(() {
                      chooseReceiving = value;
                    });
                  },
                  decoration: InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white))),
                  value: chooseReceiving,
                  items: widgetReceiving),
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
                      "Submit",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  onPressed: () {
                    if (amountController.text.trim() != '' &&
                        accountNumberController.text.trim() != '' &&
                        bankNameController.text.trim() != '' &&
                        currencyRateController.text.trim() != '' &&
                        currencyNameController.text.trim() != '' &&
                        currencyExchangeController.text.trim() != '' &&
                        phoneNumberController.text.trim() != '') {
                      Widget cryptoButton = TextButton(
                        child: Text("Crypto"),
                        onPressed: () async {
                          var instancePref =
                              await SharedPreferences.getInstance();
                          var response = jsonDecode((await post(
                                  Uri.parse(
                                      'https://api.commerce.coinbase.com/charges/'),
                                  headers: {
                                    'Content-Type': 'application/json',
                                    'X-CC-Api-Key':
                                        '76668e58-4186-46a5-8478-5b16cd96d3c6',
                                    'X-CC-Version': '2018-03-22',
                                  },
                                  body: jsonEncode({
                                    'name': 'Deposit',
                                    'description':
                                        "Selling ${amountController.text.trim()}",
                                    'local_price': {
                                      'amount': amountController.text.trim(),
                                      'currency': 'USD'
                                    },
                                    "metadata": {
                                      'userId':
                                          instancePref.getString('userId'),
                                      'phone':
                                          phoneNumberController.text.trim(),
                                      'methodOfPayment':
                                          '${chooseValue} ${accountNumberController.text.trim()} ${bankNameController.text.trim()} receive ${currencyExchangeController.text.trim()}',
                                      'sellingMethod': chooseReceiving,
                                      'currencyExchange':
                                          currencyExchangeController.text
                                              .trim(),
                                      'currency':
                                          currencyNameController.text.trim(),
                                      'dollarRate':
                                          currencyRateController.text.trim()
                                    },
                                    'pricing_type': 'fixed_price'
                                  })))
                              .body);

                          await launch(response['data']['hosted_url']);

                          Navigator.pop(context);
                        },
                      );
                      Widget fiatButton = TextButton(
                        child: Text("Fiat"),
                        onPressed: () async {
                          var instancePref =
                              await SharedPreferences.getInstance();
                          var response = jsonDecode((await post(
                                  Uri.parse(
                                      'https://naxtrust.com/ntc/trading/saveToDb'),
                                  body: jsonEncode({
                                    'amount': amountController.text.trim(),
                                    'description':
                                        'Selling ${amountController.text.trim()}',
                                    'userId': instancePref.getString('userId'),
                                    'phone': phoneNumberController.text.trim(),
                                    'methodOfPayment':
                                        '${chooseValue} $accountNumberController.text.trim()} ${bankNameController.text.trim()} receive ${currencyExchangeController.text.trim()}',
                                    'sellingMethod': chooseReceiving,
                                    'currencyExchange':
                                        currencyExchangeController.text.trim(),
                                    'currency':
                                        currencyNameController.text.trim(),
                                    'dollarRate':
                                        currencyRateController.text.trim()
                                  })))
                              .body);
                          if (response['success']) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Listed Successfully')));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Listing Failed')));
                          }
                          Navigator.pop(context);
                        },
                      );

                      // set up the AlertDialog
                      AlertDialog alert = AlertDialog(
                        title: Text("Choose Method"),
                        content: Text("Crypto or Fiat"),
                        actions: [
                          cryptoButton,
                          fiatButton,
                        ],
                      );

                      // show the dialog
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return alert;
                        },
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('please fill in all fields')));
                    }
                  },                  
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
