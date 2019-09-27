import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddNameBaby extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    /*return MaterialApp(
      title: "Add name baby",
      home: MyCustomFrom(),
    );*/
    return MyCustomFrom();
  }
}

class MyCustomFrom extends StatefulWidget {
  @override
  _MyCustomFormState createState() => _MyCustomFormState();
}

class _MyCustomFormState extends State<MyCustomFrom> {
  final myController = TextEditingController();

  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Name Baby"),
      ),
      body: Container(
        margin: EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            // mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(bottom: 14.0),
                child: TextField(
                  // obscureText: true, esto es para formato de password
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Add name baby',
                  ),
                  controller: myController,
                ),
              ),
             /* RaisedButton(
                onPressed: () {
                  Firestore.instance
                      .collection('baby')
                      .document(myController.text.toUpperCase())
                      .setData({'name': myController.text, 'votes': 10});
                  print(myController.text);
                  Navigator.pop(context);
                },
                child: Text(
                  "Add",
                  style: TextStyle(color: Colors.white),
                ),
                color: Colors.red,
              ),*/
              MaterialButton(
                child: Text("Add",/* style: TextStyle(color: Colors.white),*/),
                textColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 60),
                onPressed: () {
                  Firestore.instance
                      .collection('baby')
                      .document(myController.text.toUpperCase())
                      .setData({'name': myController.text, 'votes': 10});
                  print(myController.text);
                  Navigator.pop(context);
                },
                color: Colors.indigoAccent,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                minWidth: double.infinity,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
