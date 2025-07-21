import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/serial_provider.dart';
import '../widgets/serial_display.dart';

class TerminalScreen extends StatefulWidget {
  @override
  _TerminalScreenState createState() => _TerminalScreenState();
}

class _TerminalScreenState extends State<TerminalScreen> {
  final TextEditingController controller = TextEditingController();
  final FocusNode focusNode = FocusNode();
  
  @override
  void dispose() {
    controller.dispose();
    focusNode.dispose(); // ✅ Clean up properly
    super.dispose();
  }

  void _sendCommand(SerialProvider serial, TextEditingController controller) {
    if (serial.isConnected) {
      try {
        serial.sendCommand("${controller.text}\n");
        controller.clear();
      } catch (e) {
        debugPrint("SerialPortError in _sendCommand(): $e");
      }
    }  
  }

  @override
  Widget build(BuildContext context) {
    final serial = Provider.of<SerialProvider>(context);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(children: [
            DropdownButton<String>(
              hint: Text("Select Port"),
              value: serial.selectedPort,
              items: serial.availablePorts
                  .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                  .toList(),
              onChanged: (value) {
                serial.selectPort(value);
              },
            ),
            SizedBox(width: 16),
            ElevatedButton(
              onPressed: serial.isConnected
                  ? serial.disconnect
                  : () {
                      serial.connect();
                    },
              child: Text(serial.isConnected ? "Disconnect" : "Connect"),
            )
          ]),
          SizedBox(height: 16),
          Row(children: [
            Expanded(
              child: TextField(
                controller: controller,
                focusNode: focusNode,
                onSubmitted: (_) {
                  Future.microtask(() {
                    _sendCommand(serial, controller);
                    if (!Platform.isAndroid && !Platform.isIOS) {
                      focusNode.requestFocus();
                    }                    
                  });
                },
                decoration: InputDecoration(hintText: "Type command"),
              ),
            ),
            SizedBox(width: 8),
            ElevatedButton(
              onPressed: () => _sendCommand(serial, controller),
              child: Text("Send"),
            )
          ]),
          SizedBox(height: 16),
          Expanded(
            child: SerialDisplay(logs: serial.logs), 
          )
        ],
      ),
    );
  }
}
