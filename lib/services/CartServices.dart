import 'package:flutter/material.dart';
import './Storage.dart';
import 'dart:convert';
import '../../config/Config.dart';

class CartServices{
  static addCart(item) async{
    item = CartServices.formatCartData(item);
    print(item);

    try{// 有数据则读取
      List cartListData = json.decode(await Storage.getString('cartList')??'');
      // 查重
      bool hasData = cartListData.any((v){
        return v['_id'] == item['_id'] && v['selectedAttr'] == item['selectedAttr'];// 要增加和购物车属性一致
      });
      if(hasData){
        for(var i=0;i<cartListData.length;i++){
          if(cartListData[i]['_id'] == item['_id'] && cartListData[i]['selectedAttr'] == item['selectedAttr']){
            cartListData[i]['count'] += item['count'];
          }
        }
        await Storage.setString('cartList', json.encode(cartListData));
      }else{
        cartListData.add(item);
        await Storage.setString('cartList', json.encode(cartListData));
      }
    }catch(e){// 没有数据则写入
      List tempList = [];
      tempList.add(item);
      await Storage.setString('cartList', json.encode(tempList));
    }

  }

  //过滤数据
  static formatCartData(item){
    String pic = item.pic;
    pic = Config.domain+pic.replaceAll('\\','/');

    final Map data = new Map<String,dynamic>();
    data['_id'] = item.sId;
    data['title'] = item.title;
    // 处理数据类型
    if(item.price is int || item.price is double){
      data['price'] = item.price;
    }else{
      data['price'] = double.parse(item.price);
    }
    data['price'] = item.price;
    data['selectedAttr'] = item.selectedAttr;
    data['count'] = item.count;
    data['pic'] = item.pic;
    // 是否选中
    data['checked'] = true;
    return data;
  }

  // 获取购物车列表
  static getCheckOutData() async{
    List cartListData = [];
    List tempCheckOutData = [];
    // try{
    //   cartListData = json.decode(await Storage.getString('cartList')??'');
    //   return cartListData;
    // }catch(e){
    //   cartListData = [];
    // }
    String? cartList = await Storage.getString('cartList');
    if (cartList != null) {
       cartListData = json.decode(cartList);
    }else{
      cartListData = [];
    }   
    // for (var i = 0; i < cartListData.length; i++) {
    //   if (cartListData[i]["checked"] == true) {
    //     tempCheckOutData.add(cartListData[i]);
    //   }
    // }
    // 过滤数据
    for(var i=0;i<cartListData.length;i++){
      if(cartListData[i]['checked']==true){
        tempCheckOutData.add(cartListData[i]);
      }
    }
    return tempCheckOutData;
  }
}