class AiMember{

  // null 일수도 아닐수도
  int? uid;
  String? id;
  String? pw;
  int? age;
  String? nick;

  AiMember({
   required this.uid,
   required this.id,
   required this.pw,
   required this.age,
   required this.nick
  });


  AiMember.join({
    required this.id,
    required this.pw,
    required this.age,
    required this.nick
  });

  AiMember.login({
    required this.id,
    required this.pw,
  });

  AiMember.update({
    required this.uid,
    required this.pw,
    required this.nick,
  });
  // Map(json) -> Object(인스턴스 생성)
  // factory : 재활용 가능한 생성자 (새로운 인스턴스 생성x 일회성으로)
  factory AiMember.FromJson(Map<String,dynamic> json) =>AiMember(
      uid: json['uid'],
      id: json['id'],
      pw: json['pw'],
      age: json['age'],
      nick: json['nick']
  );


  // Object -> Map(json)
  Map<String,dynamic> toJson()=>{
   'uid':uid,
    'id':id,
    'pw':pw,
    'age':age,
    'nick':nick
  };

}