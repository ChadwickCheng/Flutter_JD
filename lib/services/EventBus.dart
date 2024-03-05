import 'package:event_bus/event_bus.dart';

EventBus eventBus = EventBus();

// 商品详情
class ProductContentEvent {
  late String str;
  ProductContentEvent(String str) {
    this.str = str;
  }
}

// 用户中心广播
class UserEvent {
  late String str;
  UserEvent(String str) {
    this.str = str;
  }
}

// 地址广播
class AddressEvent {
  late String str;
  AddressEvent(String str) {
    this.str = str;
  }
}

// 结算广播
class CheckoutEvent {
  late String str;
  CheckoutEvent(String str) {
    this.str = str;
  }
}