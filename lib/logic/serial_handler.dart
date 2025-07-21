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
      final lines = trimmed.split('\n').map((l) => l.trim()).toList();

//      if (lines.length < 2) {
//        return UnknownResponse(raw: trimmed);
//      }

      final line1Parts = lines[0].split(" ");
      
      if (line1Parts.length != 2) {
        return UnknownResponse(raw: trimmed);
      }

      final id = line1Parts[0];  
      final fix = GpsParser.parseGga(line1Parts[1]);
//      final rssi = int.tryParse(lines[1].split(':')[1]);
      final rssi = 0;

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
