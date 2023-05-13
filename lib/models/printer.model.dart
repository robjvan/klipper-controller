class Printer {
  final int id;
  final String ip;
  final String name;
  final bool hasWebcam;
  final bool hasSecondExtruder;
  final bool hasHeatedBed;
  final int maxExtruder0Temp;
  final int maxExtruder1Temp;
  final int maxBedTemp;
  // final int printerType;

  Printer({
    required this.id,
    required this.ip,
    required this.name,
    required this.hasWebcam,
    required this.hasSecondExtruder,
    required this.hasHeatedBed,
    required this.maxExtruder0Temp,
    required this.maxExtruder1Temp,
    required this.maxBedTemp,
    // required this.printerType,
  });

  Map<String, dynamic> toMap() => <String, dynamic>{
        'id': id,
        'ip': ip,
        'name': name,
        'hasWebcam': hasWebcam ? 1 : 0,
        'hasSecondExtruder': hasSecondExtruder ? 1 : 0,
        'hasHeatedBed': hasHeatedBed ? 1 : 0,
        'maxExtruder0Temp': maxExtruder0Temp,
        'maxExtruder1Temp': maxExtruder1Temp,
        'maxBedTemp': maxBedTemp,
      };

  @override
  String toString() =>
      'Printer{id: $id, ip: $ip, name: $name, hasWebcam: $hasWebcam, hasSecondExtruder: $hasSecondExtruder, hasHeatedBed: $hasHeatedBed, maxExtruder0Temp: $maxExtruder0Temp, maxExtruder1Temp: $maxExtruder1Temp, maxBedTemp: $maxBedTemp}';

  factory Printer.initial() => Printer(
        id: 0,
        ip: '',
        name: '',
        hasWebcam: false,
        hasSecondExtruder: false,
        hasHeatedBed: true,
        // printerType: 1,
        maxExtruder0Temp: 240,
        maxExtruder1Temp: 240,
        maxBedTemp: 100,
      );

  factory Printer.fromMap(final Map<String, dynamic> json) => Printer(
        id: json['id'],
        ip: json['ip'],
        name: json['name'],
        hasWebcam: json['hasWebcam'] == 1,
        hasSecondExtruder: json['hasSecondExtruder'] == 1,
        hasHeatedBed: json['hasHeatedBed'] == 1,
        // printerType: PrinterType.values.elementAt(json['printerType']),
        maxExtruder0Temp: json['maxExtruder0Temp'],
        maxExtruder1Temp: json['maxExtruder1Temp'],
        maxBedTemp: json['maxBedTemp'],
      );

  // Printer copyWith({
  //   final String? ip,
  //   final String? name,
  //   final bool? hasWebcam,
  //   final bool? hasSecondExtruder,
  //   final bool? hasHeatedBed,
  //   final PrinterType? printerType,
  //   final int? maxExtruder0Temp,
  //   final int? maxExtruder1Temp,
  //   final int? maxBedTemp,
  // }) =>
  //     Printer(
  //       ip: ip ?? this.ip,
  //       name: name ?? this.name,
  //       hasWebcam: hasWebcam ?? this.hasWebcam,
  //       hasSecondExtruder: hasSecondExtruder ?? this.hasSecondExtruder,
  //       hasHeatedBed: hasHeatedBed ?? this.hasHeatedBed,
  //       printerType: printerType ?? this.printerType,
  //       maxExtruder0Temp: maxExtruder0Temp ?? this.maxExtruder0Temp,
  //       maxExtruder1Temp: maxExtruder1Temp ?? this.maxExtruder1Temp,
  //       maxBedTemp: maxBedTemp ?? this.maxBedTemp,
  //     );
}
