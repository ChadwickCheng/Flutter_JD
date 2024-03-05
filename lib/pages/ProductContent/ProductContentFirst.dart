import 'package:flutter/material.dart';
import 'package:flutter_jdshop/services/CartServices.dart';
import 'package:flutter_jdshop/widget/jdButton.dart';

import '../../services/ScreenAdapter.dart';
import '../../widget/LoadingWidget.dart';
import '../../model/ProductContentModel.dart';
import '../../config/Config.dart';

import '../../services/EventBus.dart';
import './CartNum.dart';
import 'package:provider/provider.dart';
import '../../provider/Cart.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ProductContentFirst extends StatefulWidget {
  final List _productContentList;
  const ProductContentFirst(this._productContentList,{super.key});

  @override
  State<ProductContentFirst> createState() => _ProductContentFirstState();
}

class _ProductContentFirstState extends State<ProductContentFirst> with AutomaticKeepAliveClientMixin {

  ProductContentItem _productContent = ProductContentItem();
  List _attr = [];
  bool get wantKeepAlive => true;
  late String _selectedValue;
  var cartProvider;

  // 初始化attr
  _initAttr(){
    var attr = this._attr;
    for(var i=0;i<attr.length;i++){// attr[i].list就是尺寸和颜色的具体属性值
      for(var j=0;j<attr[i].list.length;j++){
        if(j==0){
          attr[i].attrList.add({
          'title':attr[i].list[j],
          'checked':true,
        });
        }else{
          attr[i].attrList.add({
          'title':attr[i].list[j],
          'checked':false,
        });
        }
      }
    }
    print(attr[0].attrList);
    this._getCheckedAttr();
  }

  // 改变属性值
  _changeAttr(cate,title,setBottomState){
    var attr = this._attr;
    for(var i=0;i<attr.length;i++){
      if(attr[i].cate==cate){
        for(var j=0;j<attr[i].attrList.length;j++){
          attr[i].attrList[j]['checked']=false;
          if(attr[i].attrList[j]['title']==title){
            attr[i].attrList[j]['checked']=true;
          }
        }
      }
    }
    setBottomState(() {// 当前页面改变时，弹出的页面是另一个组件无法立即显示 需要重新加载 两种方式 参考word
      this._attr = attr;
    });
    this._getCheckedAttr();
  }

  // 获取选中的值 调用两次
  _getCheckedAttr(){
    var _list = this._attr;
    List tempArr = [];
    for(var i=0;i<_list.length;i++){
      for(var j=0;j<_list[i].attrList.length;j++){
        if(_list[i].attrList[j]['checked']){
          tempArr.add(_list[i].attrList[j]['title']);
        }
      }
    }
    print(tempArr.join(','));
    setState(() {
      this._selectedValue = tempArr.join(',');
      // 给筛选属性赋值
      this._productContent.selectedAttr = this._selectedValue;
    });
  }

  var actionEventBus;

  @override
  void initState() { 
    super.initState();
    this._productContent = widget._productContentList[0];
    this._attr = this._productContent.attr!;
    _initAttr();
    // 监听广播 不传入pce则是监听所有广播
    this.actionEventBus = eventBus.on<ProductContentEvent>().listen((event) {
      print(event.str);
      this._attrBottomSheet();
    });
  }

  @override
  void dispose() {
    super.dispose();
    this.actionEventBus.cancel();// 取消监听
  }

  // 渲染attr组件 需要限定List<Widget> 而不是 List<Dynamic>
  // model格式化数据 list的数据是动态类型 map循环判断是listdynamic而非listwidget 一外一内所以封装两次
  List<Widget> _getAttrItemWidget(attrItem,setBottomState){
    List<Widget> attrItemList = [];
    attrItem.attrList.forEach((item){
      attrItemList.add(Container(
        margin:EdgeInsets.all(10),
        child:InkWell(
          child:Chip(
            padding: EdgeInsets.all(10),
            label:Text('${item['title']}',style:TextStyle(color:item['checked']?Colors.white:Colors.black54)),
            backgroundColor:item['checked']?Colors.red:Colors.black12,
          ),
          onTap: () {
            this._changeAttr(attrItem.cate,item['title'],setBottomState);
          },
        ),
      ));
    });
    return attrItemList;
  }

