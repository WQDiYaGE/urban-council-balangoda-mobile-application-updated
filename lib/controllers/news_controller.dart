import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:urban_council/models/news.dart';

class NewsController {
  final CollectionReference newsCollection =
      FirebaseFirestore.instance.collection('news');

  Stream<List<News>> getNewsStream() {
    return newsCollection.snapshots().map((QuerySnapshot snapshot) {
      return snapshot.docs.map((doc) {
        return News.fromFirestore(doc);
      }).toList();
    });
  }

  Stream<List<News>> getNewsStreamHome() {
    return newsCollection
        .limit(5) // Limit to the latest 5 items
        .snapshots()
        .map((QuerySnapshot snapshot) {
      return snapshot.docs.map((doc) {
        return News.fromFirestore(doc);
      }).toList();
    });
  }
}
