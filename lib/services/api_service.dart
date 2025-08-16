import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user.dart';
import '../models/album.dart';
import '../models/photo.dart';

class ApiService {
  static const String baseUrl = "https://jsonplaceholder.typicode.com";

  // Fetch all users
  static Future<List<User>> fetchUsers() async {
    final response = await http.get(Uri.parse('$baseUrl/users'));
    if (response.statusCode == 200) {
      List jsonData = json.decode(response.body);
      return jsonData.map((user) => User.fromJson(user)).toList();
    } else {
      throw Exception("Failed to load users");
    }
  }

  // Fetch albums (optionally filtered by userId)
  static Future<List<Album>> fetchAlbums({int? userId}) async {
    String url = '$baseUrl/albums';
    if (userId != null) {
      url += '?userId=$userId';
    }
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      List jsonData = json.decode(response.body);
      return jsonData.map((album) => Album.fromJson(album)).toList();
    } else {
      throw Exception("Failed to load albums");
    }
  }

  // Fetch photos (optionally filtered by albumId)
  static Future<List<Photo>> fetchPhotos({int? albumId}) async {
    String url = '$baseUrl/photos';
    if (albumId != null) {
      url += '?albumId=$albumId';
    }
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      List jsonData = json.decode(response.body);
      return jsonData.map((photo) => Photo.fromJson(photo)).toList();
    } else {
      throw Exception("Failed to load photos");
    }
  }

  // Fetch all photos (no filter)
  static Future<List<Photo>> fetchAllPhotos() async {
    final response = await http.get(Uri.parse('$baseUrl/photos'));
    if (response.statusCode == 200) {
      List jsonData = json.decode(response.body);
      return jsonData.map((photo) => Photo.fromJson(photo)).toList();
    } else {
      throw Exception("Failed to load all photos");
    }
  }
}
