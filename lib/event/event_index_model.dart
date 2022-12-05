import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:recsseem_mobile/domain/event.dart';

class EventListModel extends ChangeNotifier {
  List<Event> events = [];
  Map<DateTime, List<dynamic>> eventsList = {};  //key:date, value:title

  String? email;
  String? name;
  String? group;
  String? grade;

  void fetchEventList() async {
    final QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('events').get();

    final List<Event> events = snapshot.docs.map((DocumentSnapshot document) {
      Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
      final String id = document.id;
      final String username = data['user_name'];
      final String title = data['title'];
      final DateTime start = data['start'].toDate();
      final DateTime end = data['end'].toDate();
      final String unit = data['unit'];
      final String description = data['description'];
      final bool mailSend = data['mailSend'];
      return Event(id, username, title, start, end, unit, description, mailSend);
    }).toList();

    this.events = events;

    this.eventsList = {};

    events.forEach((event) => {
      if (eventsList[DateTime(event.start.year, event.start.month, event.start.day)] != null) {
        eventsList[DateTime(event.start.year, event.start.month, event.start.day)]?.add(event)
      }
      else {
        eventsList[DateTime(event.start.year, event.start.month, event.start.day)] = [event]
      }
    });

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

  Future delete(Event event) {
    return FirebaseFirestore.instance.collection('events').doc(event.id).delete();
  }
}