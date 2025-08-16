import 'package:flutter/material.dart';
import '../models/photo.dart';
import '../services/api_service.dart';
import '../services/local_storage_service.dart';
import 'photo_viewer_screen.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  List<Photo> _favoritePhotos = [];

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    List<int> favoriteIds = await LocalStorageService.getFavorites();

    List<Photo> allPhotos = await ApiService.fetchAllPhotos();
    _favoritePhotos = allPhotos
        .where((photo) => favoriteIds.contains(photo.id))
        .toList();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Favorites")),
      body: _favoritePhotos.isEmpty
          ? const Center(child: Text("No favorite photos yet"))
          : GridView.builder(
              padding: const EdgeInsets.all(8.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
              ),
              itemCount: _favoritePhotos.length,
              itemBuilder: (context, index) {
                final photo = _favoritePhotos[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PhotoViewerScreen(
                          photoId: photo.id,
                          photoUrl: photo.url,
                          title: photo.title,
                        ),
                      ),
                    );
                  },
                  child: Hero(
                    tag: photo.url,
                    child: Image.network(
                      'https://picsum.photos/150?random=${photo.id}',
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  ),
                );
              },
            ),
    );
  }
}
