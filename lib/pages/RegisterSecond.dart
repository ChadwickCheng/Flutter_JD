import 'dart:async';// 计时器
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../config/Config.dart';
import '../widget/jdButton.dart';
import '../widget/jdText.dart';
import '../services/ScreenAdapter.dart';


class RegisterSecondPage extends StatefulWidget {
  final Map arguments;
  const RegisterSecondPage({super.key,required this.arguments});

  @override
  State<RegisterSecondPage> createState() => _RegisterSecondPageState();
}

class _RegisterSecondPageState extends State<RegisterSecondPage> {
  late String tel;
  bool sendCodeBtn = false;
  int seconds = 10;
  late String code;
  
  // 倒计时 
  _showTimer(){
    Timer t;
    t = Timer.periodic(Duration(milliseconds: 1000), (timer) {
      setState(() {
        this.seconds--;
      });
      if(this.seconds==0){
        timer.cancel();// 取消定时器
        setState(() {
          this.sendCodeBtn=true;
        });
      }
    });
  }
  // 重新发送
  sendCode() async{
    setState(() {
        this.seconds=10;
        this.sendCodeBtn=false;
        this._showTimer();
      });
    var api = '${Config.domain}api/sendCode';
    var response = await Dio().post(api,data:{'tel':this.tel});
    if(response.data['success']){
      print(response);// 直接打印验证码而不是发到手机
    }else{
      Fluttertoast.showToast(
        msg: '${response.data['message']}',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
    }
  }
  // 验证验证码
  validateCode() async{
    var api = '${Config.domain}api/validateCode';
    var response = await Dio().post(api,data:{'tel':this.tel,'code':this.code});
    if(response.data['success']){
      Navigator.pushNamed(context, '/registerThird',arguments: {
        'tel':this.tel,
        'code':this.code
      });
    }else{
      Fluttertoast.showToast(
        msg: '${response.data['message']}',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.tel=widget.arguments['tel'];
    _showTimer();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text('用户注册第二步'),
      ),
      body:Container(
        padding: EdgeInsets.all(20),
        child:ListView(
          children: [
            SizedBox(height:50),
            Container(
              // margin: EdgeInsets.all(20),
              padding: EdgeInsets.only(left:10),
              child:Text('请输入验证码，我们已发送验证码到您的手机${this.tel}',style: TextStyle(fontSize: ScreenAdapter.size(28)),),
            ),
            SizedBox(height:40),
            Stack(
              children: [
                Container(
                  height:ScreenAdapter.height(100),
                  child:JdText(text:'请输入验证码',password:false,onChanged: (value){
                    print(value);
                    this.code=value;
                    },
                  )
                ),
                Positioned(
                  right: 0,
                  top: 0,
                  child: sendCodeBtn?ElevatedButton(
                    child: Text('重新发送'),
                    onPressed: (){
                      this.sendCode();
                    },
                  ):ElevatedButton(
                    child: Text('${this.seconds}秒后重发'),
                    onPressed: (){

                    },
                  ),
                )
              ],
            ),
            SizedBox(height:20),
            JdButton(
              text:'下一步',
              color:Colors.red,
              height:74,
              cb: this.validateCode,
            )
          ],
        ),
      ),
    );
  }
}