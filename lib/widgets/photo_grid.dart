import 'package:flutter/material.dart';
import '../models/photo.dart';
import 'photo_tile.dart';

class PhotoGrid extends StatelessWidget {
  final List<Photo> photos;

  const PhotoGrid({super.key, required this.photos});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
      ),
      itemCount: photos.length,
      itemBuilder: (context, index) {
        final photo = photos[index];
        return PhotoTile(
          photoUrl: photo.thumbnailUrl, // ✅ matches constructor
          title: photo.title, // ✅ matches constructor
        );
      },
    );
  }
}
