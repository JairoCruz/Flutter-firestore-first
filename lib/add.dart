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

  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Add Name Baby"),
      ),
      body: Form(
        key: _formKey,
        child: Container(
          margin: EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              // mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(bottom: 14.0),
                 /* child: TextFormField(
                    validator: (value) {
                      if(value.isEmpty){
                        return 'Please enter some text';
                      }
                      return null;
                    },
                  ),*/
                  child: TextFormField(
                    // obscureText: true, esto es para formato de password
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Add name baby',
                    ),
                    controller: myController,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
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
                  child: Text(
                    "Add", /* style: TextStyle(color: Colors.white),*/
                  ),
                  textColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 60),
                  onPressed: () {
                  if (_formKey.currentState.validate()){

                    Firestore.instance
                        .collection('baby')
                        .document(myController.text.toUpperCase())
                        .setData({
                      'name': myController.text,
                      'votes': 10,
                      'date': DateTime.now(),
                    });
                    print(myController.text);
                   
                   // Navigator.pop(context);
                    
                    _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text('Processs'),));
                  
                  }
                  },
                  color: Colors.indigoAccent,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  minWidth: double.infinity,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
