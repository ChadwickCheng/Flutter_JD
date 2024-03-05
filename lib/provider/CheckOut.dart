import 'package:flutter/material.dart';

class CheckOut with ChangeNotifier{
  List _checkOutListData = [];
  List get checkOutListData => this._checkOutListData;
  
  changeCheckOutListData(data){
    this._checkOutListData = data;
    notifyListeners();
  }
}