import 'dart:html';

import 'package:flutter/material.dart';
import '../../services/ScreenAdapter.dart';

import '../services/SearchServices.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {

  var _keywords;
  List _historyListData = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this._getHistoryListData();
  }

  _getHistoryListData() async{
    var _historyListData = await SearchServices.getHistoryData();
    setState(() {
      this._historyListData = _historyListData;
    });
  }

  _showAlertDialog(keywords) async{
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
                await SearchServices.removeHistoryData(keywords);
                this._getHistoryListData();
                Navigator.pop(context,'OK');
              },
            ),
          ],
        );
      }
    );
  }

  Widget _historyListWidget(){
    if(_historyListData.length>0){
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children:[
          Container(
                child:Text(
                  '历史记录',
                  style:TextStyle(
                    fontSize:ScreenAdapter.size(36),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Divider(),
              Column(
                children: this._historyListData.map((value){
                  return Column(
                    children:[
                      ListTile(
                        title:Text('$value'),
                        onLongPress: (){
                          this._showAlertDialog('$value');
                        },
                      ),
                      Divider(),
                    ],
                  );
                }).toList(),
              ),
              SizedBox(height:ScreenAdapter.height(10),),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    child:Container(
                      width:ScreenAdapter.width(200),
                      height:ScreenAdapter.height(64),
                      decoration: BoxDecoration(
                        border:Border.all(
                          width:1,
                          color:Color.fromRGBO(233, 233, 233, 1),
                        ),
                      ),
                      child:Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.delete),
                          Text('清空历史记录'),
                        ],
                      ),
                    ),
                    onTap: (){
                      SearchServices.clearHistoryList();// 此时要进行重新获取数据
                      this._getHistoryListData();// 因为要加载页面
                    },
                  ),
                ],
              ),
          ],
        );
    }else{
      return Text('');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Container(
          height:ScreenAdapter.height(68),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: Color.fromRGBO(233, 233, 233, 0.8),
          ),
          child:TextField(
            autofocus: false,// 默认选中会键盘弹起
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            onChanged: (value){
              this._keywords = value;
            },
          ),
        ),
        actions: [
          InkWell(
            child:Container(
              height:ScreenAdapter.height(68),
              width: ScreenAdapter.width(80),
              child:Row(
                children:[
                  Text('搜索'),
                ],
              ),
            ),
            onTap: (){
              SearchServices.setHistoryData(this._keywords);// 存储数据
              Navigator.pushReplacementNamed(context, '/ProductList',arguments:{
                'keywords':this._keywords,
              });
            },
          ),
        ],
      ),
      body:Container(
        padding: EdgeInsets.all(ScreenAdapter.width(10)),
        child:ListView(
          children:[
            Container(
              child:Text(
                '热搜',
                style:TextStyle(
                  fontSize:ScreenAdapter.size(36),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Divider(),
            Wrap(
              children:[
                Container(
                  padding:EdgeInsets.all(ScreenAdapter.width(10)),
                  margin:EdgeInsets.all(ScreenAdapter.width(10)),
                  decoration: BoxDecoration(
                    color:Color.fromRGBO(233, 233, 233, 0.9),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child:Text('女装'),
                ),
              ],
            ),
            SizedBox(height:ScreenAdapter.height(10),),
            this._historyListWidget(),
          ],
        ),
      ),
    );
  }
}