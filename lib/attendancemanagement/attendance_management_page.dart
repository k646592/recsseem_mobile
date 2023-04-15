import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:recsseem_mobile/attendancemanagement/show_attendance_page.dart';
import 'package:recsseem_mobile/domain/attendance.dart';
import 'package:table_calendar/table_calendar.dart';
import '../event/holiday.dart';
import '../login/login_page.dart';
import '../mypage/edit_my_page.dart';
import 'package:url_launcher/link.dart';
import 'dart:async';
import '../timer/timer.dart';
import 'add_attendance_page.dart';
import 'attendance_edit_page.dart';
import 'attendance_management_model.dart';

class AttendanceManagementPage extends StatefulWidget {
  const AttendanceManagementPage({Key? key}) : super(key: key);

  @override
  State<AttendanceManagementPage> createState() => _AttendanceManagementPage();
}

class _AttendanceManagementPage extends State<AttendanceManagementPage> {
  DateTime? _selectedDay;
  DateTime _focusedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime? _rangeselectionStart;
  DateTime? _rangeselectionEnd;

  final RangeSelectionMode _rangeSelectionMode = RangeSelectionMode.toggledOn;

  int getHashCode(DateTime key) {
    return key.day * 1000000 + key.month * 10000 + key.year;
  }

  late int  _lastPostDay;
  late int _today;

  void resetStatus(DateTime now) {
    setState(() {
      FirebaseFirestore.instance.collection('users').
      get().then((QuerySnapshot snapshot) {
        for (var doc in snapshot.docs) {
          FirebaseFirestore.instance.collection('users').doc(doc.id).update({
            'status': '未出席'
          });
        }
      });
      FirebaseFirestore.instance.collection('days').doc('HbUdJuhMTmmNdYrGdWw1').update({
        'day': now
      });
    });
  }

