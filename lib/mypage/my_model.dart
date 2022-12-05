import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyModel extends ChangeNotifier {
  bool isLoading = false;
  String? email;
  String? name;
  String? group;
  String? grade;

  void startLoading(){
    isLoading = true;
    notifyListeners();
  }

  void endLoading()
  {
    isLoading = false;
    notifyListeners();
  }

  void fetchUser() async {
    final user = FirebaseAuth.instance.currentUser;

    FirebaseFirestore.instance.collection('users').doc(user!.uid).snapshots().listen((DocumentSnapshot snapshot) {
      this.name = snapshot.get('name');
      this.group = snapshot.get('group');
      this.grade = snapshot.get('grade');
      this.email = snapshot.get('email');
      notifyListeners();
    });
    notifyListeners();
  }

  Future logout() async {
    await FirebaseAuth.instance.signOut();
  }
}