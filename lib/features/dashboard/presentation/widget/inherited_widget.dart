import 'package:flutter/material.dart';

class InheritedDataProvider extends InheritedWidget {
  final DateTime data;

  InheritedDataProvider({
    required Widget child,
    required this.data,
  }) : super(child: child);

  @override
  bool updateShouldNotify(InheritedDataProvider oldWidget) =>
      data != oldWidget.data;
  static InheritedDataProvider? of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<InheritedDataProvider>();
}

class InheritedAgendaProvider extends InheritedWidget {
  final String data;
  // final Report reportData;

  InheritedAgendaProvider({
    required Widget child,
    required this.data,
    // this.reportData,
  }) : super(child: child);

  @override
  bool updateShouldNotify(InheritedAgendaProvider oldWidget) =>
      data != oldWidget.data;
  static InheritedAgendaProvider? of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<InheritedAgendaProvider>();
}
