// @dart=2.9
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:naxtrust_trade/screens/buy.dart';
import 'package:naxtrust_trade/screens/cloud.dart';
import 'package:naxtrust_trade/screens/login.dart';
import 'package:naxtrust_trade/screens/rscApply.dart';
import 'package:naxtrust_trade/screens/rscHome.dart';
import 'package:naxtrust_trade/screens/sell.dart';
import 'package:naxtrust_trade/screens/signup.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: login(),
    );
  }
}

class Home extends StatelessWidget {
  const Home({
    Key key,
    @required TrackballBehavior trackballBehavior,
  })  : _trackballBehavior = trackballBehavior,
        super(key: key);

  final TrackballBehavior _trackballBehavior;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('NaxTrust Trade'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        (await SharedPreferences.getInstance()).clear();
                        await Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (ctx) => login()),
                            (r) => false);
                      },
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Log Out',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                                Icon(Icons.arrow_forward)
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (ctx) => cloud()));
                      },
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Cloud',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                                Icon(Icons.arrow_forward)
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (ctx) => rscHome()));
                      },
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'RSC',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                                Icon(Icons.arrow_forward)
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                FutureBuilder(future: () async {
                  return jsonDecode((await get(Uri.parse(
                          'https://api.binance.com/api/v3/klines?symbol=BTCUSDT&interval=1h&limit=20')))
                      .body);
                }(), builder: (ctx, snapshot) {
                  if (snapshot.hasData) {
                    var data = snapshot.data as List;
                    var chartWidgets = <ChartSampleData>[];

                    for (var i = 0; i < data.length; i++) {
                      chartWidgets.add(ChartSampleData(
                          x: DateTime.fromMillisecondsSinceEpoch(data[i][0]),
                          open: double.parse(data[i][1]),
                          high: double.parse(data[i][2]),
                          low: double.parse(data[i][3]),
                          close: double.parse(data[i][4])));
                    }

                    return SfCartesianChart(
                      title: ChartTitle(text: 'Trading '),
                      trackballBehavior: _trackballBehavior,
                      series: <HiloOpenCloseSeries>[
                        HiloOpenCloseSeries<ChartSampleData, DateTime>(
                          dataSource: chartWidgets,
                          xValueMapper: (ChartSampleData sales, _) => sales.x,
                          lowValueMapper: (ChartSampleData sales, _) =>
                              sales.low,
                          highValueMapper: (ChartSampleData sales, _) =>
                              sales.high,
                          openValueMapper: (ChartSampleData sales, _) =>
                              sales.open,
                          closeValueMapper: (ChartSampleData sales, _) =>
                              sales.close,
                        ),
                      ],
                      primaryXAxis: DateTimeAxis(),
                      primaryYAxis: NumericAxis(
                        numberFormat:
                            NumberFormat.simpleCurrency(decimalDigits: 0),
                      ),
                    );
                  } else
                    return CircularProgressIndicator();
                }),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                         backgroundColor: Colors.green[300],
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      ),                     
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (ctx) => buy()));
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Text(
                          'BUY',
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red[300],
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      ),                      
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (ctx) => sell()));
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Text(
                          'SELL',
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ChartSampleData {
  ChartSampleData({this.x, this.open, this.close, this.low, this.high});
  final DateTime x;
  final num open;
  final num close;
  final num low;
  final num high;
}
