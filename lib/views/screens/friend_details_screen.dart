import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:friends/consts/assets.dart';
import 'package:friends/consts/colors.dart';
import 'package:friends/consts/styles.dart';
import 'package:friends/models/friend_model.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

// This screen is basically shows the selected friend information.
// Basically the friend information is coming from the parent screen.
// We can send email by clicking on the email and make call to the number by clicking on the number.

class FriendDetailsScreen extends StatelessWidget {
  final Results friend;
  const FriendDetailsScreen(this.friend, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: StyleConstant.linearGradient,
      ),
      child: Scaffold(
        backgroundColor: ColorConstants.transparent,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: ColorConstants.transparent,
            statusBarBrightness: Brightness.dark,
            statusBarIconBrightness: Brightness.light,
          ),
          leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: const Icon(Icons.keyboard_arrow_left)),
          centerTitle: true,
          title: Text(
            "${friend.name?.title ?? ""} ${friend.name?.first ?? ""} ${friend.name?.last ?? ""} ",
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white, fontSize: 24),
          ),
        ),
        body: Column(children: [
          CachedNetworkImage(
            imageBuilder: (context, imageProvider) => Container(
              height: 300,
              width: double.infinity,
              decoration: BoxDecoration(
                  image:
                      DecorationImage(image: imageProvider, fit: BoxFit.cover)),
            ),
            imageUrl: friend.picture?.large ?? AssetsConstant.defaultImage,
          ),
          Container(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 15,
                ),
                Text(
                  "${friend.location?.street?.number ?? ""} ${friend.location?.street?.name ?? ""}",
                  style: const TextStyle(color: Colors.black, fontSize: 16),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  "${friend.location?.city ?? ""} ${friend.location?.state ?? ""}",
                  style: const TextStyle(color: Colors.black, fontSize: 16),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  (friend.location?.postcode ?? "").toString(),
                  style: const TextStyle(color: Colors.black, fontSize: 16),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  (friend.location?.country ?? "").toString(),
                  style: const TextStyle(color: Colors.black, fontSize: 20),
                ),
                const SizedBox(
                  height: 25,
                ),
                GestureDetector(
                  onTap: () async {
                    String? encodeQueryParameters(Map<String, String> params) {
                      return params.entries
                          .map((MapEntry<String, String> e) =>
                              '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
                          .join('&');
                    }

                    final Uri emailLaunchUri = Uri(
                      scheme: 'mailto',
                      path: friend.email,
                      query: encodeQueryParameters(<String, String>{
                        'subject': '',
                      }),
                    );

                    if (await canLaunchUrl(emailLaunchUri)) {
                      launchUrl(emailLaunchUri);
                    } else {
                      throw Exception("Could Not Send Email");
                    }
                  },
                  child: Row(
                    children: [
                      const Icon(
                        Icons.email_outlined,
                        color: Colors.amber,
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Text(
                        friend.email ?? "abc@gmail.com",
                        style: const TextStyle(
                            decoration: TextDecoration.underline,
                            decorationColor: Colors.amber,
                            fontSize: 16,
                            color: Colors.amber),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                GestureDetector(
                  onTap: () async {
                    final Uri phoneLaunchUri = Uri(
                      scheme: 'tel',
                      path: friend.phone,
                    );

                    if (await canLaunchUrl(phoneLaunchUri)) {
                      launchUrl(phoneLaunchUri);
                    } else {
                      throw Exception("Could Not Send Email");
                    }
                  },
                  child: Row(
                    children: [
                      const Icon(
                        Icons.phone_android,
                        color: Colors.amber,
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Text(
                        friend.phone ?? "-----------",
                        style:
                            const TextStyle(fontSize: 16, color: Colors.amber),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                GestureDetector(
                  onTap: () async {
                    final Uri phoneLaunchUri = Uri(
                      scheme: 'tel',
                      path: friend.cell,
                    );

                    if (await canLaunchUrl(phoneLaunchUri)) {
                      launchUrl(phoneLaunchUri);
                    } else {
                      throw Exception("Could Not Send Email");
                    }
                  },
                  child: Row(
                    children: [
                      const Icon(
                        Icons.call,
                        color: Colors.amber,
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Text(
                        friend.cell ?? "----------",
                        style:
                            const TextStyle(fontSize: 16, color: Colors.amber),
                      )
                    ],
                  ),
                ),
              ],
            ),
          )
        ]),
      ),
    );
  }
}
