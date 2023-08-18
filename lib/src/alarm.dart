import 'package:alarm/alarm.dart';
import 'package:scheduler/src/content.dart';
import 'package:scheduler/src/storage.dart';

class Scheduler {
  static Future<void> setAlarm(Content content) async {
    final alarmSettings = AlarmSettings(
      id: content.id,
      dateTime: content.dateTime,
      assetAudioPath: Storage.instance.getFile() ?? 'assets/alarm.mp3',
      loopAudio: true,
      vibrate: true,
      volumeMax: true,
      fadeDuration: 3.0,
      notificationTitle: content.title,
      notificationBody: content.subTitle,
      enableNotificationOnKill: true,
    );
    await Alarm.set(alarmSettings: alarmSettings);
  }

  static Future<void> snoozeAlarm(AlarmSettings settings) async {
    final now = DateTime.now();
    await Alarm.set(
      alarmSettings: settings.copyWith(
        dateTime: DateTime(
          now.year,
          now.month,
          now.day,
          now.hour,
          now.minute,
        ).add(const Duration(minutes: 5)),
      ),
    );
  }
}
