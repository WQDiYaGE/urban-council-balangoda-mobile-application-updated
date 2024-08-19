import 'package:flutter/material.dart';
import 'package:urban_council/controllers/announcement_controller.dart';
import 'package:urban_council/models/announcement.dart';
import 'package:urban_council/screens/announcement_details_screen.dart';
import 'package:urban_council/utils/common_helper.dart';

class AnnouncementScreen extends StatelessWidget {
  const AnnouncementScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final AnnouncementController announcementController =
        AnnouncementController();

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          'Announcement',
          style: TextStyle(),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 15, bottom: 0, right: 15, left: 15),
        child: StreamBuilder<List<Announcement>>(
          stream: announcementController.getAnnouncementStream(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No news available'));
            } else {
              final announcementList = snapshot.data!.toList();
              return ListView.builder(
                  itemCount: announcementList.length,
                  itemBuilder: (BuildContext context, int index) {
                    Announcement announcement = announcementList[index];

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AnnouncementDetailsScreen(
                              announcement: announcement,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.white,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(announcement.subject,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                )),
                            Text(
                                CommonHelper.getDateStartWithYear(
                                    announcement.date)!,
                                style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12,
                                    color: Colors.grey[600])),
                            const SizedBox(
                              height: 5,
                            ),
                          ],
                        ),
                      ),
                    );
                  });
            }
          },
        ),
      ),
    );
  }
}
