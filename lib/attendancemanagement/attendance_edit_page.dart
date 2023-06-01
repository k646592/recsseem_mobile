import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:recsseem_mobile/HeaderandFooter/footer.dart';
import 'package:recsseem_mobile/domain/attendance.dart';

import 'attendance_edit_model.dart';

class EditAttendancePage extends StatefulWidget {
  final Attendance attendance;
  const EditAttendancePage(this.attendance, {Key? key}) : super(key: key);

  @override
  _EditAttendancePageState createState() => _EditAttendancePageState(attendance);

}

class _EditAttendancePageState extends State<EditAttendancePage> {
  final Attendance attendance;
  _EditAttendancePageState(this.attendance){
    title = attendance.title;
    username = attendance.username;
    dateRange = DateTimeRange(start: DateTime(attendance.start.year,attendance.start.month,attendance.start.day), end: DateTime(attendance.end.year,attendance.end.month,attendance.end.day));
    startTime = TimeOfDay(hour: attendance.start.hour, minute: attendance.start.minute);
    endTime = TimeOfDay(hour: attendance.end.hour, minute: attendance.end.minute);
    mailSend = attendance.mailSend;
  }

  String? title;
  String? username;
  TimeOfDay? startTime;
  TimeOfDay? endTime;
  String? unit;
  bool? mailSend;
  DateTimeRange? dateRange;

  bool display = false;

  void _handleDropdownButton(String content) =>
      setState(() {
        title = content;
        if(title == '遅刻' || title == '早退'){
          startTime = TimeOfDay.now();
        }
        else {
          startTime = TimeOfDay(hour: 0, minute: 00);
        }
      });

  @override
  Widget build(BuildContext context) {

    return ChangeNotifierProvider<EditAttendanceModel>(
      create: (_) => EditAttendanceModel(attendance),
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
            Consumer<EditAttendanceModel>(builder: (context, model, child) {
              return Center(
                child: ElevatedButton(
                  child: const Text("更新"),
                  onPressed: () async {
                    try {
                      await model.update(title!,dateRange!,startTime!,endTime!,mailSend!);
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) {
                              return const Footer(pageNumber: 1);
                            }
                        ),
                      );
                      final snackBar = SnackBar(
                        backgroundColor: Colors.blue,
                        content: Text('更新しました'),
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
          title: Text('更新'),
        ),
        body: Center(
          child: Consumer<EditAttendanceModel>(builder: (context, model, child) {
            final start = dateRange!.start;


            return ListView(
              padding: const EdgeInsets.all(16.0),
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '日付：${start}',
                      style: TextStyle(
                        fontSize: 25,
                      ),
                    ),
                    Divider(
                      color: Colors.black,
                    ),
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
                            value: title,
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
                    AttendanceEdit(title!),
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

  Widget AttendanceEdit(String attendance) {
    if(attendance == '遅刻') {
      return Row(
        children: [
          Text('遅刻予定時刻：',
            style: TextStyle(
              fontSize: 25,
            ),
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
                startTime!.format(context),
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
                    endTime!.format(context),
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


}