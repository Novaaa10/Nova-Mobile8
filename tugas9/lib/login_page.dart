import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  bool _loading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    final email = _emailController.text.trim();
    final pass = _passwordController.text.trim();

    if (!_validate(email, pass)) return;

    setState(() => _loading = true);
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: pass);
      // Jika sukses, authStateChanges akan mengarahkan ke HomePage otomatis
    } on FirebaseAuthException catch (e) {
      _showError(e);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _register() async {
    final email = _emailController.text.trim();
    final pass = _passwordController.text.trim();

    if (!_validate(email, pass)) return;

    setState(() => _loading = true);
    try {
      await _auth.createUserWithEmailAndPassword(email: email, password: pass);
      // Opsional: kirim verifikasi email: await user.sendEmailVerification();
    } on FirebaseAuthException catch (e) {
      _showError(e);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  bool _validate(String email, String pass) {
    if (email.isEmpty || pass.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email dan password harus diisi')),
      );
      return false;
    }
    if (pass.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password minimal 6 karakter')),
      );
      return false;
    }
    return true;
  }

  void _showError(FirebaseAuthException e) {
    final message = e.message ?? 'Terjadi kesalahan';
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login / Register')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            if (_loading) const CircularProgressIndicator(),
            if (!_loading)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(onPressed: _login, child: const Text('Login')),
                  ElevatedButton(onPressed: _register, child: const Text('Daftar')),
                ],
              ),
          ],
        ),
      ),
    );
  }
}