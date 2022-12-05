import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:recsseem_mobile/HeaderandFooter/footer.dart';
import 'package:recsseem_mobile/event/add_event_model.dart';

class AddEventPage extends StatefulWidget {
  final DateTime selectedDate;
  final String outputdate;
  final DateTime select;

  const AddEventPage(this.select, {Key? key, required this.selectedDate, required this.outputdate}) : super(key: key);
  @override
  _AddEventPageState createState() => _AddEventPageState(select);

}

class _AddEventPageState extends State<AddEventPage> {

  final DateTime select;
  _AddEventPageState(this.select){
    dateRange = DateTimeRange(
        start: select,
        end: select
    );
  }

  DateTimeRange? dateRange;

  TimeOfDay start_time = TimeOfDay(hour: 0, minute: 00);
  TimeOfDay end_time = TimeOfDay(hour: 23, minute: 59);

  String _title = 'ミーティング';
  String _content = 'ミーティング';
  bool display = false;

  void _handleDropdownButton(String content) =>
      setState(() {
        _content = content;
      });

  void _handletitle(String title) =>
      setState(() {
        if (title == 'その他') {
          _title = '';
          display = true;
        }
        else {
          _title = title;
          display = false;
        }
      });

  String _unit = '全体';
  void _handleunit(String unit) =>
      setState(() {
        _unit = unit;
      });

  bool _mailSend = true;

  @override
  Widget build(BuildContext context) {
    final start = dateRange!.start;
    final end = dateRange!.end;
    final difference = dateRange!.duration;

    return ChangeNotifierProvider<AddEventModel>(
      create: (_) => AddEventModel()..fetchUser(),
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
            Consumer<AddEventModel>(builder: (context, model, child) {
              return Center(
                child: ElevatedButton(
                  onPressed: () async {
                    model.startLoading();
                    try {
                      await model.addEvent(_title, _unit, dateRange!, start_time, end_time, _mailSend);
                      //イベント登録
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) {
                              return Footer();
                            }
                        ),
                      );

                      final snackBar = SnackBar(
                        backgroundColor: Colors.green,
                        content: Text('イベントを追加しました'),
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
                      model.endLoading();
                    }
                  },
                  child: Text("追加"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                ),
              );
            }),
          ],
          title: Text('イベント追加'),
        ),
        body: Center(
          child: Consumer<AddEventModel>(builder: (context, model, child) {
            return ListView(
              padding: const EdgeInsets.all(16.0),
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '日付：${widget.outputdate}',
                      style: TextStyle(
                        fontSize: 25,
                      ),
                    ),
                    Divider(
                      color: Colors.black,
                    ),
                    Text(
                      '入力者：${model.username}',
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
                            value: _content,
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
                              _handletitle(_content);
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
                              hintText: '$_title',
                            ),
                            enabled: display,
                            onChanged: (text) {
                              setState(() {
                                _title = text;
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
                              start_time.format(context),
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
                              end_time.format(context),
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
                            value: _unit,
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
                              model.setUnit(text);
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
                              model.setDescription(text);
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
                                value: _mailSend,
                                onChanged: (value) {
                                  setState(() {
                                    _mailSend = value;
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
    final initialTime = start_time;

    final newTime =
    await showTimePicker(
        context: context, initialTime: initialTime);

    if (newTime != null) {
      setState(() {
        start_time = newTime;
      });
    }
    else {
      return;
    }
  }

  Future _pickEndTime(BuildContext context) async {
    final initialTime = end_time;

    final newTime =
    await showTimePicker(
        context: context, initialTime: initialTime);

    if (newTime != null) {
      setState(() {
        end_time = newTime;
      });
    }
    else {
      return;
    }
  }
}