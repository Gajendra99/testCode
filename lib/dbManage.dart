// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:path/path.dart';
// import 'package:sqflite/sqflite.dart';

// import 'dataModule.dart';

// class DBManage extends StatelessWidget {
//   // ignore: prefer_typing_uninitialized_variables
//   late final database;
//   void openDB() async {
//     database = openDatabase(
//       // Set the path to the database. Note: Using the `join` function from the
//       // `path` package is best practice to ensure the path is correctly
//       // constructed for each platform.
//       join(await getDatabasesPath(), 'SECUREHHU.db'),
//       // When the database is first created, create a table to store dogs.
//       onCreate: (db, version) {
//         // Run the CREATE TABLE statement on the database.
//         return db.execute(
//           'CREATE TABLE dogs(id INTEGER PRIMARY KEY, name TEXT, age INTEGER)',
//         );
//       },
//       // Set the version. This executes the onCreate function and provides a
//       // path to perform database upgrades and downgrades.
//       version: 1,
//     );
//   }

//   // Define a function that inserts dogs into the database
//   Future<void> insertDog(Consumer c) async {
//     // Get a reference to the database.
//     final db = await database;

//     // Insert the Dog into the correct table. You might also specify the
//     // `conflictAlgorithm` to use in case the same dog is inserted twice.
//     //
//     // In this case, replace any previous data.
//     await db.insert(
//       'dogs',
//       c.toMap(),
//       conflictAlgorithm: ConflictAlgorithm.replace,
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     openDB();
//     return Scaffold(
//         appBar: AppBar(title: Text('Database Access')),
//         body: Container(
//           child: Center(
//             child: ElevatedButton(
//                 onPressed: () async {
//                   print('Clicked');
//                   // Create a Dog and add it to the dogs table
//                   var fido = const Consumer(
//                     id: 0,
//                     name: 'Fido',
//                     age: 35,
//                   );

//                   await insertDog(fido);
//                 },
//                 child: Text(
//                   'Insert Data',
//                 )),
//           ),
//         ));
//   }
// }
