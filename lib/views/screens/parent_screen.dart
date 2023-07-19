import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:friends/consts/assets.dart';
import 'package:friends/consts/styles.dart';
import 'package:friends/controllers/friend_controller.dart';
import 'package:friends/models/friend_model.dart';
import 'package:friends/views/screens/friend_details_screen.dart';
import 'package:friends/views/widgets/shimmer_widget.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../consts/colors.dart';

// This is the parent screen or home screen that shows the list of 10 friends.
// During the loading time a shimmer is showed and then after that the list is shown.
// If the friend list is empty it shows an empty message.

class ParentScreen extends StatelessWidget {
  ParentScreen({super.key});

  final FriendController _friendController = Get.put(FriendController());

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(gradient: StyleConstant.linearGradient),
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
          leading: Container(),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                AssetsConstant.logo,
                scale: 12,
              ),
              const SizedBox(
                width: 10,
              ),
              Text("FRIENDS",
                  style: GoogleFonts.comicNeue(
                      fontSize: 24, fontWeight: FontWeight.w700)),
            ],
          ),
        ),
        body: Obx(() {
          if (_friendController.isLoading.value) {
            return GridView.builder(
              itemCount: 10,
              itemBuilder: (context, index) => const FriendListShimmer(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, mainAxisSpacing: 5),
            );
          }

          if (_friendController.friends.isEmpty) {
            return const Center(
              child: Text("No Friends Are Available"),
            );
          }
          return RefreshIndicator(
            onRefresh: () async {
              await _friendController.getFriends();
            },
            child: GridView.builder(
              itemCount: _friendController.friends.length,
              itemBuilder: (context, index) =>
                  FriendCard(_friendController.friends[index]),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, mainAxisSpacing: 5),
            ),
          );
        }),
      ),
    );
  }
}

class FriendCard extends StatelessWidget {
  final Results results;
  const FriendCard(this.results, {super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(() => FriendDetailsScreen(results));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 1.0, horizontal: 8),
        child: Card(
          shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.white.withOpacity(0.5)),
              borderRadius: BorderRadius.circular(15)),
          color: ColorConstants.gridColors[Random().nextInt(7)],
          child: Container(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CachedNetworkImage(
                      imageBuilder: (context, imageProvider) => Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                            image: DecorationImage(image: imageProvider),
                            borderRadius: BorderRadius.circular(30)),
                      ),
                      imageUrl: results.picture?.large ??
                          "https://randomuser.me/api/portraits/thumb/men/83.jpg",
                      placeholder: (context, url) =>
                          const CircularProgressIndicator(
                        color: Colors.white,
                      ),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                    const Icon(
                      Icons.keyboard_arrow_right,
                      color: Colors.white,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                Text(
                  "${results.name?.title ?? ""} ${results.name?.first ?? ""} ${results.name?.last ?? ""} ",
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: RichText(
                    text: TextSpan(children: [
                      const TextSpan(
                        text: "From",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      const WidgetSpan(
                          child: SizedBox(
                        width: 5,
                      )),
                      TextSpan(
                          text: results.location?.country ?? "",
                          style: const TextStyle(
                              color: Colors.white, fontSize: 16))
                    ]),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class FriendListShimmer extends StatelessWidget {
  const FriendListShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1.0, horizontal: 8),
      child: Card(
        shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.white.withOpacity(0.5)),
            borderRadius: BorderRadius.circular(15)),
        color: Colors.black.withOpacity(0.2),
        child: Container(
          height: 100,
          padding: const EdgeInsets.all(10),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomShimmerCircular(height: 50, width: 50),
                  SizedBox(
                    width: 50,
                    height: 50,
                  )
                ],
              ),
              SizedBox(
                height: 15,
              ),
              CustomShimmerRoundedRectangle(height: 15, width: 200),
              SizedBox(
                height: 15,
              ),
              CustomShimmerRoundedRectangle(height: 15, width: 150)
            ],
          ),
        ),
      ),
    );
  }
}
