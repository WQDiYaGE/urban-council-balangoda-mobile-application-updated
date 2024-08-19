import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:urban_council/controllers/news_controller.dart';
import 'package:urban_council/models/news.dart';
import 'package:urban_council/screens/news_details_screen.dart';
import 'package:urban_council/utils/common_helper.dart';

class NewsScreen extends StatelessWidget {
  const NewsScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final NewsController newsController = NewsController();

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          'News',
          style: TextStyle(),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 15, bottom: 0, right: 15, left: 15),
        child: StreamBuilder<List<News>>(
          stream: newsController.getNewsStream(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No news available'));
            } else {
              final newsList = snapshot.data!.toList();
              return ListView.builder(
                  itemCount: newsList.length,
                  itemBuilder: (BuildContext context, int index) {
                    News news = newsList[index];

                    return Container(
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
                            height: 5,
                          ),
                          RichText(
                            text: TextSpan(
                              text: news.description,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors
                                    .black, // Set the default color for the description text
                              ),
                              children: <TextSpan>[
                                TextSpan(
                                  text: '.. Read More',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors
                                        .blue, // Set the color for the 'Read More' text
                                    fontWeight: FontWeight.bold,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              NewsDetailsScreen(
                                            news: news,
                                          ),
                                        ),
                                      );
                                    },
                                ),
                              ],
                            ),
                            maxLines: 3,
                            overflow: TextOverflow
                                .ellipsis, // Ensure the text is ellipsized after 3 lines
                          )
                        ],
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
