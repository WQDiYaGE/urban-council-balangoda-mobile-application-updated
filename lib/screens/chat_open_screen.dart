import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';
import 'package:path/path.dart' as path;
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:urban_council/controllers/chat_controller.dart';
import 'package:urban_council/screens/chat_image_view_screen.dart';
import 'package:urban_council/services/user_service.dart';
import 'package:urban_council/utils/common_helper.dart';
import 'package:urban_council/widgets/audio_player.dart';
import 'package:urban_council/widgets/audio_recorder.dart';
import 'package:urban_council/widgets/chat_bubble.dart';
import 'package:urban_council/widgets/chat_input_field.dart';
import 'package:urban_council/widgets/file_bubble.dart';

class ChatOpenScreen extends StatefulWidget {
  final String chatRoomId;
  final String receiverId;
  final String receiverName;

  const ChatOpenScreen({
    super.key,
    required this.chatRoomId,
    required this.receiverId,
    required this.receiverName,
  });

  @override
  State<ChatOpenScreen> createState() => _ChatOpenScreenState();
}

class _ChatOpenScreenState extends State<ChatOpenScreen> {
  final TextEditingController _messageController = TextEditingController();
  final player = AudioPlayer();
  StreamController<double>? _uploadProgressController;
  bool isUploadProgressVisible = false;

  final ScrollController _scrollController = ScrollController();

  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      // await viewModel.sendMessage(widget.chatExtra.chatRoomId!,
      //     widget.chatExtra.lecturerId, _messageController.text);
      ChatController().sendMessage(
          widget.chatRoomId, widget.receiverId, _messageController.text);

      // clear the controller after sending the message
      _messageController.clear();

