import 'package:flutter/material.dart';
import 'package:flutter_application_1/data/model/crypto.dart';
import 'coin_list.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:dio/dio.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    getdata();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
              image: AssetImage('assets/images/logo.png'),
            ),
            SpinKitFadingCircle(
              size: 40,
              color: Colors.red,
              duration: Duration(seconds: 2),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> getdata() async {
    var response = await Dio().get('https://api.coincap.io/v2/assets');
    List<Crypto> CoinList = response.data['data']
        .map<Crypto>((e) => Crypto.fromMapjson(e))
        .toList();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CoinListScreen(
          CryptoList: CoinList,
        ),
      ),
    );
  }
}
