import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../domain/event.dart';

class EditEventModel extends ChangeNotifier {
  final Event event;
  EditEventModel(this.event) {
    descriptionController.text = event.description;
  }

  final descriptionController = TextEditingController();

  String? description;
  String? title;
  String? unit;
  DateTime? start;
  DateTime? end;
  bool? mailSend;

  void setDiscription(String description){
    this.description = description;
    notifyListeners();
  }

  Future update(String title, String unit, DateTimeRange dateTimeRange, TimeOfDay startTime, TimeOfDay endTime, bool mailsend) async {
    this.title = title;
    this.unit = unit;
    this.description = descriptionController.text;
    this.start = DateTime(
      dateTimeRange.start.year,
      dateTimeRange.start.month,
      dateTimeRange.start.day,
      startTime.hour,
      startTime.minute,
    );
    this.end = DateTime(
      dateTimeRange.end.year,
      dateTimeRange.end.month,
      dateTimeRange.end.day,
      endTime.hour,
      endTime.minute,
    );
    this.mailSend = mailsend;

    if (title == null || title == '') {
      throw 'タイトルが入力されていません';
    }

    if(title.length > 30) {
      throw 'タイトルの文字数が多いです';
    }
    // firestoreに更新
    FirebaseFirestore.instance.collection('events').doc(event.id).update({
      'title': title,
      'start': start,
      'end': end,
      'unit': unit,
      'description': description,
      'mailSend': mailSend,
    });
  }
}