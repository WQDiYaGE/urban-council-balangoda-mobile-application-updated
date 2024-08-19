import 'package:cloud_firestore/cloud_firestore.dart';

class News {
  final String id;
  final String title;
  final String description;
  final String location;
  final DateTime date;
  final List<String> imageUrls;

  News({
    required this.id,
    required this.title,
    required this.description,
    required this.location,
    required this.date,
    required this.imageUrls,
  });

  factory News.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    // Handle the nested date field
    DateTime dateTime;
    if (data['date'] is Timestamp) {
      dateTime = (data['date'] as Timestamp).toDate();
    } else if (data['date'] is Map<String, dynamic>) {
      final int seconds = data['date']['seconds'];
      final int nanoseconds = data['date']['nanoseconds'];
      dateTime = DateTime.fromMillisecondsSinceEpoch(
          seconds * 1000 + nanoseconds ~/ 1000000);
    } else {
      dateTime = DateTime.now(); // fallback in case of unexpected structure
    }

    // Handle the imageUrls field
    List<String> imageUrls = [];
    if (data['imageUrls'] is List) {
      imageUrls = List<String>.from(data['imageUrls']);
    }

    return News(
      id: data['id'] ?? '',
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      location: data['location'] ?? '',
      date: dateTime,
      imageUrls: imageUrls,
    );
  }
}
