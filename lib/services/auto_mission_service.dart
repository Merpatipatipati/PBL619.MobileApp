import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:application_hydrogami/services/globals.dart';

class AutoMissionService {
  // ✅ Menggunakan baseURL dari globals.dart
  static const String userBaseUrl = '${baseURL}user';

  /// Create Auto-Generated Mission
  static Future<bool> createAutoMission(
      Map<String, dynamic> missionData) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';

      if (token.isEmpty) {
        print('❌ [AUTO MISSION] Token not found');
        return false;
      }

      print('📤 [AUTO MISSION] Creating auto mission...');
      print('📤 [AUTO MISSION] Data: $missionData');

      final response = await http
          .post(
        Uri.parse('$userBaseUrl/misi/auto'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(missionData),
      )
          .timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw Exception('Request timeout');
        },
      );

      print('📥 [AUTO MISSION] Response status: ${response.statusCode}');
      print('📥 [AUTO MISSION] Response body: ${response.body}');

      if (response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        print('✅ [AUTO MISSION] Mission created: ${responseData['data']}');
        return true;
      } else if (response.statusCode == 409) {
        // Duplicate mission (sudah ada misi serupa)
        final responseData = jsonDecode(response.body);
        print('⚠️ [AUTO MISSION] Duplicate: ${responseData['message']}');
        return false;
      } else {
        print('❌ [AUTO MISSION] Failed: ${response.body}');
        return false;
      }
    } catch (e) {
      print('❌ [AUTO MISSION] Error: $e');
      return false;
    }
  }

  /// Get Active Mission by Parameter
  static Future<Map<String, dynamic>?> getActiveMission(
      String parameter) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';

      if (token.isEmpty) {
        print('❌ [GET ACTIVE] Token not found');
        return null;
      }

      print('📤 [GET ACTIVE] Fetching active mission for: $parameter');

      final response = await http.get(
        Uri.parse('$userBaseUrl/misi/active?parameter=$parameter'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw Exception('Request timeout');
        },
      );

      print('📥 [GET ACTIVE] Response status: ${response.statusCode}');
      print('📥 [GET ACTIVE] Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['success'] == true && data['data'] != null) {
          print('✅ [GET ACTIVE] Found mission: ${data['data']}');
          return data['data'];
        } else {
          print('⚠️ [GET ACTIVE] No active mission for $parameter');
          return null;
        }
      }

      return null;
    } catch (e) {
      print('❌ [GET ACTIVE] Error: $e');
      return null;
    }
  }

  /// Complete Mission by ID
  static Future<bool> completeMission(int missionId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';

      if (token.isEmpty) {
        print('❌ [COMPLETE] Token not found');
        return false;
      }

      print('📤 [COMPLETE] Completing mission ID: $missionId');

      final response = await http.patch(
        Uri.parse('$userBaseUrl/misi/$missionId/complete'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw Exception('Request timeout');
        },
      );

      print('📥 [COMPLETE] Response status: ${response.statusCode}');
      print('📥 [COMPLETE] Response body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        print('✅ [COMPLETE] Mission completed: ${responseData['data']}');
        return true;
      } else {
        print('❌ [COMPLETE] Failed: ${response.body}');
        return false;
      }
    } catch (e) {
      print('❌ [COMPLETE] Error: $e');
      return false;
    }
  }

  /// Complete Active Mission by Parameter
  static Future<bool> completeActiveMission(String parameter) async {
    try {
      print('🔄 [COMPLETE ACTIVE] Processing parameter: $parameter');

      // Get active mission
      final activeMission = await getActiveMission(parameter);

      if (activeMission != null && activeMission['id'] != null) {
        final missionId = activeMission['id'];
        print('🔄 [COMPLETE ACTIVE] Found mission ID: $missionId');

        // Complete mission
        return await completeMission(missionId);
      }

      print('⚠️ [COMPLETE ACTIVE] No active mission found for: $parameter');
      return false;
    } catch (e) {
      print('❌ [COMPLETE ACTIVE] Error: $e');
      return false;
    }
  }

  /// Cleanup Old Missions (Admin function)
  static Future<bool> cleanupOldMissions() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';

      if (token.isEmpty) {
        print('❌ [CLEANUP] Token not found');
        return false;
      }

      print('📤 [CLEANUP] Cleaning up old missions...');

      final response = await http.delete(
        Uri.parse('$userBaseUrl/misi/auto/cleanup'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw Exception('Request timeout');
        },
      );

      print('📥 [CLEANUP] Response status: ${response.statusCode}');
      print('📥 [CLEANUP] Response body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        print('✅ [CLEANUP] Cleaned up: ${responseData['data']}');
        return true;
      }

      return false;
    } catch (e) {
      print('❌ [CLEANUP] Error: $e');
      return false;
    }
  }

  /// Test Connection to API
  static Future<bool> testConnection() async {
    try {
      final response = await http.get(
        Uri.parse('${baseURL}test'),
        headers: {'Accept': 'application/json'},
      ).timeout(
        const Duration(seconds: 5),
        onTimeout: () {
          throw Exception('Connection timeout');
        },
      );

      print('🔌 [TEST] Connection status: ${response.statusCode}');

      return response.statusCode == 200;
    } catch (e) {
      print('❌ [TEST] Connection failed: $e');
      return false;
    }
  }
}
