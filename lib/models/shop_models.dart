
// File: lib/models/shop_models.dart
import 'package:equatable/equatable.dart';

enum ItemType { car, weapon, upgrade, cosmetic }

class ShopItem extends Equatable {
  final String id;
  final String name;
  final String description;
  final int price;
  final ItemType type;
  final String iconPath;
  final bool isOwned;

  const ShopItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.type,
    required this.iconPath,
    required this.isOwned,
  });

  ShopItem copyWith({
    String? id,
    String? name,
    String? description,
    int? price,
    ItemType? type,
    String? iconPath,
    bool? isOwned,
  }) {
    return ShopItem(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      type: type ?? this.type,
      iconPath: iconPath ?? this.iconPath,
      isOwned: isOwned ?? this.isOwned,
    );
  }

  @override
  List<Object?> get props => [id, name, description, price, type, iconPath, isOwned];
}