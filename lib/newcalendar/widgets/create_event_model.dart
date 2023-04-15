import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../model/calendar_event.dart';
import '../src/calendar_event_data.dart';

class CreateEventModel extends ChangeNotifier {
  
  String? username;
  String? userId;

  Future fetchUser() async {
    final user = FirebaseAuth.instance.currentUser;

    FirebaseFirestore.instance.collection('users').doc(user!.uid).snapshots().listen((DocumentSnapshot snapshot) {
      username = snapshot.get('name');
    });
    userId = user.uid;
  }

  Future addEvent(CalendarEventData<CalendarEvent> event) async {
    final startDay = DateTime(event.date.year,event.date.month, event.date.day, event.startTime!.hour, event.startTime!.minute);
    final endDay = DateTime(event.endDate.year,event.endDate.month, event.endDate.day, event.endTime!.hour, event.endTime!.minute);

    final doc = FirebaseFirestore.instance.collection('events').doc();
    //firestoreに追加
    await doc.set ({
      'title': event.title,
      'user_name': event.name,
      'start': startDay,
      'end': endDay,
      'unit': event.unit,
      'description': event.description,
      'mailSend': event.mailSend,
      'userId': event.userId,
      'color': event.color.value,
    });
    notifyListeners();
  }
}