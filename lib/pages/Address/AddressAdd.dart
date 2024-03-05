import 'package:flutter/material.dart';
import 'package:flutter_jdshop/services/ScreenAdapter.dart';
import '../../widget/jdText.dart';
import '../../widget/jdButton.dart';
import 'package:city_pickers/city_pickers.dart';
import '../../services/UserServices.dart';
import '../../services/SignServices.dart';
import '../../config/Config.dart';
import 'package:dio/dio.dart';
import '../../services/EventBus.dart';

class AddressAddPage extends StatefulWidget {
  const AddressAddPage({super.key});

  @override
  State<AddressAddPage> createState() => _AddressAddPageState();
}

class _AddressAddPageState extends State<AddressAddPage> {
  String area = '';
  String name = '';
  String phone = '';
  String address = '';

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    eventBus.fire(new AddressEvent('增加成功...'));
    eventBus.fire(new CheckoutEvent('改变了默认收货地址...'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        title: Text('新增地址'),
      ),
      body:Container(
        padding: EdgeInsets.all(10),
        child:ListView(
          children: [
            SizedBox(height: 20),
            JdText(
              text: '收货人姓名',
              onChanged: (value){
                this.name = value;
              },
            ),
            SizedBox(height: 10),
            JdText(
              text: '收货人电话',
              onChanged: (value){
                this.phone = value;
              },
            ),
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.only(left: 5),
              height: ScreenAdapter.height(68),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    width: 1,
                    color: Colors.black12
                  )
                )
              ),
              child:InkWell(
                child:Row(
                  children: [
                    Icon(Icons.add_location),
                    this.area.length>0?Text('${this.area}',style:TextStyle(color:Colors.black54)):Text('省/市/区',style:TextStyle(color:Colors.black54))
                  ],
                ),
                onTap: () async{
                  Result? result = await CityPickers.showCityPicker(
                    context: context,
                    cancelWidget: Text('取消',style: TextStyle(color: Colors.blue)),
                    confirmWidget: Text('确定',style: TextStyle(color: Colors.blue)),
                  );
                  // print(result);// 返回选择的省市区信息，格式是对象非map
                  setState(() {
                    area = "${result!.provinceName}/${result.cityName}/${result.areaName}";
                  });
                },
              ),
            ),
            SizedBox(height: 10),
            JdText(
              text: '详细地址',
              maxLines:4,
              height: 200,
              onChanged: (value){
                this.address = '${this.area} ${value}';
              },
            ),
            SizedBox(height: 10),
            SizedBox(height: 40),
            JdButton(
              text: '增加',
              color: Colors.red,
              cb: () async{
                var userInfo = await UserServices.getUserInfo();
                var tempJson = {
                  'uid':userInfo[0]['_id'],
                  'name':this.name,
                  'phone':this.phone,
                  'address':this.address,
                  'salt':userInfo[0]['salt']
                };
                var sign = SignServices.getSign(tempJson);
                var api = '${Config.domain}api/addAddress';
                var result = await Dio().post(api,data:{
                  'uid':userInfo[0]['_id'],
                  'name':this.name,
                  'phone':this.phone,
                  'address':this.address,
                  'sign':sign
                });
                // print(result);
                Navigator.pop(context);// 正常情况下不会出错
              },
            ),
          ],
        ),
      ),
    );
  }
}