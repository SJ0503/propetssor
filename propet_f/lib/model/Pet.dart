class Pet{
  int? pidx; // 펫 index
  String? pname; //펫이름
  String? pkind; //종
  int page; // 나이
  double pkg; //몸무게
  String? pgender; // 성별
  String psurgery; //중성화 여부
  String pdisease; //질환 여부
  String? pdiseaseinf; //질환정보
  int? uidx; //회원 idx
  String? pimage; // pet 사진

  Pet({
    required this.pidx,
    required this.pname,
    required this.pkind,
    required this.page,
    required this.pkg,
    required this.pgender,
    required this.psurgery,
    required this.pdisease,
    required this.pdiseaseinf,
    required this.uidx,
    required this.pimage,

  });

  //Map -> Object(인스턴스 생성)
  // factory : 재활용 가능한 생성자(새로운 인스턴스 생성x)
  factory Pet.fromJson(Map<String,dynamic> json)=>Pet(

    pidx: json['pidx'],
    pname: json['pname'],
    pkind: json['pkind'],
    page: json['page'],
    pkg: json['pkg'],
    pgender: json['pgender'],
    psurgery: json['psurgery'],
    pdisease: json['pdisease'],
    pdiseaseinf: json['pdiseaseinf'],
    uidx: json['uidx'],
    pimage: json['pimage']

  );

//Object -> json으로 바꾸는 형태
  Map<String, dynamic> toJson()=>{

    'pidx':pidx,
    'pname':pname,
    'pkind':pkind,
    'page':page,
    'pkg':pkg,
    'pgender':pgender,
    'psurgery':psurgery,
    'pdisease':pdisease,
    'pdiseaseinf':pdiseaseinf,
    'uidx':uidx,
    'pimage':pimage,
  };


  Pet.enroll({

    required this.pname,
    required this.pkind,
    required this.page,
    required this.pkg,
    required this.pgender,
    required this.psurgery,
    required this.pdisease,
    this.pdiseaseinf,
    this.uidx,
    this.pimage,
  });

  Pet.update({
    required this.page,
    required this.pkg,
    required this.psurgery,
    required this.pdisease,
    this.pdiseaseinf,
    this.uidx,
    this.pimage,
});

  // Object -> Map<String, String> 변환 메서드
  Map<String, String> toMap() {
    return {
      'pidx': pidx.toString(),
      'pname': pname.toString(),
      'pkind': pkind.toString(),
      'page': page.toString(),
      'pkg': pkg.toString(),
      'pgender': pgender.toString(),
      'psurgery': psurgery,
      'pdisease': pdisease,
      'pdiseaseinf': pdiseaseinf ?? '',
      'uidx': uidx.toString(),
      'pimage':pimage.toString(),
    };
  }

  factory Pet.fromMap(Map<String, String> map) {
    return Pet(
      pidx: int.tryParse(map['pidx'] ?? ''),
      pname: map['pname'],
      pkind: map['pkind'],
      page: int.parse(map['page'] ?? '0'),
      pkg: double.parse(map['pkg'] ?? '0'),
      pgender: map['pgender'],
      psurgery: map['psurgery']!,
      pdisease: map['pdisease']!,
      pdiseaseinf: map['pdiseaseinf'],
      uidx: int.tryParse(map['uidx'] ?? ''),
      pimage: map['pimage'],
    );
  }

}