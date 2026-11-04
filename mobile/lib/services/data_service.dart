import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import '../models/attraction.dart';

/// Ilova serversiz ishlaydi: joylar ro'yxati APK ichidagi assets/attractions.json dan o'qiladi.
class DataService {
  static List<Attraction>? _cache;

  Future<List<Attraction>> attractions() async {
    return _cache ??= (jsonDecode(await rootBundle.loadString('assets/attractions.json')) as List)
        .map((e) => Attraction.fromJson(e))
        .toList();
  }

  Future<Position?> currentPosition() async {
    try {
      if (!await Geolocator.isLocationServiceEnabled()) return null;
      var p = await Geolocator.checkPermission();
      if (p == LocationPermission.denied) p = await Geolocator.requestPermission();
      if (p == LocationPermission.denied || p == LocationPermission.deniedForever) return null;
      return await Geolocator.getCurrentPosition().timeout(const Duration(seconds: 10));
    } catch (_) {
      return null;
    }
  }
}
