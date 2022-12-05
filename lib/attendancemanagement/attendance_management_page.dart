import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import '../domain/event.dart';
import '../event/holiday.dart';
import '../login/login_page.dart';
import '../mypage/edit_my_page.dart';
import 'package:url_launcher/link.dart';

import 'attendance_management_model.dart';

class AttendanceManagementPage extends StatefulWidget {
  AttendanceManagementPage({Key? key}) : super(key: key);

  @override
  State<AttendanceManagementPage> createState() => _AttendanceManagementPage();
}

class _AttendanceManagementPage extends State<AttendanceManagementPage> {
  DateTime? _selectedDay;
  DateTime _focusedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.month;

  int getHashCode(DateTime key) {
    return key.day * 1000000 + key.month * 10000 + key.year;
  }

  @override
  Widget build(BuildContext context) {

    return ChangeNotifierProvider<AttendanceListModel>(
      create: (_) => AttendanceListModel()..fetchAttendanceList(),
      child: Scaffold(
        appBar: AppBar(
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
                icon: Icon(Icons.arrow_back_ios),
                onPressed: () {
                  Navigator.of(context).pop();
                }
            ),
          ),
          title: Text('出席管理'),
          backgroundColor: Colors.black,
          centerTitle: true,
          elevation: 0.0,
        ),
        endDrawer: Drawer(
          child: Consumer<AttendanceListModel>(builder: (context, model, child) {
            return ListView(
              children: [
                DrawerHeader(
                  decoration: BoxDecoration(
                      color: Colors.yellow
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('Menu&MyAccount',
                        style: TextStyle(
                          fontSize: 25,
                        ),
                      ),
                      Text('UserName：${model.name}'),
                      Text('Group：${model.group}'),
                      Text('Grade：${model.grade}'),
                      Text('Email：${model.email}'),
                    ],
                  ),
                ),
                ListTile(
                  title: TextButton.icon(
                    icon: Icon(
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
                    label: Text('ログアウト'),
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
                              return EditMyPage();
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
              ],
            );
          }),
        ),
        body: SingleChildScrollView(
          child: Consumer<AttendanceListModel>(builder: (context, model, child) {
            final DateFormat outputdate = DateFormat('yyyy-MM-dd');
            final DateFormat outputtime = DateFormat('a hh:mm');

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Card(
                  clipBehavior: Clip.antiAlias,
                  margin: const EdgeInsets.all(8.0),
                  child: TableCalendar(
                    //eventLoader: _getEventForDay,
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
            },
          );
        }),
      ),
    );
  }
  Color _textColor(DateTime day) {
    const _defaultTextColor = Colors.black87;

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

    return _defaultTextColor;
  }


  String outputDate(DateTime day) {
    DateFormat output = DateFormat('yyyy/MM/dd/(EE)');
    return output.format(day);
  }

  Future showConfirmDialog(BuildContext context, Event event, AttendanceListModel model,) {
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
                  //modelで削除
                  //await model.delete(event);
                  Navigator.pop(context);
                  final snackBar = SnackBar(
                    backgroundColor: Colors.blue,
                    content: Text("${event.title}を削除しました"),
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

}

