import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final dataBase = Firestore.instance;



void getData() {
  var modulos =[];

  dataBase.collection('dummy').getDocuments().then((QuerySnapshot snapShot) {
    snapShot.documents.forEach((f) => print('${f.data.map}'));
  });
}

void createRecord() async {
  await dataBase.collection("books").document("1").setData({
    'title': 'Mastering Flutter',
    'description': 'Programming Guide for Dart'
  });

  DocumentReference ref = await dataBase.collection("books").add({
    'title': 'Flutter in Action',
    'description': 'Complete Programming Guide to learn Flutter'
  });
  print(ref.documentID);
}

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: PantallaPrincipal(),
    );
  }
}

class PantallaPrincipal extends StatefulWidget {
  PantallaPrincipal({Key key}) : super(key: key);

  _PantallaPrincipalState createState() => _PantallaPrincipalState();
}

class _PantallaPrincipalState extends State<PantallaPrincipal> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: StreamBuilder<QuerySnapshot>(
            stream: Firestore.instance.collection('dummy').snapshots(),
            builder: (context, snapShot){
              if(!snapShot.hasData){
                return Text('NoDATA!');
              }
              return ListView.builder(
                itemExtent: 80,
                itemCount: snapShot.data.documents.length,
                itemBuilder: (context, index){
                 if(snapShot.data.documents[index]['base']){
                  String nombre = snapShot.data.documents[index]['nombre'];
                  return Text(nombre);  
                 }if(!snapShot.data.documents[index]['base']) {
                   var modulo = snapShot.data.documents[index]['modulo'];
                   String comentario = snapShot.data.documents[index]['comen'];
                   return Text('$comentario and $modulo');
                   
                 }
                 return CircularProgressIndicator();
                },
              );
            },
          ),
        ),
      )
    );
  }
}
