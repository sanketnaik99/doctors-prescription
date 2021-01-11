import 'package:flutter/material.dart';

class Medicine {
  final String category;
  final String id;
  final String image;
  final String name;
  final String weight;
  bool hasAddedReminder = false;

  Medicine({
    @required this.category,
    @required this.id,
    @required this.image,
    @required this.name,
    @required this.weight,
    this.hasAddedReminder,
  });

  factory Medicine.fromJson(Map<String, dynamic> json) {
    return Medicine(
      category: json['category'],
      id: json['id'],
      image: json['image'],
      name: json['name'],
      weight: json['weight'],
      hasAddedReminder: false,
    );
  }
}
