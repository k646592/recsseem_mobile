import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:provider/provider.dart';
import 'package:recsseem_mobile/newcalendar/view/extension.dart';
import 'package:recsseem_mobile/newcalendar/view/new_event_index_page.dart';

import '../model/calendar_event.dart';
import '../src/calendar_event_data.dart';
import '../view/app_colors.dart';
import '../view/constants.dart';
import 'create_event_model.dart';
import 'custom_button.dart';
import 'date_time_selector.dart';

class AddEventWidget extends StatefulWidget {
  final void Function(CalendarEventData<CalendarEvent>)? onEventAdd;

  const AddEventWidget({
    Key? key,
    this.onEventAdd,
  }) : super(key: key);

  @override
  _AddEventWidgetState createState() => _AddEventWidgetState();
}

class _AddEventWidgetState extends State<AddEventWidget> {
  late DateTime _startDate;
  late DateTime _endDate;

  DateTime? _startTime;

  DateTime? _endTime;

  String _title = "ミーティング";

  String _description = "";

  //新しく追加
  String _unit = '全体';
  bool _mailSend = true;
  String _content = "ミーティング";
  bool _display = false;
  late CalendarEventData<CalendarEvent> calendarEvent;

  Color _color = Colors.purpleAccent;

  late FocusNode _titleNode;

  late FocusNode _descriptionNode;

  //新しく追加
  late FocusNode _unitNode;
  late FocusNode _contentNode;

  late FocusNode _dateNode;

  final GlobalKey<FormState> _form = GlobalKey();

  late TextEditingController _startDateController;
  late TextEditingController _startTimeController;
  late TextEditingController _endTimeController;
  late TextEditingController _endDateController;

  //新しく追加
  late TextEditingController _arriveTimeController;
  late TextEditingController _leaveTimeController;
  late TextEditingController _mailSendController;

  @override
  void initState() {
    super.initState();

    _titleNode = FocusNode();
    _descriptionNode = FocusNode();
    _dateNode = FocusNode();
    _unitNode = FocusNode();
    _contentNode = FocusNode();

    _startDateController = TextEditingController();
    _endDateController = TextEditingController();
    _startTimeController = TextEditingController();
    _endTimeController = TextEditingController();
    _arriveTimeController = TextEditingController();
    _leaveTimeController = TextEditingController();
    _mailSendController = TextEditingController();
  }

