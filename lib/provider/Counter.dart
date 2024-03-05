import 'package:flutter/material.dart';

class Counter with ChangeNotifier {
  int _count = 0;

  Counter(){
    this._count=10;
  }

  int get count => _count;

  void increment() {
    _count++;
    notifyListeners();
  }
}