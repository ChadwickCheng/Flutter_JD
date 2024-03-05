import 'package:flutter/material.dart';
import '../../services/ScreenAdapter.dart';
import './CartNum.dart';

import 'package:provider/provider.dart';
import '.././../provider/Cart.dart';

class CartItem extends StatefulWidget {
  final Map _itemData;
  const CartItem(this._itemData,{super.key});

  @override
  State<CartItem> createState() => _CartItemState();
}

class _CartItemState extends State<CartItem> {
  late Map _itemData;
  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
    
  // }
  @override
  Widget build(BuildContext context) {
    this._itemData = widget._itemData;
    var cartProvider = Provider.of<Cart>(context);
    return Container(
      padding:EdgeInsets.all(5),
      height:ScreenAdapter.height(200),
      decoration: BoxDecoration(
        border:Border(
          bottom:BorderSide(
            width:1,
            color:Colors.black12
          )
        )
      ),
      child:Row(// 自适应宽度
        children: [
          Container(
            width:ScreenAdapter.width(60),
            child:Checkbox(
              value:_itemData['checked'],
              onChanged: (val){
                setState(() {
                  _itemData['checked'] = !_itemData['checked'];
                });
                cartProvider.itemChange();
              },
              activeColor:Colors.pink,
            ),
          ),
          Container(
            width: ScreenAdapter.width(160),
            child:Image.network(
              '${_itemData["pic"]}}',
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
                  Text('${_itemData["title"]}',maxLines:2),
                  Text('${_itemData["selectedAttr"]}',maxLines:2),
                  Stack(
                    children: [
                      Align(
                        alignment:Alignment.centerLeft,
                        child: Text('${_itemData['price']}',style:TextStyle(color:Colors.red)),
                      ),
                      Align(
                        alignment:Alignment.centerRight,
                        child: CartNum(_itemData),
                      ),
                    ],
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