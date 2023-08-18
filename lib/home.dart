import 'package:alarm/alarm.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scheduler/pages/create_alarm.dart';
import 'package:scheduler/src/alarm.dart';
import 'package:scheduler/src/content.dart';
import 'package:scheduler/src/storage.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Content> items = Storage.instance.getItem();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Alarm.ringStream.stream.listen((event) {
        showModalBottomSheet(
            context: context,
            builder: (_) {
              return SizedBox(
                height: 300,
                width: double.maxFinite,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(event.notificationTitle ?? 'N/A', style: Theme.of(context).textTheme.displayMedium),
                      const SizedBox(height: 10),
                      Text(event.notificationBody ?? 'N/A', style: Theme.of(context).textTheme.headlineLarge),
                      const SizedBox(height: 30),
                      ElevatedButton(
                        onPressed: () async {
                          await Scheduler.snoozeAlarm(event);
                          if (context.mounted) {
                            Navigator.pop(context);
                          }
                        },
                        child: const Text('Snnoze'),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () async {
                          await Alarm.stop(event.id);
                          if (context.mounted) {
                            Navigator.pop(context);
                          }
                        },
                        child: const Text('Stop'),
                      ),
                    ],
                  ),
                ),
              );
            });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return const FileSelection();
                },
              );
            },
            icon: const Icon(Icons.file_open),
          )
        ],
        title: const Text('Scheduler'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.separated(
          itemCount: items.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(items[index].title),
              subtitle: Text(items[index].subTitle),
              trailing: Text(DateFormat('dd/MM/yy hh:mm a').format(items[index].dateTime)),
            );
          },
          separatorBuilder: (context, index) {
            return const Divider();
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(context, MaterialPageRoute(builder: (_) => CreateAlarm(contents: items)));
          items = Storage.instance.getItem();
          setState(() {});
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}



class FileSelection extends StatefulWidget {
  const FileSelection({super.key});

  @override
  State<FileSelection> createState() => _FileSelectionState();
}

class _FileSelectionState extends State<FileSelection> {
  String text = Storage.instance.getFile() ?? 'Select File';

  @override
  Widget build(BuildContext context) {
    return AlertDialog.adaptive(
      title: const Text('Select Custom or System Ringtone', textAlign: TextAlign.center),
      actions: [
        TextButton(
          onPressed: () async {
            final result = await FilePicker.platform.pickFiles(type: FileType.audio);
            if (result != null) {
              Storage.instance.setFile(result.files.first.path!);
              text = result.files.first.path!.split('/').last;
            }
          },
          child: Text(text),
        ),
      ],
    );
  }
}
