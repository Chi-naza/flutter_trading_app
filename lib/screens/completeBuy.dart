import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

class completeBuy extends StatefulWidget {
  var data;

  completeBuy({this.data});
  @override
  State<completeBuy> createState() => _completeBuyState();
}

class _completeBuyState extends State<completeBuy> {
  var isLoading = false;
  var amountController = TextEditingController();
  var currencyController = TextEditingController();
  var modeOfReceivingPaymentController = TextEditingController();
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Confirm Buy'),
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
                controller: currencyController,
                decoration: InputDecoration(hintText: 'Currency'),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: modeOfReceivingPaymentController,
                decoration:
                    InputDecoration(hintText: 'Mode Of Receiving Payment'),
              ),
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
                  child: isLoading
                      ? CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : Padding(
                          padding: const EdgeInsets.all(5),
                          child: Text(
                            "I have paid",
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                  onPressed: () async {
                    setState(() {
                      isLoading = true;
                    });
                    if (amountController.text.trim() != '' &&
                        currencyController.text.trim() != '' &&
                        modeOfReceivingPaymentController.text.trim() != '') {
                      var reponse = await post(
                          Uri.parse(
                              'https://naxtrust.com/ntc/trading/confirmPay'),
                          headers: {"content-type": "application/json"},
                          body: jsonEncode({
                            'amount': amountController.text.trim(),
                            'sellerId': widget.data['userId'],
                            'modeOfPayment':
                                modeOfReceivingPaymentController.text.trim(),
                            'currency': currencyController.text.trim(),
                            'userId': '94'
                          }));
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Your request have been sent')));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Please fill in all fields')));
                    }

                    setState(() {
                      isLoading = false;
                    });
                  },                  
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text('Seller Id: ${widget.data['userId']}'),
              SizedBox(
                height: 20,
              ),
              Text('Amount for sale: \$${widget.data['amount']}'),
              SizedBox(
                height: 20,
              ),
              Text('Selling Rate: \$${widget.data['dollar_rate']}'),
              SizedBox(
                height: 20,
              ),
              Text('PayTo: ${widget.data['method_of_payment']}'),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
