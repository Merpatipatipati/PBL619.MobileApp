import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:application_hydrogami/models/panduan_model.dart';
import 'package:application_hydrogami/services/globals.dart'; // Tambahkan import globals

class DetailPanduanService {
  static Future<Panduan?> fetchPanduanDetail(int idPanduan) async {
    try {
      // Gunakan baseURL agar dinamis dan mengikuti emulator/HP
      final response =
          await http.get(Uri.parse('${baseURL}user/panduan/$idPanduan'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body)['data'];
        return Panduan.fromJson(data);
      } else {
        return null;
      }
    } catch (e) {
      // Error handling jika terjadi kesalahan
      print('Error: $e');
      return null;
    }
  }
}
