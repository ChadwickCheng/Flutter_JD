import 'package:flutter/material.dart';
import 'package:flutter_jdshop/services/ScreenAdapter.dart';
import '../widget/JdButton.dart';

import '../model/OrderModel.dart';
import '../config/Config.dart';
import 'package:dio/dio.dart';
import '../services/UserServices.dart';
import '../services/SignServices.dart';

class OrderPage extends StatefulWidget {
  OrderPage({Key? key}) : super(key: key);

  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {

  List _orderList = [];
  @override
  void initState() {
    super.initState();
    this._getListData();
  }
  _getListData() async{
    List userInfo = await UserServices.getUserInfo();
    var tempJson = {"uid": userInfo[0]["_id"], "salt": userInfo[0]["salt"]};
    var sign = SignServices.getSign(tempJson);
    var api = '${Config.domain}api/orderList?uid=${userInfo[0]["_id"]}&sign=${sign}';
    var response = await Dio().get(api);// response.data是map类型
    // print(response);
    setState(() {
      this._orderList = OrderModel.fromJson(response.data).result??[];
    });
  }

  // 自定义商品列表组件
  List<Widget> _orderItemWidget(orderItems){
    List<Widget> tempList = [];
    for(var i=0;i<orderItems.length;i++){
      tempList.add(
        Column(
          children: [
            SizedBox(height:10),
            ListTile(
              leading: Container(
                width: ScreenAdapter.width(120),
                height: ScreenAdapter.height(120),
                child: Image.network("${orderItems[i].productImg}",fit: BoxFit.cover),
              ),
              title: Text("${orderItems[i].productTitle}"),
              trailing: Text("x${orderItems[i].productCount}"),
            )
          ],
        )
      );
    }
    return tempList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("我的订单"),
      ),
      body: Stack(
        children: <Widget>[
          Container(
            margin: EdgeInsets.fromLTRB(0, ScreenAdapter.height(80), 0, 0),
            padding: EdgeInsets.all(ScreenAdapter.width(16)),
            child: ListView(
              children: this._orderList.map((value){
                return InkWell(
                  child: Card(
                    child: Column(
                      children: <Widget>[
                        ListTile(
                          title: Text("订单编号：${value.sId}",style: TextStyle(color:Colors.black54),),
                        ),
                        Divider(),
                        Column(
                          children: this._orderItemWidget(value.orderItem),
                        ),
                        ListTile(
                          leading: Text("合计：￥${value.allPrice}"),
                          trailing: TextButton(
                            child: Text("申请售后"),
                            onPressed: () {},
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(Colors.grey[100])
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  onTap: (){
                    Navigator.pushNamed(context, '/orderinfo');// 没写接口
                  },
                );
              }).toList(),
            ),
          ),
          Positioned(
            top: 0,
            width: ScreenAdapter.width(750),
            height: ScreenAdapter.height(76),
            child: Container(
              width: ScreenAdapter.width(750),
              height: ScreenAdapter.height(76),
              color: Colors.white,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text("全部", textAlign: TextAlign.center),
                  ),
                  Expanded(
                    child: Text("待付款", textAlign: TextAlign.center),
                  ),
                  Expanded(
                    child: Text("待收货", textAlign: TextAlign.center),
                  ),
                  Expanded(
                    child: Text("已完成", textAlign: TextAlign.center),
                  ),
                  Expanded(
                    child: Text("已取消", textAlign: TextAlign.center),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
