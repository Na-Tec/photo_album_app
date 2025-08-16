import 'package:flutter/material.dart';
import '../models/photo.dart';
import '../services/api_service.dart';
import '../services/local_storage_service.dart';
import 'photo_viewer_screen.dart';

class PhotosScreen extends StatefulWidget {
  final int albumId;
  final String albumTitle;

  const PhotosScreen({
    super.key,
    required this.albumId,
    required this.albumTitle,
  });

  @override
  State<PhotosScreen> createState() => _PhotosScreenState();
}

class _PhotosScreenState extends State<PhotosScreen> {
  late Future<List<Photo>> _photosFuture;
  List<int> _favoritePhotoIds = [];

  @override
  void initState() {
    super.initState();
    _photosFuture = ApiService.fetchPhotos(albumId: widget.albumId);
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    _favoritePhotoIds = await LocalStorageService.getFavorites();
    setState(() {});
  }

  Future<void> _toggleFavorite(int photoId) async {
    if (_favoritePhotoIds.contains(photoId)) {
      await LocalStorageService.removeFavorite(photoId);
      _favoritePhotoIds.remove(photoId);
    } else {
      await LocalStorageService.addFavorite(photoId);
      _favoritePhotoIds.add(photoId);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.albumTitle)),
      body: FutureBuilder<List<Photo>>(
        future: _photosFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No photos found"));
          }

          final photos = snapshot.data!;
          return GridView.builder(
            padding: const EdgeInsets.all(8.0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8.0,
            ),
            itemCount: photos.length,
            itemBuilder: (context, index) {
              final photo = photos[index];
              final isFav = _favoritePhotoIds.contains(photo.id);

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
                child: Stack(
                  children: [
                    Hero(
                      tag: photo.url,
                      child: Image.network(
                        'https://picsum.photos/150?random=${photo.id}',
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                      ),
                    ),
                    Positioned(
                      top: 4,
                      right: 4,
                      child: GestureDetector(
                        onTap: () => _toggleFavorite(photo.id),
                        child: Icon(
                          isFav ? Icons.favorite : Icons.favorite_border,
                          color: isFav ? Colors.red : Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
