import 'dart:convert';

enum CodecType { base64, unicode, morse, url }

class CodecUtils {
  static const Map<String, String> _morseMap = {
    'A': '.-', 'B': '-...', 'C': '-.-.', 'D': '-..', 'E': '.',
    'F': '..-.', 'G': '--.', 'H': '....', 'I': '..', 'J': '.---',
    'K': '-.-', 'L': '.-..', 'M': '--', 'N': '-.', 'O': '---',
    'P': '.--.', 'Q': '--.-', 'R': '.-.', 'S': '...', 'T': '-',
    'U': '..-', 'V': '...-', 'W': '.--', 'X': '-..-', 'Y': '-.--',
    'Z': '--..',
    '0': '-----', '1': '.----', '2': '..---', '3': '...--', '4': '....-',
    '5': '.....', '6': '-....', '7': '--...', '8': '---..', '9': '----.',
    ' ': '/',
  };
  static final Map<String, String> _reverseMorseMap = {
    for (var e in _morseMap.entries) e.value: e.key
  };

  static String encode(String input, CodecType type) {
    switch (type) {
      case CodecType.base64:
        return base64.encode(utf8.encode(input));
      case CodecType.unicode:
        return input.runes.map((r) => r.toRadixString(16).padLeft(4, '0')).join(' ');
      case CodecType.morse:
        return input.toUpperCase().split('').map((c) => _morseMap[c] ?? '').join(' ');
      case CodecType.url:
        return Uri.encodeComponent(input);
    }
  }

  static String decode(String input, CodecType type) {
    switch (type) {
      case CodecType.base64:
        try {
          return utf8.decode(base64.decode(input));
        } catch (_) {
          return 'Invalid Base64';
        }
      case CodecType.unicode:
        try {
          return String.fromCharCodes(input.split(RegExp(r'\\s+')).map((e) => int.parse(e, radix: 16)));
        } catch (_) {
          return 'Invalid Unicode';
        }
      case CodecType.morse:
        try {
          return input.trim().split(' ').map((e) => _reverseMorseMap[e] ?? '').join();
        } catch (_) {
          return 'Invalid Morse';
        }
      case CodecType.url:
        try {
          return Uri.decodeComponent(input);
        } catch (_) {
          return 'Invalid URL';
        }
    }
  }
}
