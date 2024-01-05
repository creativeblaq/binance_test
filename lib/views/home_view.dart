import 'package:binance_test/controllers/chart_controller.dart';
import 'package:binance_test/core/widgets/timeline_selector.dart';
import 'package:binance_test/repo/repo.dart';
import 'package:binance_test/views/chart_view.dart';
import 'package:binance_test/main.dart';
import 'package:binance_test/core/widgets/tab_selector.dart';
import 'package:binance_test/core/utils.dart';
import 'package:candlesticks_plus/candlesticks_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class HomeView extends HookWidget {
  HomeView({
    super.key,
  });

  final tabs = ['Charts', 'Orderbooks', 'Recent trades'];
  final intervals = [
    '1h',
    '2h',
    '4h',
    '1d',
    '1w',
    '1M',
  ];

  @override
  Widget build(BuildContext context) {
    final currentPage = useState(0);
    final pgController = usePageController(initialPage: 0);
    final pgControllerOrders = usePageController(initialPage: 0);
    /* final candles = useState<List<Candle>>([]);
    final currentInterval = useState(intervals[0]);
    final symbols = useState<List<String>>([]);
    final currentSymbol = useState('BTCUSDT'); */

    return Scaffold(
      appBar: AppBar(),
      body: SizedBox(
        width: context.width,
        height: context.height,
        child: ListView(
          shrinkWrap: true,
          children: [
            //Tabs
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TabSelector(
                  tabs: tabs,
                  initialValue: 0,
                  onValueChanged: (i) {
                    currentPage.value = i;
                    pgController.jumpToPage(i);
                  }),
            ),
            Container(
              height: context.height * 0.68,
              width: context.width,
              margin: const EdgeInsets.only(top: 16),
              child: PageView(
                controller: pgController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  ChartView(),
                  OrderBooks(),
                  const Text('Recent trades'),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TabSelector(
                  tabs: const ['Open orders', 'Positions'],
                  initialValue: 0,
                  onValueChanged: (i) {
                    //currentPage.value = i;
                    pgControllerOrders.jumpToPage(i);
                  }),
            ),
            Container(
              height: context.height * 0.4,
              width: context.width,
              margin: const EdgeInsets.only(top: 16),
              child: PageView(
                controller: pgControllerOrders,
                physics: const NeverScrollableScrollPhysics(),
                children: const [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'No Open Orders',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          'Lorem ipsum dolor sit amet, consectetur adipiscing'
                          ' elit. Id pulvinar nullam sit'
                          ' imperdiet pulvinar.',
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  Text('Positions'),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              Expanded(
                child: MaterialButton(
                  color: Colors.green,
                  textColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  onPressed: () {},
                  child: const Text('Buy'),
                ),
              ),
              12.wBox,
              Expanded(
                child: MaterialButton(
                  color: Colors.red,
                  textColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  onPressed: () {},
                  child: const Text('Sell'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OrderBooks extends StatefulWidget {
  const OrderBooks({
    super.key,
  });

  @override
  State<OrderBooks> createState() => _OrderBooksState();
}

class _OrderBooksState extends State<OrderBooks>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: TimelineSelector(
        initialValue: 0,
        timelines: ['1h', '2h', '3h'].map((e) => e.toUpperCase()).toList(),
        onValueChanged: (int index, String time) async {
          /* await chartController.fetchCandles(
                      chartController.currentSymbol,
                      timelines[val]);
                  /* setState(() {}); */
                  chartController.currentInterval = timelines[val]; */
        },
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
