import '../settings.dart';
import 'package:flutter/material.dart';
import '../widgets/setting_row.dart';
import '../channels.dart';

final GlobalKey<SettingPageState> settingPageKey = GlobalKey<SettingPageState>(); 

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});
  @override
  State<SettingPage> createState() => SettingPageState();
}

class SettingPageState extends State<SettingPage> {
  int? selectedChannelIndex;

  void updateSettings() {
    setState(() {});
  }

  void erase() {
    setState(() {});
  }

  void factoryReset() {
    setState(() {});
  }

  void update() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final settingRows = settings.entries
        .map((entry) => SettingRow(
              setting: entry.value,
              onChanged: (newVal) {
                setState(() {
                  if (newVal != null) entry.value.value = newVal;
                });
              },
            ))
        .toList();

    return 
      Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 800),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: ListView(
              children : [
                DropdownButton<int>(
                  value: selectedChannelIndex,
                  hint: const Text("Select Channel"),
                  items: channels.map((channel) {
                    return DropdownMenuItem<int>(
                      value: channel.number,
                      child: Text(channel.name),
                    );
                  }).toList(),
                  onChanged: (index) {
                    final channel = channels.firstWhere((c) => c.number == index);
                    setState(() {
                      selectedChannelIndex = index;
                      applyChannelPreset(channel);
                    });
                  },
                ),                    
        
                ...settingRows,
              
                Flex(
                  direction: Axis.horizontal,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [

                    ElevatedButton (
                      onPressed: factoryReset, 
                      child: const Text("Factory Reset"),
                    ),
                          
                    ElevatedButton(
                      onPressed: updateSettings, 
                      child: const Text("Upload Settings"),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
    );
  }
}