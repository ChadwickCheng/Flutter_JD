import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import '../../widget/LoadingWidget.dart';

class ProductContentSecond extends StatefulWidget {
  final List _productContentList;
  const ProductContentSecond(this._productContentList,{super.key});

  @override
  State<ProductContentSecond> createState() => _ProductContentSecondState();
}

class _ProductContentSecondState extends State<ProductContentSecond> with AutomaticKeepAliveClientMixin {
  bool _flag = true;
  var _id;
  bool get wantKeepAlive => true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this._id = widget._productContentList[0].sId;
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child:Column(
        children:[
          this._flag?LoadingWidget():Text(""),
          Expanded(
            child:InAppWebView(
              initialUrlRequest: URLRequest(url: Uri.parse("https://jdmall.itying.com/pcontent?id=${this._id}")),
              onProgressChanged: (InAppWebViewController controller, int progress) {
                print(progress / 100);
                if(progress/100>0.9999){
                  setState(() {
                    this._flag=false;
                  });
                }
              },
            ),
          )
        ],
      ),
    );
  }
}