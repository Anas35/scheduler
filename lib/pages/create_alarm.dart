
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scheduler/src/alarm.dart';
import 'package:scheduler/src/content.dart';
import 'package:scheduler/src/storage.dart';

class CreateAlarm extends StatefulWidget {
  const CreateAlarm({super.key, required this.contents});

  final List<Content> contents;

  @override
  State<CreateAlarm> createState() => _CreateAlarmState();
}

class _CreateAlarmState extends State<CreateAlarm> {
  final formKey = GlobalKey<FormState>();

  Content content = Content.empty();

  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Title should not be empty';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    content = content.copyWith(title: value);
                  },
                  decoration: InputDecoration(
                    hintText: 'Title',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Description should not be empty';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    content = content.copyWith(subTitle: value);
                  },
                  decoration: InputDecoration(
                    hintText: 'Description',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: controller,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Date Time should not be empty';
                    }
                    return null;
                  },
                  onTap: () async {
                    final date = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2030));
                    if (date == null) return;
                    if (context.mounted) {
                      final time = await showTimePicker(context: context, initialTime: TimeOfDay.now());
                      if (time == null) return;
                      content = content.copyWith(dateTime: date.copyWith(hour: time.hour, minute: time.minute));
                      controller.text = DateFormat('dd/MM/yy hh:mm a').format(content.dateTime);
                      setState(() {});
                    }
                  },
                  readOnly: true,
                  decoration: InputDecoration(
                    hintText: 'Descripiton',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      Storage.instance.addItem(widget.contents..add(content));
                      Scheduler.setAlarm(content);
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Submit'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}