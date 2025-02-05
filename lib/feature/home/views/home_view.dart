import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/feature/audio/view/audio_player_view.dart';
import 'package:todo/feature/auth/view_models/auth_viewmodel.dart';
import 'package:todo/feature/home/view_models/home_viewmodel.dart';
import 'package:todo/feature/profile/view/ProfileView.dart';
import 'package:todo/feature/profile/view_models/profile_view_model.dart'; // Import the HomeViewModel
// Import the Content model

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int currentIndex = 0;
  bool isAudioPlayerVisible = false;
  String audioPlayerLink = '';
  String img = '';

  @override
  void initState() {
    super.initState();

    // Fetch home contents when the HomeView is first loaded
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    final user = authViewModel.user;
    final homeViewModel = Provider.of<HomeViewModel>(context, listen: false);

    // Check if user is authenticated
    if (authViewModel.isAuthenticated) {
      final userData = authViewModel.user;

      final userID = userData?.id ?? 1129;
      final companyId =
          userData?.companyId ?? "9e33daa0-10ac-4548-edea-08d9e9f0d10b";

      homeViewModel.getHomeContents(userID, companyId, context);
      homeViewModel.getBannerPics(companyId, context);
    }

    final profileViewModel =
        Provider.of<ProfileViewModel>(context, listen: false);
    void getImg() async {
      img = await profileViewModel.getProfilePic(user?.id ?? 1129);
    }

    getImg();
  }

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);
    final userData = authViewModel.user;

    if (!authViewModel.isAuthenticated) {
      return const Center(child: CircularProgressIndicator());
    }

    final homeViewModel = Provider.of<HomeViewModel>(context);
    final contents = homeViewModel.contents;

    ImageProvider getProfileImage() {
      if (img.isNotEmpty) {
        return MemoryImage(base64Decode(img));
      } else {
        return NetworkImage(userData!.profilePic);
      }  
    }

    return Scaffold(
      body: Stack(children: [
        Column(
          children: [
            Stack(
              children: [
                Container(
                  height: 200,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.blue, Colors.green],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                  ),
                ),
                Positioned(
                  top: 50,
                  left: 50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Fusion",
                            style: TextStyle(
                              fontSize: 25,
                              color: Colors.white,
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                userData?.fullName ?? "Mg Hlaing Aung",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              ),
                              const Icon(
                                Icons.check_circle,
                                color: Color(0xFF3e5dd6),
                              ),
                            ],
                          ),
                          const Text(
                            "Enjoy your work today.",
                            style: TextStyle(color: Colors.white),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Row(
                              children: [
                                Container(
                                  width: 100,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text("Course"),
                                      Text("20"),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Container(
                                  width: 100,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text("Events"),
                                      Text("10"),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 50),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Profileview()),
                          );
                        },
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: getProfileImage(),
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Inside your build method:
            SizedBox(
              height: 200,
              child: homeViewModel.banners != null &&
                      homeViewModel.banners!.isNotEmpty
                  ? PageView.builder(
                      onPageChanged: (index) {
                        setState(() {
                          currentIndex = index;
                        });
                      },
                      itemCount: homeViewModel.banners?.length ?? 0,
                      itemBuilder: (context, index) {
                        final banner = homeViewModel.banners![index];
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 5),
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(banner.orgImage),
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        );
                      },
                    )
                  : const Center(child: Text("No banners available")),
            ),

            const SizedBox(height: 5),

            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                    homeViewModel.banners?.length ?? 0,
                    (index) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: CircleAvatar(
                          backgroundColor: currentIndex == index
                              ? Colors.green
                              : Colors.grey,
                          radius: 5,
                        )))),
            //Display the content list
            Column(
              children: [
                Container(
                  padding: const EdgeInsets.only(right: 20),
                  child: const Text(
                    "Recent",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  height: 300,
                  child: homeViewModel.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : (contents == null || contents.isEmpty)
                          ? const Center(child: Text("No data available"))
                          : ListView.builder(
                              scrollDirection: Axis.vertical,
                              itemCount: homeViewModel.contents!.length,
                              itemBuilder: (context, index) {
                                final content = contents[index];
                                return Container(
                                  padding: const EdgeInsets.all(10),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.only(top: 15),
                                        margin: const EdgeInsets.only(
                                            left: 5, top: 5),
                                        width: 100,
                                        height: 150,
                                        decoration: BoxDecoration(
                                          color: Colors.grey,
                                          image: DecorationImage(
                                            image: NetworkImage(
                                                content.pictureBackground),
                                            fit: BoxFit.cover,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                      const SizedBox(width: 15),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              content.contentName,
                                              style: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            const SizedBox(height: 5),
                                            Text(
                                              content.wordDescription,
                                              maxLines: 3,
                                            ),
                                            const SizedBox(height: 5),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text("Youtube and Tiktok"),
                                                content.wordDescription
                                                        .contains("mp4")
                                                    ? Icon(
                                                        Icons.video_call_sharp,
                                                        color: Colors.green)
                                                    : content.wordDescription
                                                            .contains("mp3")
                                                        ? IconButton(
                                                            icon: Icon(Icons
                                                                .volume_up_outlined),
                                                            color: Colors.green,
                                                            onPressed: () {
                                                              setState(() {
                                                                isAudioPlayerVisible =
                                                                    true;
                                                                AudioPlayerView(
                                                                    songInformation:
                                                                        content);
                                                                // GoRouter.of(
                                                                //         context)
                                                                //     .go('/audio');
                                                                Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                    builder: (context) =>
                                                                        AudioPlayerView(
                                                                            songInformation:
                                                                                content),
                                                                  ),
                                                                );
                                                              });
                                                            },
                                                          )
                                                        : Icon(
                                                            Icons.description,
                                                            color:
                                                                Colors.green),
                                              ],
                                            ),
                                            const SizedBox(height: 5),
                                            LinearProgressIndicator(
                                                value: 0.7,
                                                color: Colors.green),
                                            const SizedBox(height: 5),
                                            Container(
                                                padding:
                                                    EdgeInsets.only(left: 120),
                                                child: Text(
                                                    'End Date: 21 sept 2024'))
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                )
              ],
            ),
          ],
        ),
      ]),
    );
  }
}
