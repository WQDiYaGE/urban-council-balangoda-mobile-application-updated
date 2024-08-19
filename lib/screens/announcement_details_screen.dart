import 'package:flutter/material.dart';
import 'package:urban_council/models/announcement.dart';
import 'package:urban_council/utils/common_helper.dart';

class AnnouncementDetailsScreen extends StatelessWidget {
  final Announcement announcement;

  const AnnouncementDetailsScreen({super.key, required this.announcement});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('Announcement'),
          backgroundColor: Colors.white,
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(announcement.subject,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  )),
              Text(CommonHelper.getDateStartWithYear(announcement.date)!,
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                      color: Colors.grey[600])),
              const SizedBox(
                height: 20,
              ),
              Text(announcement.message,
                  style: const TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                  )),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ));
  }
}
