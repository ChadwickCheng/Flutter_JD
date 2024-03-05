import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import '../../provider/Counter.dart';
import '../../services/ScreenAdapter.dart';
import '../../services/UserServices.dart';
import '../../widget/jdButton.dart';
import '../../services/EventBus.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  bool isLogin = false;
  List userInfo = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this._getUserInfo();
    print('userpage init');
    eventBus.on<UserEvent>().listen((event) {
      print(event.str);
      this._getUserInfo();
    });
  }
  _getUserInfo() async{
    var isLogin = await UserServices.getUserLoginState();
    var userInfo = await UserServices.getUserInfo();
    setState(() {
      this.userInfo = userInfo;
      this.isLogin = isLogin;
    });
  }

  @override
  Widget build(BuildContext context) {
    var counterProvider = Provider.of<Counter>(context);
    return Scaffold(
      body:ListView(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('../../images/bg.jpg'),
                fit: BoxFit.cover
              )
            ),
            height:ScreenAdapter.height(220),
            width: double.infinity,
            child:Row(
              children: [
                Container(
                  margin:EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child:ClipOval(
                    child:Image.asset(
                      '../../images/avatar.jpg',
                      fit:BoxFit.cover,
                      width:ScreenAdapter.width(100),
                      height:ScreenAdapter.height(100),
                    )
                  )
                ),
                !this.isLogin?Expanded(
                  flex:1,
                  child:InkWell(
                    child:Text('登陆/注册',style: TextStyle(color:Colors.white)),
                    onTap: (){
                      Navigator.pushNamed(context, '/login');
                    },
                  ),
                ):Expanded(
                  flex:1,
                  child:Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '用户名: ${this.userInfo[0]['username']}',
                        style: TextStyle(
                          color:Colors.white,
                          fontSize:ScreenAdapter.size(32)
                        ),
                      ),
                      Text(
                        '普通会员',
                        style: TextStyle(
                          color:Colors.white,
                          fontSize:ScreenAdapter.size(24)
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading:Icon(Icons.assignment, color: Colors.red),
            title: Text('全部订单'),
            onTap: (){
              Navigator.pushNamed(context, '/order');
            },
          ),
          Divider(),
          ListTile(
            leading:Icon(Icons.payment, color: Colors.green),
            title: Text('待付款'),
          ),
          Divider(),
          ListTile(
            leading:Icon(Icons.local_car_wash, color: Colors.orange),
            title: Text('待收货'),
          ),
          Container(
            height: 10,
            width: double.infinity,
            color: Color.fromRGBO(242, 242, 242, 0.9),
          ),
          Divider(),
          ListTile(
            leading:Icon(Icons.favorite, color: Colors.lightGreen),
            title: Text('我的收藏'),
          ),
          Divider(),
          ListTile(
            leading:Icon(Icons.people, color: Colors.black54),
            title: Text('在线客服'),
          ),
          Divider(),
          this.isLogin?Container(
            padding: EdgeInsets.all(20),
              child:JdButton(
              text: '退出登陆',
              color: Colors.red,
              cb: () {
                UserServices.loginOut();
                this._getUserInfo();
              },
            )
          ):Text(''),
        ],
      ),
    );
  }
}