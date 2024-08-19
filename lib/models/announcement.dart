import 'package:cloud_firestore/cloud_firestore.dart';

class Announcement {
  final String id;
  final String message;
  final String subject;
  final DateTime date;

  Announcement({
    required this.id,
    required this.message,
    required this.subject,
    required this.date,
  });

  factory Announcement.fromFirestore(DocumentSnapshot doc) {
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

    return Announcement(
      id: data['id'] ?? '',
      message: data['message'] ?? '',
      subject: data['subject'] ?? '',
      date: dateTime,
    );
  }
}
