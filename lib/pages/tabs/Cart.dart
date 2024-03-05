import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

// import 'package:provider/provider.dart';
// import '../../provider/Counter.dart';
import '../../services/ScreenAdapter.dart';
import '../Cart/CartItem.dart';
import '../../provider/Cart.dart';

import '../../provider/Cart.dart';
import '../../services/CartServices.dart';
import '../../provider/CheckOut.dart';
import '../../services/UserServices.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  bool _isEdit = false;
  var checkOutProvider;

  // 结算
  doCheckOut() async{
    // 1.获取购物车选中的数据
    List checkOutData = await CartServices.getCheckOutData();
    // print(checkOutData);
    // 2.保存购物车选中的数据
    this.checkOutProvider.changeCheckOutListData(checkOutData);
    // 3.判断购物车有无选中数据
    if(checkOutData.length>0){
      // 4.判断是否登录
      var loginState = await UserServices.getUserLoginState();
      if(loginState==true){
        // 5.如果登录 跳转到结算页面
        Navigator.pushNamed(context, '/checkOut');
      }else{
        // 6.如果未登录 跳转到登录页面
        Fluttertoast.showToast(
          msg: "请先登录",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
        );
        Navigator.pushNamed(context, '/login');
      }
    }else{
      Fluttertoast.showToast(
        msg: "购物车为空",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
    }
    // 判断是否登录 保存购物车选中数据
    // Navigator.pushNamed(context, '/checkOut');
  }

  @override
  Widget build(BuildContext context) {
    // var counterProvider = Provider.of<Counter>(context);
    var cartProvider = Provider.of<Cart>(context);
    checkOutProvider = Provider.of<CheckOut>(context);
    return Scaffold(
      // floatingActionButton: FloatingActionButton(
      //   child:Icon(Icons.add),
      //   onPressed: (){
      //     counterProvider.increment();
      //   },
      // ),
      appBar:AppBar(
        title:Text('购物车'),
        actions: [
          IconButton(
            icon:Icon(Icons.launch),
            onPressed: (){
              setState((){
                this._isEdit = !this._isEdit;
              });
            },
          )
        ],
      ),
      body:cartProvider.cartList.length>0?Stack(
        children: [
          ListView(
            children: [
              Column(
                children: cartProvider.cartList.map((value){
                  return CartItem(value);
                }).toList(),
              ),
              SizedBox(height: ScreenAdapter.height(100)),
            ],
          ),
          Positioned(
            bottom:0,
            width: ScreenAdapter.width(750),
            height: ScreenAdapter.height(78),
            child: Container(
              decoration: BoxDecoration(
                color:Colors.white,
                border:Border(
                  top:BorderSide(
                    color:Colors.black26,
                    width:1,
                  ),
                ),
              ),
              width: ScreenAdapter.width(750),
              height: ScreenAdapter.height(78),
              child:Stack(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child:Row(
                      children: [
                        Container(
                          width: ScreenAdapter.width(60),
                          child:Checkbox(
                            value:cartProvider.isCheckedAll,
                            activeColor: Colors.pink,
                            onChanged: (val){
                              // 实现全选反选
                              cartProvider.checkAll(val);
                            },
                          ),
                        ),
                        Text('Select All'),
                        SizedBox(width: 20),
                        this._isEdit==false?Text('总价:'):Text(''),
                        this._isEdit==false?Text(
                          '￥${cartProvider.allPrice}',
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 20,
                          ),
                        ):Text(''),
                      ],
                    ),
                  ),
                  this._isEdit==false?Align(
                      alignment: Alignment.centerRight,
                      child:ElevatedButton(
                        child: Text('结算',style: TextStyle(color:Colors.white)),
                        onPressed: doCheckOut,
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(Colors.red),
                          minimumSize: MaterialStateProperty.all(Size(120, 40)),
                        ),
                    ),
                  ):Align(
                      alignment: Alignment.centerRight,
                      child:ElevatedButton(
                        child: Text('删除',style: TextStyle(color:Colors.white)),
                        onPressed: (){
                          cartProvider.removeItem();
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(Colors.red),
                          minimumSize: MaterialStateProperty.all(Size(120, 40)),
                        ),
                    ),
                  ),
                ],
              ),
              // color:Colors.red,
            ),
          )
        ],
      ):Center(
        child:Text('购物车为空'),
      ),
    );
  }
}