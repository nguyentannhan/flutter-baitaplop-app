import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../controllers/user_controller.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  static const _avatarUrl =
      'https://cdn.tienphong.vn/images/a6bf4f60924201126af6849ca45a3980233e23f03ef3498b951a7cad48f2cc3dc9ecc4de1bda431fec8abb99e453b056ba58842243581e9b11829b47dd076e6a4d693419db2695b8deb3f1e1e812ef1853167410c8042e295100f4dc6991a0e2013bd205c97fd5aef7ddf19075048ee8/472256571-1167112814781105-1579606309934709000-n-2478-4557.jpg';

  
  bool _isEditing = false;

  late final UserController _user;
  late final TextEditingController _nameCtrl;
  late final TextEditingController _emailCtrl;
  late final TextEditingController _phoneCtrl;

  @override
  void initState() {
    super.initState();
    _user = Get.find<UserController>();

    _nameCtrl = TextEditingController(text: _user.name.value);
    _emailCtrl = TextEditingController(text: _user.email.value);
    _phoneCtrl = TextEditingController(text: _user.phone.value);
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  final ImagePicker _picker = ImagePicker();
  Future<void> _pickAvatar() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 600,
      imageQuality: 85,
    );
    if (image == null) return;

    final Uint8List bytes = await image.readAsBytes();
    _user.setAvatar(bytes);
  }

  void _toggleEdit() {
    setState(() {
      if (_isEditing) {
        _user.updateProfile(
          name: _nameCtrl.text,
          email: _emailCtrl.text,
          phone: _phoneCtrl.text,
        );
      } else {
        _nameCtrl.text = _user.name.value;
        _emailCtrl.text = _user.email.value;
        _phoneCtrl.text = _user.phone.value;
      }
      _isEditing = !_isEditing;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Padding(
          padding: EdgeInsets.only(top: 12),
          child: Text(
            "Hồ sơ nè",
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),

      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(
              "https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?auto=format&fit=crop&w=1200&q=80",
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Obx(() {
                        final bytes = _user.avatarBytes.value;
                        final ImageProvider avatar = bytes != null
                            ? MemoryImage(bytes)
                            : const NetworkImage(_avatarUrl);
                        return CircleAvatar(
                          radius: 56,
                          backgroundColor: Colors.white,
                          child: CircleAvatar(
                            radius: 52,
                            backgroundImage: avatar,
                            backgroundColor: const Color(0xFFF4EBF6),
                          ),
                        );
                      }),
                      if (_isEditing)
                        Positioned(
                          bottom: 4,
                          right: 4,
                          child: InkWell(
                            onTap: _pickAvatar,
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: const BoxDecoration(
                                color: Colors.blue,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.camera_alt,
                                size: 18,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _isEditing
                              ? TextField(
                                  controller: _nameCtrl,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  decoration: const InputDecoration(
                                    isDense: true,
                                    border: InputBorder.none,
                                  ),
                                )
                              : Obx(
                                  () => Text(
                                    _user.name.value,
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.grey[900],
                                    ),
                                  ),
                                ),
                          const SizedBox(height: 10),

                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.email_outlined,
                                size: 18,
                                color: Colors.grey[700],
                              ),
                              const SizedBox(width: 8),
                              _isEditing
                                  ? Expanded(
                                      child: TextField(
                                        controller: _emailCtrl,
                                        style: TextStyle(
                                          color: Colors.grey[700],
                                        ),
                                        decoration: const InputDecoration(
                                          isDense: true,
                                          border: InputBorder.none,
                                        ),
                                      ),
                                    )
                                  : Obx(
                                      () => Text(
                                        _user.email.value,
                                        style: TextStyle(
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                    ),
                            ],
                          ),
                          const SizedBox(height: 8),

                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.phone_outlined,
                                size: 18,
                                color: Colors.grey[700],
                              ),
                              const SizedBox(width: 8),
                              _isEditing
                                  ? Expanded(
                                      child: TextField(
                                        controller: _phoneCtrl,
                                        style: TextStyle(
                                          color: Colors.grey[700],
                                        ),
                                        decoration: const InputDecoration(
                                          isDense: true,
                                          border: InputBorder.none,
                                        ),
                                      ),
                                    )
                                  : Obx(
                                      () => Text(
                                        _user.phone.value,
                                        style: TextStyle(
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                    ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  SizedBox(
                    width: 160,
                    child: OutlinedButton.icon(
                      onPressed: _toggleEdit,
                      icon: Icon(
                        _isEditing ? Icons.check : Icons.edit,
                        size: 18,
                      ),
                      label: Text(_isEditing ? 'Lưu' : 'Chỉnh sửa'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: const BorderSide(color: Colors.white),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
