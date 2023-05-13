import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:klipper_controller/controllers/app_state.controller.dart';
import 'package:klipper_controller/models/models.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class LocalIOService {
  static late final Database database;

  /// Opens a connection to the local DB
  static Future<void> openDB() async {
    database = await openDatabase(
      /// Set the path to the DB
      join(await getDatabasesPath(), 'printers.db'),

      /// When the DB is first created, create a table to store our printers
      onCreate: (final Database db, final int version) {
        /// Run script to create DB
        db.execute(
          'CREATE TABLE printers(id INTEGER PRIMARY KEY, ip TEXT, name TEXT, hasWebcam INTEGER, hasSecondExtruder INTEGER, hasHeatedBed INTEGER, maxExtruder0Temp INTEGER, maxExtruder1Temp INTEGER, maxBedTemp INTEGER)',
        );
      },
      version: 1,
    );
  }

  /// Creates a new record in the printer table
  static Future<void> insertPrinter(final Printer printer) async {
    late Map<String, dynamic> printerMap;

    try {
      printerMap = printer.toMap();

      // final int result = await database.insert(
      await database.insert(
        'printers',
        printerMap,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      // print('Printer record saved to local DB.  ID: $result');
    } on Exception catch (_) {
      log('Error saving printer to local DB');
      // print(err);
    }
  }

  /// Removes a new record in the printer table
  static Future<void> removePrinter(final Printer printer) async {
    try {
      // final int result = await database.delete(
      await database.delete(
        'printers',
        where: 'id = ?',
        whereArgs: <dynamic>[printer.id],
      );
      // print(
      //   'Printer record with ID ${printer.id} removed from local DB. Rows affected: $result',
      // );
    } on Exception catch (_) {
      debugPrint('Error removing printer from local DB');
      // print(err);
    }
  }

  // Grabs the printers from the DB and adds them to AppStateContoller.availablePrinters
  static Future<void> grabPrintersFromDB() async {
    /// Grab all printer documents from the DB
    final List<Map<String, dynamic>> results = await database.query('printers');

    if (results.isNotEmpty) {
      for (final Map<String, dynamic> element in results) {
        /// Convert each document map to a Printer object
        final Printer newPrinter = Printer.fromMap(element);

        /// Check if printer is already in the AppState list
        final bool alreadyExists = AppStateController.availablePrinters
            .any((final Printer printer) => printer.ip == newPrinter.ip);

        if (!alreadyExists) {
          /// Add to the AppState list
          AppStateController.availablePrinters.add(newPrinter);
        }
      }
    }
  }

  /// Loads app data from local storage.
  static void loadLocalData() {
    // TODO(Rob): Create loadLocalData() logic

    /// Load printers from SQLite
    /// Use loaded data to populate AppState.availablePrinters

    /// Load user prefs from Getstorage
    /// Use loaded data to apply user prefs

    // 1. Get local file
    // 2. Check for data
    // 3. Load/process data into controllers
  }

  /// Saves app data to local storage for persistence.
  /// This includes user preferences
  static void saveLocalData() {
    // TODO(Rob): Create saveLocalData() logic

    /// Save printers to SQLite
    /// Convert AppState.availablePrinters into map

    /// Save user prefs using Getstorage

    // 1. Get local file
    // 2. Overwrite any previous data
    // 3. Double-check save was successful?
  }
}
