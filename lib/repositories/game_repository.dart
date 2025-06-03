import '../models/shop_models.dart';

class GameRepository {
  int _playerCoins = 100; // Start with some coins for testing
  final List<String> _ownedItems = [];

  List<ShopItem> getShopItems() {
    return [
      ShopItem(
        id: 'car_sports',
        name: 'Sports Car',
        description: 'Faster acceleration and top speed',
        price: 500,
        type: ItemType.car,
        iconPath: 'assets/cars/sports_car.png',
        isOwned: _ownedItems.contains('car_sports'),
      ),
      ShopItem(
        id: 'car_armored',
        name: 'Armored Vehicle',
        description: 'Extra health and damage resistance',
        price: 750,
        type: ItemType.car,
        iconPath: 'assets/cars/armored_car.png',
        isOwned: _ownedItems.contains('car_armored'),
      ),
      ShopItem(
        id: 'weapon_machine_gun',
        name: 'Machine Gun',
        description: 'Rapid fire weapon with high damage',
        price: 300,
        type: ItemType.weapon,
        iconPath: 'assets/weapons/machine_gun.png',
        isOwned: _ownedItems.contains('weapon_machine_gun'),
      ),
      ShopItem(
        id: 'weapon_laser',
        name: 'Laser Cannon',
        description: 'Piercing laser that hits multiple enemies',
        price: 600,
        type: ItemType.weapon,
        iconPath: 'assets/weapons/laser.png',
        isOwned: _ownedItems.contains('weapon_laser'),
      ),
      ShopItem(
        id: 'upgrade_health',
        name: 'Health Boost',
        description: 'Increases maximum health by 25%',
        price: 200,
        type: ItemType.upgrade,
        iconPath: 'assets/upgrades/health.png',
        isOwned: _ownedItems.contains('upgrade_health'),
      ),
    ];
  }

  int getPlayerCoins() => _playerCoins;

  void addCoins(int amount) {
    _playerCoins += amount;
  }

  bool purchaseItem(ShopItem item) {
    if (_playerCoins >= item.price && !item.isOwned) {
      _playerCoins -= item.price;
      _ownedItems.add(item.id);
      return true;
    }
    return false;
  }

  bool hasItem(String itemId) => _ownedItems.contains(itemId);

  void saveProgress() {
    // TODO: Implement local storage/Firebase save
  }

  void loadProgress() {
    // TODO: Implement local storage/Firebase load
  }
}
