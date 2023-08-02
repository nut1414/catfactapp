import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class CatFactModel extends ChangeNotifier {
  String _fact = '';
  String _imageUrl = '';
  Uint8List _imageBytes = Uint8List(0);
  String _apiResponse = '';
  var dio = Dio();

  String get fact => _fact;
  String get imageUrl => _imageUrl;
  Uint8List get imageBytes => _imageBytes;
  String get apiResponse => _apiResponse;

  Future<String> fetchRandomFact() async {
    try {
      final response = await dio.get('https://catfact.ninja/fact');
      _apiResponse = response.data.toString();
      _fact = response.data['fact'];
    } catch (error) {
      print(error);
      _fact= 'Error fetching fact.';
      _apiResponse = error.toString();
    }
    return _fact;
  }

  Future<String> fetchCatImageUrl() async {
    try {
      final response = await dio.get('https://cataas.com/cat?json=true');
      _imageUrl = "https://cataas.com" + response.data['url'];
    } catch (error) {
      print(error);
      _imageUrl= '';
    }
    return _imageUrl;
  }

  Future<Uint8List> fetchCatImage() async {
    try {
      final response = await dio.get<Uint8List>(_imageUrl, options: Options(responseType: ResponseType.bytes),);
      _imageBytes = response.data!;
      return response.data!;
    } catch (error) {
      print(error);
    }
    return _imageBytes;
  }

  void setFact(String fact) {
    _fact = fact;
    notifyListeners();
  }

  CatFactModel() {
    fetchRandomFact();
  }

}
