import 'package:flutter/material.dart';
import '../services/database_service.dart'; // Updated import
import '../services/shared_prefs_service.dart';
import 'home_screen.dart';
import 'register_screen.dart';
import '../utils/password_hash.dart';

class LoginScreen extends StatefulWidget {
  final String? registeredEmail;

  const LoginScreen({Key? key, this.registeredEmail}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final _dbService = DatabaseService.instance; // Updated instance
  late SharedPrefsService _prefsService;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializePrefs();
    if (widget.registeredEmail != null) {
      _emailController.text = widget.registeredEmail!;
    }
  }

  Future<void> _initializePrefs() async {
    _prefsService = await SharedPrefsService.getInstance();
    setState(() {
      _isInitialized = true;
    });
    await _loadSavedEmail();
  }

  Future<void> _loadSavedEmail() async {
    if (!_isInitialized) return;
    final savedEmail = _prefsService.getEmail();
    if (savedEmail != null) {
      setState(() {
        _emailController.text = savedEmail;
      });
    }
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      final user = await _dbService
          .getUserByEmail(_emailController.text); // Updated method call

      if (user != null &&
          verifyPassword(_passwordController.text, user.password)) {
        await _prefsService.saveEmail(_emailController.text);

        if (!mounted) return;

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      } else {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Email atau kata sandi salah'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Terjadi kesalahan: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            const Icon(
              Icons.account_circle,
              size: 100,
              color: Colors.blue,
            ),
            const SizedBox(height: 20),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) =>
                        value!.isEmpty ? 'Mohon masukkan email Anda' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordController,
                    decoration: const InputDecoration(
                      labelText: 'Kata Sandi',
                      prefixIcon: Icon(Icons.lock),
                      border: OutlineInputBorder(),
                    ),
                    obscureText: true,
                    validator: (value) => value!.isEmpty
                        ? 'Mohon masukkan kata sandi Anda'
                        : null,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    onPressed: _login,
                    child: const Text('Masuk', style: TextStyle(fontSize: 16)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Belum punya akun?"),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const RegisterScreen()),
                    );
                  },
                  child: const Text('Daftar sekarang'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
