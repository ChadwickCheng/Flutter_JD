import 'package:flutter/material.dart';
import '../services/ScreenAdapter.dart';
import 'package:dio/dio.dart';
import '../config/Config.dart';
import '../model/ProductModel.dart';
import '../services/SearchServices.dart';
import '../widget/LoadingWidget.dart';

class ProductListPage extends StatefulWidget {
  Map? arguments;
  // const ProductListPage({super.key});
  ProductListPage({Key? key,this.arguments}) : super(key: key);

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {

  // int _selectIndex = 0;
  // bool isVisible = false;// 综合下拉菜单是否显示
  int _page = 1;
  List _productList = [];
  String _sort = '';
  int _pageSize = 8;// 每页显示条数
  bool flag = true;// 防止重复请求
  bool _hasMore = true;// 是否还有数据
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  ScrollController _scrollController = ScrollController();
  int _selectHeaderId = 1;
  bool _hasData = true;

// 点击导航出发事件
  _subHeaderChange(id){
    if(id==4){
      _scaffoldKey.currentState!.openEndDrawer();
      setState(() {
        this._selectHeaderId = id;
      });
    }else{
      setState(() {
        this._selectHeaderId = id;
        this._sort = '${this._subHeaderList[id-1]['fileds']}_${this._subHeaderList[id-1]['sort']}';
        // print('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!');
        // print(this._sort);
        // 重置分页 数据 回到顶部
        this._page = 1;
        this._productList = [];
        this._scrollController.jumpTo(0);
        this._hasMore = true;
        this._subHeaderList[id-1]['sort'] = this._subHeaderList[id-1]['sort'] * -1;
        // 重新请求
        this._getProductListData();
      });
    }
  }

  // icon
  Widget _showIcon(id){
    if(id==2||id==3){
      if(this._subHeaderList[id-1]['sort']==1){
        return Icon(Icons.arrow_drop_down);
      }
      return Icon(Icons.arrow_drop_up);
    }
    return Text('');
  }

  // 二级导航数据
  List _subHeaderList = [
    {
      'id':1,
      'title':'综合',
      'fileds':'all',
      'sort':-1,
    },
    {
      'id':2,
      'title':'销量',
      'fileds':'salecount',
      'sort':-1,
    },
    {
      'id':3,
      'title':'价格',
      'fileds':'price',
      'sort':-1,
    },
    {
      'id':4,
      'title':'筛选',
    },
  ];

  // 配置search搜索框值
  var _initKeywordsController = new TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // 配置search搜索框值
    this._initKeywordsController.text = widget.arguments?['keywords'] == null ? '' : widget.arguments?['keywords'];
    this._getProductListData();
    this._scrollController.addListener(() {
      if(this._scrollController.position.pixels > this._scrollController.position.maxScrollExtent - 20){// 滚动条滚动高度 + 20 > 页面高度
        if(this.flag && this._hasMore){
          this._getProductListData();
        }
      }
    });
  }

  Widget _showMore(index){
    if(this._hasMore){
      return (index == this._productList.length - 1) ? LoadingWidget() : Text('');// 最后一条数据显示加载中
    }else{
      return (index == this._productList.length - 1) ? Text('Come on! Why do not try buy something?') : Text('');
    }
  }

  _getProductListData() async{
    setState(() {
      this.flag = false;
    });
    
    var api;
    if(widget.arguments?['keywords']==null){
      api = '${Config.domain}api/plist?cid=${widget.arguments?['cid']}&page=${this._page}&sort=${this._sort}&pageSize=${this._pageSize}';
    }else{
      // api = '${Config.domain}api/plist?search=${widget.arguments?['keywords']}&page=${this._page}&sort=${this._sort}&pageSize=${this._pageSize}';
      api = '${Config.domain}api/plist?search=${this._initKeywordsController.text}&page=${this._page}&sort=${this._sort}&pageSize=${this._pageSize}';
    }

    var result = await Dio().get(api);
    var productList = ProductModel.fromJson(result.data);

    if(productList.result!.length==0 && this._page==1){
      setState(() {
        this._hasData = false;
      });
    }else{
      setState(() {
        this._hasData = true;
      });
    }

    if(productList.result!.length < this._pageSize){
      setState(() {
        this._productList.addAll(productList.result!);
        this._hasMore = false;
        this.flag = true;
      });
    }else{
      setState(() {
      this._productList.addAll(productList.result!);
      this._page++;
      this.flag = true;
    });
    }

  }

