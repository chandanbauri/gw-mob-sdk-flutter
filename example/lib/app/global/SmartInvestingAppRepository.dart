import 'package:flutter/services.dart';
import 'package:rxdart/rxdart.dart';
import 'package:scgateway_flutter_plugin_example/app/global/SIConfigs.dart';
import 'package:flutter/material.dart';
import 'package:clipboard/clipboard.dart';
import 'package:scgateway_flutter_plugin/ScLoan.dart';
import 'package:scgateway_flutter_plugin/ScLoanResponses.dart';


class SmartInvestingAppRepository {
  SmartInvestingAppRepository._() {
    environment.forEach((element) {
      if (environment.isClosed) return;
      scGatewayConfig.value = element.scGatewayConfig;
      scLoanConfig.value = element.scLoanConfig;
    });
  }

  static SmartInvestingAppRepository? _singleton;
  factory SmartInvestingAppRepository.singleton() =>
      _singleton ??= SmartInvestingAppRepository._();

  final environment = BehaviorSubject.seeded(SIEnvironment.PRODUCTION);

  final siConfig = BehaviorSubject.seeded(SIConfig(loansUserId: "020896"));
  final scGatewayConfig = BehaviorSubject.seeded(ScGatewayConfig.prod());
  final scLoanConfig = BehaviorSubject.seeded(ScLoanConfig.prod());

  final smartInvestingUserId = BehaviorSubject<String?>.seeded(null);
  final customAuthToken = BehaviorSubject<String?>.seeded(null);

   //alert 
  Future<void> _showAlertDialog(String message, BuildContext context) async {
    // FlutterClipboard.copy(message);

    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('SDK response'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[Text("$message")],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
                onPressed: () {
                  FlutterClipboard.copy(message.toString());
                },
                child: Text('Copy'))
          ],
        );
      },
    );
  }

  //functions for loans - 

   Future<void> setupScLoans(BuildContext context) async {
    final envMeta = ScLoanConfig.prod();
    print("_setupScLoans ${envMeta.gatewayName}");
    print("_setupScLoans ${envMeta.environment}");
    try {
      final response = await SCLoans.setup(envMeta.environment, envMeta.gatewayName);
      print(response);
        _showAlertDialog(response ?? "no response", context);
    } on PlatformException catch (e) {
     _showAlertDialog(e.code, context);
    }
  }

  Future<void> apply(String interactionToken, BuildContext context) async {
    try {
      final response = await SCLoans.apply(interactionToken);
      print("this block is running");
      _showAlertDialog(response ?? "no response", context);
    } on PlatformException catch (e) {
     _showAlertDialog(e.code, context);
    }
  }

   Future<void> pay(String interactionToken, BuildContext context) async {
    try {
      final response = await SCLoans.pay(interactionToken);
      _showAlertDialog(response ?? "no response", context);
    } on PlatformException catch (e) {
         _showAlertDialog(e.code, context);
    }
  }

  Future<void> withdraw(String interactionToken, BuildContext context) async {
    try {
      final response = await SCLoans.withdraw(interactionToken);
      _showAlertDialog(response ?? "no response", context);
    } on PlatformException catch (e) {
     _showAlertDialog(e.code, context);
    }
  }

  Future<void> service(String interactionToken, BuildContext context) async {
    try {
      final response = await SCLoans.service(interactionToken);
      _showAlertDialog(response ?? "no response", context);
    } on PlatformException catch (e) {
     _showAlertDialog(e.code, context);
    }
  }


  dispose() {
    environment.close();
    scGatewayConfig.close();
    scLoanConfig.close();
    _singleton = null;
  }
}
