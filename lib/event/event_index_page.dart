import 'dart:collection';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:recsseem_mobile/event/event_index_model.dart';
import 'package:recsseem_mobile/event/show_event_page.dart';
import 'package:table_calendar/table_calendar.dart';
import '../HeaderandFooter/drawer.dart';
import '../domain/event.dart';
import '../timer/timer.dart';
import 'add_event_page.dart';
import 'event_edit_page.dart';
import 'holiday.dart';
import 'dart:async';

class EventIndexPage extends StatefulWidget {
  const EventIndexPage({Key? key}) : super(key: key);

  @override
  State<EventIndexPage> createState() => _EventIndexPage();
}

class _EventIndexPage extends State<EventIndexPage> {
  DateTime? _selectedDay;
  DateTime _focusedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.month;

  int getHashCode(DateTime key) {
    return key.day * 1000000 + key.month * 10000 + key.year;
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return ChangeNotifierProvider<EventListModel>(
      create: (_) => EventListModel()..fetchEventList(),
      child: Scaffold(
        appBar: AppBar(
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                  icon: const Icon(Icons.timer),
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
          backgroundColor: Colors.black,
          centerTitle: true,
          elevation: 0.0,
          title: const Text('イベント'),
        ),
        drawer: const UserDrawer(),
        body: SingleChildScrollView(
          child: Consumer<EventListModel>(builder: (context, model, child) {

            final eventsList = model.eventsList;

            final _events = LinkedHashMap<DateTime, List<dynamic>>(
              equals: isSameDay,
              hashCode: getHashCode,
            )..addAll(eventsList);

            List _getEventForDay(DateTime day) {
              return _events[day] ?? [];
            }

            final DateFormat outputdate = DateFormat('yyyy-MM-dd');
            final DateFormat outputtime = DateFormat('a hh:mm');

            final List<Widget> widgets = _getEventForDay(_focusedDay).map(
                (event) => Slidable(
                  actionPane: SlidableDrawerActionPane(),
                  child: ListTile(
                    title: Text(event.title),
                    subtitle: Text(event.username),
                    trailing: Column(
                      children: [
                        Text('日付：${outputdate.format(event.start)} 〜 ${outputdate.format(event.end)}'),
                        Text('時刻：${outputtime.format(event.start)} 〜 ${outputtime.format(event.end)}')
                      ],
                    ),
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
                            builder: (context) => ShowEventPage(event),
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
                          if(user!.uid != event.userId){
                            throw 'イベント投稿者ではないため、編集できません。';
                          }
                          //編集画面に遷移
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditEventPage(event),
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
                        await showConfirmDialog(context, event, model);
                      },
                    ),
                  ],
                ),
            ).toList();

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Card(
                  clipBehavior: Clip.antiAlias,
                  margin: const EdgeInsets.all(8.0),
                  child: TableCalendar(
                    eventLoader: _getEventForDay,
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
                ListView(
                        shrinkWrap: true,
                        children: widgets,
                ),
              ],
            );
          }),
        ),

        floatingActionButton: Consumer<EventListModel>(builder: (context, model, child) {
          return FloatingActionButton(
            child: Icon(Icons.add),
            tooltip: 'Increment',
            backgroundColor: Colors.lightGreen,
            //ボタンが押されたら
            onPressed: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) {
                      return AddEventPage(_focusedDay, selectedDate: _focusedDay, outputdate: outputDate(_focusedDay),);
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

  Future showConfirmDialog(BuildContext context, Event event, EventListModel model,) {
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
                  try {
                    await model.delete(event);
                    Navigator.pop(context);
                    final snackBar = SnackBar(
                      backgroundColor: Colors.blue,
                      content: Text("${event.title}を削除しました"),
                    );
                    model.fetchEventList();
                    ScaffoldMessenger.of(context).
                    showSnackBar(snackBar);
                  }
                  catch (e){
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

