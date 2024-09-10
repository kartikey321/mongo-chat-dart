// This file is part of the mongo_chat_dart package.
// 
// Licensed under the BSD 3-Clause License. See the LICENSE file in the root directory
// of this source tree for more information.
import 'package:mongo_dart/mongo_dart.dart';

/// A configuration class to manage MongoDB connections using mongo_dart.
///
/// This class provides methods to initialize and close the MongoDB connection.
/// It encapsulates the [Db] instance and handles connection-related operations.
class MongoConfig {
  late String _mongoUrl;
  late Db _db;

  /// Constructs a [MongoConfig] instance with a given MongoDB connection URL.
  ///
  /// The [mongoUrl] parameter is the MongoDB connection string.
  MongoConfig(String mongoUrl) {
   _mongoUrl=mongoUrl;
   
  }

  /// Returns the instance of [Db] to interact with MongoDB.
  ///
  /// This method provides access to the underlying [Db] object for direct MongoDB operations.
  Db getInstance() => _db;

  /// Initializes the MongoDB connection.
  ///
  /// Opens a connection to the MongoDB server. Should be called before performing any database operations.
  /// Throws an exception if the connection fails.
  Future<void> initialize() async {
    try {
       _db =await Db.create(_mongoUrl);
      await _db.open();
      print('MongoDB connection opened successfully.');
    } catch (e) {
      print('Failed to open MongoDB connection: $e');
      rethrow; // Re-throw the exception after logging
    }
  }

  /// Closes the MongoDB connection.
  ///
  /// Safely closes the connection to the MongoDB server.
  /// Throws an exception if closing the connection fails.
  Future<void> close() async {
    try {
      await _db.close();
      print('MongoDB connection closed successfully.');
    } catch (e) {
      print('Failed to close MongoDB connection: $e');
      rethrow; // Re-throw the exception after logging
    }
  }
}
