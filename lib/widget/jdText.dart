import 'package:flutter/material.dart';
import '../services/ScreenAdapter.dart';

class JdText extends StatelessWidget {
  final String text;
  final bool password;
  final dynamic onChanged; 
  final int maxLines;
  final double height;
  final TextEditingController? controller;
  JdText({super.key,this.text='输入内容',this.password=false,this.onChanged=null,this.maxLines=1,this.height=68,this.controller=null});

  @override
  Widget build(BuildContext context) {
    return Container(
          height:ScreenAdapter.height(ScreenAdapter.height(this.height)),
          decoration: BoxDecoration(
            // borderRadius: BorderRadius.circular(30),
            // color: Color.fromRGBO(233, 233, 233, 0.8),
            border: Border(
              bottom: BorderSide(
                width: 1,
                color: Colors.black12
              )
            )
          ),
          child:TextField(
            controller: this.controller,
            maxLines: this.maxLines,
            obscureText: this.password,// true密码框
            autofocus: false,// 默认选中会键盘弹起
            decoration: InputDecoration(
              hintText: this.text,
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            onChanged: this.onChanged,
          ),
        );
  }
}