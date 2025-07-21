import 'package:gps_tracker/models/gps_fix.dart';

class LocalResponse {
  final GpsFix fix;
  LocalResponse({required this.fix});
}

class RemoteResponse {
  final String remoteId;
  final GpsFix fix;
  final int rssi;
  RemoteResponse({required this.remoteId, required this.fix, required this.rssi});
}

class SettingResponse {
  final String key;
  final String value;
  SettingResponse({required this.key, required this.value});
}

class CommandStatus {
  final String response;
  CommandStatus({required this.response});
}

class UnknownResponse {
  final String raw;
  UnknownResponse({required this.raw});
}
