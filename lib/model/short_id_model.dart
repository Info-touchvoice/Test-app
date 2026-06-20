enum ShortIdType {
  normal(prefix: 'ID', label: 'Normal ID'),
  short(prefix: 'SID', label: 'Short ID'),
  legend(prefix: 'LID', label: 'Legend ID'),
  premium(prefix: 'PID', label: 'Premium ID'),
  founder(prefix: 'FID', label: 'Founder ID'),
  event(prefix: 'EID', label: 'Event ID');

  const ShortIdType({
    required this.prefix,
    required this.label,
  });

  final String prefix;
  final String label;
}

class ShortIdModel {
  final ShortIdType type;
  final String value;

  const ShortIdModel({
    required this.type,
    required this.value,
  });

  String get displayText => '${type.prefix}:$value';

  static const normalSample = ShortIdModel(
    type: ShortIdType.normal,
    value: '52288',
  );

  static const shortSample = ShortIdModel(
    type: ShortIdType.short,
    value: '88',
  );

  static const legendSample = ShortIdModel(
    type: ShortIdType.legend,
    value: '1234',
  );

  static const premiumSample = ShortIdModel(
    type: ShortIdType.premium,
    value: '786',
  );

  static const founderSample = ShortIdModel(
    type: ShortIdType.founder,
    value: '1',
  );

  static const eventSample = ShortIdModel(
    type: ShortIdType.event,
    value: '2026',
  );

  static const samples = [
    normalSample,
    shortSample,
    legendSample,
    premiumSample,
    founderSample,
    eventSample,
  ];
}