  @override
  void initState() {
    DateTime now = DateTime.now();
    _today = int.parse(DateFormat('yyyyMMdd').format(now));
    FirebaseFirestore.instance.collection('days').doc('HbUdJuhMTmmNdYrGdWw1').snapshots().listen((DocumentSnapshot snapshot) {
      _lastPostDay = int.parse(DateFormat('yyyyMMdd').format(snapshot.get('day').toDate()));
      if (_today > _lastPostDay) {
        resetStatus(now);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return ChangeNotifierProvider<AttendanceListModel>(
      create: (_) => AttendanceListModel()..fetchAttendanceList(),
      child: Scaffold(
        appBar: AppBar(
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                  icon: Icon(Icons.timer),
                  onPressed: () async {
                    await Navigator.of(context).push(
                        MaterialPageRoute(builder: (context){
                          return ClockTimer();
                        })
                    );
                  }
              ),
            ),
          ],
          title: const Text('出席管理'),
          backgroundColor: Colors.black,
          centerTitle: true,
          elevation: 0.0,
        ),

        drawer: Drawer(
          child: Consumer<AttendanceListModel>(builder: (context, model, child) {
            return ListView(
              children: [
                DrawerHeader(
                  decoration: const BoxDecoration(
                      color: Colors.yellow
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text('Menu&MyAccount',
                        style: TextStyle(
                          fontSize: 25,
                        ),
                      ),
                      Text('UserName：${model.name}'),
                      Text('Group：${model.group}'),
                      Text('Grade：${model.grade}'),
                      Text('Email：${model.email}'),
                      Text('出席状況：${model.status}'),
                    ],
                  ),
                ),
                ListTile(
                  title: TextButton.icon(
                    icon: const Icon(
                      Icons.logout_outlined,
                    ),
                    onPressed: () async {
                      try {
                        await FirebaseAuth.instance.signOut();
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) {
                                return LoginPage();
                              }
                          ),
                        );
                        final snackBar = SnackBar(
                          backgroundColor: Colors.green,
                          content: Text('ログアウトしました'),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      } catch (e) {
                        //失敗した場合
                        final snackBar = SnackBar(
                          backgroundColor: Colors.red,
                          content: Text(e.toString()),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                    },
                    label: const Text('ログアウト'),
                  ),
                ),
                Divider(
                  color: Colors.black,
                ),
                ListTile(
                  title: TextButton.icon(
                    onPressed: () async {
                      await Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) {
                              return EditMyPage(name: model.name!, email: model.email!, group: model.group!, grade: model.grade!,);
                            }
                        ),
                      );
                    },
                    icon: Icon(
                      Icons.manage_accounts,
                    ),
                    label: Text('アカウント情報変更'),
                  ),
                ),
                Divider(
                  color: Colors.black,
                ),
                ListTile(
                  title: Link(
                    // 開きたいWebページのURLを指定
                    uri: Uri.parse('https://p.al.kansai-u.ac.jp/'),
                    // targetについては後述
                    target: LinkTarget.self,
                    builder: (BuildContext ctx, FollowLink? openLink) {
                      return TextButton.icon(
                        onPressed: openLink,
                        label: const Text(
                          'Polemanage',
                        ),
                        icon: Icon(Icons.poll),
                      );
                    },
                  ),
                ),
                Divider(
                  color: Colors.black,
                ),
                ListTile(
                  title: Link(
                    // 開きたいWebページのURLを指定
                    uri: Uri.parse('http://192.168.11.115:3000'),
                    // targetについては後述
                    target: LinkTarget.self,
                    builder: (BuildContext ctx, FollowLink? openLink) {
                      return TextButton.icon(
                        onPressed: openLink,
                        label: const Text(
                          '齋藤作 New bole (研究室内のみ)',
                        ),
                        icon: Icon(Icons.library_books),
                      );
                    },
                  ),
                ),
                const Divider(
                  color: Colors.black,
                ),
              ],
            );
          }),
        ),
        body: SingleChildScrollView(
          child: Consumer<AttendanceListModel>(builder: (context, model, child) {
            final attendancesList = model.attendancesList;

            final attendances = LinkedHashMap<DateTime, List<dynamic>>(
              equals: isSameDay,
              hashCode: getHashCode,
            )..addAll(attendancesList);

            List _getAttendanceForDay(DateTime day) {
              return attendances[day] ?? [];
            }

            final List<Widget> widgets = _getAttendanceForDay(_focusedDay).map(
                  (attendance) => Slidable(
                actionPane: SlidableDrawerActionPane(),
                child: ListTile(
                  leading: IconButton(
                    onPressed: () {
                      setState(() {
                        _rangeselectionStart = attendance.start;
                        _rangeselectionEnd = attendance.end;
                      });
                    },
                    icon: Icon(Icons.calendar_month),
                  ),
                  title: Text(attendance.title),
                  subtitle: Text(attendance.username),
                  trailing: dateAndTimeList(attendance),
                ),
                actions: <Widget>[
                  IconSlideAction(
                    caption: '詳細',
                    color: Colors.black87,
                    icon: Icons.more_horiz,
                    onTap: () async {
                      //詳細画面に遷移
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ShowAttendancePage(attendance),
                          fullscreenDialog: true,
                        ),
                      );
                    },
                  ),
                ],
                secondaryActions: <Widget>[
                  IconSlideAction(
                    caption: '編集',
                    color: Colors.blue,
                    icon: Icons.edit,
                    onTap: () async {
                      try{
                        if(user!.uid != attendance.userId){
                          throw 'イベント投稿者ではないため、編集できません。';
                        }
                        //編集画面に遷移
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditAttendancePage(attendance),
                            fullscreenDialog: true,
                          ),
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
                  ),
                  IconSlideAction(
                    caption: '削除',
                    color: Colors.red,
                    icon: Icons.delete,
                    onTap: () async {
                      //削除しますか？って聞いて、はいだったら削除
                      await showConfirmDialog(context, attendance, model);
                    },
                  ),
                ],
              ),
            ).toList();

            final userGroupList = model.userGroupList;

            List _getUserGroup(String text) {
              return userGroupList[text] ?? [];
            }

            String Network = 'Network班';
            String Web = 'Web班';
            String Grid = 'Grid班';
            String Teacher = '教員';

            final List<Widget> NetIndex = _getUserGroup(Network).map(
                    (user) => Expanded(
                      child: Container(
                        alignment: Alignment.center,
                        child: Text('${user.name}'),
                        decoration: BoxDecoration(
                            color: _attendanceColor(user.status),
                            border: Border.all(
                              color: Colors.black45,
                            ),
                        ),
                      ),
                    ),
            ).toList();

            final List<Widget> WebIndex = _getUserGroup(Web).map(
                  (user) => Expanded(
                child: Container(
                  alignment: Alignment.center,
                  child: Text('${user.name}'),
                  decoration: BoxDecoration(
                    color: _attendanceColor(user.status),
                    border: Border.all(
                      color: Colors.black45,
                    ),
                  ),
                ),
              ),
            ).toList();

            final List<Widget> GridIndex = _getUserGroup(Grid).map(
                  (user) => Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    child: Text('${user.name}'),
                    decoration: BoxDecoration(
                      color: _attendanceColor(user.status),
                      border: Border.all(
                        color: Colors.black45,
                      ),
                    ),
                  ),
                ),
            ).toList();

            final List<Widget> TeacherIndex = _getUserGroup(Teacher).map(
                  (user) => Expanded(
                child: Container(
                  alignment: Alignment.center,
                  child: Text('${user.name}'),
                  decoration: BoxDecoration(
                    color: _attendanceColor(user.status),
                    border: Border.all(
                      color: Colors.black45,
                    ),
                  ),
                ),
              ),
            ).toList();

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Card(
                  clipBehavior: Clip.antiAlias,
                  margin: const EdgeInsets.all(4.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            await model.attendanceUpdate('出席');
                            final snackBar = SnackBar(
                              backgroundColor: Colors.green,
                              content: Text("出席しました"),
                            );
                            model.fetchAttendanceList();
                            ScaffoldMessenger.of(context).
                            showSnackBar(snackBar);
                          },
                          child: Text(
                            '出席',
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.green[400], //ボタンの背景色
                            onPrimary: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Expanded(
                        child: ElevatedButton(
                            onPressed: () async {
                              await model.attendanceUpdate('一時退席');
                              final snackBar = SnackBar(
                                backgroundColor: Colors.yellow,
                                content: Text("一時退席しました"),
                              );
                              model.fetchAttendanceList();
                              ScaffoldMessenger.of(context).
                              showSnackBar(snackBar);
                            },
                          child: Text(
                            '一時退席',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 9,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.yellow, //ボタンの背景色
                            onPrimary: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            await model.attendanceUpdate('帰宅');
                            final snackBar = SnackBar(
                              backgroundColor: Colors.grey,
                              content: Text("帰宅しました"),
                            );
                            model.fetchAttendanceList();
                            ScaffoldMessenger.of(context).
                            showSnackBar(snackBar);
                          },
                          child: Text(
                            '帰宅',
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.grey, //ボタンの背景色
                            onPrimary: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            await model.attendanceUpdate('欠席');
                            final snackBar = SnackBar(
                              backgroundColor: Colors.red,
                              content: Text("欠席しました"),
                            );
                            model.fetchAttendanceList();
                            ScaffoldMessenger.of(context).
                            showSnackBar(snackBar);
                          },
                          child: Text(
                            '欠席',
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.red, //ボタンの背景色
                            onPrimary: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            await model.attendanceUpdate('未出席');
                            final snackBar = SnackBar(
                              backgroundColor: Colors.blue,
                              content: Text("未出席になりました"),
                            );
                            model.fetchAttendanceList();
                            ScaffoldMessenger.of(context).
                            showSnackBar(snackBar);
                          },
                          child: Text(
                            '未出席',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.blue, //ボタンの背景色
                            onPrimary: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Card(
                  clipBehavior: Clip.antiAlias,
                  margin: const EdgeInsets.all(2.0),
                  child: Row(
                    children: [
                      Container(
                        width: 100,
                          alignment: Alignment.center,
                          child: Text('Net班'),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                color: Colors.black45,
                              )
                          ),
                      ),
                      Expanded(
                          child: Row(
                            children: NetIndex,
                          ),
                      ),
                    ]
                  ),
                ),
                Card(
                  clipBehavior: Clip.antiAlias,
                  margin: const EdgeInsets.all(2.0),
                  child: Row(
                      children: [
                        Container(
                          width: 100,
                          alignment: Alignment.center,
                          child: Text('Grid班'),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                color: Colors.black45,
                              )
                          ),
                        ),
                        Expanded(
                          child: Row(
                            children: GridIndex,
                          ),
                        ),
                      ]
                  ),
                ),
                Card(
                  clipBehavior: Clip.antiAlias,
                  margin: const EdgeInsets.all(2.0),
                  child: Row(
                      children: [
                        Container(
                          width: 100,
                          alignment: Alignment.center,
                          child: Text('Web班'),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                color: Colors.black45,
                              )
                          ),
                        ),
                        Expanded(
                          child: Row(
                            children: WebIndex,
                          ),
                        ),
                      ]
                  ),
                ),
                Card(
                  clipBehavior: Clip.antiAlias,
                  margin: const EdgeInsets.all(2.0),
                  child: Row(
                      children: [
                        Container(
                          width: 100,
                          alignment: Alignment.center,
                          child: Text('教員'),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                color: Colors.black45,
                              )
                          ),
                        ),
                        Expanded(
                          child: Row(
                            children: TeacherIndex,
                          ),
                        ),
                      ]
                  ),
                ),
                Card(
                  clipBehavior: Clip.antiAlias,
                  margin: const EdgeInsets.all(8.0),
                  child: TableCalendar(
                    eventLoader: _getAttendanceForDay,

                    rangeSelectionMode: _rangeSelectionMode,
                    rangeStartDay: _rangeselectionStart,
                    rangeEndDay: _rangeselectionEnd,

                    firstDay: DateTime.utc(2010, 1, 1),
                    lastDay: DateTime.utc(2030, 1, 1),
                    focusedDay: _focusedDay,

                    //カレンダー曜日スタイル
                    calendarBuilders: CalendarBuilders(
                        defaultBuilder: (
                            BuildContext context, DateTime day, DateTime focusedDay) {
                          return Container(
                            alignment: Alignment(0.0, 0.0),
                            child: Text(
                              day.day.toString(),
                              style: TextStyle(
                                color: _textColor(day),
                              ),
                            ),
                          );
                        },
                        dowBuilder: (context, day) {
                          if (day.weekday == DateTime.sunday) {
                            final text = DateFormat.E().format(day);

                            return Center(
                              child: Text(
                                text,
                                style: TextStyle(color: Colors.red),
                              ),
                            );
                          }
                          else if(day.weekday == DateTime.saturday) {
                            final text =DateFormat.E().format(day);

                            return Center(
                              child: Text(
                                text,
                                style: TextStyle(color: Colors.blue),
                              ),
                            );
                          }
                        }
                    ),

                    //カレンダーのヘッダー
                    headerStyle: HeaderStyle(
                      decoration: BoxDecoration(
                        color: Colors.blue,
                      ),
                      headerMargin: const EdgeInsets.only(bottom: 8.0),
                      titleTextStyle: TextStyle(color: Colors.white),
                      formatButtonDecoration: BoxDecoration(
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      formatButtonTextStyle: TextStyle(color: Colors.white),
                      leftChevronIcon: Icon(Icons.chevron_left, color: Colors.white,),
                      rightChevronIcon: Icon(Icons.chevron_right, color: Colors.white,),
                    ),

                    //カレンダーのフォーマット
                    calendarFormat: _calendarFormat,
                    onFormatChanged: (format) {
                      if (_calendarFormat != format) {
                        setState(() {
                          _calendarFormat = format;
                        });
                      }
                    },
                    startingDayOfWeek: StartingDayOfWeek.sunday,
                    daysOfWeekVisible: true,

                    //日付選択
                    selectedDayPredicate: (day) {
                      return isSameDay(_selectedDay, day);
                    },
                    onDaySelected: (selectedDay, focusedDay) {
                      if (!isSameDay(_selectedDay, selectedDay)) {
                        setState(() {
                          _selectedDay = selectedDay;
                          _focusedDay = focusedDay;
                        });
                      };
                    },

                    //カレンダースタイル
                    calendarStyle: CalendarStyle(
                      isTodayHighlighted: true,
                      //選択された日付のUI
                      selectedDecoration: BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                      ),
                      selectedTextStyle: TextStyle(color: Colors.white),

                      //今日の日付のUI
                      todayDecoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.5),
                        shape: BoxShape.circle,
                      ),
                      todayTextStyle: TextStyle(color: Colors.white),

                    ),
                  ),
                ),
                Scrollbar(
                  child: ListView(
                    shrinkWrap: true,
                    children: widgets,
                  ),
                ),
              ],
            );
          }),
        ),

        floatingActionButton: Consumer<AttendanceListModel>(builder: (context, model, child) {
          return FloatingActionButton(
            child: Icon(Icons.add),
            tooltip: 'Increment',
            backgroundColor: Colors.lightGreen,
            //ボタンが押されたら
            onPressed: () async {
              //add_出席管理
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return AddAttendancePage(_focusedDay, selectedDate: _focusedDay, outputdate: outputDate(_focusedDay),);
                  },
                  fullscreenDialog: true,
                ),
              );
            },
          );
        }),
      ),
    );
  }
  Color _textColor(DateTime day) {
    const defaultTextColor = Colors.black87;

    if (day.weekday == DateTime.sunday) {
      return Colors.red;
    }

    for(var i=0; i<Holidays.holidays.length; i++) {
      if(day == Holidays.holidays[i]) {
        return Colors.red;
      }
    }

    if (day.weekday == DateTime.saturday) {
      return Colors.blue[600]!;
    }

    return defaultTextColor;
  }


  String outputDate(DateTime day) {
    DateFormat output = DateFormat('yyyy/MM/dd/(EE)');
    return output.format(day);
  }

  Future showConfirmDialog(BuildContext context, Attendance attendance, AttendanceListModel model,) {
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
                  //modelで削除
                  await model.delete(attendance);
                  Navigator.pop(context);
                  final snackBar = SnackBar(
                    backgroundColor: Colors.blue,
                    content: Text("${attendance.title}を削除しました"),
                  );
                  model.fetchAttendanceList();
                  ScaffoldMessenger.of(context).
                  showSnackBar(snackBar);
                },
              ),
            ],
          );
        }
    );
  }

  Widget dateAndTimeList(Attendance attendance) {
    if(attendance.title == '遅刻'){
      return Text('到着予定時刻：${DateFormat('a hh:mm').format(attendance.start)}');
    }
    else if(attendance.title == '早退'){
      return Text('早退予定時刻：${DateFormat('a hh:mm').format(attendance.start)}');
    }
    else {
      return Column(
        children: [
          Text('日付：${DateFormat('yyyy/MM/dd').format(attendance.start)} 〜 ${DateFormat('yyyy/MM/dd').format(attendance.end)}'),
          Text('時刻：${DateFormat('a hh:mm').format(attendance.start)} 〜 ${DateFormat('a hh:mm').format(attendance.end)}')
        ],
      );
    }
  }
  
  Color _attendanceColor(String text){
    if (text == '一時退席'){
      return Colors.yellow;
    }
    else if (text == '出席'){
      return Colors.green;
    }
    else if(text == '欠席'){
      return Colors.red;
    }
    else if(text == '帰宅'){
      return Colors.grey;
    }
    else return Colors.blue;
  }
  
}

