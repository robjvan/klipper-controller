// ignore_for_file: non_constant_identifier_names

class PreheatPresets {
  //! Change these values to alter preheat presets
  //* All temperatures are in degrees celsius

  static Map<String, int> ABS = <String, int>{
    'extruder': 205,
    'bedTemp': 95,
  };

  static Map<String, int> PETG = <String, int>{
    'extruder': 240,
    'bedTemp': 70,
  };

  static Map<String, int> PLA = <String, int>{
    'extruder': 205,
    'bedTemp': 55,
  };

  static Map<String, int> TPU = <String, int>{
    'extruder': 200,
    'bedTemp': 50,
  };

  static Map<String, int> NYLON = <String, int>{
    'extruder': 240,
    'bedTemp': 80,
  };
}
