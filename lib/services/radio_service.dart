// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/station.dart';

class RadioService {
  Future<List<Station>> fetchStationsByLocation(
      double latitude, double longitude) async {
    final uri = Uri.parse(
        'https://de1.api.radio-browser.info/json/stations/search?latitude=$latitude&longitude=$longitude&radius=100&limit=100&order=clickcount&hidebroken=true');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final List<dynamic> stationsJson = json.decode(response.body);
      return stationsJson.map((json) => Station.fromJson(json)).toList();
    } else {
      print('Failed to load stations. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception('Failed to load stations');
    }
  }

  Future<List<Station>> fetchStationsByName(String name) async {
    final uri = Uri.parse(
        'https://de1.api.radio-browser.info/json/stations/byname/$name');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final List<dynamic> stationsJson = json.decode(response.body);
      return stationsJson.map((json) => Station.fromJson(json)).toList();
    } else {
      print('Failed to load stations. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception('Failed to load stations');
    }
  }

  Future<String> fetchDescription(String stationuuid) async {
    final uri = Uri.parse('http://de2.api.radio-browser.info/json/checks/$stationuuid');
    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final List<dynamic> checkJson = json.decode(response.body);
        if (checkJson.isNotEmpty) {
          return checkJson.first['description'] as String? ?? '';
        }
      }
    } catch (e) {
      print('Could not fetch description: $e');
    }
    return ''; // Return empty string on any failure
  }
}
