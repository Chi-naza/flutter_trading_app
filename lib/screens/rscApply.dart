//@dart=2.9
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:naxtrust_trade/utils/helpers.dart';
import 'package:http_parser/http_parser.dart';

class rscApply extends StatefulWidget {
  var id;
  rscApply({this.id});
  @override
  State<rscApply> createState() => _rscApplyState();
}

class _rscApplyState extends State<rscApply> {
  var isLoading = false;
  var emailController = TextEditingController();
  var whatDoYouWant = TextEditingController();
  var phoneNumberController = TextEditingController();

  File image;
  var _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Apply'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(hintText: 'Enter Email'),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: phoneNumberController,
                decoration: InputDecoration(hintText: 'Enter Phone Number'),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: whatDoYouWant,
                decoration: InputDecoration(hintText: 'Work Experience'),
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
                            'Upload Certificate',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ),
                ),
              ),
              SizedBox(
                height: 30,
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
                            "Submit",
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                  onPressed: () async {
                    setState(() {
                      isLoading = true;
                    });
                    if (whatDoYouWant.text.trim() != '' &&
                        emailController.text.trim() != '' &&
                        phoneNumberController.text.trim() != '') {
                      try {
                        await upload(
                            image,
                            'workExperience',
                            MediaType('image', 'jpeg'),
                            'https://rsc.naxtrust.com/apply', {
                          'email': emailController.text.trim(),
                          'workExperienceDes': whatDoYouWant.text.trim(),
                          'phoneNumber': phoneNumberController.text.trim(),
                        });
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content:
                                Text('Skill Listed for Job Successfully')));
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('Skill Listed for Job Failed')));
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
