import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tugas9/utils/validators.dart';
import 'home_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  
  final _auth = FirebaseAuth.instance;
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      final name = _nameController.text.trim();
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();

      setState(() => _isLoading = true);

      try {
        // 1. Buat user di Firebase Auth
        final userCredential = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        // 2. Update display name
        await userCredential.user!.updateDisplayName(name);

        // 3. Kirim email verifikasi (opsional)
        await userCredential.user!.sendEmailVerification();

        // 4. Tampilkan success message
        _showSuccessDialog(userCredential.user!);

      } on FirebaseAuthException catch (e) {
        _showError(e);
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  void _showSuccessDialog(User user) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Registrasi Berhasil! 🎉'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Halo, ${user.displayName}!'),
            const SizedBox(height: 10),
            const Text(
              'Akun Anda telah berhasil dibuat. '
              'Silakan cek email Anda untuk verifikasi.',
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Tutup dialog
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const HomePage()),
              );
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showError(FirebaseAuthException e) {
    String errorMessage;
    
    switch (e.code) {
      case 'email-already-in-use':
        errorMessage = 'Email sudah terdaftar';
        break;
      case 'invalid-email':
        errorMessage = 'Format email tidak valid';
        break;
      case 'operation-not-allowed':
        errorMessage = 'Registrasi dengan email/password belum diaktifkan';
        break;
      case 'weak-password':
        errorMessage = 'Password terlalu lemah';
        break;
      default:
        errorMessage = e.message ?? 'Terjadi kesalahan';
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(errorMessage),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _togglePasswordVisibility() {
    setState(() => _obscurePassword = !_obscurePassword);
  }

  void _toggleConfirmPasswordVisibility() {
    setState(() => _obscureConfirmPassword = !_obscureConfirmPassword);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Akun Baru'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              const Text(
                'Buat Akun Baru',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              const Text(
                'Isi data diri Anda untuk mulai menggunakan aplikasi',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 30),

              // Nama Lengkap
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nama Lengkap',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),
                validator: Validators.validateName,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 16),

              // Email
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(),
                  hintText: 'contoh@email.com',
                ),
                keyboardType: TextInputType.emailAddress,
                validator: Validators.validateEmail,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 16),

              // Password
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: const Icon(Icons.lock),
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: _togglePasswordVisibility,
                  ),
                ),
                obscureText: _obscurePassword,
                validator: Validators.validatePassword,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 16),

              // Konfirmasi Password
              TextFormField(
                controller: _confirmPasswordController,
                decoration: InputDecoration(
                  labelText: 'Konfirmasi Password',
                  prefixIcon: const Icon(Icons.lock_outline),
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirmPassword ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: _toggleConfirmPasswordVisibility,
                  ),
                ),
                obscureText: _obscureConfirmPassword,
                validator: (value) => Validators.validateConfirmPassword(
                  _passwordController.text,
                  value,
                ),
                textInputAction: TextInputAction.done,
              ),
              const SizedBox(height: 24),

              // Password requirements
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Password harus mengandung:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            _passwordController.text.length >= 6
                                ? Icons.check_circle
                                : Icons.circle_outlined,
                            color: _passwordController.text.length >= 6
                                ? Colors.green
                                : Colors.grey,
                            size: 16,
                          ),
                          const SizedBox(width: 8),
                          const Text('Minimal 6 karakter'),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(
                            RegExp(r'[A-Z]').hasMatch(_passwordController.text)
                                ? Icons.check_circle
                                : Icons.circle_outlined,
                            color: RegExp(r'[A-Z]').hasMatch(_passwordController.text)
                                ? Colors.green
                                : Colors.grey,
                            size: 16,
                          ),
                          const SizedBox(width: 8),
                          const Text('Minimal 1 huruf besar'),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(
                            RegExp(r'[0-9]').hasMatch(_passwordController.text)
                                ? Icons.check_circle
                                : Icons.circle_outlined,
                            color: RegExp(r'[0-9]').hasMatch(_passwordController.text)
                                ? Colors.green
                                : Colors.grey,
                            size: 16,
                          ),
                          const SizedBox(width: 8),
                          const Text('Minimal 1 angka'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Tombol Daftar
              if (_isLoading)
                const Center(child: CircularProgressIndicator())
              else
                ElevatedButton(
                  onPressed: _register,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Daftar Sekarang',
                    style: TextStyle(fontSize: 16),
                  ),
                ),

              // Link ke Login
              const SizedBox(height: 20),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Sudah punya akun?'),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Login di sini'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}