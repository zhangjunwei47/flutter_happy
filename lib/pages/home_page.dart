import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_happy/dao/home_dao.dart';
import 'package:flutter_happy/model/home_model.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

const APPBAR_OFFSET = 100;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List _imageUrls = [
    'https://img3.doubanio.com/view/photo/l/public/p2181503494.webp',
    'https://img3.doubanio.com/view/photo/l/public/p2181503501.webp',
    'https://img1.doubanio.com/view/photo/l/public/p2512009298.webp',
  ];

  double appBarAlpha = 0;
  String resultString = "";

  @override
  void initState() {
    super.initState();
    loadData();
  }

  _onScroll(offset) {
    double alpha = offset / APPBAR_OFFSET;
    if (alpha < 0) {
      alpha = 0;
    } else if (alpha > 1) {
      alpha = 1;
    }
    setState(() {
      appBarAlpha = alpha;
    });
  }

  loadData() async {
    try {
      HomeModel model = await HomeDao.fetch();
      setState(() {
        resultString = json.encode(model);
      });
    } catch (e) {
      setState(() {
        resultString = e.toString();
      });
    }
  }

  Widget getListView() {
    return ListView(
      children: <Widget>[
        Container(
          height: 250,
          child: Swiper(
            itemCount: _imageUrls.length,
            autoplay: true,
            itemBuilder: (BuildContext context, int index) {
              return Image.network(
                _imageUrls[index],
                fit: BoxFit.fill,
              );
            },
            pagination: SwiperPagination(),
          ),
        ),
        Container(
          height: 1000,
          child: ListTile(
            title: new Text(resultString),
          ),
        )
      ],
    );
  }

  Opacity getOpacity() {
    return Opacity(
      opacity: appBarAlpha,
      child: Container(
        height: 60,
        decoration: BoxDecoration(color: Colors.white),
        child: Center(
          child: Padding(
            padding: EdgeInsets.only(top: 20),
            child: Text('首页'),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: <Widget>[
        MediaQuery.removePadding(
          context: context,
          removeTop: true,
          child: NotificationListener(
            onNotification: (sc) {
              if (sc is ScrollUpdateNotification && sc.depth == 0) {
                _onScroll(sc.metrics.pixels);
              }
            },
            child: getListView(),
          ),
        ),
        getOpacity()
      ],
    ));
  }
}
