import 'dart:convert';

import 'package:flutter/material.dart';
import '../services/ScreenAdapter.dart';
import '../widget/jdText.dart';
import '../widget/jdButton.dart';

import 'package:dio/dio.dart';
import '../config/Config.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../services/Storage.dart';
import '../services/EventBus.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  String username='',password='';
  // 监听页面销毁
  dispose(){
    super.dispose();
    eventBus.fire(new UserEvent('登录成功...'));
  }

  doLogin() async{
    RegExp reg = new RegExp(r'^\d{11}$');
    if(!reg.hasMatch(this.username)){
      Fluttertoast.showToast(
        msg: '手机号格式不正确',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
    }else if(password.length<6){
      Fluttertoast.showToast(
        msg: '密码格式不正确',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
    }else{
      var api = '${Config.domain}api/doLogin';
      var response = await Dio().post(api,data:{'username':this.username,'password':this.password});
      if(response.data['success']){
        print(response.data);
        // 保存用户信息
        Storage.setString('userInfo', json.encode(response.data['userinfo']));
        Navigator.pop(context);
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
        leading:IconButton(
          icon:Icon(Icons.close),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
        actions: [
          TextButton(
            child:Text('客服',style: TextStyle(color:Colors.black)),
            onPressed: (){
              
            },
          )
        ],
      ),
      body:Container(
        padding:EdgeInsets.all(ScreenAdapter.width(20)),
        child:ListView(
          children: [
            Center(
              child:Container(
                margin:EdgeInsets.only(top:ScreenAdapter.height(20)),
                height:ScreenAdapter.height(160),
                width:ScreenAdapter.width(160),
                child:Image.asset('../../images/login.jpg',fit:BoxFit.cover),
              ),
            ),
            SizedBox(height:ScreenAdapter.height(30)),
            JdText(text:'请输入用户名',onChanged: (value){
              this.username=value;
            },),
            SizedBox(height:ScreenAdapter.height(10)),
            JdText(text:'请输入密码',password:true,onChanged: (value){
              this.password=value;
            },),
            SizedBox(height:ScreenAdapter.height(10)),
            Container(
              padding:EdgeInsets.all(ScreenAdapter.width(ScreenAdapter.width(20))),
              child:Stack(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child:Text('忘记密码')
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child:InkWell(
                      onTap: (){
                        Navigator.pushNamed(context, '/registerFirst');
                      },
                      child:Text('新用户注册')
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height:ScreenAdapter.height(20)),
            JdButton(text:'登录',color:Colors.red,height:74,cb: doLogin,),
          ],
        )
      ),
    );
  }
}