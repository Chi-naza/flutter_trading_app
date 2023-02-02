import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:naxtrust_trade/screens/rscApply.dart';
import 'package:naxtrust_trade/screens/rscSeek.dart';

class rscHome extends StatefulWidget {
  @override
  State<rscHome> createState() => _rscHomeState();
}

class _rscHomeState extends State<rscHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('RSC'),
        ),
        body: SingleChildScrollView(
          child: Padding(
              padding: EdgeInsets.all(25),
              child: StreamBuilder(
                stream: () async* {
                  while (true) {
                    yield jsonDecode((await get(
                            Uri.parse('https://rsc.naxtrust.com/listjobsapp')))
                        .body);
                    await Future.delayed(Duration(seconds: 30));
                  }
                }(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    var works = snapshot.data as List;
                    var workWidget = <Widget>[];
                    for (var work in works) {
                      workWidget.add(Container(
                        child: Column(
                          children: [
                            Image.network(
                              work['workExperienceUrl'],
                              width: 200,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text(work['workExperience']),
                            SizedBox(
                              height: 20,
                            ),
                            Text('User ${work['user_id']}'),
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                ),
                                backgroundColor: Colors.blueAccent,
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.all(8.0),
                                // splashColor: Colors.grey,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: Text(
                                    "Seek",
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (ctx) => rscSeek(
                                                id: work['user_id'],
                                              )));
                                },                                
                              ),
                            )
                          ],
                        ),
                      ));
                    }

                    return Column(
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          backgroundColor: Colors.blueAccent,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.all(8.0),
                          // splashColor: Colors.grey,
                          ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (ctx) => rscApply()));
                          },
                          child: Text('Apply'),                          
                        ),
                      ]..addAll(workWidget),
                    );
                  }
                  return Center(child: CircularProgressIndicator());
                },
              )),
        ));
  }
}
