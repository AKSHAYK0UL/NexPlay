import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// class DeviceToken {
//   String token;
//   String nodeID;
//   DeviceToken({required this.token, required this.nodeID});
// }

class DeviceTokens with ChangeNotifier {
  final firebaseRef = FirebaseDatabase.instance.ref();
  List<String> deviceToken = [];

  Future<void> storeToken(String? token) async {
    final getnode = firebaseRef.child('Devicetokens').push();
    final nodekey = getnode.key;
    try {
      await getnode.set({'token': token});
    } catch (e) {
      rethrow;
    }
  }

  Future<void> fetchToken() async {
    firebaseRef.child('Devicetokens').orderByValue().onValue.listen((event) {
      List<String> tokenlist = [];
      final tok = event.snapshot.value as Map<dynamic, dynamic>;

      tok.forEach((key, value) {
        tokenlist.add(value['token'].toString());
      });
      deviceToken = tokenlist;
      print(deviceToken);
      notifyListeners();
    });
  }

  Future<void> sendNotification(String type, String name) async {
    for (var i = 0; i < deviceToken.length; i++) {
      var data = {
        'to': deviceToken[i].toString(),
        'priority': 'high',
        'notification': {
          'title': type,
          'body': name,
        },
        'data': {
          'type': 'msg',
          'id': '12345',
        },
      };
      await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
          body: jsonEncode(data),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization':
                'key=AAAAqPPs4Jo:APA91bH59KxBqQVKib8UToNY3_6RNA3A-vhYXS4zZEeBoaVtvlDBOoqHfk5K6gMPGqXckyKn_XnSI_BDkcMRHMXhAIdyC0TmPxofEo6NJyX5aD7G9tnI-ZF_VPN8VDN_Uap7V_Rd8n4w',
          });
    }
  }
}
