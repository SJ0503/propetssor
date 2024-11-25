import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:propetsor/config/config.dart';
import 'package:propetsor/model/Goods.dart';
import 'shop_details.dart';

class MainShopPage extends StatefulWidget {
  const MainShopPage({Key? key}) : super(key: key);

  @override
  _MainShopPageState createState() => _MainShopPageState();
}

class _MainShopPageState extends State<MainShopPage> {
  late List<Goods> _goodsList = [];
  late List<Goods> _currentCategoryGoods;
  int _selectedCategoryIndex = 0;

  @override
  void initState() {
    super.initState();
    _fetchGoods();
  }

  Future<void> _fetchGoods() async {
    final dio = Dio();

    try {
      Response res = await dio.get(
        "${Config.baseUrl}/boot/selectAllGoods",
        options: Options(
          headers: {
            "Content-Type": "application/json",
          },
        ),
      );

      List<dynamic> data = res.data is String ? json.decode(res.data) : res.data;
      List<Goods> goodsList = data.map((json) => Goods.fromJson(json)).toList();

      setState(() {
        _goodsList = goodsList;
        _currentCategoryGoods = goodsList; // 초기 모든 상품
      });
    } catch (e) {
      print("Error fetching goods: $e");
    }
  }

  void _onCategorySelected(int index) {
    setState(() {
      _selectedCategoryIndex = index;
      // 선택한 카테고리에 따라 상품 업데이트
      switch (index) {
        case 0:
          _currentCategoryGoods = _goodsList; // 모든 상품
          break;
        case 1:
          _currentCategoryGoods = _goodsList.where((goods) => goods.gidx >= 1 && goods.gidx <= 4).toList(); // 눈/눈물
          break;
        case 2:
          _currentCategoryGoods = _goodsList.where((goods) => goods.gidx >= 5 && goods.gidx <= 6).toList(); // 장/유산균
          break;
        case 3:
          _currentCategoryGoods = _goodsList.where((goods) => goods.gidx >= 7 && goods.gidx <= 8).toList(); // 피부/모질
          break;
        default:
          _currentCategoryGoods = _goodsList; // 기본적으로 모든 상품
          break;
      }
    });
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

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: TabBar(
            onTap: _onCategorySelected,
            indicatorColor: Colors.black,
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(
                child: Text(
                  '전체',
                  style: TextStyle(fontFamily: 'Geekble'),
                ),
              ),
              Tab(
                child: Text(
                  '눈/눈물',
                  style: TextStyle(fontFamily: 'Geekble'),
                ),
              ),
              Tab(
                child: Text(
                  '장/유산균',
                  style: TextStyle(fontFamily: 'Geekble'),
                ),
              ),
              Tab(
                child: Text(
                  '피부/모질',
                  style: TextStyle(fontFamily: 'Geekble'),
                ),
              ),
            ],
          ),
        ),
        body: _goodsList.isEmpty
            ? Center(child: CircularProgressIndicator())
            : TabBarView(
          children: [
            _buildCategoryPage(),
            _buildCategoryPage(),
            _buildCategoryPage(),
            _buildCategoryPage(),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryPage() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.builder(
        itemCount: _currentCategoryGoods.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 0.7,
        ),
        itemBuilder: (BuildContext context, int index) {
          final goods = _currentCategoryGoods[index];
          return InkWell(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ShopDetails(goods: goods),
              ));
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Hero(
                    tag: goods.gidx,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.asset(
                        _getImagePath(goods.gidx),
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  goods.gname,
                  style: Theme.of(context).textTheme.subtitle1?.copyWith(fontFamily: 'Geekble'), // 카테고리와 상품명 글꼴 변경
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '₩${goods.gprice}',
                      style: Theme.of(context).textTheme.bodyText2?.copyWith(color: Colors.black.withOpacity(0.8), fontFamily: 'Omyu'), // 나머지 글꼴 변경
                    ),
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.yellow, size: 16),
                        SizedBox(width: 4),
                        Text(
                          '4.0', // This rating is static, can be dynamic if needed
                          style: Theme.of(context).textTheme.bodyText2?.copyWith(color: Colors.black.withOpacity(0.8), fontFamily: 'Omyu'), // 나머지 글꼴 변경
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
