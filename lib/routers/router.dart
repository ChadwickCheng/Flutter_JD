import 'package:flutter/material.dart';
import '../pages/tabs/Tabs.dart';
import '../pages/search.dart';
import '../pages/ProductList.dart';
import '../pages/ProductContent.dart';
import '../pages/tabs/Cart.dart';
import '../pages/login.dart';
import '../pages/RegisterFirst.dart';
import '../pages/RegisterSecond.dart';
import '../pages/RegisterThird.dart';
import '../pages/CheckOut.dart';
import '../pages/Address/AddressAdd.dart';
import '../pages/Address/AddressEdit.dart';
import '../pages/Address/AddressList.dart';
import '../pages/Pay.dart';
import '../pages/Order.dart';
import '../pages/OrderInfo.dart';

final routes = {
  '/': (context) => Tabs(),
  '/search': (context) => SearchPage(),
  '/ProductList':(context,{arguments})=>ProductListPage(arguments:arguments),
  '/ProductContent':(context,{arguments})=>ProductContentPage(arguments:arguments),
  '/cart':(context)=>CartPage(),
  '/login':(context)=>LoginPage(),
  '/registerFirst':(context)=>RegisterFirstPage(),
  '/registerSecond':(context,{arguments})=>RegisterSecondPage(arguments:arguments),
  '/registerThird':(context,{arguments})=>RegisterThirdPage(arguments:arguments),
  '/checkOut':(context)=>CheckOutPage(),
  '/addressAdd':(context)=>AddressAddPage(),
  '/addressEdit':(context,{arguments})=>AddressEditPage(arguments:arguments),
  '/addressList':(context)=>AddressListPage(),
  '/pay':(context)=>PayPage(),
  '/order':(context)=>OrderPage(),
  '/orderinfo':(context)=>OrderInfoPage(),
};

var onGenerateRoute = (RouteSettings settings){
  final String? name = settings.name;
  final Function? pageContentBuilder = routes[name];
  if(pageContentBuilder != null){
    if(settings.arguments != null){
      final Route route = MaterialPageRoute(
        builder: (context) => pageContentBuilder(context, arguments: settings.arguments)
      );
      return route;
    }else{
      final Route route = MaterialPageRoute(
        builder: (context) => pageContentBuilder(context)
      );
      return route;
    }
  }
};