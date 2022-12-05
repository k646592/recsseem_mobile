import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:recsseem_mobile/HeaderandFooter/footer.dart';
import 'package:recsseem_mobile/domain/event.dart';
import 'event_edit_model.dart';

class EditEventPage extends StatefulWidget {
  final Event event;
  const EditEventPage(this.event, {Key? key}) : super(key: key);

  @override
  _EditEventPageState createState() => _EditEventPageState(event);

}

class _EditEventPageState extends State<EditEventPage> {
  final Event event;
  _EditEventPageState(this.event){
   title = event.title;
   username = event.username;
   dateRange = DateTimeRange(start: DateTime(event.start.year,event.start.month,event.start.day), end: DateTime(event.end.year,event.end.month,event.end.day));
   startTime = TimeOfDay(hour: event.start.hour, minute: event.start.minute);
   endTime = TimeOfDay(hour: event.end.hour, minute: event.end.minute);
   unit = event.unit;
   mailSend = event.mailSend;
   if(event.title == 'ミーティング' || event.title == '輪講') {
     content = event.title;
   }
   else content = 'その他';
  }

  String? title;
  String? username;
  TimeOfDay? startTime;
  TimeOfDay? endTime;
  String? unit;
  bool? mailSend;
  DateTimeRange? dateRange;
  String? content;

  void _handleDropdownButton(String text) =>
      setState(() {
        content = text;
      });

  void _handletitle(String content) =>
      setState(() {
        if (content == 'その他') {
          title = '';
        }
        else {
          title = content;
        }
      });

  void _handleunit(String text) =>
      setState(() {
        unit = text;
      });

