import 'dart:convert';
import './Storage.dart';

class UserServices{
  static getUserInfo() async{
    List userInfo;
    try{
      List userInfoData = json.decode(await Storage.getString('userInfo')??'[]');
      userInfo = userInfoData;
    }catch(e){
      userInfo = [];
    }
    return userInfo;
  }

  static getUserLoginState() async{
    var userInfo = await UserServices.getUserInfo();
    if(userInfo.length>0 && userInfo[0]['username']!=''){
      return true;
    }else{
      return false;
    }
  }
  
  static loginOut(){
    Storage.remove('userInfo');
  }
}