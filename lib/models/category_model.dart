
import 'package:flutter/material.dart';

class Category {
  final String id;
  final String name;
  final int colorValue;

  Category({required this.id, required this.name, required this.colorValue});

  Color get color => Color(colorValue);

  factory Category.fromMap(Map<String, dynamic> data, String documentId) {
    return Category(
      id: documentId,
      name: data['name'],
      colorValue: data['colorValue'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'colorValue': colorValue,
    };
  }
}
