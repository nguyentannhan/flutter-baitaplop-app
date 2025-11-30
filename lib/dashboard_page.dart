import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'pages/home_page.dart';
import 'pages/user_profile.dart';
import 'pages/map_page.dart';

class DashboardPage extends StatefulWidget {
  final bool showSuccessSnack;
  const DashboardPage({super.key, this.showSuccessSnack = false});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _selectedIndex = 0;

  late final List<Widget> screens;

  @override
  void initState() {
    super.initState();

    screens = [
      HomePage(),
      const Center(child: Text('Tìm kiếm', style: TextStyle(fontSize: 20))),
      const Center(child: Text('Tin nhắn', style: TextStyle(fontSize: 20))),
      const ProfilePage(),
    ];

    if (widget.showSuccessSnack) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showTopRightToast(context, "Đăng nhập thành công");
      });
    }
  }

  void _onNavTap(int idx) {
    setState(() => _selectedIndex = idx);
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final isSelected = _selectedIndex == index;
    final color = isSelected ? Colors.blue : Colors.grey;

    return Expanded(
      child: InkWell(
        onTap: () => _onNavTap(index),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(fontSize: 11, color: color),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBF5F8),

      body: SafeArea(
        child: IndexedStack(
          index: _selectedIndex,
          children: screens,
        ),
      ),

      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        backgroundColor: Colors.blue,
        elevation: 4,
        onPressed: () {
          Get.to(() => const MapPage());
        },
        child: const Icon(Icons.map, size: 32),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      bottomNavigationBar: SafeArea(
        top: false,
        child: BottomAppBar(
          shape: const CircularNotchedRectangle(),
          notchMargin: 8,
          child: SizedBox(
            height: 72,
            child: Row(
              children: [
                _buildNavItem(Icons.home, "Trang chủ", 0),
                _buildNavItem(Icons.search, "Tìm kiếm", 1),

                Expanded(
                  child: InkWell(
                    onTap: () {
                      Get.to(() => const MapPage());
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        SizedBox(height: 4),
                        Icon(Icons.map, color: Colors.transparent, size: 24),
                        SizedBox(height: 2),
                      ],
                    ),
                  ),
                ),

                _buildNavItem(Icons.message, "Tin nhắn", 2),
                _buildNavItem(Icons.person, "Hồ sơ", 3),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showTopRightToast(BuildContext context, String message) {
    final overlay = Overlay.of(context);
    late OverlayEntry entry;

    entry = OverlayEntry(
      builder: (context) => Positioned(
        top: 40,
        right: 20,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.85),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.check_circle, color: Colors.white, size: 18),
                const SizedBox(width: 8),
                Text(
                  message,
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    overlay.insert(entry);
    Future.delayed(const Duration(seconds: 2), () {
      entry.remove();
    });
  }
}
