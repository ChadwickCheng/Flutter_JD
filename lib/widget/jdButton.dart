import 'package:flutter/material.dart';
import '../services/ScreenAdapter.dart';

class JdButton extends StatelessWidget {
  final Color color;
  final String text;
  final void Function()? cb;
  final double height;
  JdButton({super.key,this.color=Colors.black,this.text='button',this.cb=null,this.height=68});// 构造函数
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap:this.cb,
      child:Container(
        margin:EdgeInsets.all(5),
        padding:EdgeInsets.all(5),
        height:ScreenAdapter.height(this.height),
        width:double.infinity,
        decoration: BoxDecoration(
          color:this.color,
          borderRadius:BorderRadius.circular(10),
        ),
        child:Center(
          child:Text(this.text,style:TextStyle(color:Colors.white)),
        ),
      ),
    );
  }
}