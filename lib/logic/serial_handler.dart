import '../models/tracker_data.dart';
import 'gps_parser.dart';

class SerialHandler {
  dynamic parse({required String command, required String response}) {
    final trimmed = response.trim();
    if (command == 'L') {
      // Local NMEA sentence
      final fix = GpsParser.parseGga(trimmed);
      if (fix != null) {
        return LocalResponse(fix: fix);
      } else {
        return UnknownResponse(raw: trimmed);
      }
    }
   
    if (command == 'R') {
      final lineParts = trimmed.split(" ");
      
      if (lineParts.length != 3) {
        return UnknownResponse(raw: trimmed);
      }

      final id = lineParts[0];
      final fix = GpsParser.parseGga(lineParts[1]);
      final rssi = int.tryParse(lineParts[2]);

      if (fix != null && rssi != null) {
        return RemoteResponse(remoteId: id, fix: fix, rssi: rssi);
      } else {
        return UnknownResponse(raw: trimmed);
      }      
    }
        
    if (command.startsWith("GET ")) {
      final key = command.split(" ").last;
      return SettingResponse(
        key: key,
        value: trimmed,
      );
    }

    if (command.startsWith("SET ")) {
      return CommandStatus(response: trimmed);

    }
    
    return UnknownResponse(raw: trimmed);
  }
}