  List<Widget> _getAttrWidget(setBottomState){

    List<Widget> attrList = [];

    this._attr.forEach((attrItem){
      attrList.add(Wrap(
        children: [
          Container(
            width: ScreenAdapter.width(120),
            child:Container(
              padding: EdgeInsets.only(top:ScreenAdapter.height(20)),
              child:Text(attrItem.cate,style: TextStyle(fontWeight: FontWeight.bold),),
            ),
          ),
          Container(
            width: ScreenAdapter.width(590),
            child:Wrap(
              children: this._getAttrItemWidget(attrItem,setBottomState),
            ),
          )
        ],
      ));
    });
    return attrList;
  }

  //底部弹出框
  _attrBottomSheet(){
      showModalBottomSheet(context: context, builder: (context){
        return StatefulBuilder(
          builder: (BuildContext context, setBottomState) {
            return GestureDetector(// 无水波纹效果 returnfalse点击不会消失
              onTap:(){
                return;
              },
              child: Container(
                height:400,
                child:Stack(
                  children:[
                    Container(
                      padding:EdgeInsets.all(10),
                      child:ListView(
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: this._getAttrWidget(setBottomState),
                          ),
                          Divider(),
                          Container(
                            padding:EdgeInsets.only(top:10),
                            height:ScreenAdapter.height(80),
                            child: Row(
                                children: [
                                  Text('数量',style:TextStyle(fontWeight:FontWeight.bold)),
                                  SizedBox(width:10),
                                  CartNum(this._productContent),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                    Positioned(
                      bottom:0,
                      width:ScreenAdapter.width(750),
                      height:ScreenAdapter.height(76),
                      child: Row(
                        children: [
                          Expanded(
                            flex:1,
                            child:Container(
                              margin:EdgeInsets.fromLTRB(10, 0, 10, 0),
                              child:JdButton(
                                color:Color.fromRGBO(253, 1, 0, 0.9),
                                text:'加入购物车',
                                cb:() async{
                                  print('加入购物车');
                                  await CartServices.addCart(this._productContent);
                                  Navigator.of(context).pop();// 关闭弹出框
                                  this.cartProvider.updateCartList();
                                  Fluttertoast.showToast(
                                    msg: "加入购物车成功",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER,
                                  );
                                },
                              ),
                            ),
                          ),
                          Expanded(
                            flex:1,
                            child:Container(
                              margin:EdgeInsets.fromLTRB(10, 0, 10, 0),
                              child:JdButton(
                                color:Color.fromRGBO(255, 165, 0, 0.9),
                                text:'立即购买',
                                cb:(){
                                  print('立即购买');
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            );
          },
        );
      });
    }
  @override
  Widget build(BuildContext context) {
    this.cartProvider = Provider.of<Cart>(context);
    String pic = Config.domain+this._productContent.pic!;
    pic = pic.replaceAll('\\', '/');
    return Container(
      padding: EdgeInsets.all(10),
      child:ListView(
        children:[
          AspectRatio(
            aspectRatio: 16/12,
            child:Image.network(pic,fit: BoxFit.cover,)
          ),
          Container(
            padding:EdgeInsets.only(top:10),
            child:Text(
              this._productContent.title!,
              style:TextStyle(
                fontSize:ScreenAdapter.size(36),
                color:Colors.black87
              )  
            )
          ),
          Container(
            padding:EdgeInsets.only(top:10),
            child:Text(
              '${this._productContent.subTitle}',
              style:TextStyle(
                fontSize:ScreenAdapter.size(28),
                color:Colors.black45
              )  
            )
          ),
          Container(
            padding:EdgeInsets.only(top:10),
            child:Row(
              children: [
                Expanded(
                  flex:1,
                  child:Row(
                    children: [
                      Text('价格'),
                      Text('￥${this._productContent.price}',style:TextStyle(color:Colors.red,fontSize:ScreenAdapter.size(36))),
                    ],
                  ),
                ),
                Expanded(
                  flex:1,
                  child:Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text('原价'),
                      Text('￥${this._productContent.oldPrice}',style:TextStyle(color:Colors.red,fontSize:ScreenAdapter.size(28),decoration:TextDecoration.lineThrough)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // 筛选
          this._attr.length>0?Container(
            padding:EdgeInsets.only(top:10),
            height:ScreenAdapter.height(80),
            child: InkWell(
              onTap:(){
                _attrBottomSheet();  
              },
              child:Row(
                children: [
                  Text('已选',style:TextStyle(fontWeight:FontWeight.bold)),
                  Text('${this._selectedValue}'),
                ],
              ),
            ),
          ):Text(''),
          Divider(),
          Container(
            height:ScreenAdapter.height(80),
            child: Row(
              children: [
                Text('运费',style:TextStyle(fontWeight:FontWeight.bold)),
                Text('免运费'),
              ],
            ),
          ),
          Divider(),
        ],
      ),
    );
  }
}