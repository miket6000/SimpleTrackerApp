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
    const double widgetWidth = 400;
    bool wideScreen = MediaQuery.sizeOf(context).width > (widgetWidth * 2);
    int? selectedChannelIndex;

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
      SingleChildScrollView(child:
      Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
        children: [
        Flex(
          direction: wideScreen ? Axis.horizontal : Axis.vertical,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
             Container(
                constraints: const BoxConstraints(maxWidth: widgetWidth, maxHeight: 600),
                child: Column( 
                  children:[
                    const Text("SimpleTracker Settings"),
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
                  ]
                ),
              ),
          ]   
        ),
        Flex(
          direction: wideScreen ? Axis.horizontal : Axis.vertical,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.end,
          children:[
            Row(
              //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //crossAxisAlignment: CrossAxisAlignment.end,
              children:[
                ElevatedButton(
                  onPressed: factoryReset, 
                  child: const Text("Factory Reset"),
                ),
                const SizedBox(width:60),
                ElevatedButton(
                  onPressed: updateSettings, 
                  child: const Text("Upload Settings"),
                ),
              ]
            ),
          ],
        ),
        ]
      )
      )
    );
  }

}