import 'dart:math';

class Content {

  final int id;
  final DateTime dateTime;
  final String title;
  final String subTitle;

  Content({required this.id, required this.dateTime, required this.title, required this.subTitle});

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'dateTime': dateTime.toIso8601String(),
      'title': title,
      'subTitle': subTitle,
    };
  }

  factory Content.fromJson(Map<String, dynamic> json) {
    return Content(
      id: json['id'], 
      dateTime: DateTime.parse(json['dateTime']), 
      title: json['title'], 
      subTitle: json['subTitle'],
    );
  }

  Content copyWith({int? id, DateTime? dateTime, String? title, String? subTitle}) {
    return Content(
      id: id ?? this.id, 
      dateTime: dateTime ?? this.dateTime, 
      title: title ?? this.title, 
      subTitle: subTitle ?? this.subTitle,
    );
  }

  factory Content.empty() {
    return Content(id: Random().nextInt(1000), dateTime: DateTime.now(), title: 'title', subTitle: 'subTitle');
  }
}