import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recsseem_mobile/attendancemanagement/Calendar/model/calendar_event.dart';
import 'package:recsseem_mobile/attendancemanagement/Calendar/src/calendar_controller_provider.dart';
import 'package:recsseem_mobile/attendancemanagement/Calendar/src/event_controller.dart';
import 'package:recsseem_mobile/attendancemanagement/Calendar/widgets/responsive_widget.dart';
import 'package:recsseem_mobile/attendancemanagement/pages/calendar_view_page.dart';
import 'package:recsseem_mobile/attendancemanagement/pages/web/web_home_page.dart';

import 'package:recsseem_mobile/attendancemanagement/view/attendance_index_model.dart';





class AttendanceTop extends StatelessWidget {
  const AttendanceTop({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return ChangeNotifierProvider<AttendanceListModel>(
        create: (_) => AttendanceListModel()..fetchEventList(),
        child: Consumer<AttendanceListModel>(builder: (context, model, child) {
          return CalendarControllerProvider<CalendarEvent>(
            controller: EventController<CalendarEvent>()..addAll(model.eventsList),
            child: Scaffold(
              body: ResponsiveWidget(
                mobileWidget: const ViewPageDemo(),
                webWidget: WebHomePage(),
              ),
            ),
          );
        })
    );
  }
}


