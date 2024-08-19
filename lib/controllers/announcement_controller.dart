import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:urban_council/models/announcement.dart';

class AnnouncementController {
  final CollectionReference announcementCollection =
      FirebaseFirestore.instance.collection('announcements');

  Stream<List<Announcement>> getAnnouncementStream() {
    return announcementCollection.snapshots().map((QuerySnapshot snapshot) {
      return snapshot.docs.map((doc) {
        return Announcement.fromFirestore(doc);
      }).toList();
    });
  }

  Stream<List<Announcement>> getAnnouncementStreamHome() {
    return announcementCollection
        .limit(5) // Limit to the latest 5 items
        .snapshots()
        .map((QuerySnapshot snapshot) {
      return snapshot.docs.map((doc) {
        return Announcement.fromFirestore(doc);
      }).toList();
    });
  }
}
