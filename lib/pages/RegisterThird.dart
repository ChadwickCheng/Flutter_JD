import 'dart:convert';

import 'package:flutter/material.dart';
import '../widget/jdButton.dart';
import '../widget/jdText.dart';
import '../services/ScreenAdapter.dart';
import 'package:dio/dio.dart';
import '../config/Config.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../services/Storage.dart';
import '../pages/tabs/Tabs.dart';

class RegisterThirdPage extends StatefulWidget {
  final Map arguments;
  const RegisterThirdPage({super.key,required this.arguments});

  @override
  State<RegisterThirdPage> createState() => _RegisterThirdPageState();
}

class _RegisterThirdPageState extends State<RegisterThirdPage> {
  late String tel;
  late String code;
  late String password = '';
  late String rpassword = '';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.tel = widget.arguments['tel'];
    this.code = widget.arguments['code'];
  }

  // 注册
  doRegister() async{
    if(password.length<6){
      Fluttertoast.showToast(
        msg: '密码长度不能小于6位',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
      return;
    }else if(rpassword!=password){
      Fluttertoast.showToast(
        msg: '密码不一致',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
      return;
    }else{
      var api =  '${Config.domain}api/register';
      var response = await Dio().post(api,data:{'tel':this.tel,'code':this.code,'password':this.password});
      if(response.data['success']){
        // 保存用户信息
        Storage.setString('userInfo', json.encode(response.data['userinfo']));
        // Navigator.pushNamed(context, '/'); // 跳转到首页
        Navigator.of(context).pushAndRemoveUntil(
          new MaterialPageRoute(builder: (context)=>new Tabs()),
          (route)=>route==null
        );// 与上面的区别是这个可以返回到根路由
      }else{
        Fluttertoast.showToast(
          msg: '${response.data['message']}',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text('用户注册第s步'),
      ),
      body:Container(
        padding:EdgeInsets.all(20),
        child:ListView(
          children: [
            SizedBox(height: 50,),
            JdText(text:'请输入密码',password:true,onChanged: (value){
              this.password = value;
            },),
            SizedBox(height: 10,),
            JdText(text:'确认密码',password:true,onChanged: (value){
              this.rpassword = value;
            },),
            SizedBox(height: 20,),
            JdButton(
              text:'注册',
              color:Colors.red,
              height:74,
              cb: doRegister,
            )
          ],
        )
      ),
    );
  }
}