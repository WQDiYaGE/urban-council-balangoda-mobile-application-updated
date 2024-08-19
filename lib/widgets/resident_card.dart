import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:urban_council/controllers/chat_controller.dart';
import 'package:urban_council/models/resident.dart';
import 'package:urban_council/screens/chat_open_screen.dart';
import 'package:urban_council/services/user_service.dart';

class ResidentCard extends StatelessWidget {
  final String receiverName;
  final String receiverUid;
  final String profileImage;

  const ResidentCard({
    super.key,
    required this.receiverName,
    required this.receiverUid,
    required this.profileImage,
  });

  @override
  Widget build(BuildContext context) {
    // Access the user data
    Resident? user = UserService().currentUser;

    return Container(
      decoration: BoxDecoration(
          color: Colors.grey[200], borderRadius: BorderRadius.circular(12)),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      height: 65,
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: SizedBox(
                height: 45,
                width: 45,
                child: CachedNetworkImage(
                  imageUrl: profileImage,
                  placeholder: (context, url) =>
                      const CircularProgressIndicator(),
                  errorWidget: (context, url, error) => Container(
                    color: Colors.blue[600],
                    child: Center(
                      child: Text(
                        receiverName
                            .split(" ")
                            .map((part) => part[0].toUpperCase())
                            .join(),
                        style:
                            const TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ),
                  ),
                  fit: BoxFit.cover,
                )),
          ),
          const SizedBox(
            width: 15,
          ),
          Expanded(
            child: Text(
              receiverName,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              maxLines: 1,
            ),
          ),
          GestureDetector(
            onTap: () async {
              final chatRoomId = await ChatController().createNewChat(
                user.uid,
                receiverUid,
                receiverName,
                '${user.firstName} ${user.firstName}',
              );

              if (chatRoomId != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ChatOpenScreen(
                      chatRoomId: chatRoomId['id'],
                      receiverId: receiverUid,
                      receiverName: receiverName,
                    ),
                  ),
                );
              } else {
                // Handle error: chat room creation failed
                print('Error creating chat room');
              }
            },
            child: Container(
                width: 25,
                height: 25,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: Colors.grey[600],
                    borderRadius: BorderRadius.circular(50)),
                child: const Icon(
                  Icons.add,
                  color: Colors.white,
                )),
          ),
        ],
      ),
    );
  }
}
