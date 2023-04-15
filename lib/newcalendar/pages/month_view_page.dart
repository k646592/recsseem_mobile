import 'package:flutter/material.dart';
import 'package:recsseem_mobile/newcalendar/pages/day_view_page.dart';
import 'package:recsseem_mobile/newcalendar/pages/week_view_page.dart';
import 'package:recsseem_mobile/newcalendar/view/extension.dart';

import '../model/calendar_event.dart';
import '../src/calendar_controller_provider.dart';
import '../src/calendar_event_data.dart';
import '../widgets/month_view_widget.dart';
import 'create_event_page.dart';

class MonthViewPageDemo extends StatefulWidget {
  const MonthViewPageDemo({
    Key? key,
  }) : super(key: key);

  @override
  _MonthViewPageDemoState createState() => _MonthViewPageDemoState();
}

class _MonthViewPageDemoState extends State<MonthViewPageDemo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('イベント一覧(月)'),
        centerTitle: true,
        actions: [
          TextButton(
              onPressed: () async {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return const WeekViewDemo();
                    },
                  ),
                );
              },
              child: const Text('週',
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
      body: const MonthViewWidget(),
    );
  }

  Future<void> _addEvent() async {
    final event = await context.pushRoute<CalendarEventData<CalendarEvent>>(
      CreateEventPage(
        withDuration: true,
      ),
    );
    if (event == null) return;
    CalendarControllerProvider.of<CalendarEvent>(context).controller.add(event);
  }
}
