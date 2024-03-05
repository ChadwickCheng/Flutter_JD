import './Storage.dart';
import 'dart:convert';

class SearchServices{
  static setHistoryData(keywords) async{
    try{
      List searchListData = json.decode(await Storage.getString('searchList')??'');
      // 查重
      var hasData = searchListData.any((v){
        return v==keywords;
      });
      if(!hasData){
        searchListData.add(keywords);
        await Storage.setString('searchList', json.encode(searchListData));
      }
    }catch(e){
      List tempList = [];
      tempList.add(keywords);
      await Storage.setString('searchList', json.encode(tempList));
    }
  }

  static getHistoryData() async{
    try{
      List searchListData = json.decode(await Storage.getString('searchList')??'');
      return searchListData;
    }catch(e){
      return [];
    }
  }

  static clearHistoryList() async{
    await Storage.remove('searchList');
  }

  static removeHistoryData(keywords) async{
    List searchListData = json.decode(await Storage.getString('searchList')??'');
    searchListData.remove(keywords);
    await Storage.setString('searchList', json.encode(searchListData));
  }
}

// 获取数据 searchlist
// 判断是否有数据
// 有数据 读取数据 判断是否已经存在 没有就拼接写入 有则无操作
// 在您的代码示例中，json.decode函数用于将存储在本地存储中的JSON字符串解码为一个包含搜索关键字的列表。然后，您可以使用List对象的方法来操作这个列表。json.encode函数用于将更新后的列表编码为JSON字符串，并将其存储在本地存储中。