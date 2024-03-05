import 'package:flutter/material.dart';
import 'dart:convert';
import '../services/Storage.dart';

class Cart with ChangeNotifier{
  List _cartList = [];
  List get cartList => this._cartList;
  bool _isCheckedAll = false;
  bool get isCheckedAll => this._isCheckedAll;// 是否全选
  double _allPrice = 0;// 总价
  double get allPrice => this._allPrice;

  Cart(){
    this.init();
  }

  // 初始化时获取购物车数据
  init() async{
    try{
      List cartListData = json.decode(await Storage.getString('cartList')??'');
      this._cartList = cartListData;
    }catch(e){
      this._cartList = [];
    }
    this._isCheckedAll = this.isCheckAll();
    this.computeAllPrice();// 计算总价
    notifyListeners();
  }
  updateCartList(){
    this.init();
  }
  changeItemCount(){
    Storage.setString('cartList', json.encode(this._cartList));
    this.computeAllPrice();// 计算总价
    notifyListeners();
  }
  // 全选
  checkAll(value){
    for(var i=0;i<this._cartList.length;i++){
      this._cartList[i]['checked'] = value;
    }
    this._isCheckedAll = value;
    this.computeAllPrice();// 计算总价
    Storage.setString('cartList', json.encode(this._cartList));
    notifyListeners();
  }
  // 判断是否全选
  bool isCheckAll(){
    if(this._cartList.length>0){
      for(var i=0;i<this._cartList.length;i++){
        if(this._cartList[i]['checked']==false){
          return false;
        }
      }
      return true;
    }
    return false;
  }
  // 监听每一项选中事件
  itemChange(){
    if(this.isCheckAll()){
      this._isCheckedAll = true;
    }else{
      this._isCheckedAll = false;
    }
    this.computeAllPrice();// 计算总价
    Storage.setString('cartList', json.encode(this._cartList));
    notifyListeners();
  }
  // 计算总价
  computeAllPrice(){
    double tempAllPrice = 0;
    for(var i=0;i<this._cartList.length;i++){
      if(this._cartList[i]['checked']){
        tempAllPrice += this._cartList[i]['price']*this._cartList[i]['count'];
      }
    }
    this._allPrice = tempAllPrice;
    notifyListeners();
  }
  // 删除
  removeItem(){
    List tempList = [];
    for(var i=0;i<this._cartList.length;i++){
      if(this._cartList[i]['checked']==false){
        tempList.add(this._cartList[i]);
      }
    }
    this._cartList = tempList;
    Storage.setString('cartList', json.encode(this._cartList));
    this.computeAllPrice();// 计算总价
    notifyListeners();
  }
}