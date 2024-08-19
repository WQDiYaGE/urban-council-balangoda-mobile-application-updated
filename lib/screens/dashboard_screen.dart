import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:urban_council/controllers/announcement_controller.dart';
import 'package:urban_council/controllers/news_controller.dart';
import 'package:urban_council/controllers/phone_authentication.dart';
import 'package:urban_council/controllers/user_controller.dart';
import 'package:urban_council/models/announcement.dart';
import 'package:urban_council/models/news.dart';
import 'package:urban_council/screens/announcement_details_screen.dart';
import 'package:urban_council/screens/announcement_screen.dart';
import 'package:urban_council/screens/news_screen.dart';
import 'package:urban_council/screens/phone_screen.dart';
import 'package:urban_council/screens/profile_screen.dart';
import 'package:urban_council/services/user_service.dart';
import 'package:urban_council/utils/common_helper.dart';
import 'package:urban_council/widgets/news_card.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // Access the user ID
  String? userId = UserService().userId;
  String userName = '';
  String profileImage = '';

  setUser() async {
    await UserController().handleLogin(userId!);
    setState(() {
      userName =
          '${UserService().currentUser.firstName} ${UserService().currentUser.lastName}';
      profileImage = UserService().currentUser.profileUrl;
    });
  }

  @override
  void initState() {
    setUser();
    super.initState();
  }

  final NewsController newsController = NewsController();
  final AnnouncementController announcementController =
      AnnouncementController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            StickyAppBar(name: userName, userImage: profileImage),
            const SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Latest News',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NewsScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      'View All',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ),
            StreamBuilder<List<News>>(
              stream: newsController.getNewsStreamHome(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No news available'));
                } else {
                  final newsForHome = snapshot.data!.toList();

                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: newsForHome
                          .map(
                            (news) => NewsCard(
                              news: news,
                            ),
                          )
                          .toList(),
                    ),
                  );
                }
              },
            ),
            // SingleChildScrollView(
            //   scrollDirection: Axis.horizontal,
            //   child: Row(
            //     children: [
            //       for (int i = 0; i < 4; i++)
            //         NewsCard(
            //           imageUrl:
            //               'https://st.depositphotos.com/1162190/2462/i/450/depositphotos_24622155-stock-photo-soccer-ball-stadium-light.jpg',
            //           title:
            //               'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nuhimenaeos.',
            //         ),
            //       const SizedBox(
            //         width: 15,
            //       )
            //     ],
            //   ),
            // ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Announcements',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w500),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const AnnouncementScreen(),
                              ),
                            );
                          },
                          child: const Text(
                            'View All',
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Expanded(
                      child: StreamBuilder<List<Announcement>>(
                        stream:
                            announcementController.getAnnouncementStreamHome(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(
                                child: Text('Error: ${snapshot.error}'));
                          } else if (!snapshot.hasData ||
                              snapshot.data!.isEmpty) {
                            return const Center(
                                child: Text('No announcements available'));
                          } else {
                            final announcementList = snapshot.data!;
                            return SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: Column(
                                children: announcementList
                                    .map(
                                      (announcement) => GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  AnnouncementDetailsScreen(
                                                announcement: announcement,
                                              ),
                                            ),
                                          );
                                        },
                                        child: Container(
                                          margin:
                                              const EdgeInsets.only(bottom: 10),
                                          alignment: Alignment.centerLeft,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 10),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              border: Border.all(
                                                  color: Colors.grey[400]!,
                                                  width: 1)),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SvgPicture.asset(
                                                  'assets/announce.svg'),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              Text(announcement.subject,
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 14,
                                                  )),
                                              Text(
                                                  CommonHelper
                                                      .getDateStartWithYear(
                                                          announcement.date)!,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize: 12,
                                                      color: Colors.grey[600])),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              Text(announcement.message,
                                                  maxLines: 3,
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                  ))
                                            ],
                                          ),
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

enum Menu { logout }

class StickyAppBar extends StatelessWidget {
  final String? userImage;
  final String name;

  const StickyAppBar({
    super.key,
    this.userImage,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    final PhoneAuthentication phoneAuthentication = PhoneAuthentication();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Row(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ProfileScreen()),
                  );
                },
                child: SizedBox(
                  width: 40,
                  height: 40,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: userImage != null
                        ? CachedNetworkImageProvider(userImage!)
                        : const AssetImage('assets/user.png')
                            as ImageProvider<Object>,
                    onBackgroundImageError: (_, __) =>
                        const AssetImage('assets/user.png')
                            as ImageProvider<Object>,
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Welcome',
                      style: TextStyle(
                        fontSize: 16,
                        height: 1,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      name,
                      maxLines: 1,
                      style: const TextStyle(
                        fontSize: 12,
                        height: 1,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuButton<Menu>(
                popUpAnimationStyle: AnimationStyle(),
                color: Colors.white,
                iconSize: 27,
                onSelected: (Menu item) {
                  switch (item) {
                    case Menu.logout:
                      print('logout');
                      break;
                    default:
                    // code to execute if variable doesn't match any case
                  }
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<Menu>>[
                  PopupMenuItem<Menu>(
                    value: Menu.logout,
                    child: ListTile(
                      leading: SvgPicture.asset('assets/logout.svg'),
                      title: Text(
                        'Log Out',
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                      onTap: () async {
                        await phoneAuthentication.logOutUser();
                        // Navigate to the dashboard
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const PhoneScreen()),
                          (Route<dynamic> route) => false,
                        );
                      },
                    ),
                  ),
                ],
                child: Container(
                  height: 36,
                  width: 40,
                  alignment: Alignment.centerRight,
                  child: const Icon(
                    Icons.more_vert,
                    size: 27,
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
            height: 1.2,
            decoration: BoxDecoration(
              color: Colors.grey[100],
            ))
      ],
    );
  }
}
