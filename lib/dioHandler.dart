import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:xml2json/xml2json.dart';

import 'get_user_list_online.dart';

class DioHandler extends StatelessWidget {
  final String BaseURL =
      "http://15.206.103.207:85/AccuchekServiceSetup/AccuchekMobilityService.svc";
  final String xmlData =
      '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:acc="http://Entity.com/AccuchekMobilityService/">'
      '<soapenv:Header/>'
      '<soapenv:Body>'
      '<acc:AuthenticateUserOnline>'
      ' <!--Optional:-->'
      '  <acc:userID>919191</acc:userID>'
      '   <!--Optional:-->'
      '    <acc:password>9191</acc:password>'
      '     <!--Optional:-->'
      '      <acc:hhuIMEINumber>352326101930264</acc:hhuIMEINumber>'
      '    </acc:AuthenticateUserOnline>'
      '  </soapenv:Body>'
      '</soapenv:Envelope>';

  Future<GetUserListOnline> getData() async {
    final xml2json = Xml2Json();
    try {
      Dio dio = Dio();
      // dio.options.method = 'SEARCH';
      // dio.options.responseType = ResponseType.plain;
      dio.options.headers = {
        // HttpHeaders.authorizationHeader: basicAuth,
        'content-Type': 'text/xml',
        "SOAPAction":
            "http://Entity.com/AccuchekMobilityService/IAccuchekMobilityService/AuthenticateUserOnline",
      };
      String data = xmlData;

      var response = await dio.request(
        BaseURL,
        data: data,
        options: Options(method: 'POST'),
      );

      xml2json.parse(response.data);
      return GetUserListOnline.fromJson(jsonDecode(xml2json.toBadgerfish()));
    } catch (e) {
      print("the Error is : $e");
      throw Exception("$e");
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    Future<GetUserListOnline> fetchAlbum = getData();

    return Scaffold(
      body: SafeArea(
          child: Center(
              child: FutureBuilder<GetUserListOnline>(
        future: fetchAlbum,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Text(snapshot.data!.responseStatus.toString());
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }

          // By default, show a loading spinner.
          return const CircularProgressIndicator();
        },
      ))),
    );
  }
}
