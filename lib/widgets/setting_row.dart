import 'package:flutter/material.dart';
import '../settings.dart';

class SettingRow<T> extends StatelessWidget {
  final Setting<T> setting;
  final void Function(T?) onChanged;

  const SettingRow({
    super.key,
    required this.setting,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    // Shared input decoration style
    const inputDecoration = InputDecoration(
      border: OutlineInputBorder(),
      isDense: true,
      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    );

    Widget inputWidget;

    if (setting.options != null) {
      // Dropdown for settings with options
      inputWidget = SizedBox(
        height: 48,
        child: InputDecorator(
          decoration: inputDecoration,
          child: DropdownButtonHideUnderline(
            child: DropdownButton<T>(
              isExpanded: true,
              isDense: true,
              value: setting.value,
              onChanged: setting.configurable ? onChanged : null,
              items: setting.options!.entries.map((entry) {
                return DropdownMenuItem<T>(
                  value: entry.value,
                  child: Text(entry.key),
                );
              }).toList(),
            ),
          ),
        ),
      );
    } else {
      // TextField for manual input
      inputWidget = SizedBox(
        height: 48,
        child: TextField(
          enabled: setting.configurable,
          controller: TextEditingController(text: setting.value.toString())
            ..selection = TextSelection.collapsed(offset: setting.value.toString().length),
          keyboardType: T == int
              ? TextInputType.number
              : T == double
                  ? const TextInputType.numberWithOptions(decimal: true)
                  : TextInputType.text,
          decoration: inputDecoration,
          onSubmitted: (text) {
            try {
              T parsed;
              if (T == int) {
                parsed = int.parse(text) as T;
              } else if (T == double) {
                parsed = double.parse(text) as T;
              } else {
                parsed = text as T;
              }
              onChanged(parsed);
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Invalid value for ${setting.title}')),
              );
            }
          },
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Setting Title
          Expanded(
            flex: 3,
            child: Text(
              setting.title,
              style: const TextStyle(fontSize: 16),
            ),
          ),

          // Input Field (Dropdown or TextField)
          Expanded(flex: 4, child: inputWidget),

          // Tooltip Icon
          Tooltip(
            message: setting.hint,
            waitDuration: const Duration(milliseconds: 500),
            child: const Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: Icon(Icons.info_outline, size: 20),
            ),
          ),
        ],
      ),
    );
  }
}
