import 'dart:typed_data';
import 'package:get/get.dart';

class UserController extends GetxController {
  final name = 'Sếp'.obs;
  final email = 'email@gmail.com'.obs;
  final phone = '0373998654'.obs;

  final avatarBytes = Rxn<Uint8List>();

  void updateProfile({
    String? name,
    String? email,
    String? phone,
  }) {
    if (name != null) this.name.value = name;
    if (email != null) this.email.value = email;
    if (phone != null) this.phone.value = phone;
  }

  void setAvatar(Uint8List bytes) {
    avatarBytes.value = bytes;
  }
}
