import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:recsseem_mobile/HeaderandFooter/footer.dart';
import 'package:recsseem_mobile/domain/attendance.dart';

import 'attendance_edit_page.dart';

class ShowAttendancePage extends StatelessWidget {
  final Attendance attendance;
  ShowAttendancePage(this.attendance);

  DateFormat output = DateFormat('yyyy/MM/dd  a hh:mm');
  DateFormat outputdate = DateFormat('yyyy/MM/dd');
  DateFormat outputtime = DateFormat('a hh:mm');

  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('詳細'),
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () {
                Navigator.of(context).pop();
              }
          ),
        ),
        actions: [
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                icon: Icon(Icons.edit),
                onPressed: () async {
                  try{
                    if(user!.uid != attendance.userId){
                      throw 'イベント投稿者ではないため、編集できません。';
                    }
                    await Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) {
                              return EditAttendancePage(attendance);
                            }
                        )
                    );
                  }
                  catch(e){
                    final snackBar = SnackBar(
                      backgroundColor: Colors.red,
                      content: Text(e.toString()),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                },
              )
          ),
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                icon: Icon(Icons.delete),
                onPressed: () async {
                  //削除しますか？って聞いて、はいだったら削除
                  await showConfirmDialog(context, attendance);
                },
              )
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: [
              Text('入力者：${attendance.username}',
                style: TextStyle(
                  fontSize: 25,
                ),
              ),
              Divider(
                color: Colors.black,
              ),
              Text('タイトル：${attendance.title}',
                style: TextStyle(
                  fontSize: 25,
                ),
              ),
              Divider(
                color: Colors.black,
              ),
              attendanceList(attendance.title),
              Divider(
                color: Colors.black,
              ),
              Row(
                children: [
                  Text('詳細：',
                    style: TextStyle(
                      fontSize: 25,
                    ),
                  ),
                  Flexible(
                    child: TextFormField(
                      enabled: false,
                      maxLines: 6,
                      minLines: 6,
                      decoration: InputDecoration(
                        hintText: attendance.description,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(0),
                          borderSide: const BorderSide(
                            width: 2,
                            color: Colors.black87,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(0),
                          borderSide: const BorderSide(
                            width: 2,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Divider(
                color: Colors.black,
              ),
              Row(
                children: [
                  Text('メール送信：',
                    style: TextStyle(
                      fontSize: 25,
                    ),
                  ),
                  Flexible(
                    child: ListTile(
                      trailing: CupertinoSwitch(
                        value: attendance.mailSend,
                        onChanged: null,
                      ),
                    ),
                  ),
                ],
              ),
              Divider(
                color: Colors.black,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget attendanceList(String content) {
    if(content == '遅刻') {
      return Column(
        children: [
          Row(
            children: [
              Text('日付：${outputdate.format(attendance.start)}',
                style: TextStyle(
                  fontSize: 25,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Text('到着予定時刻：${outputtime.format(attendance.start)}',
                style: TextStyle(
                  fontSize: 25,
                ),
              ),
            ],
          ),
        ],
      );
    }
    else if(content == '早退'){
      return Column(
        children: [
          Row(
            children: [
              Text('日付：${outputdate.format(attendance.start)}',
                style: TextStyle(
                  fontSize: 25,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Text('早退予定時刻：${outputtime.format(attendance.start)}',
                style: TextStyle(
                  fontSize: 25,
                ),
              ),
            ],
          ),
        ],
      );
    }
    else {
      return Column(
        children: [
          Row(
            children: [
              Text('開始日時：${output.format(attendance.start)}',
                style: TextStyle(
                  fontSize: 25,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Text('終了日時：${output.format(attendance.end)}',
                style: TextStyle(
                  fontSize: 25,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Text('期間日数： ${attendance.end.difference(attendance.start).inDays} 日間',
                style: TextStyle(
                  fontSize: 25,
                ),
              ),
            ],
          ),
        ],
      );
    }
  }

  Future showConfirmDialog(BuildContext context, Attendance attendance) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return AlertDialog(
            title: Text("削除の確認"),
            content: Text("『${attendance.title}』を削除しますか？"),
            actions: [
              TextButton(
                child: Text("いいえ"),
                onPressed: () => Navigator.pop(context),
              ),
              TextButton(
                child: Text("はい"),
                onPressed: () async {
                  final user = FirebaseAuth.instance.currentUser;
                  try{
                    if ( user!.uid != attendance.userId){
                      throw 'イベント投稿者ではないため、削除できません。';
                    }
                    FirebaseFirestore.instance.collection('events').doc(attendance.id).delete();
                    Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) {
                              return const Footer(pageNumber: 1);
                            }
                        )
                    );
                    final snackBar = SnackBar(
                      backgroundColor: Colors.blue,
                      content: Text("${attendance.title}を削除しました"),
                    );
                    ScaffoldMessenger.of(context).
                    showSnackBar(snackBar);
                  }
                  catch(e){
                    final snackBar = SnackBar(
                      backgroundColor: Colors.red,
                      content: Text(e.toString()),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    Navigator.pop(context);
                  }
                },
              ),
            ],
          );
        }
    );
  }
}