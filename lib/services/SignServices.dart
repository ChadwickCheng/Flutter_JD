import 'package:crypto/crypto.dart';
import 'dart:convert';

class SignServices{
  static getSign(json){
    // Map addressListAttr = {
    //   'uid':'1',
    //   'age':'10',
    //   'salt':'xxxxxxx'
    // };
    List attrKeys = json.keys.toList();
    attrKeys.sort();
    String str = '';
    for(var i=0;i<attrKeys.length;i++){
      str += '${attrKeys[i]}${json[attrKeys[i]]}';
    }
    // print(str);
    return md5.convert(utf8.encode(str)).toString();
  }
}