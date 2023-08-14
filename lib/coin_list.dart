import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/data/constans/constant.dart';
import 'package:flutter_application_1/data/model/crypto.dart';

class CoinListScreen extends StatefulWidget {
  CoinListScreen({super.key, this.CryptoList});
  List<Crypto>? CryptoList;
  @override
  State<CoinListScreen> createState() => _CoinListScreenState();
}

class _CoinListScreenState extends State<CoinListScreen> {
  List<Crypto>? CryptoList;

  @override
  void initState() {
    super.initState();
    CryptoList = widget.CryptoList;
  }

  bool isSearchLoadingVisible = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('کریپتو بازار'),
        centerTitle: true,
        backgroundColor: blackColor,
        automaticallyImplyLeading: false,
      ),
      backgroundColor: blackColor,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(8),
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: Container(
                  height: 50,
                  child: TextField(
                    onChanged: (value) => _FilterList(value),
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      prefixIconColor: Colors.white,
                      hintText: 'اسم رمزارز معتبر را سرچ کنید',
                      hintStyle: TextStyle(
                        color: Colors.white,
                      ),
                      hintTextDirection: TextDirection.rtl,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(9),
                      ),
                      filled: true,
                      fillColor: greenColor,
                    ),
                  ),
                ),
              ),
            ),
            Visibility(
              visible: isSearchLoadingVisible,
              child: Text(
                '...در حال اپدیت اطلاعات رمز ارز ها',
                style: TextStyle(
                  color: greenColor,
                ),
              ),
            ),
            Expanded(
              child: RefreshIndicator(
                color: redColor,
                backgroundColor: blackColor,
                onRefresh: () async {
                  List<Crypto> FereshData = await _getdata();
                  setState(() {
                    CryptoList = FereshData;
                  });
                },
                child: ListView.builder(
                  itemCount: CryptoList!.length,
                  itemBuilder: (context, index) => _GetListTile(index),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _GetListTile(index) {
    return ListTile(
      title: Text(
        CryptoList![index].name,
        style: TextStyle(color: greenColor),
      ),
      subtitle: Text(
        CryptoList![index].symbol,
        style: TextStyle(color: greyColor),
      ),
      leading: SizedBox(
        width: 30,
        child: Center(
          child: Text(
            CryptoList![index].rank.toString(),
            style: TextStyle(color: greyColor),
          ),
        ),
      ),
      trailing: SizedBox(
        width: 150,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  CryptoList![index].priceUsd.toStringAsFixed(2),
                  style: TextStyle(color: greyColor, fontSize: 16),
                ),
                Text(
                  CryptoList![index].changePercent24Hr.toStringAsFixed(2),
                  style: TextStyle(
                    color: _getColorchangeText(
                        CryptoList![index].changePercent24Hr),
                  ),
                ),
              ],
            ),
            SizedBox(
              width: 30,
              child: Center(
                child:
                    _GetIconChangePercent(CryptoList![index].changePercent24Hr),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _GetIconChangePercent(double PercentChange) {
    return PercentChange <= 0
        ? Icon(
            Icons.trending_down,
            color: redColor,
            size: 24,
          )
        : Icon(
            Icons.trending_up,
            color: greenColor,
            size: 24,
          );
  }

  Color _getColorchangeText(double PercentChange) {
    return PercentChange <= 0 ? redColor : greenColor;
  }

  Future<List<Crypto>> _getdata() async {
    var response = await Dio().get('https://api.coincap.io/v2/assets');
    List<Crypto> CoinList = response.data['data']
        .map<Crypto>((e) => Crypto.fromMapjson(e))
        .toList();

    return CoinList;
  }

  Future<void> _FilterList(String EnteredKeyWord) async {
    if (EnteredKeyWord.isEmpty) {
      setState(() {
        isSearchLoadingVisible = true;
      });
      var result = await _getdata();

      setState(() {
        CryptoList = result;
        isSearchLoadingVisible = false;
      });
      return;
    }
    List<Crypto> cryptoresultlist = [];
    cryptoresultlist = CryptoList!
        .where(
          (element) => element.name.toLowerCase().contains(
                EnteredKeyWord.toLowerCase(),
              ),
        )
        .toList();

    setState(() {
      CryptoList = cryptoresultlist;
    });
  }
}
