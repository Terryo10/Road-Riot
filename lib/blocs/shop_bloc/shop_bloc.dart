
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../repositories/game_repository.dart';
import '../../models/shop_models.dart';

part 'shop_event.dart';
part 'shop_state.dart';

class ShopBloc extends Bloc<ShopEvent, ShopState> {
  final GameRepository gameRepository;
  
  ShopBloc({required this.gameRepository}) : super( ShopInitial()) {
    on<LoadShopEvent>(_onLoadShop);
    on<PurchaseItemEvent>(_onPurchaseItem);
  }

  void _onLoadShop(LoadShopEvent event, Emitter<ShopState> emit) {
    final items = gameRepository.getShopItems();
    final playerCoins = gameRepository.getPlayerCoins();
    emit(ShopLoaded(items: items, playerCoins: playerCoins));
  }

  void _onPurchaseItem(PurchaseItemEvent event, Emitter<ShopState> emit) {
    try {
      final success = gameRepository.purchaseItem(event.item);
      if (success) {
        emit(ShopPurchaseSuccess(event.item));
        // Reload shop
        add(LoadShopEvent());
      } else {
        emit(const ShopPurchaseError('Insufficient coins'));
      }
    } catch (e) {
      emit(ShopPurchaseError(e.toString()));
    }
  }
}