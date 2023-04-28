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
  State<MonthViewPageDemo> createState() => _MonthViewPageDemoState();
}

class _MonthViewPageDemoState extends State<MonthViewPageDemo> {



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('イベント一覧(月)'),
          backgroundColor: Colors.black,
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
              style: TextButton.styleFrom(
                minimumSize: const Size(10, 10), //最小のサイズ

              ),
                child: const Text('週',
                  style: TextStyle(
                      color: Colors.white,
                  ),
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
              style: TextButton.styleFrom(
                minimumSize: const Size(10, 10), //最小のサイズ
              ),
              child: const Text('日',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          elevation: 8,
          onPressed: _addEvent,
          child: const Icon(Icons.add),
        ),
        body: const MonthViewWidget(),
    );
  }

  Future<void> _addEvent() async {
    final event = await context.pushRoute<CalendarEventData<CalendarEvent>>(
      const CreateEventPage(
        withDuration: true,
      ),
    );
    if (event == null) return;
    CalendarControllerProvider.of<CalendarEvent>(context).controller.add(event);
  }
}