  Widget _productListWidget(){
    if(this._productList.length>0){
      return Container(
        padding:EdgeInsets.all(10),
        margin: EdgeInsets.only(top:ScreenAdapter.height(80)),
        child:ListView.builder(
          controller: _scrollController,
          itemCount: this._productList.length,
          itemBuilder: (context,index){
            String pic = this._productList[index].pic!;
            pic = Config.domain + pic.replaceAll('\\', '/');
            return Column(
              children:[
                Row(
                  children:[
                    Container(
                      width: ScreenAdapter.width(180),
                      height:ScreenAdapter.height(180),
                      child:Image.network('${pic}',fit:BoxFit.cover),
                    ),
                    Expanded(
                      flex:1,
                      child:Container(// 直接写列无法控制距离
                        // color:Colors.red,
                        height:ScreenAdapter.height(180),
                        margin:EdgeInsets.only(left:10),
                        child:Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,// 父container必须有高度
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children:[
                            Text(
                              '${this._productList[index].title}',
                              maxLines:2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Row(
                              children: [
                                Container(
                                  height:ScreenAdapter.height(36),
                                  margin:EdgeInsets.only(right:10),
                                  padding:EdgeInsets.fromLTRB(10, 0, 10, 0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color:Color.fromRGBO(230, 230, 230, 0.9),
                                  ),
                                  child:Text('4g'),
                                ),
                                Container(
                                  height:ScreenAdapter.height(36),
                                  margin:EdgeInsets.only(right:10),
                                  padding:EdgeInsets.fromLTRB(10, 0, 10, 0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color:Color.fromRGBO(230, 230, 230, 0.9),
                                  ),
                                  child:Text('4g'),
                                ),
                              ],
                            ),
                            Text(
                              '${this._productList[index].price}',
                              style:TextStyle(
                                color:Colors.red,
                                fontSize:10,
                              )
                            ),
                          ],
                        ),
                      ),
                    ),
                  ]
                ),
                Divider(height:20),
                this._showMore(index),
              ]
            );
          },
        ),
      );
    }else{
      return LoadingWidget();
    }
  }

  Widget _subHandlerWidget(){
    return Positioned(
            top:0,
            height:ScreenAdapter.height(80),
            width:ScreenAdapter.width(750),
            child:Container(
              width:ScreenAdapter.width(750),
              height:ScreenAdapter.height(80),
              // color:Colors.red,
              decoration: BoxDecoration(
                border:Border(
                  bottom:BorderSide(
                    width:1,
                    color:Colors.black12,
                  ),
                ),
              ),
              child:Row(
                children:this._subHeaderList.map((value){
                  return Expanded(
                          flex:1,
                          child:InkWell(
                            // onTap: (){
                              // int index = 1;
                              // setState(() {
                              //   // this._selectIndex = index;
                              //   if(this.isVisible){
                              //     this.isVisible = false;
                              //   }else{
                              //     this.isVisible = true;
                              //   }
                              // });
                            //   if(value['id'] == 4){
                            //     _scaffoldKey.currentState!.openEndDrawer();
                            //   }
                            // },
                            child:Padding(
                              padding:EdgeInsets.fromLTRB(0, ScreenAdapter.height(16), 0, ScreenAdapter.height(16)),
                              child:Row(
                                mainAxisAlignment:MainAxisAlignment.center,
                                children:[
                                  Text(
                                    "${value['title']}",
                                    textAlign:TextAlign.center,
                                    style:TextStyle(
                                      color:(this._selectHeaderId == value['id']) ? Colors.red : Colors.black54,
                                    ),
                                  ),
                                  this._showIcon(value['id']),
                                ]
                              ),
                            ),
                            onTap: (){
                              _subHeaderChange(value['id']);
                            },
                          )
                        );
                }).toList(),
              ),
            ),
          );
  }

  // Widget _zongHeDown(){
  //   return Visibility(
  //     visible: this.isVisible,
  //     child:Container(
  //       padding:EdgeInsets.all(10),
  //       margin: EdgeInsets.only(top:ScreenAdapter.height(80)),
  //       width:ScreenAdapter.width(750),
  //       height:ScreenAdapter.height(80),
  //       color:Colors.red,
  //       child:Text('这是综合的下拉菜单'),
  //     )
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key:_scaffoldKey,
      appBar: AppBar(
        title:Container(
          height:ScreenAdapter.height(68),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: Color.fromRGBO(233, 233, 233, 0.8),
          ),
          child:TextField(
            controller: this._initKeywordsController,
            autofocus: false,// 默认选中会键盘弹起
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            onChanged: (value){
              setState(() {
                this._initKeywordsController.text = value;
              });
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
              SearchServices.setHistoryData(this._initKeywordsController.text);// 存储数据
              this._subHeaderChange(1);// 点击搜索按钮时，重置排序规则
            },
          ),
        ],
      ),
      endDrawer: Drawer(
        child:Container(
          child:Text('筛选功能'),
        ),
      ),
      // body:Text('${widget.arguments}'),
      body:_hasData?Stack(
        children:[
          this._productListWidget(),
          this._subHandlerWidget(),
          // this._zongHeDown(),
        ],
      ):Center(
        child:Text('没有您要浏览的数据'),
      ),
    );
  }
}