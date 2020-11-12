import 'package:flutter/material.dart';
import 'coin_data.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
//  DROPDOWN FOR ANDROID OS
  String selectedCurrency = 'AUD';

  DropdownButton<String> androidDropdown() {
    List<DropdownMenuItem<String>> dropdownItems = [];

//    for (int i = 0; i < currenciesList.length; i++) {
//      String currency = (currenciesList[i]);
//      var newItem = DropdownMenuItem(
//        child: Text(currency),
//        value: currency,
//      );
//      dropdownItems.add(newItem);
//    }
    for (String currency in currenciesList) {
      var newItem = DropdownMenuItem(
        child: Text(currency),
        value: currency,
      );
      dropdownItems.add(newItem);
    }

    return DropdownButton<String>(
      value: selectedCurrency,
      items: dropdownItems,
      onChanged: (value) {
        setState(
          () {
            selectedCurrency = value;
            getData();
          },
        );
      },
    );
  }

//  For IOS
  CupertinoPicker iOSPicker() {
    List<Text> dropdownItems = [];
    for (String currency in currenciesList) {
      var newItem = Text(currency);
      dropdownItems.add(newItem);
    }

    return CupertinoPicker(
      backgroundColor: Colors.lightBlue,
      itemExtent: 32.0,
      onSelectedItemChanged: (selectedIndex) {
//        print(selectedIndex);
        selectedCurrency = selectedIndex.toString();
        getData();
      },
      children: dropdownItems,
    );
  }

//  Widget getPicker(){
//    if(Platform.isIOS){
//      return iOSPicker();
//    }else if(Platform.isAndroid){
//      return androidDropdown();
//    }
//  }

  String bitcoinValueInUSD = '?';

  Map<String,String> coinValues ={};

  bool isWaiting =false;


  void getData() async {
    isWaiting=true;
    try {
      var data = await CoinData().getCoinData(selectedCurrency);
      isWaiting= false;
      setState(() {
//        bitcoinValueInUSD = data.toStringAsFixed(0);
      coinValues=data;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          '🤑 Coin Ticker',
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          CryptoCard(
            cryptoCurrency: 'BTC',
            value: isWaiting ? '?': coinValues['BTC'],
            selectedCurrency: selectedCurrency,
          ),
          CryptoCard(
            cryptoCurrency: 'ETH',
            value: isWaiting ? '?': coinValues['ETH'],
            selectedCurrency: selectedCurrency,
          ),
          CryptoCard(
            cryptoCurrency: 'LTC',
            value: isWaiting ? '?': coinValues['LTC'],
            selectedCurrency: selectedCurrency,
          ),
          SizedBox(
            height: 200.0,
          ),
          Container(
            height: 241.0,
            alignment: Alignment.center,
//            padding: EdgeInsets.only(bottom: 80.0),
            color: Colors.lightBlue,
            child:
//            getPicker(),
                Platform.isIOS ? iOSPicker() : androidDropdown(),
          ),
        ],
      ),
    );
  }
}

class CryptoCard extends StatelessWidget {
  const CryptoCard({this.value, this.selectedCurrency, this.cryptoCurrency});

  final String value;
  final String selectedCurrency;
  final String cryptoCurrency;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
      child: Card(
        color: Colors.lightBlueAccent,
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
          child: Text(
            '1 $cryptoCurrency = $value $selectedCurrency',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
