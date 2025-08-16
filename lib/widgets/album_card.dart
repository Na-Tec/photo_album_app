import 'package:flutter/material.dart';
import '../models/album.dart';

class AlbumCard extends StatelessWidget {
  final Album album;
  final VoidCallback onTap;

  const AlbumCard({super.key, required this.album, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              album.title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}
