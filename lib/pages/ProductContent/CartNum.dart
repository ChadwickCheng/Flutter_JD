import 'package:flutter/material.dart';
import '../../services/ScreenAdapter.dart';

import '../../model/ProductContentModel.dart';

class CartNum extends StatefulWidget {
  final ProductContentItem _productContent;
  const CartNum(this._productContent,{super.key});

  @override
  State<CartNum> createState() => _CartNumState();
}

class _CartNumState extends State<CartNum> {

  var _productContent;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this._productContent = widget._productContent;
  }

  Widget _leftBtn(){
    return InkWell(
      child:Container(
        alignment: Alignment.center,
        width: ScreenAdapter.width(45),
        height: ScreenAdapter.height(45),
        child: Text('-'),
      ),
      onTap: () {
        if(this._productContent.count>1){
          setState(() {
            this._productContent.count-=this._productContent.count;
          });
        }else{
          print('不能再少了');
        }
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
          this._productContent.count+=this._productContent.count;
        });
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
      child: Text('${this._productContent.count}'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenAdapter.width(168),
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