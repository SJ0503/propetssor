class Users {
  int? uidx;
  String? id;
  String? uname;
  String? pw;
  String? uphone;

  Users({
    this.uidx,
    this.id,
    this.uname,
    this.pw,
    this.uphone,
  });

  // JSON을 Users 객체로 변환하는 factory 생성자
  factory Users.fromJson(Map<String, dynamic> json) {
    return Users(
      uidx: json['uidx'],
      id: json['id'],
      uname: json['uname'],
      pw: json['pw'],
      uphone: json['uphone'],
    );
  }

  // Object -> json으로 바꾸는 형태
  Map<String, dynamic> toJson() => {
    'uidx': uidx,
    'id': id,
    'uname': uname,
    'uphone': uphone,
    'pw': pw,
  };



  Users.join({
    required this.id,
    required this.uname,
    required this.uphone,
    required this.pw,
  });

  Users.login({
    required this.id,
    required this.pw,
  });

  Users.update({
    required this.uidx,
    required this.pw,
    required this.uphone,
    required this.uname,
  });
}
