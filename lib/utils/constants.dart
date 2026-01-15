import 'package:flutter/material.dart';
import '../models/category.dart';

class AppConstants {
  // Predefined categories
  static final List<Category> categories = [
    Category(
      name: 'Food',
      icon: Icons.restaurant,
      color: Colors.orange,
    ),
    Category(
      name: 'Transport',
      icon: Icons.directions_car,
      color: Colors.blue,
    ),
    Category(
      name: 'Shopping',
      icon: Icons.shopping_bag,
      color: Colors.pink,
    ),
    Category(
      name: 'Entertainment',
      icon: Icons.movie,
      color: Colors.purple,
    ),
    Category(
      name: 'Bills',
      icon: Icons.receipt,
      color: Colors.red,
    ),
    Category(
      name: 'Health',
      icon: Icons.local_hospital,
      color: Colors.green,
    ),
    Category(
      name: 'Education',
      icon: Icons.school,
      color: Colors.indigo,
    ),
    Category(
      name: 'Others',
      icon: Icons.more_horiz,
      color: Colors.grey,
    ),
  ];

  // Get category by name
  static Category getCategoryByName(String name) {
    return categories.firstWhere(
          (category) => category.name == name,
      orElse: () => categories.last, // Return 'Others' as default
    );
  }
}