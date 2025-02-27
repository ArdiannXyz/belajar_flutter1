import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/database_service.dart';
import '../services/shared_prefs_service.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _dbService = DatabaseService.instance;
  late SharedPrefsService _prefsService;
  bool _isInitialized = false;
  String? _userEmail;
  List<User> _users = [];

  @override
  void initState() {
    super.initState();
    _initializePrefs();
  }

  Future<void> _initializePrefs() async {
    _prefsService = await SharedPrefsService.getInstance();
    setState(() {
      _isInitialized = true;
    });
    await _loadUserData();
  }

  Future<void> _loadUserData() async {
    if (!_isInitialized) return;
    try {
      final email = _prefsService.getEmail();
      final users = await _dbService.getAllUsers();
      setState(() {
        _userEmail = email;
        _users = users;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading data: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          if (_userEmail != null)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text('Selamat datang, $_userEmail',
                  style: const TextStyle(fontSize: 16)),
            ),
          if (_userEmail != null)
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () => _showLogoutDialog(context),
            ),
        ],
      ),
      body: !_isInitialized
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _users.length,
              itemBuilder: (context, index) {
                final user = _users[index];
                return ListTile(
                  title: Text(user.name),
                  subtitle: Text(user.email),
                );
              },
            ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi Keluar'),
        content: const Text('Apakah Anda yakin ingin keluar?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () async {
              await _prefsService.clearEmail();
              if (!mounted) return;
              Navigator.pushReplacementNamed(context, '/login');
            },
            child: const Text('Keluar'),
          ),
        ],
      ),
    );
  }
}