  @override
  Widget build(BuildContext context) {

    return ChangeNotifierProvider<EditEventModel>(
      create: (_) => EditEventModel(event),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: IconButton(
            icon: Icon(Icons.clear, color: Colors.red,),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: [
            Consumer<EditEventModel>(builder: (context, model, child) {
              return Center(
                child: ElevatedButton(
                  child: Text("更新"),
                  onPressed: () async {
                    try {
                      await model.update(title!,unit!,dateRange!,startTime!,endTime!,mailSend!);
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) {
                              return Footer();
                            }
                        ),
                      );
                      final snackBar = SnackBar(
                        backgroundColor: Colors.blue,
                        content: Text('イベントを更新しました'),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    } catch (e) {
                      //失敗した場合
                      final snackBar = SnackBar(
                        backgroundColor: Colors.red,
                        content: Text(e.toString()),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    } finally {
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                  ),
                ),
              );
            }),
          ],
          title: Text('イベント更新'),
        ),
        body: Center(
          child: Consumer<EditEventModel>(builder: (context, model, child) {
            final start = dateRange!.start;
            final end = dateRange!.end;
            final difference = dateRange!.duration;

            return ListView(
              padding: const EdgeInsets.all(16.0),
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '入力者：${username}',
                      style: TextStyle(
                        fontSize: 25,
                      ),
                    ),
                    Divider(
                      color: Colors.black,
                    ),
                    Row(
                      children: [
                        Text('内容：',
                          style: TextStyle(
                            fontSize: 25,
                          ),
                        ),
                        DropdownButton(
                            value: content,
                            items: const [
                              DropdownMenuItem(
                                child: Text('ミーティング'),
                                value: 'ミーティング',
                              ),
                              DropdownMenuItem(
                                child: Text('輪講'),
                                value: '輪講',
                              ),
                              DropdownMenuItem(
                                child: Text('その他'),
                                value: 'その他',
                              ),
                            ],
                            onChanged: (text) {
                              _handleDropdownButton(text!);
                              _handletitle(content!);
                            }
                        ),
                      ],
                    ),
                    Divider(
                      color: Colors.black,
                    ),
                    Row(
                      children: [
                        Text('タイトル：',
                          style: TextStyle(
                            fontSize: 25,
                          ),
                        ),
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: '$title',
                            ),
                            enabled: display(content!),
                            onChanged: (text) {
                              setState(() {
                                title = text;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    Divider(
                      color: Colors.black,
                    ),
                    Row(
                      children: [
                        Text('開始日時：',
                          style: TextStyle(
                            fontSize: 25,
                          ),
                        ),
                        Expanded(
                          child: ElevatedButton(
                              child: Text(
                                  '${start.year}/${start.month}/${start.day}'),
                              onPressed: pickDateRange
                          ),
                        ),
                        SizedBox(
                          width: 16,
                        ),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => _pickStartTime(context),
                            child: Text(
                              startTime!.format(context),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text('終了日時：',
                          style: TextStyle(
                            fontSize: 25,
                          ),
                        ),
                        Expanded(
                          child: ElevatedButton(
                              child: Text(
                                  '${end.year}/${end.month}/${end.day}'),
                              onPressed: pickDateRange
                          ),
                        ),
                        SizedBox(
                          width: 16,
                        ),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => _pickEndTime(context),
                            child: Text(
                              endTime!.format(context),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text('期間日数： ${difference.inDays} 日間',
                          style: TextStyle(
                            fontSize: 25,
                          ),
                        ),
                      ],
                    ),
                    Divider(
                      color: Colors.black,
                    ),
                    Row(
                      children: [
                        Text('参加単位：',
                          style: TextStyle(
                            fontSize: 25,
                          ),
                        ),
                        DropdownButton(
                            value: unit,
                            items: const [
                              DropdownMenuItem(
                                child: Text('全体'),
                                value: '全体',
                              ),
                              DropdownMenuItem(
                                child: Text('個人'),
                                value: '個人',
                              ),
                              DropdownMenuItem(
                                child: Text('Net班'),
                                value: 'Net班',
                              ),
                              DropdownMenuItem(
                                child: Text('Grid班'),
                                value: 'Grid班',
                              ),
                              DropdownMenuItem(
                                child: Text('Web班'),
                                value: 'Web班',
                              ),
                              DropdownMenuItem(
                                child: Text('B4'),
                                value: 'B4',
                              ),
                              DropdownMenuItem(
                                child: Text('M1'),
                                value: 'M1',
                              ),
                              DropdownMenuItem(
                                child: Text('M2'),
                                value: 'M2',
                              ),
                              DropdownMenuItem(
                                child: Text('その他'),
                                value: 'その他',
                              ),
                            ],
                            onChanged: (text) {
                              _handleunit(text!);
                            }
                        ),
                      ],
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
                            controller: model.descriptionController,
                            maxLines: 6,
                            minLines: 6,
                            decoration: InputDecoration(
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
                            onChanged: (text) {
                              model.setDiscription(text);
                            },
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
                                value: mailSend!,
                                onChanged: (value) {
                                  setState(() {
                                    mailSend = value;
                                  });
                                }
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
              ],
            );
          }),
        ),
      ),
    );
  }

  Future pickDateRange() async {
    DateTimeRange? newDateRange = await showDateRangePicker(
      context: context,
      initialDateRange: dateRange,
      firstDate: DateTime(DateTime.now().year - 3),
      lastDate: DateTime(DateTime.now().year + 3),
    );

    if ( newDateRange == null) return;

    setState( () => dateRange = newDateRange );
  }

  Future _pickStartTime(BuildContext context) async {
    final initialTime = startTime!;

    final newTime =
    await showTimePicker(
        context: context, initialTime: initialTime);

    if (newTime != null) {
      setState(() {
        startTime = newTime;
      });
    }
    else {
      return;
    }
  }

  Future _pickEndTime(BuildContext context) async {
    final initialTime = endTime!;

    final newTime =
    await showTimePicker(
        context: context, initialTime: initialTime);

    if (newTime != null) {
      setState(() {
        endTime= newTime;
      });
    }
    else {
      return;
    }
  }

  bool display(String content) {
    if(content == 'ミーティング' || content == '輪講') {
      return false;
    }
    else return true;
  }
}