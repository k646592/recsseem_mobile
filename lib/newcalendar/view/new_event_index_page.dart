import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recsseem_mobile/newcalendar/pages/month_view_page.dart';
import 'package:recsseem_mobile/newcalendar/pages/web/web_home_page.dart';

import '../model/calendar_event.dart';

import '../src/calendar_controller_provider.dart';
import '../src/event_controller.dart';
import '../widgets/responsive_widget.dart';
import 'new_event_index_model.dart';


class TopPage extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return ChangeNotifierProvider<NewEventListModel>(
      create: (_) => NewEventListModel()..fetchEventList(),
      child: Consumer<NewEventListModel>(builder: (context, model, child) {
        return CalendarControllerProvider<CalendarEvent>(
          controller: EventController<CalendarEvent>()..addAll(model.eventsList),
          child: MaterialApp(
            title: 'Flutter Calendar Page Demo',
            debugShowCheckedModeBanner: false,
            theme: ThemeData.light(),
            scrollBehavior: ScrollBehavior().copyWith(
              dragDevices: {
                PointerDeviceKind.trackpad,
                PointerDeviceKind.mouse,
                PointerDeviceKind.touch,
              },
            ),
            home: ResponsiveWidget(
              mobileWidget: MonthViewPageDemo(),
              webWidget: WebHomePage(),
            ),
          ),
        );
      })
    );
  }
}