  @override
  void dispose() {
    _titleNode.dispose();
    _descriptionNode.dispose();
    _dateNode.dispose();
    _contentNode.dispose();
    _unitNode.dispose();

    _startDateController.dispose();
    _endDateController.dispose();
    _startTimeController.dispose();
    _endTimeController.dispose();
    _arriveTimeController.dispose();
    _leaveTimeController.dispose();
    _mailSendController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CreateEventModel>(
      create: (_) => CreateEventModel()..fetchUser(),
      child: Consumer<CreateEventModel>(builder: (context, model, child) {
        return Form(
          key: _form,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(5.0),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(
                        width: 2,
                        color: AppColors.lightNavyBlue
                    ),
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 10,
                      ),
                      Text('Content',
                        style: TextStyle(
                          fontSize: 17.0,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      DropdownButton(
                        value: _content,
                        items: const [
                          DropdownMenuItem(
                            child: Text('ミーティング'),
                            value: 'ミーティング',
                          ),
                          DropdownMenuItem(
                            child: Text('輪講'),
                            value: '輪講',
                          ),
                          DropdownMenuItem(
                            child: Text('その他'),
                            value: 'その他',
                          ),
                        ],
                        onChanged: (text) {
                          setState(() {
                            _content = text.toString();
                            if (text.toString() == 'ミーティング') {
                              _display = false;
                              _title = 'ミーティング';
                            }
                            if (text.toString() == '輪講') {
                              _display = false;
                              _title = '輪講';
                            }
                            if (text.toString() == 'その他') {
                              _display = true;
                              _title = '';
                            }
                            colorSelector(_unit, _content);
                          });
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                TextFormField(
                  decoration: AppConstants.inputDecoration.copyWith(
                    labelText: _title,
                  ),
                  style: TextStyle(
                    color: AppColors.black,
                    fontSize: 17.0,
                  ),
                  enabled: _display,

                  validator: (value) {
                    if (_title == "")
                      return "Please enter event title.";

                    return null;
                  },
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                ),
                SizedBox(
                  height: 15,
                ),
                unitSelector(_content),
                Row(
                  children: [
                    Expanded(
                      child: DateTimeSelectorFormField(
                        controller: _startDateController,
                        decoration: AppConstants.inputDecoration.copyWith(
                          labelText: "Start Date",
                        ),
                        validator: (value) {
                          if (value == null || value == "")
                            return "Please select date.";

                          return null;
                        },
                        textStyle: TextStyle(
                          color: AppColors.black,
                          fontSize: 17.0,
                        ),
                        onSave: (date) => _startDate = date,
                        type: DateTimeSelectionType.date,
                      ),
                    ),
                    SizedBox(width: 20.0),
                    Expanded(
                      child: DateTimeSelectorFormField(
                        controller: _endDateController,
                        decoration: AppConstants.inputDecoration.copyWith(
                          labelText: "End Date",
                        ),
                        validator: (value) {
                          if (value == null || value == "")
                            return "Please select date.";

                          return null;
                        },
                        textStyle: TextStyle(
                          color: AppColors.black,
                          fontSize: 17.0,
                        ),
                        onSave: (date) => _endDate = date,
                        type: DateTimeSelectionType.date,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    Expanded(
                      child: DateTimeSelectorFormField(
                        controller: _startTimeController,
                        decoration: AppConstants.inputDecoration.copyWith(
                          labelText: "Start Time",
                        ),
                        validator: (value) {
                          if (value == null || value == "")
                            return "Please select start time.";

                          return null;
                        },
                        onSave: (date) => _startTime = date,
                        textStyle: TextStyle(
                          color: AppColors.black,
                          fontSize: 17.0,
                        ),
                        type: DateTimeSelectionType.time,
                      ),
                    ),
                    SizedBox(width: 20.0),
                    Expanded(
                      child: DateTimeSelectorFormField(
                        controller: _endTimeController,
                        decoration: AppConstants.inputDecoration.copyWith(
                          labelText: "End Time",
                        ),
                        validator: (value) {
                          if (value == null || value == "")
                            return "Please select end time.";

                          return null;
                        },
                        onSave: (date) => _endTime = date,
                        textStyle: TextStyle(
                          color: AppColors.black,
                          fontSize: 17.0,
                        ),
                        type: DateTimeSelectionType.time,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                TextFormField(
                  focusNode: _descriptionNode,
                  style: TextStyle(
                    color: AppColors.black,
                    fontSize: 17.0,
                  ),
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.newline,
                  selectionControls: MaterialTextSelectionControls(),
                  minLines: 1,
                  maxLines: 10,
                  maxLength: 1000,
                  validator: (value) {
                    if (value == null || value.trim() == "")
                      return "Please enter event description.";

                    return null;
                  },
                  onSaved: (value) => _description = value?.trim() ?? "",
                  decoration: AppConstants.inputDecoration.copyWith(
                    hintText: "Event Description",
                  ),
                ),
                SizedBox(
                  height: 15.0,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(5.0),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          border: Border.all(
                              width: 2,
                              color: AppColors.lightNavyBlue
                          ),
                          borderRadius: BorderRadius.circular(7),
                        ),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 10,
                            ),
                            Text('メール送信',
                              style: TextStyle(
                                fontSize: 17.0,
                              ),
                            ),
                            Flexible(
                              child: ListTile(
                                trailing: CupertinoSwitch(
                                    value: _mailSend,
                                    onChanged: (value) {
                                      setState(() {
                                        _mailSend = value;
                                      });
                                    }
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 15.0,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      "Event Color: ",
                      style: TextStyle(
                        color: AppColors.black,
                        fontSize: 17,
                      ),
                    ),
                    GestureDetector(
                      onTap: _displayColorPicker,
                      child: CircleAvatar(
                        radius: 15,
                        backgroundColor: _color,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                CustomButton(
                  onTap: () {
                    _createEvent(model.username!, model.userId!);
                    model.addEvent(calendarEvent);
                    model.Mailer();
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) {
                          return TopPage();
                        }
                    ),
                    );
                  },
                  title: "Add Event",
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  void _createEvent(String username, String userId) {
    if (!(_form.currentState?.validate() ?? true)) return;

    _form.currentState?.save();

    final event = CalendarEventData<CalendarEvent>(
      date: _startDate,
      color: _color,
      endTime: _endTime,
      startTime: _startTime,
      description: _description,
      endDate: _endDate,
      title: _title,
      content: _content,
      unit: _unit,
      mailSend: _mailSend,
      name: username,
      userId: userId,
      event: CalendarEvent(
        title: _title,
      ),
    );
    setState(() {
      calendarEvent = event;
    });

    widget.onEventAdd?.call(event);
    _resetForm();
  }

  void _resetForm() {
    _form.currentState?.reset();
    _startDateController.text = "";
    _endTimeController.text = "";
    _startTimeController.text = "";
  }

  void _displayColorPicker() {
    var color = _color;
    showDialog(
      context: context,
      useSafeArea: true,
      barrierColor: Colors.black26,
      builder: (_) => SimpleDialog(
        clipBehavior: Clip.hardEdge,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
          side: BorderSide(
            color: AppColors.bluishGrey,
            width: 2,
          ),
        ),
        contentPadding: EdgeInsets.all(20.0),
        children: [
          Text(
            "Event Color",
            style: TextStyle(
              color: AppColors.black,
              fontSize: 25.0,
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 20.0),
            height: 1.0,
            color: AppColors.bluishGrey,
          ),
          ColorPicker(
            displayThumbColor: true,
            enableAlpha: false,
            pickerColor: _color,
            onColorChanged: (c) {
              color = c;
            },
          ),
          Center(
            child: Padding(
              padding: EdgeInsets.only(top: 50.0, bottom: 30.0),
              child: CustomButton(
                title: "Select",
                onTap: () {
                  if (mounted)
                    setState(() {
                      _color = color;
                    });
                  context.pop();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget unitSelector(String content) {
    if (content == 'ミーティング'){
      return Column(
        children: [
          Container(
            padding: const EdgeInsets.all(5.0),
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(
                  width: 2,
                  color: AppColors.lightNavyBlue
              ),
              borderRadius: BorderRadius.circular(7),
            ),
            child: Row(
                children: [
                  SizedBox(
                    width: 10,
                  ),
                  Text('参加単位',
                    style: TextStyle(
                      fontSize: 17.0,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  DropdownButton(
                      value: _unit,
                      items: const [
                        DropdownMenuItem(
                          child: Text('全体'),
                          value: '全体',
                        ),
                        DropdownMenuItem(
                          child: Text('個人'),
                          value: '個人',
                        ),
                        DropdownMenuItem(
                          child: Text('Net班'),
                          value: 'Net班',
                        ),
                        DropdownMenuItem(
                          child: Text('Grid班'),
                          value: 'Grid班',
                        ),
                        DropdownMenuItem(
                          child: Text('Web班'),
                          value: 'Web班',
                        ),
                        DropdownMenuItem(
                          child: Text('B4'),
                          value: 'B4',
                        ),
                        DropdownMenuItem(
                          child: Text('M1'),
                          value: 'M1',
                        ),
                        DropdownMenuItem(
                          child: Text('M2'),
                          value: 'M2',
                        ),
                      ],
                      onChanged: (text) {
                        setState(() {
                          _unit = text.toString();
                        });
                        colorSelector(_unit, _content);
                      }
                  ),
                ]),
          ),
          SizedBox(
            height: 15,
          ),
        ],
      );
    }
    else return SizedBox();
  }

  void colorSelector(String unit, String content) {
    if(content != 'ミーティング') {
      _color = Colors.blue;
    }
    else {
      if(unit == 'Grid班'){
        _color = Colors.lightGreen;
      }
      else if(unit == '全体'){
        _color = Colors.purple;
      }
      else if(unit == 'Web班') {
        _color = Colors.lightBlue;
      }
      else if(unit == 'Net班') {
        _color = Colors.yellow;
      }
      else {
        _color = Colors.blueGrey;
      }
    }
  }

}



