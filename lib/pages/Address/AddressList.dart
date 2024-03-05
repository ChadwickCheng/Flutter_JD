import 'package:flutter/material.dart';
import 'package:flutter_jdshop/services/EventBus.dart';
import 'package:flutter_jdshop/services/SearchServices.dart';
import '../../services/ScreenAdapter.dart';
import '../../services/UserServices.dart';
import '../../services/SignServices.dart';
import '../../config/Config.dart';
import 'package:dio/dio.dart';
import '../../services/EventBus.dart';


class AddressListPage extends StatefulWidget {
  const AddressListPage({super.key});

  @override
  State<AddressListPage> createState() => _AddressListPageState();
}

class _AddressListPageState extends State<AddressListPage> {

  List addressList = [];

  // 获取收货地址
  _getAddressList() async{
    // 请求接口
    List userinfo = await UserServices.getUserInfo();
    var tempJson = {'uid':userinfo[0]['_id'],'salt':userinfo[0]['salt']};
    var sign = SignServices.getSign(tempJson);
    var api = '${Config.domain}api/addressList?uid=${userinfo[0]['_id']}&sign=${sign}';
    var response = await Dio().get(api);
    print(response);
    setState(() {
      this.addressList = response.data['result'];
    });
  }

  // 修改默认收货地址
  _changeDefault(id) async{
    List userinfo = await UserServices.getUserInfo();
    var tempJson = {'uid':userinfo[0]['_id'],'id':id,'salt':userinfo[0]['salt']};
    var sign = SignServices.getSign(tempJson);
    var api = '${Config.domain}api/changeDefaultAddress';
    var response = await Dio().post(api,data:{
      'uid':userinfo[0]['_id'],
      'id':id,
      'sign':sign
    });
    // print(response);
    Navigator.pop(context);
  }

  // 删除收货地址
  _delAddress(id) async{
    List userinfo=await UserServices.getUserInfo();


    var tempJson={
      "uid":userinfo[0]["_id"],
      "id":id,
      "salt":userinfo[0]["salt"]
    };

    var sign=SignServices.getSign(tempJson);
    // print(sign);

    var api = '${Config.domain}api/deleteAddress';
    var response = await Dio().post(api,data:{
        "uid":userinfo[0]["_id"],
        "id":id,                
        "sign":sign
    });    
    // 删除后重新获取
    this._getAddressList();
  }

  _showDelAlertDialog(id) async{
    var result = await showDialog(
      barrierDismissible: false,
      context:context,
      builder:(context){
        return AlertDialog(
          title:Text('Alert Warning!'),
          content:Text('Make sure delete'),
          actions: [
            TextButton(
              child:Text('Cancel'),
              style:ButtonStyle(
                backgroundColor:MaterialStateProperty.all(Colors.red),
              ),
              onPressed: (){
                print('Cancel');
                Navigator.pop(context,'Cancel');
              },
            ),
            TextButton(
              child:Text('OK'),
              style:ButtonStyle(
                backgroundColor:MaterialStateProperty.all(Colors.red),
              ),
              onPressed: () async{
                // print(keywords);
                // 删除
                this._delAddress(id);
                Navigator.pop(context,'OK');
              },
            ),
          ],
        );
      }
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this._getAddressList();
    eventBus.on<AddressEvent>().listen((event){
      print(event);
      this._getAddressList();
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    eventBus.fire(new CheckoutEvent('修改收货地址成功...'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        title: Text('收货地址'),
      ),
      body:Container(
        child:Stack(
          children: [
            ListView.builder(
              itemCount: this.addressList.length,
              itemBuilder: (context,index){
                return Column(
                  children: [
                    SizedBox(height: 20),
                    ListTile(
                      leading:this.addressList[index]['default_address']==1?Icon(Icons.check,color: Colors.red,):Text(''),
                      title:InkWell(
                        child:Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${this.addressList[index]['name']} ${this.addressList[index]['phone']}'),
                            SizedBox(height: 10),
                            Text('${this.addressList[index]['address']}'),
                          ],
                        ),
                        onTap: (){
                          this._changeDefault(this.addressList[index]['_id']);
                        },
                        onLongPress: (){
                          this._showDelAlertDialog(this.addressList[index]['_id']);
                        },
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.edit,color: Colors.blue),
                        onPressed: (){
                          Navigator.pushNamed(context, '/addressEdit',arguments: {
                            'id':this.addressList[index]['_id'],
                            'name':this.addressList[index]['name'],
                            'phone':this.addressList[index]['phone'],
                            'address':this.addressList[index]['address'],
                          });
                        },
                      ),
                    ),
                    Divider(height:20),
                      ],
                    );
                  },
                ),
            Positioned(
              bottom: 0,
              width: ScreenAdapter.width(750),
              height: ScreenAdapter.height(88),
              child:Container(
                padding:EdgeInsets.all(5),
                width: ScreenAdapter.width(750),
                height: ScreenAdapter.height(88),
                decoration: BoxDecoration(
                  color: Colors.red,
                  border: Border(
                    top: BorderSide(
                      width: 1,
                      color: Colors.black12,
                    ),
                  ),
                ),
                child:InkWell(
                  child:Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add,color: Colors.white,),
                      Text('增加收货地址',style: TextStyle(color:Colors.white)),
                    ],
                  ),
                  onTap:(){
                    Navigator.pushNamed(context, '/addressAdd');
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}