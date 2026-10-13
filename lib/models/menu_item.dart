import 'package:flutter/material.dart';

class MenuItem {
  final String name;
  final int price;
  final String description;
  final String category;
  final double rating;
  final IconData icon;
  final bool isAvailable;
  final bool isPopular;

  const MenuItem({
    required this.name,
    required this.price,
    required this.description,
    required this.category,
    required this.rating,
    required this.icon,
    this.isAvailable = true,
    this.isPopular = false,
  });

  static const List<MenuItem> dummyMenu = [
    MenuItem(
      name: 'Nasi Goreng Spesial',
      price: 15000,
      description:
          'Nasi goreng dengan telur, ayam suwir, sayuran segar, dan kerupuk. Bumbu rahasia Bu Sari yang bikin nagih!',
      category: 'Makanan',
      rating: 4.8,
      icon: Icons.restaurant_rounded,
      isPopular: true,
    ),
    MenuItem(
      name: 'Mie Ayam Bakso',
      price: 13000,
      description:
          'Mie ayam dengan bakso sapi pilihan, taburan bawang goreng, dan kuah kaldu gurih.',
      category: 'Makanan',
      rating: 4.6,
      icon: Icons.ramen_dining_rounded,
      isPopular: true,
    ),
    MenuItem(
      name: 'Soto Ayam',
      price: 12000,
      description:
          'Soto ayam kuning khas Jawa dengan soun, telur rebus, dan sambal rawit.',
      category: 'Makanan',
      rating: 4.5,
      icon: Icons.soup_kitchen_rounded,
    ),
    MenuItem(
      name: 'Ayam Geprek',
      price: 14000,
      description:
          'Ayam crispy digeprek dengan sambal bawang pedas level 1-5. Dilengkapi nasi dan lalapan.',
      category: 'Makanan',
      rating: 4.7,
      icon: Icons.set_meal_rounded,
      isPopular: true,
    ),
    MenuItem(
      name: 'Gado-Gado',
      price: 10000,
      description:
          'Sayuran rebus segar dengan bumbu kacang khas, kerupuk, dan telur rebus.',
      category: 'Makanan',
      rating: 4.3,
      icon: Icons.eco_rounded,
    ),
    MenuItem(
      name: 'Nasi Uduk Komplit',
      price: 13000,
      description:
          'Nasi uduk pulen dengan lauk ayam goreng, tempe orek, sambal, dan kerupuk.',
      category: 'Makanan',
      rating: 4.4,
      icon: Icons.rice_bowl_rounded,
    ),
    MenuItem(
      name: 'Es Teh Manis',
      price: 5000,
      description:
          'Teh manis segar dengan es batu. Pelepas dahaga yang sempurna!',
      category: 'Minuman',
      rating: 4.2,
      icon: Icons.local_cafe_rounded,
    ),
    MenuItem(
      name: 'Es Jeruk Segar',
      price: 7000,
      description: 'Jeruk peras asli dengan gula dan es batu. Kaya vitamin C!',
      category: 'Minuman',
      rating: 4.5,
      icon: Icons.local_drink_rounded,
    ),
    MenuItem(
      name: 'Jus Alpukat',
      price: 10000,
      description:
          'Jus alpukat kental dengan susu coklat dan gula aren. Creamy dan segar!',
      category: 'Minuman',
      rating: 4.7,
      icon: Icons.blender_rounded,
      isPopular: true,
    ),
    MenuItem(
      name: 'Kopi Susu Gula Aren',
      price: 12000,
      description:
          'Kopi robusta pilihan dengan susu segar dan gula aren asli. Energi booster!',
      category: 'Minuman',
      rating: 4.6,
      icon: Icons.coffee_rounded,
    ),
    MenuItem(
      name: 'Pisang Goreng Coklat',
      price: 8000,
      description:
          'Pisang goreng crispy dengan topping coklat leleh dan keju parut.',
      category: 'Snack',
      rating: 4.4,
      icon: Icons.bakery_dining_rounded,
    ),
    MenuItem(
      name: 'Tahu Crispy',
      price: 6000,
      description:
          'Tahu goreng crispy renyah dengan bumbu tabur pedas manis. 10 pcs per porsi.',
      category: 'Snack',
      rating: 4.3,
      icon: Icons.tapas_rounded,
      isAvailable: false,
    ),
  ];
}
