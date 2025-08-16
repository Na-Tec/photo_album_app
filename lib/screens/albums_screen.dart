import 'package:flutter/material.dart';
import '../models/album.dart';
import '../services/api_service.dart';
import 'photos_screen.dart';

class AlbumsScreen extends StatefulWidget {
  final int userId;
  final String userName;

  const AlbumsScreen({super.key, required this.userId, required this.userName});

  @override
  State<AlbumsScreen> createState() => _AlbumsScreenState();
}

class _AlbumsScreenState extends State<AlbumsScreen> {
  late Future<List<Album>> _albumsFuture;

  @override
  void initState() {
    super.initState();
    _albumsFuture = ApiService.fetchAlbums(userId: widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("${widget.userName}'s Albums")),
      body: FutureBuilder<List<Album>>(
        future: _albumsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No albums found"));
          }

          final albums = snapshot.data!;
          return GridView.builder(
            padding: const EdgeInsets.all(8.0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 8.0,
              crossAxisSpacing: 8.0,
              childAspectRatio: 1.2,
            ),
            itemCount: albums.length,
            itemBuilder: (context, index) {
              final album = albums[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PhotosScreen(
                        albumId: album.id,
                        albumTitle: album.title,
                      ),
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.blue.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.all(12),
                  child: Center(
                    child: Text(
                      album.title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
