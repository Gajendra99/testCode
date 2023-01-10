import 'dart:io';
import 'package:demo/dbManage.dart';
import 'package:demo/dioHandler.dart';
import 'package:demo/httpHandler.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:xml2json/xml2json.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:get/get.dart';

void main() {
  runApp(const MyApp());
}

late final database;

var isChanged = false.obs;

var consumerList = [].obs;

void getDB() async {
  var databasesPath = await getDatabasesPath();
  String path = join(databasesPath, 'SECUREHHU.db');

  final exists = await databaseExists(path);

  if (exists) {
    print('Database Exists');
    database = await openDatabase(path);
  } else {
    print('Database not found');
    try {
      await Directory(dirname(path)).create(recursive: true);
      ByteData data = await rootBundle.load(join('assets', 'SECUREHHU.db'));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      await File(path).writeAsBytes(bytes, flush: true);
      database = await openDatabase(path);
    } catch (e) {
      print('try catch error : $e');
    }
  }
}

void getDbList() async {
  List<Map> list = await database.rawQuery('SELECT * FROM T_ACM_IC_CONSINFO');
  print('List length: ${list.length}');
  list.map((index) {
    print(index.toString());
    print(list[0].toString());
  });
  print(list);
  consumerList.value = list;

  isChanged.value = !isChanged.value;
  // print(expectedList);
}

// Insert some records in a transaction
void insertIntoDB(String id) async {
  await database.transaction((txn) async {
    int id1 = await txn.rawInsert(
        'INSERT INTO T_ACM_IC_CONSINFO VALUES($id, "Gajendra somawat","Batharda Khurd","Udaipur", "Rajasthan","SN 300568", "Urban","Round", "udaipur","Bhatewar","RC Menaria","987654321","57392","152.05","KV","20/12/2022","29/12/2022",1,1,"None",1,1,0)');
    print('inserted1: $id1');
  });

  getDbList();
  isChanged.value = !isChanged.value;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // home: const MyHomePage(title: 'Flutter Demo Home Page'),
      home: HttpHandler(),
      // home: DBManage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // late Future<Album> futureAlbum;
  int id = 200;
  @override
  Widget build(BuildContext context) {
    // futureAlbum = fetchAlbum();
    getDB();
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        height: Get.height,
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () => {
                insertIntoDB(id.toString()),
                id = id + 1,
              },
              child: Text('Insert Into DB'),
            ),
            SizedBox(
              height: Get.height - 150,
              child: isChanged.value
                  ? ListView.builder(
                      itemCount: consumerList.length,
                      itemBuilder: (context, index) => Text(context.toString()),
                    )
                  : ListView.builder(
                      itemCount: consumerList.length,
                      itemBuilder: (context, index) => Text(context.toString()),
                    ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {
          // futureAlbum = fetchAlbum(),
          getDB(),
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
