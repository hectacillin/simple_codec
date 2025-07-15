import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'utils/codec_utils.dart';
import 'widgets/custom_text_field.dart';
import 'widgets/result_card.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const CupertinoApp(
      debugShowCheckedModeBanner: false,
      home: EncodeDecodeScreen(),
    );
  }
}

class EncodeDecodeScreen extends StatefulWidget {
  const EncodeDecodeScreen({super.key});

  @override
  State<EncodeDecodeScreen> createState() => _EncodeDecodeScreenState();
}

class _CodecInfo {
  final CodecType type;
  final String label;
  final IconData icon;
  const _CodecInfo(this.type, this.label, this.icon);
}

class _EncodeDecodeScreenState extends State<EncodeDecodeScreen> {
  CodecType _selectedCodec = CodecType.base64;
  final TextEditingController _inputController = TextEditingController();
  String _result = '';
  bool _isEncode = true;
  bool _copied = false;

  final List<_CodecInfo> _codecList = const [
    _CodecInfo(CodecType.base64, 'Base64', Icons.code),
    _CodecInfo(CodecType.unicode, 'Unicode', Icons.language),
    _CodecInfo(CodecType.morse, 'Morse', Icons.ssid_chart),
    _CodecInfo(CodecType.url, 'URL', Icons.link),
  ];

  void _process() {
    setState(() {
      if (_isEncode) {
        _result = CodecUtils.encode(_inputController.text, _selectedCodec);
      } else {
        _result = CodecUtils.decode(_inputController.text, _selectedCodec);
      }
      _copied = false;
    });
  }

  Widget _buildCodecSelector(bool isDark) {
    return Material(
      color: Colors.transparent,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: _codecList.map((info) {
          final selected = info.type == _selectedCodec;
          return InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: () {
              setState(() {
                _selectedCodec = info.type;
                _result = '';
                _inputController.clear();
                _copied = false;
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: selected ? Colors.blueAccent : (isDark ? Colors.grey[900] : Colors.grey[200]),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: selected ? Colors.blue : Colors.transparent,
                  width: selected ? 2 : 1,
                ),
                boxShadow: selected
                    ? [
                        BoxShadow(
                          color: Colors.blue.withOpacity(0.12),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : [],
              ),
              child: Row(
                children: [
                  Icon(
                    info.icon,
                    color: selected ? Colors.white : (isDark ? Colors.white70 : Colors.blueGrey),
                    size: 22,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    info.label,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: selected ? Colors.white : (isDark ? Colors.white70 : Colors.black87),
                      fontSize: 14,
                      letterSpacing: -0.5,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Brightness brightness = MediaQuery.of(context).platformBrightness;
    final bool isDark = brightness == Brightness.dark;
    final Color bgColor = isDark ? const Color(0xFF181A20) : const Color(0xFFF6F8FB);
    final Color cardColor = isDark ? const Color(0xFF23262F) : Colors.white;
    return CupertinoPageScaffold(
      backgroundColor: bgColor,
      child: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header
                Container(
                  margin: const EdgeInsets.only(top: 0),
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      SizedBox(height: 2),
                      Text(
                        'Codec Converter',
                        style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, letterSpacing: -1),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Encode and decode Base64, Unicode, Morse, and URL easily. Fast, beautiful, and cross-platform.',
                        style: TextStyle(fontSize: 16, color: CupertinoColors.systemGrey),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                _buildCodecSelector(isDark),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.03),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      CustomTextField(
                        controller: _inputController,
                        placeholder: _isEncode ? 'Enter text to encode...' : 'Enter text to decode...',
                        isDark: isDark,
                      ),
                      const SizedBox(height: 16),
                      CupertinoSlidingSegmentedControl<bool>(
                        groupValue: _isEncode,
                        children: const {
                          true: Text('Encode'),
                          false: Text('Decode'),
                        },
                        onValueChanged: (bool? value) {
                          if (value != null) {
                            setState(() {
                              _isEncode = value;
                              _result = '';
                              _copied = false;
                            });
                          }
                        },
                      ),
                      const SizedBox(height: 22),
                      SizedBox(
                        width: double.infinity,
                        child: CupertinoButton(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(14),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: const Text('Convert', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                          onPressed: _process,
                        ),
                      ),
                    ],
                  ),
                ),
                if (_result.isNotEmpty) ...[
                  const SizedBox(height: 32),
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.03),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: ResultCard(result: _result, isDark: isDark),
                        ),
                        const SizedBox(width: 8),
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(10),
                            onTap: () async {
                              await Clipboard.setData(ClipboardData(text: _result));
                              setState(() => _copied = true);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: Icon(_copied ? Icons.check : Icons.copy, color: Colors.blue, size: 26),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
