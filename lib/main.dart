import 'package:binance_test/controllers/chart_controller.dart';
import 'package:binance_test/core/utils.dart';
import 'package:binance_test/views/home_view.dart';
import 'package:candlesticks_plus/candlesticks_plus.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
//import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ChartController(),
      child: MaterialApp(
        home: HomeView(),
        theme: ThemeData.from(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blue,
          ),
          useMaterial3: true,
          textTheme: context.theme.textTheme.apply(
            fontFamily: 'Montserrat',
          ),
        ),
      ),
    );
  }
}
