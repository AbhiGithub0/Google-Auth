import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: FireBaseDemo(),
  ));
}

class FireBaseDemo extends StatefulWidget {
  @override
  _FireBaseDemoState createState() => _FireBaseDemoState();
}

class _FireBaseDemoState extends State<FireBaseDemo> {

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  TextEditingController nameController = TextEditingController();
  TextEditingController numberController = TextEditingController();

  Map data;



  // _signIn() async{
  //   final GoogleSignInAccount googleUser = await googleSignIn.signIn();
  //   final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
  //   final AuthCredential credential = GoogleAuthProvider.credential(idToken: googleAuth.idToken,accessToken: googleAuth.accessToken);
  //   final User user =  (await firebaseAuth.signInWithCredential(credential)).user;
  //
  //

  addData() {

    Map<String,dynamic> demoData = {'name': nameController.text, 'number':numberController.text};
    FirebaseFirestore.instance.collection('data').doc(numberController.text).set(demoData);
    //collectionReference.add(demoData);
    nameController.clear();
    numberController.clear();
  }

  deleteData() async{
     FirebaseFirestore.instance.collection('data').doc(numberController.text).delete();
     numberController.clear();
    //QuerySnapshot querySnapshot = await collectionReference.get();
    //querySnapshot.docs[0].reference.delete();
  }

  updateData() {
  FirebaseFirestore.instance.collection('data').doc(numberController.text).update({'name' : nameController.text});
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal:10.0,vertical: 25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [

                TextField(
                  autofocus: true,
                  controller: nameController,
                  decoration: InputDecoration(
                    hintText: 'Enter Name'
                  ),
                ),
                TextField(
                  autofocus: true,
                  controller: numberController,
                  decoration: InputDecoration(
                      hintText: 'Enter Number'
                  ),
                ),
                RaisedButton(
                    child: Text('Add Data'),
                    onPressed: addData),
                RaisedButton(
                    child: Text('Delete Data'),
                    onPressed: deleteData),
                RaisedButton(
                    child: Text('Update Data'),
                    onPressed: updateData),
                  Expanded(
                     child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance.collection("data").orderBy('name' ,descending: false).snapshots(),
                      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return Text('Something went wrong');
                      }else if (snapshot.connectionState == ConnectionState.waiting) {
                        return Text("Loading");
                      }

                      return new ListView.builder(
                          itemCount: snapshot.data.docs.length,
                        itemBuilder: (c,i) {
                          final list = snapshot.data.docs;
                          return Dismissible(
                            key: Key(snapshot.data.docs[i].id ),
                            onDismissed: (direction) {
                              print(list[i]["name"]);
                              FirebaseFirestore.instance.collection('data').doc(snapshot.data.docs[i].id).delete();
                             // snapshot.data.docs.removeAt(i);

                              setState(() {

                              });
                            },
                            direction: DismissDirection.endToStart,
                            child: Card(
                              color: Colors.grey,
                              child: Column(
                                children: [
                                  SizedBox(height: 10,),
                                  Text('Name : ' + snapshot.data.docs[i]['name'],style: TextStyle(color: Colors.white),),
                                  SizedBox(height: 10,),
                                  Text('Number : ' + snapshot.data.docs[i]['number'],style: TextStyle(color: Colors.white),),
                                  SizedBox(height: 10,),
                                ],
                              ),
                            ),
                          );
                        },
                        // children:  {
                        //   return
                        // }).toList(),
                      );
                    }),
                  ),

            ],),
          ),
        ),
      ),
    );
  }
}
