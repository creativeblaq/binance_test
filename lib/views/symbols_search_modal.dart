import 'package:binance_test/core/utils.dart';
import 'package:flutter/material.dart';

class SymbolsSearchModal extends StatefulWidget {
  final Function(String symbol) onSelect;

  final List<String> symbols;
  const SymbolsSearchModal({
    Key? key,
    required this.onSelect,
    required this.symbols,
  }) : super(key: key);

  @override
  State<SymbolsSearchModal> createState() => _SymbolSearchModalState();
}

class _SymbolSearchModalState extends State<SymbolsSearchModal> {
  String symbolSearch = "";
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        //color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: SizedBox(
          width: context.width * 0.95,
          height: MediaQuery.of(context).size.height * 0.75,
          // color: Theme.of(context).backgroundColor.withOpacity(0.5),
          child: Column(
            children: [
              Container(
                width: 56,
                height: 4,
                margin: const EdgeInsets.only(
                  top: 8,
                ),
                decoration: BoxDecoration(
                  color: context.colorScheme.outlineVariant,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search symbol',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0)),
                  ),
                  onChanged: (value) {
                    setState(() {
                      symbolSearch = value;
                    });
                  },
                ),
              ),
              Expanded(
                child: ListView(
                  children: widget.symbols
                      .where((element) => element
                          .toLowerCase()
                          .contains(symbolSearch.toLowerCase()))
                      .map((e) => Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12.0,
                              vertical: 2,
                            ),
                            child: SizedBox(
                              width: 50,
                              height: 48,
                              child: RawMaterialButton(
                                elevation: 0,
                                fillColor: context.colorScheme.outlineVariant
                                    .withOpacity(
                                  0.5,
                                ),
                                onPressed: () {
                                  widget.onSelect(e);
                                  Navigator.of(context).pop();
                                },
                                child: Text(
                                  e,
                                  style: const TextStyle(
                                      //color: Colors.blue,
                                      ),
                                ),
                              ),
                            ),
                          ))
                      .toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
