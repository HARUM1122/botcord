import 'package:http/http.dart';
import 'package:nyxx/nyxx.dart';

import 'dart:async';

Future<void> login(String token) async {
    runZonedGuarded(
      () async {
        NyxxGateway client = await Nyxx.connectGateway(token, GatewayIntents.all);
      }, 
      (error, stack) {
        if (error is ClientException) {
          print("CLIENT EXCEPTION");
        }
        print(error);
      }
    );
  }

void main() {
  login('MTAxMzcxMTEzMjIzMTQ4NzUwOA.GTeo5Z.sRn3kXiGGmxgHW-_4kObi_IfJzzWJeiB9w09_k');
}