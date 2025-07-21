import 'dart:convert';
import 'package:flutter_libserialport/flutter_libserialport.dart';
import 'package:flutter/foundation.dart';

class SerialService {
  SerialPort? _port;
  SerialPortReader? _reader;
  void Function(String)? onDataReceived;

  final _decoder = Utf8Decoder(allowMalformed: true);

  bool get isOpen { 
    try {
      return _port?.isOpen ?? false; 
    } catch (e) {
      return false;
    }
  }

  List<String> get availablePorts => SerialPort.availablePorts;

  bool openPort(String portName, int baudRate) {
    if (!SerialPort.availablePorts.contains(portName)) {
      _port = null;
      return false;
    }
    _port = SerialPort(portName);

    final config = SerialPortConfig()
      ..baudRate = baudRate
      ..bits = 8
      ..stopBits = 1
      ..parity = SerialPortParity.none;

    if (!_port!.openReadWrite()) {
      _port = null;
      return false;
    }

    try {  
      _port!.config = config;
    } catch (error) {
      debugPrint(error.toString());
    }
    
    _reader = SerialPortReader(_port!);

    _reader!.stream.listen((Uint8List data) {
      final msg = _decoder.convert(data);
      onDataReceived?.call(msg);
    });

    return true;
  }

  void closePort() {
    _reader?.close();
    _port?.close();
    _port = null;
  }

  void send(String data) {
    if (_port?.isOpen ?? false) {
      _port!.write(utf8.encode(data));
    }
  }
}
