import 'package:flutter/material.dart';
import 'package:gps_tracker/logic/geo_tools.dart';
import 'package:gps_tracker/models/gps_fix.dart';
import 'package:intl/intl.dart';
import '../widgets/datatile.dart';
import '../widgets/status_bar.dart';
import 'package:provider/provider.dart';
import '../providers/serial_provider.dart';
import '../widgets/location_qr_widget.dart';

class OverviewScreen extends StatefulWidget {
  const OverviewScreen({super.key});

  @override
  OverviewScreenState createState() => OverviewScreenState();
}

class OverviewScreenState extends State<OverviewScreen> {
    
  DateTime lastMessageTime = DateTime.now();
  double altOffset = 0.0;

  toggleAbsoluteAlt(GpsFix? remoteFix) {
    if (altOffset > 0.0) {
      altOffset = 0.0;
    } else {
      if (remoteFix?.altitude != null) {
        altOffset = remoteFix!.altitude!;
      }
    }
  }
 
  @override
  Widget build(BuildContext context) {
    final serial = Provider.of<SerialProvider>(context);
    final telemetry = serial.telemetry;
    final remoteFix = telemetry?.remoteFix;
    final int crossAxisCount = MediaQuery.of(context).size.width > 650 ? 3 : 1; // For mobile
    final List dataTiles = [
      //DataTile(title: "Time",               value: remoteFix?.timestamp != null ? DateFormat("HH:mm:ss").format(remoteFix!.timestamp) : null),
      DataTile(title: "Time",               value: serial.telemetry?.localFix.timestamp != null ? DateFormat("HH:mm:ss").format(telemetry!.localFix.timestamp!) : null),
      DataTile(title: "RSSI",               value: telemetry?.rssi != null ? "${telemetry?.rssi}" : null),
      DataTile(title: "Altitude",           value: remoteFix?.altitude != null ? "${(remoteFix!.altitude! - altOffset).toStringAsFixed(1)} m" : null, onPressed: () => toggleAbsoluteAlt(remoteFix)),
      DataTile(title: "Latitude",           value: remoteFix?.latitude != null ? remoteFix!.latitude!.toStringAsFixed(4) : null),
      DataTile(title: "Longitude",          value: remoteFix?.longitude != null ? remoteFix!.longitude!.toStringAsFixed(4) : null),
      DataTile(title: "Vertical Velocity",  value: telemetry?.verticalVelocity != null ? "${telemetry!.verticalVelocity!.toStringAsFixed(2)} m/s" : null),
      DataTile(title: "Bearing",            value: telemetry?.bearing != null ? "${telemetry!.bearing!.toStringAsFixed(0)} deg (${bearingToCompass(telemetry.bearing)})" : null),
      DataTile(title: "Distance",           value: telemetry?.distance != null ? "${telemetry!.distance!.toStringAsFixed(2)} m" : null),
      DataTile(title: "Elevation",          value: telemetry?.elevation != null ? "${telemetry!.elevation!.toStringAsFixed(2)} deg" : null),
    ];
  
    return Scaffold(
      body: 
      SingleChildScrollView(
      //child: Padding(
      //  padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
             GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                mainAxisExtent: 100, // Set fixed height for each item
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              itemCount: dataTiles.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) { 
                  return dataTiles[index];
              },
            ),
            SizedBox(height:20),

            LocationQrWidget(latitude: remoteFix?.latitude, longitude: remoteFix?.longitude),
 
          ],
        ),
      ),
    bottomNavigationBar: StatusBar(
      isGpsFix: (remoteFix?.hasFix ?? false) && serial.isConnected, 
      isConnected: serial.isConnected),
    );
  }
}

