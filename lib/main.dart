import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'auth/login_page.dart';
import 'controllers/user_controller.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  Get.put(UserController(), permanent: true);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Unit Converter Demo',
      home: const LoginPage(),
    );
  }
}
