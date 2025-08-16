import 'package:flutter/material.dart';
import '../services/local_storage_service.dart';

class PhotoViewerScreen extends StatefulWidget {
  final int photoId;
  final String photoUrl;
  final String title;

  const PhotoViewerScreen({
    super.key,
    required this.photoId,
    required this.photoUrl,
    required this.title,
  });

  @override
  State<PhotoViewerScreen> createState() => _PhotoViewerScreenState();
}

class _PhotoViewerScreenState extends State<PhotoViewerScreen> {
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    _loadFavoriteStatus();
  }

  Future<void> _loadFavoriteStatus() async {
    bool fav = await LocalStorageService.isFavorite(widget.photoId);
    setState(() => isFavorite = fav);
  }

  Future<void> _toggleFavorite() async {
    if (isFavorite) {
      await LocalStorageService.removeFavorite(widget.photoId);
    } else {
      await LocalStorageService.addFavorite(widget.photoId);
    }
    setState(() => isFavorite = !isFavorite);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title, maxLines: 1, overflow: TextOverflow.ellipsis),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: Colors.red,
            ),
            onPressed: _toggleFavorite,
          ),
        ],
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: Hero(
          tag: widget.photoUrl,
          child: InteractiveViewer(
            child: Image.network(
              widget.photoUrl,
              errorBuilder: (context, error, stackTrace) {
                // Fallback placeholder if image fails to load
                return Image.network(
                  'https://picsum.photos/300?random=${widget.photoId}',
                  fit: BoxFit.cover,
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
