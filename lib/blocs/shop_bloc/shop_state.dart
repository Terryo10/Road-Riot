part of 'shop_bloc.dart';

sealed class ShopEvent extends Equatable {
  const ShopEvent();

  @override
  List<Object> get props => [];
}

class LoadShopEvent extends ShopEvent {}

class PurchaseItemEvent extends ShopEvent {
  final ShopItem item;
  const PurchaseItemEvent(this.item);
  @override
  List<Object> get props => [item];
}
