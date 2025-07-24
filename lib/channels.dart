const baseFrequencykHz = 434000;
const channelSpacingkHz = 100;

class Channel {
  final int number;
  final String name;
  final Map<String, dynamic> presetValues;

  const Channel({
    required this.number,
    required this.name,
    required this.presetValues,
  });
}

final List<Channel> channels = List.generate(25, (i) { 
  final freq = baseFrequencykHz + channelSpacingkHz * i;
  return Channel (
    number: i,
    name: "CH$i (${(freq/1000).toStringAsFixed(3)} Mhz)", 
    presetValues: {
      'f': freq,
      's': 9,
      'b': 6,
      'c': 1
    }
  );
});
