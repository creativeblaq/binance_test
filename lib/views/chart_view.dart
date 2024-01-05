import 'package:binance_test/controllers/chart_controller.dart';
import 'package:binance_test/main.dart';
import 'package:binance_test/core/widgets/timeline_selector.dart';
import 'package:binance_test/core/utils.dart';
import 'package:binance_test/views/symbols_search_modal.dart';
import 'package:candlesticks_plus/candlesticks_plus.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:provider/provider.dart';

class ChartView extends StatefulWidget {
  const ChartView({
    super.key,
  });

  @override
  State<ChartView> createState() => _ChartViewState();
}

class _ChartViewState extends State<ChartView>
    with AutomaticKeepAliveClientMixin {
  final timelines = ['1h', '2h', '4h', '1d', '1w', '1M'];

  late ChartController chartController;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      chartController.fetchSymbols().then((value) {
        //print(value);
        chartController.symbols = value;

        if (chartController.symbols.isNotEmpty) {
          chartController.fetchCandles(
              chartController.symbols[0], chartController.currentInterval);
        }
      });
    });
  }

  @override
  void dispose() {
    chartController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    chartController = context.watch<ChartController>();

    return StreamBuilder(
        stream: chartController.channel == null
            ? null
            : chartController.channel!.stream,
        builder: (context, snapshot) {
          chartController.updateCandlesFromSnapshot(snapshot);

          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  height: 34,
                  width: context.width,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Time',
                          style: TextStyle(
                            color: context.colorScheme.outline,
                            fontSize: 14,
                          ),
                        ),
                        8.wBox,
                        Expanded(
                          child: TimelineSelector(
                            initialValue: 0,
                            timelines: timelines,
                            onValueChanged: (int index, String time) async {
                              if (chartController.currentInterval == time) {
                                return;
                              }
                              await chartController.fetchCandles(
                                  chartController.currentSymbol, time);
                              chartController.currentInterval = time;
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const Divider(
                thickness: 0.5,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  onPressed: () {},
                  icon: Icon(
                    EvaIcons.expand,
                    color: context.colorScheme.outline,
                  ),
                ),
              ),
              const Divider(
                thickness: 0.5,
              ),
              //CandleInfoTextToolbar(),
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  height: context.height * 0.5,
                  width: context.width,
                  child: Candlesticks(
                    candles: chartController.candles,

                    //watermark: 'Matinex',
                    onCurrentCandle: (candle) {
                      //print(candle);

                      chartController.currentCandle = candle;
                    },
                    showToolbar: true,
                    actions: [
                      ToolBarAction(
                        //width: 70,
                        onPressed: () async {
                          await showModalBottomSheet(
                            backgroundColor: Colors.transparent,
                            context: context,
                            builder: (context) {
                              return SymbolsSearchModal(
                                onSelect: (symbol) async {
                                  await chartController.fetchCandles(
                                      symbol, chartController.currentInterval);
                                  /*  setState(() {}); */
                                  chartController.currentSymbol = symbol;
                                },
                                symbols: chartController.symbols,
                              );
                            },
                          );
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: context.colorScheme.outlineVariant,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                EvaIcons.chevron_down_outline,
                                size: 20,
                                color: context.iconColor,
                              ),
                            ),
                            8.wBox,
                            Text(
                              chartController.currentSymbol,
                              style: TextStyle(
                                fontSize: 10,
                                color: context.iconColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    onLoadMoreCandles: chartController.loadMoreCandles,
                  ),
                ),
              ),
              const Divider(
                thickness: 0.5,
              ),
            ],
          );
        });
  }

  @override
  bool get wantKeepAlive => true;
}
