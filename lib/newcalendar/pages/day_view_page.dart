import 'package:flutter/material.dart';
import 'package:recsseem_mobile/newcalendar/pages/month_view_page.dart';
import 'package:recsseem_mobile/newcalendar/pages/week_view_page.dart';
import 'package:recsseem_mobile/newcalendar/view/extension.dart';

import '../model/calendar_event.dart';
import '../src/calendar_controller_provider.dart';
import '../src/calendar_event_data.dart';
import '../widgets/day_view_widget.dart';
import 'create_event_page.dart';

class DayViewPageDemo extends StatefulWidget {
  const DayViewPageDemo({Key? key}) : super(key: key);

  @override
  _DayViewPageDemoState createState() => _DayViewPageDemoState();
}

class _DayViewPageDemoState extends State<DayViewPageDemo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('イベント一覧(日)'),
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
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        elevation: 8,
        onPressed: () async {
          final event =
          await context.pushRoute<CalendarEventData<CalendarEvent>>(CreateEventPage(
            withDuration: true,
          ));
          if (event == null) return;
          CalendarControllerProvider.of<CalendarEvent>(context).controller.add(event);
        },
      ),
      body: DayViewWidget(),
    );
  }
}
