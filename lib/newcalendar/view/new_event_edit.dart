import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:recsseem_mobile/newcalendar/src/calendar_event_data.dart';

import 'app_colors.dart';

class NewEventEdit extends StatelessWidget {

  final CalendarEventData event;
  const NewEventEdit(this.event, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        centerTitle: false,
        title: const Text(
          'イベント詳細',
          style: TextStyle(
            color: AppColors.black,
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: AppColors.black,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(12.0),
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(
                      width: 2,
                      color: AppColors.lightNavyBlue
                  ),
                  borderRadius: BorderRadius.circular(7),
                ),
                child: Text(
                  'タイトル：${event.title}',
                  style: const TextStyle(
                    color: AppColors.black,
                    fontSize: 17.0,
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Container(
                padding: const EdgeInsets.all(12.0),
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(
                      width: 2,
                      color: AppColors.lightNavyBlue
                  ),
                  borderRadius: BorderRadius.circular(7),
                ),
                child: Text(
                  '参加単位：${event.unit}',
                  style: const TextStyle(
                    color: AppColors.black,
                    fontSize: 17.0,
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Container(
                padding: const EdgeInsets.all(12.0),
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(
                      width: 2,
                      color: AppColors.lightNavyBlue
                  ),
                  borderRadius: BorderRadius.circular(7),
                ),
                child: Text(
                  '開始日時：${DateFormat('yyyy/MM/dd(EEE) a hh:mm').format(event.startTime!)}',
                  style: const TextStyle(
                    color: AppColors.black,
                    fontSize: 17.0,
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Container(
                padding: const EdgeInsets.all(12.0),
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(
                      width: 2,
                      color: AppColors.lightNavyBlue
                  ),
                  borderRadius: BorderRadius.circular(7),
                ),
                child: Text(
                  '終了日時：${DateFormat('yyyy/MM/dd(EEE) a hh:mm').format(event.endTime!)}',
                  style: const TextStyle(
                    color: AppColors.black,
                    fontSize: 17.0,
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Container(
                padding: const EdgeInsets.all(12.0),
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(
                      width: 2,
                      color: AppColors.lightNavyBlue
                  ),
                  borderRadius: BorderRadius.circular(7),
                ),
                child: Text(
                  '詳細：${event.description}',
                  style: const TextStyle(
                    color: AppColors.black,
                    fontSize: 17.0,
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
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
                          const SizedBox(
                            width: 10,
                          ),
                          const Text('メール送信',
                            style: TextStyle(
                              fontSize: 17.0,
                            ),
                          ),
                          Flexible(
                            child: ListTile(
                              trailing: CupertinoSwitch(
                                value: event.mailSend,
                                onChanged: null,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 15.0,
              ),
              Row(
                children: [
                  SizedBox(
                    width: 20,
                  ),
                  const Text(
                    "Event Color: ",
                    style: TextStyle(
                      color: AppColors.black,
                      fontSize: 17,
                    ),
                  ),
                  GestureDetector(
                    onTap: null,
                    child: CircleAvatar(
                      radius: 15,
                      backgroundColor: event.color,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
            ],
          ),
        ),
      ),
    );
  }
}