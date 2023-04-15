import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:recsseem_mobile/HeaderandFooter/footer.dart';
import 'package:recsseem_mobile/event/event_edit_page.dart';
import '../domain/event.dart';

class ShowEventPage extends StatelessWidget {
  final Event event;
  ShowEventPage(this.event);

  DateFormat output = DateFormat('yyyy/MM/dd  a hh:mm');

  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('イベント詳細'),
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
                  if(user!.uid != event.userId){
                    throw 'イベント投稿者ではないため、編集できません。';
                  }
                  await Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) {
                            return EditEventPage(event);
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
                  await showConfirmDialog(context, event);
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
              Text('入力者：${event.username}',
                style: TextStyle(
                  fontSize: 25,
                ),
              ),
              Divider(
                color: Colors.black,
              ),
              Text('タイトル：${event.title}',
                style: TextStyle(
                  fontSize: 25,
                ),
              ),
              Divider(
                color: Colors.black,
              ),
              Text('開催日時：${output.format(event.start)}',
                style: TextStyle(
                  fontSize: 25,
                ),
              ),
              Text('終了日時：${output.format(event.end)}',
                style: TextStyle(
                  fontSize: 25,
                ),
              ),
              Text('期間日数：${event.end.difference(event.start).inDays} 日間',
                style: TextStyle(
                  fontSize: 25,
                ),
              ),
              Divider(
                color: Colors.black,
              ),
              Text('参加単位：${event.unit}',
                style: TextStyle(
                  fontSize: 25,
                ),
              ),
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
                        hintText: event.description,
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
                          value: event.mailSend,
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

  Future showConfirmDialog(BuildContext context, Event event) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return AlertDialog(
            title: Text("削除の確認"),
            content: Text("『${event.title}』を削除しますか？"),
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
                    if ( user!.uid != event.userId){
                      throw 'イベント投稿者ではないため、削除できません。';
                    }
                    FirebaseFirestore.instance.collection('events').doc(event.id).delete();
                    Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) {
                              return Footer(pageNumber: 0);
                            }
                        )
                    );
                    final snackBar = SnackBar(
                      backgroundColor: Colors.blue,
                      content: Text("${event.title}を削除しました"),
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