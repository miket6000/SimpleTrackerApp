import 'settings.dart';

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

// Example: Channel 1 = low-power config
final List<Channel> channels = [
  Channel(
    number: 0,
    name: 'Channel 0',
    presetValues: {
      'f': 433000,
      's': 9,
      'b': 6,
      'c': 1,
    },
  ),
  Channel(
    number: 1,
    name: 'Channel 1',
    presetValues: {
      'f': 433100,
      's': 9,
      'b': 6,
      'c': 1,
    },
  ),
  Channel(
    number: 2,
    name: 'Channel 2',
    presetValues: {
      'f': 433200,
      's': 9,
      'b': 6,
      'c': 1,
    },
  ),
  Channel(
    number: 3,
    name: 'Channel 3',
    presetValues: {
      'f': 433300,
      's': 9,
      'b': 6,
      'c': 1,
    },
  ),
  Channel(
    number: 4,
    name: 'Channel 4',
    presetValues: {
      'f': 433400,
      's': 9,
      'b': 6,
      'c': 1,
    },
  ),
  Channel(
    number: 5,
    name: 'Channel 5',
    presetValues: {
      'f': 433500,
      's': 9,
      'b': 6,
      'c': 1,
    },
  ),
  Channel(
    number: 6,
    name: 'Channel 6',
    presetValues: {
      'f': 433600,
      's': 9,
      'b': 6,
      'c': 1,
    },
  ),
  Channel(
    number: 7,
    name: 'Channel 7',
    presetValues: {
      'f': 433700,
      's': 9,
      'b': 6,
      'c': 1,
    },
  ),
  Channel(
    number: 8,
    name: 'Channel 8',
    presetValues: {
      'f': 433800,
      's': 9,
      'b': 6,
      'c': 1,
    },
  ),
  Channel(
    number: 9,
    name: 'Channel 9',
    presetValues: {
      'f': 433900,
      's': 9,
      'b': 6,
      'c': 1,
    },
  ),
  Channel(
    number: 10,
    name: 'Channel 10',
    presetValues: {
      'f': 434000,
      's': 9,
      'b': 6,
      'c': 1,
    },
  ),
  Channel(
    number: 11,
    name: 'Channel 11',
    presetValues: {
      'f': 434100,
      's': 9,
      'b': 6,
      'c': 1,
    },
  ),
  Channel(
    number: 12,
    name: 'Channel 12',
    presetValues: {
      'f': 434200,
      's': 9,
      'b': 6,
      'c': 1,
    },
  ),
  Channel(
    number: 13,
    name: 'Channel 13',
    presetValues: {
      'f': 434300,
      's': 9,
      'b': 6,
      'c': 1,
    },
  ),
  Channel(
    number: 14,
    name: 'Channel 14',
    presetValues: {
      'f': 434400,
      's': 9,
      'b': 6,
      'c': 1,
    },
  ),
  Channel(
    number: 15,
    name: 'Channel 15',
    presetValues: {
      'f': 434500,
      's': 9,
      'b': 6,
      'c': 1,
    },
  ),
  Channel(
    number: 16,
    name: 'Channel 16',
    presetValues: {
      'f': 434600,
      's': 9,
      'b': 6,
      'c': 1,
    },
  ),
  Channel(
    number: 17,
    name: 'Channel 17',
    presetValues: {
      'f': 434700,
      's': 9,
      'b': 6,
      'c': 1,
    },
  ),
  Channel(
    number: 18,
    name: 'Channel 18',
    presetValues: {
      'f': 434800,
      's': 9,
      'b': 6,
      'c': 1,
    },
  ),
  Channel(
    number: 19,
    name: 'Channel 19',
    presetValues: {
      'f': 434900,
      's': 9,
      'b': 6,
      'c': 1,
    },
  ),
  Channel(
    number: 20,
    name: 'Channel 20',
    presetValues: {
      'f': 435000,
      's': 9,
      'b': 6,
      'c': 1,
    },
  ),
  Channel(
    number: 21,
    name: 'Channel 21',
    presetValues: {
      'f': 435100,
      's': 9,
      'b': 6,
      'c': 1,
    },
  ),
  Channel(
    number: 22,
    name: 'Channel 22',
    presetValues: {
      'f': 435200,
      's': 9,
      'b': 6,
      'c': 1,
    },
  ),
  Channel(
    number: 23,
    name: 'Channel 23',
    presetValues: {
      'f': 435300,
      's': 9,
      'b': 6,
      'c': 1,
    },
  ),
  Channel(
    number: 24,
    name: 'Channel 24',
    presetValues: {
      'f': 435400,
      's': 9,
      'b': 6,
      'c': 1,
    },
  ),
  Channel(
    number: 25,
    name: 'Channel 25',
    presetValues: {
      'f': 435500,
      's': 9,
      'b': 6,
      'c': 1,
    },
  ),
  // Add up to 25 channels...
];
