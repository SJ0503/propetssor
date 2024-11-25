import 'package:flutter/material.dart';
import 'package:propetsor/model/Goods.dart';

class ShopDetails extends StatelessWidget {
  final Goods goods;

  const ShopDetails({Key? key, required this.goods}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "제품 상세 정보",
          style: TextStyle(
            fontSize: 20,
            fontFamily: 'Geekble', // 상품 상세 정보 제목 글꼴 변경
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Center(
              child: Hero(
                tag: goods.gidx,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    _getImagePath(goods.gidx),
                    width: 200,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: Column(
                children: [
                  Text(
                    goods.gname,
                    style: Theme.of(context).textTheme.headline6?.copyWith(fontFamily: 'Geekble'), // 상품명 글꼴 변경
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '₩${goods.gprice}',
                    style: Theme.of(context).textTheme.subtitle1?.copyWith(fontFamily: 'Geekble'), // 가격 글꼴 변경
                  ),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.star, color: Colors.yellow, size: 20),
                      const SizedBox(width: 5),
                      Text(
                        "4.1 (523개 리뷰)", // 이 부분은 실제 데이터로 수정 필요
                        style: Theme.of(context).textTheme.bodyText2?.copyWith(fontFamily: 'Geekble', color: Colors.black.withOpacity(0.6)), // 리뷰 글꼴 변경
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            _buildDetailRow(
              context,
              Icons.pets_outlined,
              "성분 분석",
              goods.gingre,
              [
                _buildTag(context, "비타민 A", Colors.pink[200]!),
                _buildTag(context, "비타민 D", Colors.blue[200]!),
                _buildTag(context, "비타민 E", Colors.purple[200]!),
                _buildTag(context, "칼슘", Colors.green[200]!),
                _buildTag(context, "인", Colors.yellow[200]!),
                _buildTag(context, "철", Colors.orange[200]!),
              ],
              iconColor: Colors.brown, // 성분 분석 아이콘 색상
            ),
            const SizedBox(height: 20),
            _buildDetailRow(
              context,
              Icons.recommend_outlined,
              "추천 사용법",
              "하루 두 번, 아침과 저녁에 급여하세요. 신선한 물을 항상 함께 제공해 주세요.",
              [
                _buildTag(context, "아침", Colors.pink[200]!),
                _buildTag(context, "저녁", Colors.blue[200]!),
              ],
              iconColor: Colors.blue, // 추천 사용법 아이콘 색상
            ),
            const SizedBox(height: 20),
            _buildReviewSection(context),
            const SizedBox(height: 20),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  String _getImagePath(int gidx) {
    switch (gidx) {
      case 1:
        return 'assets/images/1.png';
      case 2:
        return 'assets/images/2.png';
      case 3:
        return 'assets/images/3.jpg';
      case 4:
        return 'assets/images/4.png';
      case 5:
        return 'assets/images/5.jpg';
      case 6:
        return 'assets/images/6.png';
      case 7:
        return 'assets/images/7.png';
      case 8:
        return 'assets/images/8.jpg';
      default:
        return 'assets/images/default.png'; // 기본 이미지 경로
    }
  }

  Widget _buildDetailRow(BuildContext context, IconData icon, String title, String content, List<Widget> tags, {required Color iconColor}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor, size: 30), // 아이콘 색상 변경
              const SizedBox(width: 10),
              Container(
                height: 24,
                width: 1,
                color: Colors.grey,
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: Theme.of(context).textTheme.subtitle1?.copyWith(
                  fontFamily: 'Geekble', // 세부 항목 제목 글꼴 변경
                  fontSize: 18, // 글씨 크기 키움
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Divider(color: Colors.grey),
          const SizedBox(height: 10),
          Text(
            content,
            style: Theme.of(context).textTheme.bodyText2?.copyWith(fontFamily: 'Omyu', fontSize: 16),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8.0,
            runSpacing: 4.0,
            children: tags,
          ),
        ],
      ),
    );
  }

  Widget _buildTag(BuildContext context, String text, Color color) {
    return Chip(
      label: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontFamily: 'Omyu', // 동그란 칸 안의 글씨는 12로 유지
          shadows: [
            Shadow(
              blurRadius: 3.0,
              color: Colors.black,
              offset: Offset(1.0, 1.0),
            ),
          ],
        ),
      ),
      backgroundColor: color,
      shape: StadiumBorder(
        side: BorderSide(color: color),
      ),
    );
  }

  Widget _buildReviewSection(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.rate_review_outlined, color: Colors.redAccent, size: 30), // 상품 리뷰 아이콘 색상
              const SizedBox(width: 10),
              Container(
                height: 24,
                width: 1,
                color: Colors.grey,
              ),
              const SizedBox(width: 10),
              Text(
                "상품 리뷰",
                style: Theme.of(context).textTheme.subtitle1?.copyWith(
                  fontFamily: 'Geekble', // 리뷰 섹션 제목 글꼴 변경
                  fontSize: 18, // 글씨 크기 키움
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Divider(color: Colors.grey),
          const SizedBox(height: 10),
          _buildReviewCard(context, "반려견이 정말 좋아해요!", "사용자가", 5),
          const SizedBox(height: 10),
          _buildReviewCard(context, "냄새도 좋고, 잘 먹어요.", "사용자가", 4),
          const SizedBox(height: 10),
          _buildReviewCard(context, "포장이 깔끔하고 좋아요.", "사용자가", 4.5),
        ],
      ),
    );
  }

  Widget _buildReviewCard(BuildContext context, String review, String user, double rating) {
    return Card(
      color: Colors.white, // 카드 색상 변경
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: List.generate(5, (index) {
                return Icon(
                  index < rating
                      ? Icons.star
                      : index < rating + 0.5
                      ? Icons.star_half
                      : Icons.star_border,
                  color: Colors.yellow,
                  size: 16,
                );
              }),
            ),
            const SizedBox(height: 5),
            Text(
              review,
              style: Theme.of(context).textTheme.bodyText2?.copyWith(fontFamily: 'Omyu', fontSize: 16),
            ),
            const SizedBox(height: 5),
            Align(
              alignment: Alignment.bottomRight,
              child: Text(
                "- $user",
                style: Theme.of(context).textTheme.caption?.copyWith(fontFamily: 'Omyu', fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
