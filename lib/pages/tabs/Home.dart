import 'package:flutter/material.dart';
import 'package:card_swiper/card_swiper.dart';
import '../../services/ScreenAdapter.dart';
import '../../model/FocusModel.dart';
import '../../model/ProductModel.dart';
// import 'dart:convert';
import 'package:dio/dio.dart';
import '../../config/Config.dart';
import '../../services/SignServices.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin {

  List _focusData=[];
  List _hotProductData=[];
  List _bestProductData = [];

  @override
  bool get wantKeepAlive => true;

  @override
  void initState(){
    super.initState();
    this._getFocusData();
    this._getHotProductData();
    this._getBestProductData();
    // SignServices.getSign();
  }
  // 获取轮播图数据
  _getFocusData() async{
    var api = '${Config.domain}api/focus';
    var result = await Dio().get(api);// map类型
    // print('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!');
    // print(result);
    // print('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!');
    // print(result.data);
    // print('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!');
    // print(result.data is Map);
    var focusList = FocusModel.fromJson(result.data);
    // print('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!');
    // print(focusList);
    // print('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!');
    // print(focusList.result);
    // print('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!');
    // print(focusList.result?.length);
    setState(() {
      this._focusData = focusList.result??[];
    });
  }

  // 获取猜你喜欢数据
  _getHotProductData()async{
    var api = '${Config.domain}api/plist?is_hot=1';
    var result = await Dio().get(api);
    var hotProductList = ProductModel.fromJson(result.data);
    setState(() {
      this._hotProductData = hotProductList.result??[];
    });
  }

  // 获取热门推荐
  _getBestProductData()async{
    var api = '${Config.domain}api/plist?is_best=1';
    var result = await Dio().get(api);
    var bestProductList = ProductModel.fromJson(result.data);
    setState(() {
      this._bestProductData = bestProductList.result??[];
    });
  }

  Widget _swiperWidget(){
    if(this._focusData.length>0){
      return Container(
      child:AspectRatio(
        aspectRatio: 2/1,
        child:Swiper(
            itemBuilder: (BuildContext context,int index){
              String pic = this._focusData[index].pic;
              pic = Config.domain + pic.replaceAll('\\', '/');
              return Image.network(
                pic,
                fit:BoxFit.fill,
              );
            },
            itemCount: this._focusData.length,
            pagination: SwiperPagination(),
            autoplay: true,
          ),
      ),
    );
    }else{
      return Text('加载中...');
    }
  }

  Widget _titleWidget(value){
    return Container(
      height:ScreenAdapter.height(34),
      margin:EdgeInsets.only(left:ScreenAdapter.width(20)),
      padding:EdgeInsets.only(left:ScreenAdapter.width(20)),
      decoration: BoxDecoration(
        border:Border(
          left: BorderSide(
            color: Colors.red,
            width: ScreenAdapter.width(10),
          )
        )
      ),
      child:Text(
        value,
        style:TextStyle(
          color:Colors.black54,
          fontSize: ScreenAdapter.size(24),
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _hotProductListWidget(){
    if(this._hotProductData.length>0){
      return Container(
          height:ScreenAdapter.height(240),
          padding:EdgeInsets.all(ScreenAdapter.width(20)),
          // width:double.infinity,
          child:ListView.builder(
            scrollDirection: Axis.horizontal,
            itemBuilder: (context,index){
              String sPic = this._hotProductData[index].sPic;
              sPic = Config.domain+sPic.replaceAll('\\','/');
              return Column(
                children:[
                  Container(
                    height:ScreenAdapter.height(140),
                    width:ScreenAdapter.width(140),
                    margin:EdgeInsets.only(right:ScreenAdapter.width(21)),
                    child:Image.network(sPic,fit:BoxFit.cover)
                  ),
                  Container(
                    padding:EdgeInsets.only(top:ScreenAdapter.height(10)),
                    height:ScreenAdapter.height(44),
                    child:Text('￥${this._hotProductData[index].price}',style:TextStyle(color:Colors.red)),
                  ),
                ],
              );
            },
            itemCount: this._hotProductData.length,
          ),
        );
    }else{
      return Text('加载中...');
    }
  }
  
  Widget _recProductListWidget(){
    var itemWidth = (ScreenAdapter.getScreenWidth() - 30)/2;
    return Container(
          padding:EdgeInsets.all(10),
          child:Wrap(
            runSpacing: 10,// 纵轴（垂直）方向间距
            spacing: 10,// 间距
            children:this._bestProductData.map((value){
              String sPic = value.sPic;
              sPic = Config.domain+sPic.replaceAll('\\','/');
              return InkWell(
                onTap: (){
                  Navigator.pushNamed(context, '/ProductContent',arguments: {"id": value.sId});
                },
                child:Container(
                  padding:EdgeInsets.all(10),
                  width:itemWidth,
                  decoration: BoxDecoration(
                    border:Border.all(
                      color:Colors.black12,
                      width:1,
                    )
                  ),
                  child:Column(
                    children:[
                      Container(
                        width:double.infinity,
                        // height: 20,
                        child:AspectRatio(
                          child:Image.network('${sPic}',fit:BoxFit.cover),
                          aspectRatio: 1/1,// 防止服务器图片大小不一致导致高度不一致问题
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top:ScreenAdapter.height(20)),
                        child:Text(
                          '${value.title}',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color:Colors.black54,
                            fontSize: ScreenAdapter.size(24),
                          ),
                        ),
                      ),
                      Padding(
                        padding:EdgeInsets.only(top:ScreenAdapter.height(20)),
                        child:Stack(
                          children:[
                            Align(
                              alignment:Alignment.centerLeft,
                              child:Text(
                                '￥${value.price}',
                                style:TextStyle(
                                  color:Colors.red,
                                  fontSize:ScreenAdapter.size(16),
                                ),
                              ),
                            ),
                            Align(
                              alignment:Alignment.centerRight,
                              child:Text(
                                '￥${value.oldPrice}',
                                style:TextStyle(
                                  color:Colors.black,
                                  fontSize:ScreenAdapter.size(14),
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ]
                  ),
                ),
              );
            }).toList(),
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
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
      body:ListView(
        children:[
          _swiperWidget(),
          SizedBox(height:ScreenAdapter.height(20)),
          _titleWidget('猜你喜欢'),
          SizedBox(height:ScreenAdapter.height(20)),
          _hotProductListWidget(),
          _titleWidget('热门推荐'),
          _recProductListWidget(),
        ],
      )
    );
  }
  
  
}