// File: lib/screens/shop_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/shop_bloc/shop_bloc.dart';
import '../../models/shop_models.dart';

class ShopScreen extends StatelessWidget {
  const ShopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Shop',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.orange, Colors.red],
          ),
        ),
        child: BlocConsumer<ShopBloc, ShopState>(
          listener: (context, state) {
            if (state is ShopPurchaseSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Successfully purchased ${state.purchasedItem.name}!',
                  ),
                  backgroundColor: Colors.green,
                ),
              );
            } else if (state is ShopPurchaseError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.error),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is ShopInitial) {
              context.read<ShopBloc>().add(LoadShopEvent());
              return const Center(
                child: CircularProgressIndicator(color: Colors.white),
              );
            }

            if (state is ShopLoaded) {
              return Column(
                children: [
                  // Coins display
                  Container(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.monetization_on,
                          color: Colors.amber,
                          size: 32,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          '${state.playerCoins}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(
                                offset: Offset(2, 2),
                                blurRadius: 4,
                                color: Colors.black54,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Coins',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Shop items
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: state.items.length,
                      itemBuilder: (context, index) {
                        final item = state.items[index];
                        return _buildShopItem(context, item, state.playerCoins);
                      },
                    ),
                  ),
                ],
              );
            }

            return const Center(
              child: Text(
                'Error loading shop',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildShopItem(BuildContext context, ShopItem item, int playerCoins) {
    final canAfford = playerCoins >= item.price;
    final isOwned = item.isOwned;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha((0.95 * 255).toInt()),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Item icon
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: _getItemTypeColor(item.type),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: _getItemTypeColor(
                    item.type,
                  ).withAlpha((0.3 * 255).toInt()),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              _getItemTypeIcon(item.type),
              color: Colors.white,
              size: 40,
            ),
          ),

          const SizedBox(width: 16),

          // Item details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  item.description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _getItemTypeColor(
                      item.type,
                    ).withAlpha((0.1 * 255).toInt()),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _getItemTypeText(item.type),
                    style: TextStyle(
                      color: _getItemTypeColor(item.type),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 16),

          // Price and buy button
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (!isOwned) ...[
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.monetization_on,
                      color: Colors.amber,
                      size: 18,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${item.price}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: 80,
                  child: ElevatedButton(
                    onPressed:
                        canAfford
                            ? () => context.read<ShopBloc>().add(
                              PurchaseItemEvent(item),
                            )
                            : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: canAfford ? Colors.green : Colors.grey,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Buy',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ] else ...[
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.check, color: Colors.white, size: 16),
                      SizedBox(width: 4),
                      Text(
                        'Owned',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Color _getItemTypeColor(ItemType type) {
    switch (type) {
      case ItemType.car:
        return Colors.blue;
      case ItemType.weapon:
        return Colors.red;
      case ItemType.upgrade:
        return Colors.green;
      case ItemType.cosmetic:
        return Colors.purple;
    }
  }

  IconData _getItemTypeIcon(ItemType type) {
    switch (type) {
      case ItemType.car:
        return Icons.directions_car;
      case ItemType.weapon:
        return Icons.local_fire_department;
      case ItemType.upgrade:
        return Icons.upgrade;
      case ItemType.cosmetic:
        return Icons.palette;
    }
  }

  String _getItemTypeText(ItemType type) {
    switch (type) {
      case ItemType.car:
        return 'VEHICLE';
      case ItemType.weapon:
        return 'WEAPON';
      case ItemType.upgrade:
        return 'UPGRADE';
      case ItemType.cosmetic:
        return 'COSMETIC';
    }
  }
}
