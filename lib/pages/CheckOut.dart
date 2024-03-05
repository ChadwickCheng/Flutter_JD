// import 'dart:ffi';

import 'dart:convert';

import 'package:flutter/material.dart';
import '../services/ScreenAdapter.dart';
import '../../provider/CheckOut.dart';
import 'package:provider/provider.dart';
import '.././config/Config.dart';
import 'package:dio/dio.dart';
import '../services/SignServices.dart';
import '../services/UserServices.dart';
import '../services/EventBus.dart';
import '../services/CheckOutServices.dart';
import '../provider/Cart.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CheckOutPage extends StatefulWidget {
  const CheckOutPage({super.key});

  @override
  State<CheckOutPage> createState() => _CheckOutPageState();
}

class _CheckOutPageState extends State<CheckOutPage> {
  List addressList = [];
  @override
  void initState() {
    super.initState();
    this._getDefaultAddress();
    eventBus.on<CheckoutEvent>().listen((event){
      print(event.str);
      this._getDefaultAddress();
    });
  }
  _getDefaultAddress() async{
    List userInfo = await UserServices.getUserInfo();
    var tempJson = {
      'uid':userInfo[0]['_id'],
      'salt':userInfo[0]['salt']
    };
    var sign = SignServices.getSign(tempJson);
    var api = '${Config.domain}api/oneAddressList?uid=${userInfo[0]['_id']}&sign=${sign}';
    var response = await Dio().get(api);
    print(response);
    setState(() {
      this.addressList = response.data['result'];
    });
  }

  Widget _checkOutItem(item){
    return Row(
      children: [
        Container(
            width: ScreenAdapter.width(160),
            child:Image.network(
              '${item['pic']}}',
              fit:BoxFit.cover,
            ),
          ),
          Expanded(
            flex:1,
            child:Container(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 5),
              child:Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${item['title']}',maxLines:2),
                  Text('${item['selectedAttr']}',maxLines:2),
                  Stack(
                    children: [
                      Align(
                        alignment:Alignment.centerLeft,
                        child: Text('￥${item['price']}',style:TextStyle(color:Colors.red)),
                      ),
                      Align(
                        alignment:Alignment.centerRight,
                        child: Text('x${item['count']}'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var checkOutProvider = Provider.of<CheckOut>(context);
    var cartProvider = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('结算'),
      ),
      body: Stack(
        children: [
          ListView(
            children: [
              Container(
                color: Colors.white,
                child:Column(
                  children: [
                    SizedBox(height: 10),
                    this.addressList.length<=0?ListTile(
                      leading: Icon(Icons.add_location),
                      title:Center(
                        child:Text('请添加收货地址'),
                      ),
                      trailing: Icon(Icons.navigate_next),
                      onTap: (){
                        Navigator.pushNamed(context, '/addressAdd');
                      },
                    ):ListTile(
                      leading: Icon(Icons.add_location),
                      title:Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${this.addressList[0]['name']} ${this.addressList[0]['phone']}'),
                          SizedBox(height: 10),
                          Text('${this.addressList[0]['address']}'),
                        ],
                      ),
                      trailing: Icon(Icons.navigate_next),
                      onTap: (){
                        Navigator.pushNamed(context, '/addressList');
                      },
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ),
              SizedBox(height: 20),
              // Container(
              //   color: Colors.white,
              //   padding: EdgeInsets.all(ScreenAdapter.width(20)),
              //   child:Column(
              //     children: checkOutProvider.checkOutListData.map((value){
              //       return Column(
              //         children: [
              //           _checkOutItem(value),
              //           Divider(),],
              //       );
              //     }).toList(),
              //   ),
              // ),
              Container(
                color: Colors.white,
                padding: EdgeInsets.all(ScreenAdapter.width(20)),
                child: Column(
                    children: checkOutProvider.checkOutListData.map((value) {
                  return Column(
                    children: <Widget>[_checkOutItem(value), Divider()],
                  );
                }).toList()),
              ),
              SizedBox(height: 20),
              Container(
                color:Colors.white,
                padding: EdgeInsets.all(ScreenAdapter.width(20)),
                child:Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('商品总金额 ￥9999'),
                    Divider(),
                    Text('立减 ￥8999'),
                    Divider(),
                    Text('运费 ￥0'),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 0,
            width: ScreenAdapter.width(750),
            height: ScreenAdapter.height(100),
            child:Container(
              padding:EdgeInsets.all(5),
              width: ScreenAdapter.width(750),
              height: ScreenAdapter.height(100),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  top: BorderSide(
                    width: 1,
                    color: Colors.black12,
                  ),
                ),
              ),
              child:Stack(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child:Text('总价:￥9999',style:TextStyle(color:Colors.red,fontSize:16)),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child:ElevatedButton(
                      onPressed: () async{
                        if(this.addressList.length>0){
                          List userInfo = await UserServices.getUserInfo();
                          var allPrice = CheckOutServices.getAllPrice(checkOutProvider.checkOutListData).toStringAsFixed(1);
                          var sign = SignServices.getSign({
                            'uid':userInfo[0]['_id'],
                            'phone':this.addressList[0]['phone'],
                            'address':this.addressList[0]['address'],
                            'name':this.addressList[0]['name'],
                            'all_price':allPrice,
                            'products':json.encode(checkOutProvider.checkOutListData),
                            'salt':userInfo[0]['salt']
                          });
                          var api = '${Config.domain}api/doOrder';
                          var response = await Dio().post(api,data:{
                            'uid':userInfo[0]['_id'],
                            'phone':this.addressList[0]['phone'],
                            'address':this.addressList[0]['address'],
                            'name':this.addressList[0]['name'],
                            'all_price':allPrice,
                            'products':json.encode(checkOutProvider.checkOutListData),
                            'sign':sign
                          });
                          print(response);
                          if(response.data['success']){
                            print('下单成功,跳转到支付页面');
                            // Navigator.pushNamed(context, '/pay',arguments: {
                            //   'id':response.data['id'],
                            // });
                            // 获取未选中商品存入本地存储，其他删掉
                            await CheckOutServices.removeUnSelectedCartItem();
                            // provider更新
                            cartProvider.updateCartList();
                            Navigator.pushReplacementNamed(context, '/pay');
                          }
                        }else{
                          Fluttertoast.showToast(
                            msg: '请填写收货地址',
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                          );
                        }
                      },
                      child:Text('立即下单',style:TextStyle(color:Colors.white)),
                      style:ButtonStyle(
                        backgroundColor:MaterialStateProperty.all(Colors.red),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}