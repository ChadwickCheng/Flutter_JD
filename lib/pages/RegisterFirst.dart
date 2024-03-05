import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../widget/jdButton.dart';
import '../widget/jdText.dart';
import '../services/ScreenAdapter.dart';
import '../config/Config.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RegisterFirstPage extends StatefulWidget {
  const RegisterFirstPage({super.key});

  @override
  State<RegisterFirstPage> createState() => _RegisterFirstPageState();
}

class _RegisterFirstPageState extends State<RegisterFirstPage> {
  
  String tel = '';

  sendCode() async{
    RegExp reg = new RegExp(r'^1\d{10}$');
    if(reg.hasMatch(this.tel)){
      var api = '${Config.domain}api/sendCode';
      var response = await Dio().post(api,data:{'tel':this.tel});
      if(response.data['success']){
        print(response);// 直接打印验证码而不是发到手机
        Navigator.pushNamed(context, '/registerSecond',arguments: {'tel':this.tel});
      }else{
        Fluttertoast.showToast(
          msg: '${response.data['message']}',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
        );
      }
    }else{
      Fluttertoast.showToast(
        msg: '手机号格式不对',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text('用户注册第一步'),
      ),
      body:Container(
        padding: EdgeInsets.all(20),
        child:ListView(
          children: [
            SizedBox(height:50),
            JdText(text:'请输入手机号',password:false,onChanged: (value){
              this.tel=value;
            },),
            SizedBox(height:20),
            JdButton(
              text:'下一步',
              color:Colors.red,
              height:74,
              cb: sendCode,
            )
          ],
        ),
      ),
    );
  }
}