import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:recsseem_mobile/domain/attendance.dart';

class EditAttendanceModel extends ChangeNotifier {
  final Attendance attendance;
  EditAttendanceModel(this.attendance) {
    descriptionController.text = attendance.description;
  }

  final descriptionController = TextEditingController();

  String? description;
  String? title;
  DateTime? start;
  DateTime? end;
  bool? mailSend;

  void setDiscription(String description){
    this.description = description;
    notifyListeners();
  }

  Future update(String content, DateTimeRange dateTimeRange, TimeOfDay startTime, TimeOfDay endTime, bool mailsend) async {
    this.title = content;
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


    // firestoreに更新
    FirebaseFirestore.instance.collection('attendances').doc(attendance.id).update({
      'title': title,
      'start': start,
      'end': end,
      'description': description,
      'mailSend': mailSend,
    });
    notifyListeners();
  }
}