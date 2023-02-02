// @dart=2.9
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:naxtrust_trade/utils/helpers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http_parser/http_parser.dart';

class cloud extends StatefulWidget {
  @override
  State<cloud> createState() => _cloudState();
}

class _cloudState extends State<cloud> {
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  var isLoading = false;
  var titleController = TextEditingController();
  var descriptionController = TextEditingController();
  File image;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Cloud'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: titleController,
                decoration: InputDecoration(hintText: 'Enter Title'),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: descriptionController,
                decoration: InputDecoration(hintText: 'Enter Description'),
              ),
              SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  showDialog<ImageSource>(
                    context: context,
                    builder: (context) => AlertDialog(
                        content: Text("Choose image source"),
                        actions: [
                          TextButton(
                            child: Text("Camera"),
                            onPressed: () =>
                                Navigator.pop(context, ImageSource.camera),
                          ),
                          TextButton(
                            child: Text("Gallery"),
                            onPressed: () =>
                                Navigator.pop(context, ImageSource.gallery),
                          ),
                        ]),
                  ).then((ImageSource source) async {
                    if (source != null) {
                      image = File((await ImagePicker().pickImage(
                        source: source,
                      ))
                          .path);
                      setState(() {});
                    }
                  });
                },
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(10)),
                  height: 200,
                  child: image != null
                      ? Image.file(image)
                      : Center(
                          child: Text(
                            'Upload File',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ),
                ),
              ),
              SizedBox(height: 20),
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
                            "Submit",
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                  onPressed: () async {
                    setState(() {
                      isLoading = true;
                    });
                    if (titleController.text.trim() != '' &&
                        descriptionController.text.trim() != '') {
                      try {
                        await upload(image, 'file', MediaType('image', 'jpeg'),
                            'https://naxtrust.com/cloud/', {
                          'title': titleController.text.trim(),
                          'description': descriptionController.text.trim(),
                        });
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('Uploaded to cloud successfully')));

                        setState(() {
                          titleController.clear();
                          descriptionController.clear();
                          image = null;
                        });
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Upload to cloud failed')));
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('please fill in all fields')));
                    }
                    setState(() {
                      isLoading = false;
                    });
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
