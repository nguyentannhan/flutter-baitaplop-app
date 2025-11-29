import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const String sampleImageUrl =
    '/mnt/data/1ce05aea-fe93-42dc-a627-3a84d56b5e25.png';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chuyển đổi đơn vị nhiệt độ',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF9F0F6),
      ),
      home: const ConverterPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class ConverterPage extends StatefulWidget {
  const ConverterPage({super.key});
  @override
  State<ConverterPage> createState() => _ConverterPageState();
}

class _ConverterPageState extends State<ConverterPage>
    with SingleTickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  String _displayResult = ''; // visible result text
  String _errorText = ''; // shown inside TextField or empty
  bool _isCtoF = true; // true = C -> F, false = F -> C
  double _lastConverted = double.nan;

  late final AnimationController _pulseController;
  late final Animation<double> _pulseAnim;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onInputChanged);

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 280),
    );
    _pulseAnim = Tween<double>(begin: 1.0, end: 1.08)
        .chain(CurveTween(curve: Curves.easeOut))
        .animate(_pulseController);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _controller.removeListener(_onInputChanged);
    _controller.dispose();
    super.dispose();
  }

  // Simple conversion functions
  double _cToF(double c) => (c * 1.8) + 32;
  double _fToC(double f) => (f - 32) / 1.8;

  String _fromLabel() => _isCtoF ? '°C' : '°F';
  String _toLabel() => _isCtoF ? '°F' : '°C';

  // Called on typing (auto conversion)
  void _onInputChanged() => _tryConvert(auto: true);

  // Try parse, validate and convert. If auto=false show snack on error.
  void _tryConvert({bool auto = false}) {
    final raw = _controller.text.trim();

    // empty input -> clear or show inline message
    if (raw.isEmpty) {
      setState(() {
        _displayResult = '';
        _errorText = auto ? '' : 'Vui lòng nhập nhiệt độ (${_fromLabel()})';
      });
      return;
    }

    // normalize comma -> dot then try parse
    final normalized = raw.replaceAll(',', '.');

    // quick reject invalid characters (allow digits, ., -, +)
    final invalidChars = RegExp(r'[^0-9\.\-+]');
    if (invalidChars.hasMatch(normalized)) {
      _showError('Không được nhập ký tự đặc biệt', auto);
      return;
    }

    // parse
    final value = double.tryParse(normalized);
    if (value == null) {
      _showError('Giá trị không hợp lệ', auto);
      return;
    }

    // perform conversion
    final converted = _isCtoF ? _cToF(value) : _fToC(value);

    // update UI and play pulse if value changed significantly
    setState(() {
      _displayResult = '${converted.toStringAsFixed(1)} ${_toLabel()}';
      _errorText = '';
    });

    if (_lastConverted.isNaN || (_lastConverted - converted).abs() > 0.01) {
      _pulseController.forward(from: 0).then((_) => _pulseController.reverse());
      _lastConverted = converted;
    }
  }

  void _showError(String message, bool auto) {
    setState(() {
      _displayResult = '';
      _errorText = message;
    });
    if (!auto) {
      final messenger = ScaffoldMessenger.of(context);
      messenger.hideCurrentSnackBar();
      messenger.showSnackBar(SnackBar(content: Text(message)));
    }
  }

  // Called when user taps the calculate button or FAB
  void _onCalculatePressed() {
    _tryConvert(auto: false);
    if (_errorText.isNotEmpty) {
      final messenger = ScaffoldMessenger.of(context);
      messenger.hideCurrentSnackBar();
      messenger.showSnackBar(SnackBar(content: Text(_errorText)));
    }
  }

  // Header card (kept layout like original)
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.white.withOpacity(0.9),
              const Color(0xFFFAF0FB).withOpacity(0.9),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 18),
        child: Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  Text(
                    'Chuyển đổi đơn vị',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.grey[900],
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Nhập ${_fromLabel()} để xem ${_toLabel()} ngay',
                    style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                  ),
                ],
              ),
            ),
            Container(
              width: 86,
              height: 86,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              clipBehavior: Clip.hardEdge,
              child: Image.network(
                sampleImageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stack) {
                  return const Center(child: Icon(Icons.phone_android));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Main input card (kept layout)
  Widget _buildInputCard() {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 16, 18, 20),
        child: Column(
          children: [
            Row(
              children: [
                const Icon(Icons.thermostat, color: Color(0xFF6A3B78)),
                const SizedBox(width: 8),
                const Text(
                  'Nhập nhiệt độ',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(width: 6),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5E9F6),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _fromLabel(),
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF4B2A5B),
                    ),
                  ),
                ),
                const Spacer(),
                // toggle
                RawMaterialButton(
                  onPressed: () {
                    setState(() {
                      _isCtoF = !_isCtoF;
                      _displayResult = '';
                      _errorText = '';
                      _controller.clear();
                    });
                  },
                  fillColor: const Color(0xFFF4EBF6),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Text(_isCtoF ? 'C →' : 'F →'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    keyboardType: const TextInputType.numberWithOptions(
                        decimal: true, signed: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[\d\.,\-\+]')),
                    ],
                    decoration: InputDecoration(
                      hintText: 'Ví dụ: 33',
                      errorText: _errorText.isEmpty ? null : _errorText,
                      filled: true,
                      fillColor: Colors.white,
                      suffix: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF4EBF6),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          _fromLabel(),
                          style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF4B2A5B)),
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.transparent),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade200),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 16),
                    ),
                    style: const TextStyle(fontSize: 20),
                    onSubmitted: (_) => _onCalculatePressed(),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: _onCalculatePressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF7C4DFF),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    elevation: 4,
                  ),
                  child: const Icon(Icons.arrow_forward, color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 18),
            // Result area with scale animation
            ScaleTransition(
              scale: _pulseAnim,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    _displayResult.isNotEmpty ? 'KẾT QUẢ' : 'KẾT QUẢ (chưa có)',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[700],
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TweenAnimationBuilder<double>(
                    tween: Tween<double>(
                      begin: 0,
                      end: _displayResult.isNotEmpty
                          ? double.tryParse(_displayResult.split(' ').first) ?? 0
                          : 0,
                    ),
                    duration: const Duration(milliseconds: 600),
                    curve: Curves.easeOut,
                    builder: (context, value, child) {
                      final shown = _displayResult.isNotEmpty
                          ? '${value.toStringAsFixed(1)} ${_toLabel()}'
                          : '--';
                      return Text(
                        shown,
                        style: const TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF4B2A5B),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top + 12;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: topPadding),
            _buildHeader(),
            const SizedBox(height: 18),
            _buildInputCard(),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  _isCtoF ? '°F = (°C × 1.8) + 32' : '°C = (°F - 32) / 1.8',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            const Expanded(child: SizedBox()),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _onCalculatePressed,
        backgroundColor: const Color(0xFF7C4DFF),
        child: const Icon(Icons.calculate),
      ),
    );
  }
}
