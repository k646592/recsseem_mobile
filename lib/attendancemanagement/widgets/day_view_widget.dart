import 'package:flutter/material.dart';
import 'package:recsseem_mobile/attendancemanagement/src/day_view/day_view.dart';

import '../../Calendar/model/calendar_event.dart';


class DayViewWidget extends StatelessWidget {
  final GlobalKey<DayViewState>? state;
  final double? width;

  const DayViewWidget({
    Key? key,
    this.state,
    this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DayView<CalendarEvent>(
      key: state,
      width: width,
    );
  }
}
