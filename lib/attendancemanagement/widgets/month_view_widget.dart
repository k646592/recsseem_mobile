import 'package:flutter/material.dart';
import 'package:recsseem_mobile/attendancemanagement/src/month_view/month_view.dart';

import '../../Calendar/model/calendar_event.dart';


class MonthViewWidget extends StatelessWidget {
  final GlobalKey<MonthViewState>? state;
  final double? width;

  const MonthViewWidget({
    Key? key,
    this.state,
    this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MonthView<CalendarEvent>(
      key: state,
      width: width,
    );
  }
}
