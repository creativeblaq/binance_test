import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

extension BuildContextExtensions on BuildContext {
  Size get size => MediaQuery.of(this).size;
  double get height => size.height;
  double get width => size.width;
  ThemeData get theme => Theme.of(this);
  ColorScheme get colorScheme => theme.colorScheme;
  IconThemeData get iconTheme => theme.iconTheme;
  Color get iconColor => iconTheme.color ?? colorScheme.onSurface;
}

extension IntExtensions on num {
  SizedBox get wBox => SizedBox(width: toDouble());
  SizedBox get hBox => SizedBox(height: toDouble());
}
