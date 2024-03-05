import 'dart:html';

import 'package:flutter/material.dart';
import '../../services/ScreenAdapter.dart';

import '../../model/CateModel.dart';
import 'package:dio/dio.dart';
import '../../config/Config.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> with AutomaticKeepAliveClientMixin {

  int _selectIndex = 0;
  List _leftCateData = [];
  List _rightCateData = [];

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getLeftCateData();
  }

  _getLeftCateData()async{
    var api = '${Config.domain}api/pcate';
    var result = await Dio().get(api);
    var leftCateList = CateModel.fromJson(result.data);
    // print('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!');
    // print(leftCateList.result);
    setState(() {
      this._leftCateData = leftCateList.result??[];
    });
    _getRightCateData(leftCateList.result![0].sId);
  }

  _getRightCateData(pid)async{
    var api = '${Config.domain}api/pcate?pid=${pid}';
    var result = await Dio().get(api);
    var rightCateList = CateModel.fromJson(result.data);
    setState(() {
      this._rightCateData = rightCateList.result??[];
    });
  }

  Widget _leftCateWidget(leftWidth){
    if(this._leftCateData.length>0){
      return Container(
          width:leftWidth,
          height:double.infinity,
          child:ListView.builder(
            itemCount: this._leftCateData.length,
            itemBuilder: (context,index){
              return Column(
                children: [
                  InkWell(
                    onTap: (){
                      setState(() {
                        _selectIndex = index;
                        this._getRightCateData(this._leftCateData[index].sId);
                      });
                    },
                    child:Container(
                      width:double.infinity,
                      height:ScreenAdapter.height(84),
                      padding:EdgeInsets.only(top:ScreenAdapter.height(24)),
                      child:Text(
                        '${this._leftCateData[index].title}',
                        textAlign:TextAlign.center,
                      ),
                      color:_selectIndex == index ? Color.fromRGBO(240, 246, 246, 0.9) : Colors.white,
                    ),
                  ),
                  Divider(height:1)
                ],
              );
            },
          ),
        );
    }else{
      return Container(
        width:leftWidth,
        height:double.infinity,
      );// 返回空容器防止错位
    }
  }

  Widget _rightCateWidget(rightItemWidth,rightItemHeight){
    if(this._rightCateData.length>0){
      return Expanded(
          flex:1,
          child:Container(
            padding:EdgeInsets.all(10),// 写10方便计算
            height:double.infinity,
            color:Color.fromRGBO(240, 246, 246, 0.9),
            child:GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: rightItemWidth/rightItemHeight,
              ),
              itemCount: this._rightCateData.length,
              itemBuilder: (context, index){
                // 处理图片
                String pic = this._rightCateData[index].pic;
                pic = Config.domain+pic.replaceAll('\\','/');
                return InkWell(
                  onTap: (){
                    Navigator.pushNamed(
                      context, 
                      '/ProductList',
                      arguments: {'cid':this._rightCateData[index].sId},
                    );
                  },
                  child:Container(
                    child:Column(
                      children:[
                        AspectRatio(// 配置图片宽高比
                          aspectRatio: 1/1,
                          child:Image.network(
                            pic,
                            fit:BoxFit.cover,
                          ),
                        ),
                        Container(
                          height:ScreenAdapter.height(28),
                          child:Text('${this._rightCateData[index].title}'),
                        )
                      ]
                    ),
                  )
                );
              },              
            ),
          ),
        );
    }else{
      return Expanded(
        flex:1,
        child:Container(
          padding:EdgeInsets.all(10),// 写10方便计算
          height:double.infinity,
          color:Color.fromRGBO(240, 246, 246, 0.9),
          child:Text('加载中')
        )
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // ScreenAdapter.init(context);
    // 计算右侧gridview宽高比
    var leftWidth = ScreenAdapter.getScreenWidth()/4;
    // 右侧宽度等于总宽度-左侧宽度-gridview外层元素左右padding-gridview中间间距
    var rightItemWidth = (ScreenAdapter.getScreenWidth()-leftWidth-20-20)/3;
    rightItemWidth = ScreenAdapter.width(rightItemWidth);
    var rightItemHeight = rightItemWidth + ScreenAdapter.height(28);// 文本宽度

    return Scaffold(
      appBar: AppBar(
          leading:IconButton(
            icon:Icon(Icons.center_focus_weak,size:28,color:Colors.black87),
            onPressed: null,
          ),
          title:InkWell(
            onTap:(){
              Navigator.pushNamed(context, '/search');
            },
            child:Container(
              height:ScreenAdapter.height(68),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Color.fromRGBO(233, 233, 233, 0.8),
              ),
              padding:EdgeInsets.only(left:10),
              child:Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children:[
                  Icon(Icons.search,size:28,color:Colors.black87),
                  Text(
                    '笔记本',
                    style:TextStyle(
                      fontSize:ScreenAdapter.size(28)
                    )
                  ),
                ],
              ),
            ),
          ),
          actions: [
            IconButton(
              icon:Icon(Icons.message,size:28,color:Colors.black87),
              onPressed: null,
            )
          ],
        ),
      body:Row(
        children: [
          _leftCateWidget(leftWidth),
          _rightCateWidget(rightItemWidth, rightItemHeight),
        ],
      )
    );
  }
}

