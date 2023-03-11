import 'dart:convert';
import 'dart:io';
import 'package:archive/archive.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ftpconnect/ftpconnect.dart';
import 'package:get/get.dart';
// import 'package:ssh2/src/sftp.dart';

import 'package:path_provider/path_provider.dart';
import 'package:ssh2/ssh2.dart';
import 'package:xml2json/xml2json.dart';

import 'get_user_list_online.dart';

class GetConsumerList extends StatelessWidget {
  String fileReadDataList = '';
  var isDataChanged = true.obs;
  final String BaseURL =
      "http://15.206.103.207:85/AccuchekServiceSetup/AccuchekMobilityService.svc";
  final String xmlData =
      '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:acc="http://Entity.com/AccuchekMobilityService/">'
      '<soapenv:Header/>'
      '<soapenv:Body>'
      '<acc:GetConsumerListBySupervisorID>'
      '<!--Optional:-->'
      '<acc:supervisorID>221901</acc:supervisorID>'
      '<!--Optional:-->'
      '<acc:hhuIMEINumber>866700047844343</acc:hhuIMEINumber>'
      '</acc:GetConsumerListBySupervisorID>'
      '</soapenv:Body>'
      '</soapenv:Envelope>';

  getData() async {
    final xml2json = Xml2Json();
    try {
      await onClickSFTP();
      //   Dio dio = Dio();
      //   // dio.options.method = 'SEARCH';
      //   // dio.options.responseType = ResponseType.plain;
      //   dio.options.headers = {
      //     // HttpHeaders.authorizationHeader: basicAuth,
      //     'content-Type': 'text/xml',
      //     "SOAPAction":
      //         "http://Entity.com/AccuchekMobilityService/IAccuchekMobilityService/GetConsumerListBySupervisorID",
      //   };
      //   String data = xmlData;

      //   var response = await dio.request(
      //     BaseURL,
      //     data: data,
      //     options: Options(method: 'POST'),
      //   );

      //   xml2json.parse(response.data);
      //   print(jsonDecode(xml2json.toBadgerfish()));

      // return GetUserListOnline.fromJson(jsonDecode(xml2json.toBadgerfish()));
    } catch (e) {
      print("the Error is : $e");
      throw Exception("$e");
    }
  }

  Future<String> createZipFile() async {
    // Create an archive object
    final archive = Archive();

    final directory = await getApplicationDocumentsDirectory();
    final directoryPath = directory.path;
    // Encode the archive to a ZIP file
    final zipFileBytes = ZipEncoder().encode(archive);

    // Save the ZIP file to disk
    final zipFile = File('${directory.path}/output.zip');
    await zipFile.writeAsBytes(zipFileBytes!);

    return zipFile.path;
  }

  Future<void> onClickSFTP() async {
    var zipPath = await createZipFile();
    print("Printing zip file path : $zipPath");

    final ftp = FTPConnect('14.142.32.3',
        user: 'ftpwebcdc', pass: 'computer@123', port: 22);
    await ftp.connect();
    await ftp.changeDirectory('/path/to/directory');
    final remoteFile = '/221901_866700047844343_hhuconsumerlist.zip';
    final localFile = File(zipPath.toString());
    await ftp.downloadFile(remoteFile, localFile);
    print('File downloaded at ${localFile.path}');
    // await ftp.disconnect();

    //decode zip file
    // Read the contents of the zip file into memory
    final bytes = File(zipPath).readAsBytesSync();

    // Decode the zip file into an archive object
    final archive = ZipDecoder().decodeBytes(bytes);

    // Extract each file from the archive
    String fileData = '';
    for (final file in archive) {
      final filename = file.name;
      final data = file.content as List<int>;
      final fileContent = utf8.decode(data);
      fileReadDataList = fileData;
      isDataChanged(!isDataChanged.value);
      print("Printing file content : \n $fileContent");
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    getData();
    // getData();

    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Obx(() => isDataChanged.value
            ? Text(fileReadDataList.toString())
            : Text(fileReadDataList.toString())),
      )),
    );
  }
}
