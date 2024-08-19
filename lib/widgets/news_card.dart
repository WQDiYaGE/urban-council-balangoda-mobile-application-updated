import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:urban_council/models/news.dart';
import 'package:urban_council/screens/news_details_screen.dart';

class NewsCard extends StatelessWidget {
  final News news;

  const NewsCard({super.key, required this.news});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NewsDetailsScreen(
              news: news,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(left: 15),
        width: MediaQuery.of(context).size.width * 0.7,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                  height: 150,
                  width: double.infinity,
                  child: CachedNetworkImage(
                    imageUrl: news.imageUrls[0],
                    fit: BoxFit.cover,
                  )),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              news.title,
              maxLines: 3,
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w300,
                  color: Colors.grey[800]),
            )
          ],
        ),
      ),
    );
  }
}