      _scrollToBottom();
    }
  }

  Future<void> sendFileMessage(String filePath) async {
    _uploadProgressController = StreamController<double>();

    // Check if the file exists
    File file = File(filePath);
    if (!file.existsSync()) {
      print('File does not exist at path: $filePath');
      return;
    }

    setState(() {
      isUploadProgressVisible = true;
    });

    try {
      // String fileUrl =
      //     await viewModel.uploadFile(filePath, _uploadProgressController!);
      String fileUrl = await ChatController()
          .uploadFile(filePath, _uploadProgressController!);
      String mimeType = lookupMimeType(filePath) ?? '';
      String fileType = mimeType;
      String fileName = path.basename(filePath);
      // await viewModel.sendMessage(
      //     widget.chatExtra.chatRoomId!, widget.chatExtra.lecturerId, '',
      //     fileUrl: fileUrl, fileName: fileName, fileType: fileType);
      ChatController().sendMessage(widget.chatRoomId, widget.receiverId, '',
          fileUrl: fileUrl, fileName: fileName, fileType: fileType);
    } finally {
      // Navigator.of(context).pop(); // Close the progress dialog

      setState(() {
        isUploadProgressVisible = false;
      });
      _uploadProgressController!.close(); // Close the StreamController
    }
  }

  Future<void> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      String filePath = result.files.single.path!;
      await sendFileMessage(filePath);
    }
  }

  // method to cache and open file
  Future<void> _openFile(String url) async {
    try {
      // Get the cache directory
      final directory = await getTemporaryDirectory();
      final filePath = path.join(directory.path, path.basename(url));

      // Download the file to the cache directory
      final response = await http.get(Uri.parse(url));
      final file = File(filePath);
      await file.writeAsBytes(response.bodyBytes);

      // Open the file with the appropriate application
      await OpenFile.open(filePath);
    } catch (e) {
      print('Error opening file: $e');
    }
  }

  Future<void> requestMicrophonePermission() async {
    var status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      await Permission.microphone.request();
      throw RecordingPermissionException('Microphone permission not granted');
    }
  }

  void _scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 150),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.receiverName),
        backgroundColor: Colors.white,
      ),
      body: Stack(children: [
        Column(
          children: [
            // messages
            Expanded(
              child: _buildMessageList(),
            ),

            // user input
            _buildMessageInput(),
          ],
        ),
        Visibility(
            visible: isUploadProgressVisible,
            maintainInteractivity: false,
            child: Container(
              color: Colors.white,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator.adaptive(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Colors.grey.shade600),
                  ),
                  const Text('Uploading...')
                ],
              ),
            ))
      ]),
    );
  }

  // build message input
  Widget _buildMessageInput() {
    return Row(
      children: [
        const SizedBox(
          width: 8,
        ),
        Expanded(
            child: ChatTextField(
          controller: _messageController,
          hintText: 'Enter message',
          obscureText: false,
        )),
        const SizedBox(
          width: 5,
        ),
        GestureDetector(
            onTap: sendMessage,
            child: const Icon(
              Icons.arrow_upward,
            )),
        const SizedBox(
          width: 5,
        ),
        GestureDetector(
          onTap: pickFile,
          child: const Icon(
            Icons.attach_file,
          ),
        ),
        const SizedBox(
          width: 5,
        ),
        GestureDetector(
          child: const Icon(Icons.mic),
          onTap: () async {
            await requestMicrophonePermission();
            String? filePath = await showModalBottomSheet<String>(
              context: context,
              builder: (context) => const AudioRecorderBottomSheet(),
            );
            if (filePath != null) {
              bool? send = await showModalBottomSheet<bool>(
                context: context,
                builder: (context) => AudioPlayerBottomSheet(
                  fileUrl: filePath,
                  openFromRecorder: true,
                ),
              );
              if (send == true) {
                await sendFileMessage(filePath);
              }
            }
          },
        ),
        const SizedBox(
          width: 5,
        ),
      ],
    );
  }

  // build message list
  Widget _buildMessageList() {
    return StreamBuilder(
        stream: ChatController().getMessages(widget.chatRoomId,
            UserService().currentUser.uid, widget.receiverId),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text('Loading...');
          }

          // Update unread message count in Firestore
          ChatController().updateUnreadMessages(
              widget.chatRoomId, UserService().currentUser.uid, 0);

          // Mark all messages as read
          for (var doc in snapshot.data!.docs) {
            if (doc['receiver'] == UserService().currentUser.uid &&
                !doc['seen']) {
              doc.reference.update({'seen': true});
            }
          }

          WidgetsBinding.instance
              .addPostFrameCallback((_) => _scrollToBottom());

          return ListView(
            controller: _scrollController,
            children: snapshot.data!.docs
                .map((doc) => _buildMessageItem(doc))
                .toList(),
          );
        });
  }

  // build message item
  Widget _buildMessageItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;

    // align the messages to the right if the sender is the current user, otherwise to the left
    var alignment = (data['sender'] == UserService().currentUser.uid)
        ? Alignment.centerRight
        : Alignment.centerLeft;

    return Container(
      alignment: alignment,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8.0),
        child: Column(
          crossAxisAlignment: (data['sender'] == UserService().currentUser.uid)
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          mainAxisAlignment: (data['sender'] == UserService().currentUser.uid)
              ? MainAxisAlignment.end
              : MainAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () async {
                if (data['file'] != null) {
                  String fileType = data['fileType'] ?? '';
                  if (fileType.split('/')[0] == 'image') {
                    _openFileInApp(data['file'],
                        fileType); // Open supported files directly in the app
                  } else if (fileType.split('/')[0] == 'audio') {
                    await showModalBottomSheet<String>(
                      context: context,
                      builder: (context) =>
                          AudioPlayerBottomSheet(fileUrl: data['file']),
                    );
                  } else {
                    _openFile(
                        data['file']); // Open other files with external apps
                  }
                }
              },
              child: data['file'] != null
                  ? (data['fileType'].split('/')[0] == 'image')
                      ? Column(
                          crossAxisAlignment:
                              (data['sender'] == UserService().currentUser.uid)
                                  ? CrossAxisAlignment.end
                                  : CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                                width: 150,
                                height: 150,
                                child: Image.network(
                                  data['file'],
                                  fit: BoxFit.cover,
                                )),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                                CommonHelper.getTime(
                                    (data['createdAt'] as Timestamp).toDate())!,
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey[500],
                                ))
                          ],
                        )
                      : FileBubble(
                          message: '${data['fileName']}',
                          time: CommonHelper.getTime(
                              (data['createdAt'] as Timestamp).toDate())!,
                          chatBubbleType:
                              data['sender'] == UserService().currentUser.uid
                                  ? ChatBubbleType.Sender
                                  : ChatBubbleType.Receiver)
                  : ChatBubble(
                      message: data['content'],
                      time: CommonHelper.getTime(
                          (data['createdAt'] as Timestamp).toDate())!,
                      chatBubbleType:
                          data['sender'] == UserService().currentUser.uid
                              ? ChatBubbleType.Sender
                              : ChatBubbleType.Receiver),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openFileInApp(String fileUrl, String fileType) async {
    // Handle opening files in the app based on their types
    if (fileType.split('/')[0] == 'image') {
      // Display images within the app
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ImageViewerScreen(imageUrl: fileUrl),
        ),
      );
    }
  }
}
