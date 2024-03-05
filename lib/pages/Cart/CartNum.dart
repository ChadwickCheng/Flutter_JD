import 'package:flutter/material.dart';
import '../../services/ScreenAdapter.dart';
import 'package:provider/provider.dart';
import '.././../provider/Cart.dart';

class CartNum extends StatefulWidget {
  final Map _itemData;
  const CartNum(this._itemData,{super.key});

  @override
  State<CartNum> createState() => _CartNumState();
}

class _CartNumState extends State<CartNum> {
  var cartProvider;
  late Map _itemData;
  // @override
  // void initState() {
  //   super.initState();
    
  // }

  Widget _leftBtn(){
    return InkWell(
      child:Container(
        alignment: Alignment.center,
        width: ScreenAdapter.width(45),
        height: ScreenAdapter.height(45),
        child: Text('-'),
      ),
      onTap: () {
        setState(() {
          if(_itemData["count"]>1){
            _itemData["count"]--;
          }
        });
        this.cartProvider.changeItemCount();
      },
    );
  }

  Widget _rightBtn(){
    return InkWell(
      child:Container(
        alignment: Alignment.center,
        width: ScreenAdapter.width(45),
        height: ScreenAdapter.height(45),
        child: Text('+'),
      ),
      onTap: () {
        setState(() {
          _itemData["count"]++;
        });
        this.cartProvider.changeItemCount();
      },
    );
  }

  Widget _centerArea(){
    return Container(
      alignment: Alignment.center,
      width: ScreenAdapter.width(70),
      height: ScreenAdapter.height(45),
      decoration: BoxDecoration(
        border:Border(
          left:BorderSide(
            width:ScreenAdapter.width(2),
            color:Colors.black12
          ),
          right:BorderSide(
            width:ScreenAdapter.width(2),
            color:Colors.black12
          )
        )
      ),
      child: Text('${_itemData["count"]}'),
    );
  }

  @override
  Widget build(BuildContext context) {
    this._itemData = widget._itemData;
    this.cartProvider = Provider.of<Cart>(context);
    return Container(
      width: ScreenAdapter.width(164),
      decoration: BoxDecoration(
        border:Border.all(
          width:ScreenAdapter.width(2),
          color:Colors.black12
        )
      ),
      child:Row(
        children: [
          _leftBtn(),
          _centerArea(),
          _rightBtn(),
        ],
      ),
    );
  }
}