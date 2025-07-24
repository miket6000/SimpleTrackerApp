import 'dart:typed_data';
import 'channels.dart';

// ============================
// Generic Setting Class
// ============================
class Setting<T> {
  final String commandChar;
  final String title;
  final String hint;
  final bool configurable;
  final Map<String, T>? options;
  T value;

  Setting({
    required this.commandChar,
    required this.title,
    required this.value,
    this.options,
    this.configurable = true,
    this.hint = '',
  });

  String serialize() => 'SET $commandChar ${_serializeValue()}';

  void deserialize(String input) {
    value = _parseValue(input);
  }

  String _serializeValue() => value.toString();

  T _parseValue(String input) {
    if (T == int) return int.parse(input) as T;
    if (T == double) return double.parse(input) as T;
    if (T == String) return input as T;
    throw UnsupportedError('Unsupported value type: $T');
  }

  @override
  String toString() => '$title ($commandChar): $value';
}

// ============================
// Unit Class
// ============================
class Unit {
  final String title;
  final double slope;
  final double offset;
  const Unit({required this.title, required this.slope, required this.offset});
}

// ============================
// Settings Definitions
// ============================
final Map<String, Setting> settings = {
  'f': Setting<int>(
    commandChar: 'f',
    title: 'Frequency',
    value: 434000,
    hint: 'The center frequency in kHz, must match on both transmitter and receiver.',
  ),
  's': Setting<int>(
    commandChar: 's',
    title: 'Spread Factor',
    value: 9,
    options: spreadingFactorOptions,
    hint: 'Length of chirp. Affects range and transmission time.',
  ),
  'b': Setting<int>(
    commandChar: 'b',
    title: 'Bandwidth',
    value: 6,
    options: bandwidthOptions,
    hint: 'Lower bandwidth increases range but reduces speed.',
  ),
  'c': Setting<int>(
    commandChar: 'c',
    title: 'CRC Rate',
    value: 1,
    options: codingRateOptions,
    hint: 'Error detection bits in CRC. Must match on both ends.',
  ),
  'd': Setting<int>(
    commandChar: 'd',
    title: 'Transmit Power',
    value: 0xFF,
    options: powerOptions,
    hint: 'Transmit power in dBm. Higher uses more power.',
  ),
  'o': Setting<int>(
    commandChar: 'o',
    title: 'Overcurrent Limit',
    value: 150,
    configurable: false,
    hint: 'Hard current limit to prevent brownout.',
  ),
  'p': Setting<int>(
    commandChar: 'p',
    title: 'Preamble Length',
    value: 8,
    hint: 'Longer preamble helps battery-powered receivers.',
  ),
};

// ============================
// Option Maps
// ============================
const Map<String, int> spreadingFactorOptions = {
  '7': 7,
  '8': 8,
  '9': 9,
  '10': 10,
  '11': 11,
  '12': 12,
};

const Map<String, int> bandwidthOptions = {
  '7.8kHz': 0,
  '10.4kHz': 1,
  '15.6kHz': 2,
  '20.8kHz': 3,
  '31.25kHz': 4,
  '41.7kHz': 5,
  '62.5kHz': 6,
  '125kHz': 7,
  '250kHz': 8,
  '500kHz': 9,
};

const Map<String, int> codingRateOptions = {
  '4_5': 1,
  '4_6': 2,
  '4_7': 3,
  '4_8': 4,
};

const Map<String, int> powerOptions = {
  '11dB': 0xF6,
  '14dB': 0xF9,
  '17dB': 0xFC,
  '20dB': 0xFF,
};

const Map<String, int> modeOptions = {
  'Receiver': 1,
  'Transmitter': 2,
};

// ============================
// Units Definitions
// ============================
const Map<String, Unit> units = {
  'Hz': Unit(title: 'Frequency', slope: 0.000001, offset: 0),
  'kHz': Unit(title: 'Frequency', slope: 0.001, offset: 0),
  'MHz': Unit(title: 'Frequency', slope: 1, offset: 0),
  'SF': Unit(title: 'Spreading Factor', slope: 1, offset: 0),
  'dBm': Unit(title: 'Power', slope: 1, offset: 0),
  'mA': Unit(title: 'Current', slope: 1, offset: 0),
  'A': Unit(title: 'Current', slope: 0.001, offset: 0),
  '': Unit(title: 'Count', slope: 1, offset: 0),
  'V': Unit(title: 'Voltage', slope: 1000, offset: 0),
  'm': Unit(title: 'Altitude', slope: 100, offset: 0),
  'ft': Unit(title: 'Altitude', slope: 30.48, offset: 0),
  'hPa': Unit(title: 'Pressure', slope: 100, offset: 0),
  'psi': Unit(title: 'Pressure', slope: 6894.75729, offset: 0),
  '°C': Unit(title: 'Temperature', slope: 100, offset: 0),
  '°F': Unit(title: 'Temperature', slope: 180, offset: 32),
  '-': Unit(title: 'Status', slope: 1, offset: 0),
};

void applyChannelPreset(Channel channel) {
  for (final entry in channel.presetValues.entries) {
    final setting = settings[entry.key];
    if (setting != null) {
      setting.value = entry.value;
    }
  }
}

// ============================
// Byte Swapping Utility
// ============================
int swapBytes(Uint8List bytes) {
  if (bytes.length == 1) return bytes[0].toInt();
  if (bytes.length == 2) {
    return (bytes[1].toInt() << 8) + bytes[0].toInt();
  }
  if (bytes.length == 4) {
    return (bytes[3].toInt() << 24) +
           (bytes[2].toInt() << 16) +
           (bytes[1].toInt() << 8) +
           bytes[0].toInt();
  }
  throw ArgumentError('Invalid number of bytes');
}
