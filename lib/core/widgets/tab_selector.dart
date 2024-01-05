import 'package:flutter/cupertino.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class TabSelector extends HookWidget {
  const TabSelector({
    required this.tabs,
    required this.initialValue,
    required this.onValueChanged,
    super.key,
  });

  final void Function(int val) onValueChanged;
  final int initialValue;
  final List<String> tabs;

  @override
  Widget build(BuildContext context) {
    final selectedValue = useState(initialValue);
    return CupertinoSlidingSegmentedControl(
      children: List.generate(
        tabs.length,
        (index) =>
            SizedBox(height: 36, child: Center(child: Text(tabs[index]))),
      ).asMap(),
      onValueChanged: (val) {
        selectedValue.value = val ?? 0;
        onValueChanged.call(selectedValue.value);
      },
      groupValue: selectedValue.value,
    );
  }
}
