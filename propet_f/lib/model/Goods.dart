class Goods{

  int gidx;
  String gname;
  String gexplan;
  String gingre;
  int gprice;
  String glink;
  String gsoldout;

  Goods({
    required this.gidx,
    required this.gname,
    required this.gexplan,
    required this.gingre,
    required this.gprice,
    required this.glink,
    required this.gsoldout,

  });

  // JSON을 Users 객체로 변환하는 factory 생성자
  factory Goods.fromJson(Map<String, dynamic> json) {
    return Goods(
      gidx: json['gidx'],
      gname: json['gname'],
      gexplan: json['gexplan'],
      gingre: json['gingre'],
      gprice: json['gprice'],
      glink: json['glink'],
      gsoldout: json['gsoldout'],
    );
  }

  // Object -> json으로 바꾸는 형태
  Map<String, dynamic> toJson() => {
    'gidx': gidx,
    'gname': gname,
    'gexplan': gexplan,
    'gingre': gingre,
    'gprice': gprice,
    'glink': glink,
    'gsoldout': gsoldout,
  };


}