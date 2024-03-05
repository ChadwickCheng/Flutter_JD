import 'dart:convert';
// import 'dart:html';
import '../services/Storage.dart';

class CheckOutServices{
  // 计算总价
  static getAllPrice(CheckOutServices){
    var tempAllPrice = 0.0;
    CheckOutServices.forEach((element) {
      if(element['checked']==true){
        tempAllPrice += element['price']*element['count'];
      }
    });
    return tempAllPrice;
  }

  // 来自provider
  static removeUnSelectedCartItem() async{
    List _cartList = [];
    List _tempList = [];
    // 获取购物车数据
    try{
      List cartListData = json.decode(await Storage.getString('cartList')??'');
      _cartList = cartListData;
    }catch(e){
      _cartList = [];
    }
    for(var i=0; i<_cartList.length; i++){
      if(_cartList[i]['checked']==false){
        _tempList.add(_cartList[i]);
      }
    }
    await Storage.setString('cartList', json.encode(_tempList));
  }
}