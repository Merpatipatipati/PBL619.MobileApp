import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import '../models/sensor_data_model.dart';
import 'package:application_hydrogami/services/globals.dart';

class SensorDataService {

  Future<bool> sendSensorData(SensorData data) async {
    try {
      final jsonData = data.toJson();
      debugPrint('Sending data: $jsonData'); // Debug 1

      final response = await http.post(
        Uri.parse('${baseURL}sensor-data'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(jsonData),
      );

      debugPrint('Response status: ${response.statusCode}'); // Debug 2
      debugPrint('Response body: ${response.body}'); // Debug 3

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        debugPrint('Failed to send data: ${response.body}');
        return false;
      }
    } catch (e) {
      debugPrint('Error sending data: $e');
      return false;
    }
  }

  Future<List<SensorData>> getSensorData() async {
    try {
      final response = await http.get(Uri.parse('${baseURL}sensor-data'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body)['data'];
        return data.map((json) => SensorData.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      debugPrint('Error getting data: $e');
      rethrow;
    }
  }
}
