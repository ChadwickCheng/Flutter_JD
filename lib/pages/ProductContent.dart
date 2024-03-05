import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter_jdshop/services/ScreenAdapter.dart';
import 'package:flutter_jdshop/widget/LoadingWidget.dart';
import '../pages/ProductContent/ProductContentFirst.dart';
import '../pages/ProductContent/ProductContentSecond.dart';
import '../pages/ProductContent/ProductContentThird.dart';

import '../widget/jdButton.dart';
import '../model/ProductContentModel.dart';
import '../config/Config.dart';
import 'package:dio/dio.dart';

import '../services/EventBus.dart';
import 'package:provider/provider.dart';
import '../provider/Cart.dart';
import '../services/CartServices.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ProductContentPage extends StatefulWidget {
  final Map? arguments;
  ProductContentPage({Key? key,this.arguments}) : super(key: key);

  @override
  State<ProductContentPage> createState() => _ProductContentPageState();
}

class _ProductContentPageState extends State<ProductContentPage> {

  List _productContentList = [];

  @override
  void initState() {
    super.initState();
    this._getContentData();
  }

  _getContentData() async{
    var api = '${Config.domain}api/pcontent?id=${widget.arguments!['id']}';
    // print('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!');
    // print(api);
    var result = await Dio().get(api);
    var productContent = ProductContentModel.fromJson(result.data);
    // print('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!');
    // print(productContent);
    setState(() {
      this._productContentList.add(productContent.result);// 使用add是因为 有sid 则进去 没有sid 返回空
    });
  }

  @override
  Widget build(BuildContext context) {
    var cartProvider = Provider.of<Cart>(context);
    return DefaultTabController(
      length:3,
      child:Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width:ScreenAdapter.width(400),
                child:TabBar(
                  indicatorColor: Colors.red,
                  indicatorSize: TabBarIndicatorSize.label,
                  tabs:[
                    Tab(child:Text('商品',style:TextStyle(color:Colors.black))),
                    Tab(child:Text('详情',style:TextStyle(color:Colors.black))),
                    Tab(child:Text('评价',style:TextStyle(color:Colors.black))),
                  ],
                ),
              ),
            ],
          ),
          actions:[
            IconButton(
              icon:Icon(Icons.more_horiz),
              onPressed: () {
                showMenu(
                  context: context,
                  position: RelativeRect.fromLTRB(ScreenAdapter.width(600), 76, 10, 0),
                  items: [
                    PopupMenuItem(
                      child: Row(
                        children: [
                          Icon(Icons.home),
                          Text('首页'),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      child: Row(
                        children: [
                          Icon(Icons.search),
                          Text('搜索'),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
        body:this._productContentList.length>0?Stack(
          children: [
            TabBarView(
              physics:NeverScrollableScrollPhysics(),// 禁止滑动
              children: [
                ProductContentFirst(this._productContentList),
                ProductContentSecond(this._productContentList),
                ProductContentThird(),
              ],
            ),
            Positioned(
              width: ScreenAdapter.width(750),
              height:ScreenAdapter.height(88),
              bottom:0,
              child:Container(
                // color:Colors.red,
                decoration: BoxDecoration(
                  border:Border(
                    top:BorderSide(
                      color:Colors.black26,
                      width:1,
                    ),
                  ),
                  color:Colors.white,
                ),
                child:Row(
                  children: [
                    InkWell(
                      child:Container(
                        padding:EdgeInsets.only(top:ScreenAdapter.height(10)),
                        width: 100,
                        height: ScreenAdapter.height(80),
                        child:Column(
                            children: [
                              Icon(Icons.shopping_cart),
                              Text('购物车'),
                            ],
                        ),
                      ),
                      onTap: () {
                        Navigator.pushNamed(context, '/cart');
                      },
                    ),
                    Expanded(
                      flex:1,
                      child:JdButton(
                        color:Color.fromRGBO(253, 1, 0, 0.9),
                        text:'加入购物车',
                        cb:() async{
                          if(this._productContentList[0].attr.length>0){
                            print('加入购物车');
                            // 广播
                            eventBus.fire(ProductContentEvent('加入购物车'));
                          }else{
                            await CartServices.addCart(this._productContentList[0]);
                            //Navigator.of(context).pop();// 关闭弹出框
                            cartProvider.updateCartList();
                            Fluttertoast.showToast(
                              msg: "加入购物车成功",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                            );
                          }
                        },
                      )
                    ),
                    Expanded(
                      flex:1,
                      child:JdButton(
                        color:Color.fromRGBO(255, 165, 0, 0.9),
                        text:'立即购买',
                        cb:() {
                          if(this._productContentList[0].attr.length>0){
                            print('立即购买');
                            // 广播
                            eventBus.fire(ProductContentEvent('立即购买'));
                          }else{
                            print('立即购买');
                          }
                        },
                      )
                    ),
                  ],
                ),
              ),
            ),
          ],
        ):LoadingWidget(),
      )
    );
  }
}