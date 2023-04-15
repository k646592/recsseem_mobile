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
  String? status;


  void fetchEventList() async {
    final user = FirebaseAuth.instance.currentUser;

    final QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('events').get();

    final List<Event> events = snapshot.docs.map((DocumentSnapshot document) {
      Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
      final String id = document.id;
      final String username = data['user_name'].toString();
      final String title = data['title'].toString();
      final DateTime start = data['start'].toDate();
      final DateTime end = data['end'].toDate();
      final String unit = data['unit'];
      final String description = data['description'];
      final bool mailSend = data['mailSend'];
      final String userId = data['userId'];
      final int color = data['color'];
      return Event(id, username, title, start, end, unit, description, mailSend, userId, color);
    }).toList();

    this.events = events;

    for (var event in events) {
      if (eventsList[DateTime(event.start.year, event.start.month, event.start.day)] != null) {
        eventsList[DateTime(event.start.year, event.start.month, event.start.day)]?.add(event);
      }
      else {
        eventsList[DateTime(event.start.year, event.start.month, event.start.day)] = [event];
      }
    }

    FirebaseFirestore.instance.collection('users').doc(user!.uid).snapshots().listen((DocumentSnapshot snapshot) {
      name = snapshot.get('name');
      group = snapshot.get('group');
      grade = snapshot.get('grade');
      email = snapshot.get('email');
      status = snapshot.get('status');
    });

    notifyListeners();
  }

  Future delete(Event event) {
    final user = FirebaseAuth.instance.currentUser;
    if ( user!.uid != event.userId){
      throw 'イベント投稿者ではないため、削除できません。';
    }
    return FirebaseFirestore.instance.collection('events').doc(event.id).delete();
  }
}