class Question{
  int qidx;
  String qcontent;
  String qanswer;
  //Unit8List q_embedding;  // gpt는 된다는데 안됨

  String qtf;
  String qcategory;
  int uidx;

  Question({
    required this.qidx,
    required this.qcontent,
    required this.qanswer,

    required this.qtf,
    required this.qcategory,
    required this.uidx,

  });


}