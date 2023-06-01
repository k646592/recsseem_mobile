import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:recsseem_mobile/HeaderandFooter/footer.dart';

import 'add_attendance_model.dart';

class AddAttendancePage extends StatefulWidget {
  final DateTime selectedDate;
  final String outputdate;
  final DateTime select;

  const AddAttendancePage(this.select, {Key? key, required this.selectedDate, required this.outputdate}) : super(key: key);
  @override
  _AddAttendancePageState createState() => _AddAttendancePageState(select);

}

class _AddAttendancePageState extends State<AddAttendancePage> {

  final DateTime select;
  _AddAttendancePageState(this.select){
    dateRange = DateTimeRange(
      start: select,
      end: select,
    );
  }

  DateTimeRange? dateRange;

  TimeOfDay start_time = TimeOfDay.now();
  TimeOfDay end_time = TimeOfDay(hour: 23, minute: 59);

  String _content = '遅刻';
  bool display = false;

  void _handleDropdownButton(String content) =>
      setState(() {
        _content = content;
        if(_content == '遅刻' || _content == '早退'){
          start_time = TimeOfDay.now();
        }
        else {
          start_time = TimeOfDay(hour: 0, minute: 00);
        }
      });

  bool _mailSend = true;

  @override
  Widget build(BuildContext context) {

    return ChangeNotifierProvider<AddAttendanceModel>(
      create: (_) => AddAttendanceModel()..fetchUser(),
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
            Consumer<AddAttendanceModel>(builder: (context, model, child) {
              return Center(
                child: ElevatedButton(
                  onPressed: () async {
                    model.startLoading();
                    try {
                      await model.addAttendance(_content, dateRange!, start_time, end_time, _mailSend);
                      //イベント登録
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) {
                              return const Footer(pageNumber: 1);
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
          title: Text('出席予定の追加'),
        ),
        body: Center(
          child: Consumer<AddAttendanceModel>(builder: (context, model, child) {
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
                                child: Text('遅刻'),
                                value: '遅刻',
                              ),
                              DropdownMenuItem(
                                child: Text('欠席'),
                                value: '欠席',
                              ),
                              DropdownMenuItem(
                                child: Text('早退'),
                                value: '早退',
                              ),
                            ],
                            onChanged: (text) {
                              _handleDropdownButton(text!);
                            }
                        ),
                      ],
                    ),
                    Divider(
                      color: Colors.black,
                    ),
                    Attendance(_content),
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

  Widget Attendance(String attendance) {
    if(attendance == '遅刻') {
      return Row(
        children: [
          Text('到着予定時刻：',
            style: TextStyle(
              fontSize: 25,
            ),
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
      );
    }
    else if(attendance == '早退'){
      return Row(
        children: [
          Text('早退予定時刻：',
            style: TextStyle(
              fontSize: 25,
            ),
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
      );
    }
    else {
      return Column(
        children: [
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
                        '${dateRange!.start.year}/${dateRange!.start.month}/${dateRange!.start.day}'),
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
                        '${dateRange!.end.year}/${dateRange!.end.month}/${dateRange!.end.day}'),
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
              Text('期間日数： ${dateRange!.duration.inDays} 日間',
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