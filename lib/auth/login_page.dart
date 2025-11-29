import 'package:flutter/material.dart';
import '../dashboard_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  String? emailError;
  String? passError;

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  void _handleLogin() {
    final email = emailCtrl.text.trim();
    final pass = passCtrl.text.trim();

    setState(() {
      emailError = null;
      passError = null;
    });

    bool hasError = false;

    if (email.isEmpty) {
      emailError = "Vui lòng nhập Email";
      hasError = true;
    } else if (!_isValidEmail(email)) {
      emailError = "Email không hợp lệ";
      hasError = true;
    }

    if (pass.isEmpty) {
      passError = "Vui lòng nhập Mật khẩu";
      hasError = true;
    } else if (pass.length < 6) {
      passError = "Mật khẩu phải có ít nhất 6 ký tự";
      hasError = true;
    }

    if (hasError) {
      setState(() {});
      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) =>
            const DashboardPage(showSuccessSnack: true),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5E8EE),
      appBar: AppBar(
        title: const Text("Đăng nhập"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: emailCtrl,
              decoration: InputDecoration(
                labelText: "Email",
                errorText: emailError,
              ),
            ),
            const SizedBox(height: 14),

            TextField(
              controller: passCtrl,
              obscureText: true,
              decoration: InputDecoration(
                labelText: "Mật khẩu",
                errorText: passError,
              ),
            ),

            const SizedBox(height: 26),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _handleLogin,
                child: const Text("Đăng nhập"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
