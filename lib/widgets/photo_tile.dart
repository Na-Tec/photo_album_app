import 'package:flutter/material.dart';

class PhotoTile extends StatelessWidget {
  final String photoUrl;
  final String title;

  const PhotoTile({super.key, required this.photoUrl, required this.title});

  @override
  Widget build(BuildContext context) {
    return GridTile(
      footer: Container(
        padding: const EdgeInsets.all(4),
        color: Colors.black54,
        child: Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(color: Colors.white, fontSize: 12),
        ),
      ),
      child: Image.network(photoUrl, fit: BoxFit.cover),
    );
  }
}
