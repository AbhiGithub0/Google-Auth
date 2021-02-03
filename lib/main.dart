import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async{
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
  Map data;
  String name = '6666665656565656565666565';
  String pass = '010101';

  _signIn() async{
    final GoogleSignInAccount googleUser = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(idToken: googleAuth.idToken,accessToken: googleAuth.accessToken);
    final User user =  (await firebaseAuth.signInWithCredential(credential)).user;

  }
  addData() {

    Map<String,dynamic> demoData = {'Name': name,'Pass' : pass };
    FirebaseFirestore.instance.collection("data").add(demoData);

    // collectionReference.doc(name).add(demoData);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RaisedButton(
                child: Text('Sign In'),
                onPressed: () {
                  _signIn();
                },
              ),
              RaisedButton(
                child: Text('Add Data'),
                onPressed: () {
                  addData();
                },
              ),
          ],),
        ),
      ),
    );
  }
}
