import 'package:flutter/material.dart';
import 'package:recsseem_mobile/newcalendar/pages/month_view_page.dart';
import 'package:recsseem_mobile/newcalendar/view/extension.dart';

import '../model/calendar_event.dart';
import '../src/calendar_controller_provider.dart';
import '../src/calendar_event_data.dart';
import '../widgets/week_view_widget.dart';
import 'create_event_page.dart';
import 'day_view_page.dart';

class WeekViewDemo extends StatefulWidget {
  const WeekViewDemo({Key? key}) : super(key: key);

  @override
  _WeekViewDemoState createState() => _WeekViewDemoState();
}

class _WeekViewDemoState extends State<WeekViewDemo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('イベント一覧(週)'),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () async {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return const MonthViewPageDemo();
                  },
                ),
              );
            },
            child: const Text('月',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            style: TextButton.styleFrom(
              minimumSize: Size(10, 10), //最小のサイズ

            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return const DayViewPageDemo();
                  },
                ),
              );
            },
            child: const Text('日',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            style: TextButton.styleFrom(
              minimumSize: Size(10, 10), //最小のサイズ

            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        elevation: 8,
        onPressed: _addEvent,
      ),
      body: const WeekViewWidget(),
    );
  }

  Future<void> _addEvent() async {
    final event =
    await context.pushRoute<CalendarEventData<CalendarEvent>>(CreateEventPage(
      withDuration: true,
    ));
    if (event == null) return;
    CalendarControllerProvider.of<CalendarEvent>(context).controller.add(event);
  }
}
