import 'dart:convert';

import 'package:binance_test/models/candle_ticker_model.dart';
import 'package:binance_test/repo/repo.dart';
import 'package:candlesticks_plus/candlesticks_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class ChartController extends ChangeNotifier {
  final repository = BinanceRepository();
  List<Candle> _candles = [];
  Candle? _currentCandle;
  List<String> _symbols = [];
  String _currentInterval = '1h';
  String _currentSymbol = 'BTCUSDT';

  set currentCandle(Candle? value) {
    _currentCandle = value;
    //notifyListeners();
  }

  Candle? get currentCandle => _currentCandle;

  List<Candle> get candles => _candles;

  set candles(List<Candle> value) {
    _candles = value;
    notifyListeners();
  }

  String get currentInterval => _currentInterval;

  set currentInterval(String value) {
    _currentInterval = value;
    notifyListeners();
  }

  String get currentSymbol => _currentSymbol;

  set currentSymbol(String value) {
    _currentSymbol = value;
    notifyListeners();
  }

  WebSocketChannel? _channel;

  WebSocketChannel? get channel => _channel;

  List<String> get symbols => _symbols;

  set symbols(List<String> value) {
    _symbols = value;
    notifyListeners();
  }

  set channel(WebSocketChannel? value) {
    _channel = value;
    notifyListeners();
  }

  Future<void> fetchCandles(String symbol, String interval) async {
    // close current channel if exists
    if (_channel != null) {
      _channel!.sink.close();
      _channel = null;
    }
    // clear last candle list
    candles = [];
    currentInterval = interval;
    //notifyListeners();

    try {
      // load candles info
      final data =
          await repository.fetchCandles(symbol: symbol, interval: interval);
      // connect to binance stream
      channel =
          repository.establishConnection(symbol.toLowerCase(), currentInterval);
      // update candles

      //print(data);
      candles = data;
      currentInterval = interval;
      currentSymbol = symbol;
      //notifyListeners();
    } catch (e) {
      // handle error
      return;
    }
  }

  Future<List<String>> fetchSymbols() async {
    try {
      // load candles info
      final data = await repository.fetchSymbols();
      return data;
    } catch (e) {
      // handle error
      return [];
    }
  }

  Future<void> loadMoreCandles() async {
    try {
      // load candles info
      final data = await repository.fetchCandles(
          symbol: currentSymbol,
          interval: currentInterval,
          endTime: candles.last.date.millisecondsSinceEpoch);
      candles.removeLast();

      candles = [...candles, ...data];
      //notifyListeners();
    } catch (e) {
      // handle error
      return;
    }
  }

  void updateCandlesFromSnapshot(AsyncSnapshot<Object?> snapshot) {
    if (candles.isEmpty) return;
    if (snapshot.data != null) {
      final map = jsonDecode(snapshot.data as String) as Map<String, dynamic>;
      print(map);
      if (map.containsKey("k") == true) {
        final candleTicker = CandleTickerModel.fromJson(map);

        // cehck if incoming candle is an update on current last candle, or a new one
        if (candles[0].date == candleTicker.candle.date &&
            candles[0].open == candleTicker.candle.open) {
          // update last candle
          candles[0] = candleTicker.candle;
        }
        // check if incoming new candle is next candle so the difrence
        // between times must be the same as last existing 2 candles
        /* else if (candleTicker.candle.date.difference(candles[0].date) ==
            candles[0].date.difference(candles[1].date))  {*/
        else if (candleTicker.candle.date.isAfter(candles[0].date)) {
          // add new candle to list
          _candles = [candleTicker.candle, ...candles];
        }
      }
    }
  }

  @override
  void dispose() {
    if (_channel != null) {
      _channel!.sink.close();
    }
    super.dispose();
  }
}
