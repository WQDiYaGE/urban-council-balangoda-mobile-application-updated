import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart' as path;
import 'package:urban_council/models/message.dart';
import 'package:urban_council/models/resident.dart';
import 'package:urban_council/services/user_service.dart';

class ChatController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Resident>> fetchResidents() async {
    try {
      // Get the current user's ID
      String currentUserId = UserService().currentUser.uid;

      // Fetch residents excluding the current user
      QuerySnapshot snapshot = await _firestore
          .collection('residents')
          .where(FieldPath.documentId,
              isNotEqualTo: currentUserId) // Exclude current user
          .get();

      return snapshot.docs.map((doc) => Resident.fromDocument(doc)).toList();
    } catch (e) {
      throw Exception('Error fetching residents: $e');
    }
  }

  // Create a new chat room
  Future<Map<String, dynamic>?> createNewChat(
    String userId,
    String receiverId,
    String receiverName,
    String senderName,
  ) async {
    try {
      // Get chatrooms collection reference
      CollectionReference chatroomCollection =
          _firestore.collection('chatrooms');

      // Check if a chat room already exists between the users
      QuerySnapshot chatroomSnapshot =
          await chatroomCollection.where('users', whereIn: [
        [userId, receiverId],
        [receiverId, userId],
      ]).get();

      if (chatroomSnapshot.docs.isNotEmpty) {
        DocumentSnapshot doc = chatroomSnapshot.docs.first;
        return _buildChatroomData(doc);
      }

      // Create a new chat room
      Map<String, dynamic> newChatroom =
          _buildNewChatroomData(userId, receiverId, receiverName, senderName);

      // Add the new chat room to Firestore
      DocumentReference chatroomRef = await chatroomCollection.add(newChatroom);

      return _buildChatroomDataFromReference(chatroomRef, newChatroom);
    } catch (error) {
      print('Error creating new chat: $error');
      return null;
    }
  }

  // Build chatroom data from a Firestore document snapshot
  Map<String, dynamic> _buildChatroomData(DocumentSnapshot doc) {
    return {
      'id': doc.id,
      'names': doc['names'],
      'users': doc['users'],
      'lastMessage': doc['lastMessage'],
      'createdAt': doc['createdAt'],
      'updatedAt': doc['updatedAt'],
      'unReadMessages': doc['unReadMessages'],
    };
  }

  // Build new chatroom data
  Map<String, dynamic> _buildNewChatroomData(String userId, String receiverId,
      String receiverName, String senderName) {
    return {
      'users': [userId, receiverId],
      'lastMessage': '',
      'names': [
        {'id': userId, 'name': senderName},
        {'id': receiverId, 'name': receiverName},
      ],
      'createdAt': Timestamp.now(),
      'updatedAt': Timestamp.now(),
      'unReadMessages': {
        userId: 0,
        receiverId: 0,
      },
    };
  }

  // Build chatroom data from a Firestore document reference and new chatroom data
  Map<String, dynamic> _buildChatroomDataFromReference(
      DocumentReference ref, Map<String, dynamic> newChatroom) {
    return {
      'id': ref.id,
      'names': newChatroom['names'],
      'users': newChatroom['users'],
      'lastMessage': newChatroom['lastMessage'],
      'createdAt': newChatroom['createdAt'],
      'updatedAt': newChatroom['updatedAt'],
      'unReadMessages': newChatroom['unReadMessages'],
    };
  }

  // SEND MESSAGE
  Future<void> sendMessage(String chatRoomId, String receiverId, String message,
      {String? fileUrl, String? fileName, String? fileType}) async {
    final DateTime timestamp = DateTime.now();
    try {
      String senderId = UserService().currentUser.uid;

      // create a new message
      Message newMessage = Message(
          chatRoomId: chatRoomId,
          sender: senderId,
          receiver: receiverId,
          content: message,
          file: fileUrl,
          fileType: fileType,
          fileName: fileName,
          createdAt: timestamp,
          seen: false);

      // add new message to database
      await _firestore.collection('messages').add(newMessage.toMap());

      DocumentReference chatroomRef =
          FirebaseFirestore.instance.collection('chatrooms').doc(chatRoomId);

      String lastMessage;
      if (message.isNotEmpty) {
        lastMessage = message;
      } else if (fileUrl != null) {
        String mimeType = fileType ?? 'application/octet-stream';
        if (mimeType == 'application/pdf') {
          lastMessage = 'PDF';
        } else if (mimeType.startsWith('image/')) {
          lastMessage = 'Photo';
        } else if (mimeType.startsWith('audio/')) {
          lastMessage = 'Audio';
        } else {
          lastMessage = 'Unknown';
        }
      } else {
        lastMessage = message;
      }

      await chatroomRef.update({
        'lastMessage': lastMessage,
        'updatedAt': Timestamp.now(),
        'unReadMessages.$receiverId': 1,
      });
    } catch (e) {
      print('Message send failed, $e');
    }
  }

  // Upload file and get URL with progress
  Future<String> uploadFile(
      String filePath, StreamController<double> progressController) async {
    File file = File(filePath);

    String fileName = path.basename(filePath);
    String mimeType = lookupMimeType(file.path) ?? '';
    String fileType = mimeType.split('/')[0];
    String date = DateTime.now().toIso8601String();

    Reference storageRef;

    if (fileType == 'image') {
      storageRef = FirebaseStorage.instance.ref('images/$date$fileName');
    } else {
      storageRef = FirebaseStorage.instance.ref('files/$date$fileName');
    }

    // Reference storageReference =  _firebaseStorage.ref().child('chat_files/$fileName');
    // UploadTask uploadTask = storageReference.putFile(file);
    UploadTask uploadTask = storageRef.putFile(file);

    uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
      double progress = (snapshot.bytesTransferred / snapshot.totalBytes);
      progressController.add(progress);
    });

    TaskSnapshot snapshot = await uploadTask;
    return await snapshot.ref.getDownloadURL();
  }

  // GET MESSAGE
  Stream<QuerySnapshot> getMessages(
      String chatRoomId, String userId, String otherUserId) {
    return _firestore
        .collection('messages')
        .where('chatRoomId', isEqualTo: chatRoomId)
        .orderBy('createdAt', descending: false)
        .snapshots();
  }

  Future<void> updateUnreadMessages(
      String chatRoomId, String userId, int unreadCount) async {
    DocumentReference chatRoomRef =
        _firestore.collection('chatrooms').doc(chatRoomId);

    Map<String, dynamic> data = {
      'unReadMessages.$userId': unreadCount,
    };

    await chatRoomRef.update(data);
  }
}
