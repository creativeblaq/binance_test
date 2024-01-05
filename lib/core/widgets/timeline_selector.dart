import 'package:binance_test/core/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class TimelineSelector extends HookWidget {
  const TimelineSelector({
    required this.timelines,
    required this.initialValue,
    required this.onValueChanged,
    super.key,
  });

  final void Function(int index, String time) onValueChanged;
  final int initialValue;
  final List<String> timelines;

  @override
  Widget build(BuildContext context) {
    final selectedValue = useState(initialValue);

    return ListView.builder(
      itemCount: timelines.length,
      scrollDirection: Axis.horizontal,
      shrinkWrap: true,
      itemBuilder: (BuildContext context, int index) {
        final time = timelines[index];
        return InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            selectedValue.value = index;
            onValueChanged.call(selectedValue.value, time);
          },
          child: Container(
            decoration: BoxDecoration(
              color: index == selectedValue.value
                  ? context.colorScheme.outlineVariant
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            //alignment: Alignment.center,
            child: Center(
              child: Text(
                time,
                style: TextStyle(
                  fontSize: 14,
                  color: index == selectedValue.value
                      ? context.colorScheme.onBackground
                      : context.colorScheme.outline,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
