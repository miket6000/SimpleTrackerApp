import 'dart:async';
import '../providers/serial_provider.dart'; // or SerialService, if you're going lower level

class SerialPoller {
  final SerialProvider serial;
  Timer? _timer;
  
  SerialPoller({required this.serial});

  void start() {
    // Start polling 'L' every 1 second
    int tick = 0;
    _timer = Timer.periodic(Duration(seconds: 1), (_) {
      if (!serial.isConnected) {
        stop();
      } else {
        tick++;
        if (tick % 2 == 0) {
          serial.sendCommand('L\n');
        } else {
          serial.sendCommand('R\n');
        }
      }
    });
  }

  void stop() {
    _timer?.cancel();
  }

  bool get isPolling => _timer?.isActive == true;
}
