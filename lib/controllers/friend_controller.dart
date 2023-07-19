import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:friends/models/friend_model.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

// This the controller class that basically call the api and update the view.

class FriendController extends GetxController {
  RxList<Results> friends = <Results>[].obs;
  RxBool isLoading = true.obs;

  final http.Client _client = http.Client();

  @override
  void onInit() {
    super.onInit();
    getFriends();
  }

  getFriends() async {
    try {
      isLoading.value = true;
      friends.value = [];
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult != ConnectivityResult.none) {
        int page = 1;
        Map<String, String> headers = {
          'Content-Type': 'application/json; charset=UTF-8'
        };
        for (page; page < 11; page++) {
          Uri uri = Uri.parse("https://randomuser.me/api/?page=$page");

          var response = await _client.get(
            uri,
            headers: headers,
          );

          var friend = Friend.fromJson(jsonDecode(response.body));

          friends.add(friend.results!.first);
        }
      }
    } catch (e, s) {
      if (kDebugMode) {
        print(e);
        print(s);
      }
    } finally {
      isLoading.value = false;
    }
  }
}
