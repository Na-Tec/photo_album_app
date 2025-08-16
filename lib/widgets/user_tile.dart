import 'package:flutter/material.dart';
import '../models/user.dart';
import '../screens/albums_screen.dart';

class UserTile extends StatelessWidget {
  final User user;

  const UserTile({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.person, color: Colors.blue),
      title: Text(
        user.name,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text('@${user.username} • ${user.email}'),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => AlbumsScreen(userId: user.id, userName: user.name),
          ),
        );
      },
    );
  }
}
