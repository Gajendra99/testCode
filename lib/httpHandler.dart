import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:xml2json/xml2json.dart';

class HttpHandler extends StatelessWidget {
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

  void getData() async {
    final xml2json = Xml2Json();
    try {
      var response = await http.post(
        Uri.parse(BaseURL),
        headers: <String, String>{
          'Content-Type': 'text/xml; charset=UTF-8',
          "SOAPAction":
              "http://Entity.com/AccuchekMobilityService/IAccuchekMobilityService/AuthenticateUserOnline",
        },
        body: xmlData,
      );

      xml2json.parse(response.body);
      print(xml2json.toBadgerfish());
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Center(
        child: ElevatedButton(
          onPressed: () => getData(),
          child: Text('Call API'),
        ),
      )),
    );
  }
}
