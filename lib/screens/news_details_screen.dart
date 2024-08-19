import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:urban_council/models/news.dart';
import 'package:urban_council/utils/common_helper.dart';

class NewsDetailsScreen extends StatelessWidget {
  final News news;

  const NewsDetailsScreen({super.key, required this.news});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('News'),
          backgroundColor: Colors.white,
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(news.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    )),
                Text(CommonHelper.getDateStartWithYear(news.date)!,
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                        color: Colors.grey[600])),
                const SizedBox(
                  height: 20,
                ),
                for (int i = 0; i < news.imageUrls.length; i++)
                  Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: SizedBox(
                          height: 250,
                          child: CachedNetworkImage(
                            imageUrl: news.imageUrls[i],
                            placeholder: (context, url) => const Center(
                                child: CircularProgressIndicator()),
                            errorWidget: (context, url, error) => Container(
                              color: Colors.grey[100],
                              child: Center(
                                child: Text(
                                  'No Image',
                                  style: TextStyle(
                                      color: Colors.grey[500], fontSize: 14),
                                ),
                              ),
                            ),
                            fit: BoxFit.cover,
                          )),
                    ),
                  ),
                const SizedBox(
                  height: 10,
                ),
                Text(news.description,
                    style: const TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                    )),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on,
                      size: 18,
                    ),
                    const Text('Location : ',
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                        )),
                    Text(news.location,
                        style: const TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                        )),
                  ],
                ),
                const SizedBox(
                  height: 30,
                )
              ],
            ),
          ),
        ));
  }
}
