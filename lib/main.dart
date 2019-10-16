import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:first_flutter_firestore/add.dart';
import 'package:flutter/material.dart';
import 'package:grouped_listview/grouped_listview.dart';
import 'package:intl/intl.dart';

void main() => runApp(MyApp());

/*final dummySnapshot = [
  {"name": "Filip", "votes": 15},
  {"name": "Jaio", "votes": 100},
];*/

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Baby Names',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() {
    return _MyHomePageState();
  }
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
     appBar: AppBar(
        title: Text('Baby Name Votes'),
      ),
      //appBar: _customScrollView(),
      body: _buildBody(context),
     // body: _customScrollView(context),
      floatingActionButton: _buildFloatingButton(context),
    );
  }
}

/*Widget _customScrollView(BuildContext context) {
  return NestedScrollView(
    headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled){
      return <Widget>[
        SliverAppBar(
          expandedHeight: 200.0,
          floating: false,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            centerTitle: true,
            title: Text("hello"),
          ),
        ),
      ];
    },
    body: _buildBody(context),
  );
}*/

Widget _buildFloatingButton(BuildContext context) {
  return FloatingActionButton(
    onPressed: () {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => AddNameBaby()));
    },
    child: Icon(Icons.add),
    backgroundColor: Colors.red,
  );
}

Widget _buildBody(BuildContext context) {
  return StreamBuilder<QuerySnapshot>(
    stream: Firestore.instance.collection('baby').snapshots(),
    builder: (context, snapshot) {
      if (!snapshot.hasData) return LinearProgressIndicator();
      if (snapshot.data.documents.length == 0)
        return Center(
          child: Text('No hay datos.',
              style: TextStyle(
                //fontWeight: FontWeight.bold,
                fontSize: 18,
              )),
        );

      return _buildList(context, snapshot.data.documents);
    },
  );
}

Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
  /*return ListView(
    padding: const EdgeInsets.only(top: 20.0),
    children: snapshot.map((data) => _buildListItem(context, data)).toList(),
  );*/

  //Este codigo me permite crear una coleccion de Registros para pasarlos al widget GrouptListView
  var listaRecord = List<Record>();
  snapshot.forEach((data) {
    final record = Record.fromSnapshot(data);
    listaRecord.add(record);
  });

  return GroupedListView<Record, String>(
    collection: listaRecord,
    groupBy: (Record r) => DateFormat("d-MMMM-yyyy").format(r.dates),
    //listBuilder: (BuildContext context, Record r) => ListTile(title: Text(r.name.toString()),),
    listBuilder: (BuildContext context, Record record) {
      return Stack(
        children: <Widget>[
          Dismissible(
            key: Key(record.name),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) {
              Firestore.instance
                  .collection("baby")
                  .document(record.name.toUpperCase())
                  .delete();
              print(record.name);
            },
            background: Container(
              alignment: Alignment.centerRight,
              padding: EdgeInsets.only(right: 20.0),
              color: Colors.red,
              child: Icon(
                Icons.delete,
                color: Colors.white,
              ),
            ),
            child: Padding(
              key: ValueKey(record.name),
              //padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 8.0),
              padding:
                  const EdgeInsets.only(left: 28.0, bottom: 8.0, right: 16.0),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: ListTile(
                  title: Text(record.name),
                  trailing: Text(record.votes.toString()),
                  subtitle:
                      Text(new DateFormat("d MMMM yyyy").format(record.dates)),
                  onTap: () =>
                      record.reference.updateData({'votes': record.votes + 1}),
                  /* *no work for me **onTap: () => Firestore.instance.runTransaction((transaction) async {
               final freshSnapshot = await transaction.get(record.reference);
               final fresh = Record.fromSnapshot(freshSnapshot);

               await transaction
                   .update(record.reference, {'votes': fresh.votes + 1});
             }),*/
                ),
              ),
            ),
          ),
          Positioned(
            top: 0.0,
            bottom: 0.0,
            left: 16.0,
            child: Container(
              height: double.infinity,
              width: 1.0,
              color: Colors.blue,
            ),
          )
        ],
      );
    },
    groupBuilder: (BuildContext context, String name) =>
        _stickerHeader(context, name),
    //groupBuilder: (BuildContext context, String name) => Padding(padding: EdgeInsets.symmetric(horizontal: 15.0,vertical: 0.0),child:Text(name,style: TextStyle(color: Colors.red),)),
  );
}

Widget _stickerHeader(BuildContext context, String name) {
  //return Text(name);
  return Stack(
    children: <Widget>[
      Padding(
        padding: EdgeInsets.only(left: 30.0, top: 12.0, bottom: 16.0),
        child: Text(name),
      ),
      new Positioned(
        top: 10.0,
        left: 5.0,
        child: new Container(
          height: 20.0,
          width: 20.0,
          decoration:
              new BoxDecoration(shape: BoxShape.circle, color: Colors.white),
          child: new Container(
            margin: new EdgeInsets.all(4.0),
            height: 25.0,
            width: 25.0,
            decoration: new BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.blue,
            ),
          ),
        ),
      ),
    ],
  );
}

Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
  final record = Record.fromSnapshot(data);
  //print(data.documentID);
  return Dismissible(
    key: Key(record.name),
    direction: DismissDirection.endToStart,
    onDismissed: (direction) {
      Firestore.instance
          .collection("baby")
          .document(record.name.toUpperCase())
          .delete();
      print(record.name);
    },
    background: Container(
      alignment: Alignment.centerRight,
      padding: EdgeInsets.only(right: 20.0),
      color: Colors.red,
      child: Icon(
        Icons.delete,
        color: Colors.white,
      ),
    ),
    child: Padding(
      key: ValueKey(record.name),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: ListTile(
          title: Text(record.name),
          trailing: Text(record.votes.toString()),
          subtitle: Text(new DateFormat("d MMMM yyyy").format(record.dates)),
          onTap: () => record.reference.updateData({'votes': record.votes + 1}),
          /* *no work for me **onTap: () => Firestore.instance.runTransaction((transaction) async {
               final freshSnapshot = await transaction.get(record.reference);
               final fresh = Record.fromSnapshot(freshSnapshot);

               await transaction
                   .update(record.reference, {'votes': fresh.votes + 1});
             }),*/
        ),
      ),
    ),
  );
}

class Record {
  final String name;
  final int votes;
  final DateTime dates;
  final DocumentReference reference;

  Record.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['name'] != null),
        assert(map['votes'] != null),
        assert(map['date'] != null),
        name = map['name'],
        votes = map['votes'],
        dates = map['date'];

  Record.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  String toString() => "Record<$name:$votes>";
}
