
part of 'shop_bloc.dart';

sealed class ShopState extends Equatable {
  const ShopState();
  
  @override
  List<Object> get props => [];
}

final class ShopInitial extends ShopState {}

final class ShopLoaded extends ShopState {
  final List<ShopItem> items;
  final int playerCoins;
  
  const ShopLoaded({required this.items, required this.playerCoins});
  
  @override
  List<Object> get props => [items, playerCoins];
}

final class ShopPurchaseSuccess extends ShopState {
  final ShopItem purchasedItem;
  const ShopPurchaseSuccess(this.purchasedItem);
  @override
  List<Object> get props => [purchasedItem];
}

final class ShopPurchaseError extends ShopState {
  final String error;
  const ShopPurchaseError(this.error);
  @override
  List<Object> get props => [error];
}