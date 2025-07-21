import 'package:flutter/material.dart';
import '../logic/telemetry_tracker.dart';
import '../services/serial_service.dart';
import '../services/logging_service.dart';
import '../logic/serial_handler.dart';
import '../models/tracker_data.dart';
import '../models/telemetry_model.dart';
import '../logic/serial_poller.dart';
import 'dart:async';

class SerialProvider extends ChangeNotifier {
  final SerialService _serial = SerialService();
  final LoggingService _logger = LoggingService();
  final SerialHandler _handler = SerialHandler();

  bool _isConnected = false;
  final List<String> _rawLogs = [];
  final TelemetryTracker _tracker = TelemetryTracker();
  String? _remoteId;
  String? _lastCommand;
  Map<String, String> _settings = {};
  Timer? _portScanTimer;
  List<String> _availablePorts = [];
  String? _selectedPort;
  late SerialPoller _poller;

  SerialProvider() {
    _poller = SerialPoller(serial: this);
    _logger.init();
    _serial.onDataReceived = _handleIncomingData;
    _startPortScanner();
  }

  // Public state getters
  bool get isConnected => _isConnected && _serial.isOpen;
  List<String> get logs => List.unmodifiable(_rawLogs);
  TelemetryModel? get telemetry => _tracker.telemetry;
  String? get remoteId => _remoteId;
  Map<String, String> get settings => Map.unmodifiable(_settings);
  List<String> get availablePorts => _availablePorts;
  String? get selectedPort => _selectedPort;

  void selectPort(String? port) {
    _selectedPort = port;
    notifyListeners();
  }
 
  void connect() {
    if (selectedPort != null) {
      try {
        _isConnected = _serial.openPort(_selectedPort!, 115200);
        _poller.start();
        notifyListeners();
      } catch (e) {
        debugPrint("SerialPortError on connect(): $e");
      }
    }
  }

  void disconnect() {
    _poller.stop();   
    _serial.closePort();
    _isConnected = false;
    notifyListeners();
  }

  Future<void> sendCommand(String command) async {
    if (!_isConnected) return;

    try {
      _lastCommand = command.trim();
      _serial.send(command);
      final logLine = "> $_lastCommand";
      _rawLogs.add(logLine);
      await _logger.append(logLine);
      notifyListeners();
    } catch (e) {
      debugPrint("SerialPortError on send(): $e");
      disconnect();
    }
  }

  void _handleIncomingData(String raw) async {
    final logLine = "< $raw";
    _rawLogs.add(logLine);
    await _logger.append(logLine);

    if (_lastCommand != null) {
      final result = _handler.parse(command: _lastCommand!, response: raw);

      if (result is LocalResponse) {
        _tracker.updateLocal(result);
        //_rawLogs.add("% ${_lastLocalFix?.altitude.toString()}");
      } else if (result is RemoteResponse) {
        _tracker.updateRemote(result);
      } else if (result is SettingResponse) {
        
        //Thi is probably wrong, setting result will be 'OK' or 'ERR', fix later.
        _settings[result.key] = result.value;
        
      }

      _lastCommand = null; // clear after parsing
    } else {
      // No command context — fallback parsing?
    }

    notifyListeners();
  }

  void _startPortScanner() {
    _availablePorts = _serial.availablePorts;

    _portScanTimer = Timer.periodic(Duration(seconds: 2), (_) {
      final currentPorts = _serial.availablePorts;

      // Check if port list has changed
      final portListChanged = !_listEquals(currentPorts, _availablePorts);

      // Check if selected port is still valid
      final selectedPortStillExists = _selectedPort == null || currentPorts.contains(_selectedPort);

      if (portListChanged || !selectedPortStillExists) {
        _availablePorts = currentPorts;

        if (!selectedPortStillExists) {
          // Clean up connection and reset selected port
          _selectedPort = null;

          if (_isConnected) {
            try {
              _serial.closePort();
            } catch (e) {
              debugPrint('Error closing port: $e');
            } finally {
              _isConnected = false;
            }
          }
        }

        notifyListeners(); // Trigger UI rebuild
      }
    });
  }


  bool _listEquals(List<String> a, List<String> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  @override
  void dispose() {
    _portScanTimer?.cancel();
    super.dispose();
  }
}
