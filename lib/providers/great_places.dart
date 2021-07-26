import 'package:flutter/material.dart';
import 'dart:io';
import '../models/place.dart';

class GreatPlaces with ChangeNotifier {
  List<Place> _items = [];

  List<Place> get items {
    return [..._items];
  }

  void addPlace(String title, File image) {
    String pickedTitle = title;
    File pickedFile = image;

    final newPlace = Place(
      id: DateTime.now().toString(),
      image: pickedFile,
      title: pickedTitle,
      location: null,
    );

    _items.add(newPlace);
    notifyListeners();
  }
}
