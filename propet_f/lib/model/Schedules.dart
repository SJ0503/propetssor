class Schedules {
  int? sidx;
  String startTime;
  String endTime;
  String content;
  int uidx;
  String ndate; // 수정된 부분

  Schedules({
    this.sidx,
    required this.startTime,
    required this.endTime,
    required this.content,
    required this.uidx,
    required this.ndate,
  });

  factory Schedules.fromJson(Map<String, dynamic> json) {
    return Schedules(
      sidx: json['sidx'],
      startTime: json['startTime'],
      endTime: json['endTime'],
      content: json['content'],
      uidx: json['uidx'],
      ndate: json['ndate'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sidx': sidx,
      'startTime': startTime,
      'endTime': endTime,
      'content': content,
      'uidx': uidx,
      'ndate': ndate,
    };
  }
}
