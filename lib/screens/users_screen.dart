import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/api_service.dart';
import 'albums_screen.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  late Future<List<User>> _usersFuture;
  List<User> _allUsers = [];
  List<User> _filteredUsers = [];
  String _searchQuery = "";

  @override
  void initState() {
    super.initState();
    _usersFuture = ApiService.fetchUsers();
  }

  void _filterUsers(String query) {
    setState(() {
      _searchQuery = query.toLowerCase();
      _filteredUsers = _allUsers
          .where(
            (user) =>
                user.name.toLowerCase().contains(_searchQuery) ||
                user.username.toLowerCase().contains(_searchQuery) ||
                user.email.toLowerCase().contains(_searchQuery),
          )
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Users"),
        backgroundColor: Colors.blueAccent,
      ),
      body: FutureBuilder<List<User>>(
        future: _usersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No users found"));
          }

          if (_allUsers.isEmpty) {
            _allUsers = snapshot.data!;
            _filteredUsers = _allUsers;
          }

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  onChanged: _filterUsers,
                  decoration: InputDecoration(
                    hintText: "Search users...",
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: _filteredUsers.length,
                  itemBuilder: (context, index) {
                    final user = _filteredUsers[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      child: ListTile(
                        title: Text(user.name),
                        subtitle: Text("${user.username} • ${user.email}"),
                        trailing: const Icon(Icons.arrow_forward_ios),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AlbumsScreen(
                                userId: user.id,
                                userName: user.name,
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
