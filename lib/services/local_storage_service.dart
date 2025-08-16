import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static const String _favoritesKey = 'favorite_photos';

  /// Get all favorite photo IDs
  static Future<List<int>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_favoritesKey)?.map(int.parse).toList() ?? [];
  }

  /// Add a photo ID to favorites
  static Future<void> addFavorite(int photoId) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> favorites = prefs.getStringList(_favoritesKey) ?? [];
    if (!favorites.contains(photoId.toString())) {
      favorites.add(photoId.toString());
      await prefs.setStringList(_favoritesKey, favorites);
    }
  }

  /// Remove a photo ID from favorites
  static Future<void> removeFavorite(int photoId) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> favorites = prefs.getStringList(_favoritesKey) ?? [];
    favorites.remove(photoId.toString());
    await prefs.setStringList(_favoritesKey, favorites);
  }

  /// Check if a photo is already in favorites
  static Future<bool> isFavorite(int photoId) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> favorites = prefs.getStringList(_favoritesKey) ?? [];
    return favorites.contains(photoId.toString());
  }
}
