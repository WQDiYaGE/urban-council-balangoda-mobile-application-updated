class Message {
  final String chatRoomId;
  final String sender;
  final String receiver;
  final String content;
  final DateTime createdAt;
  final bool seen;
  final String? file;
  final String? fileName;
  final String? fileType;

  Message({
    required this.chatRoomId,
    required this.sender,
    required this.receiver,
    required this.content,
    required this.createdAt,
    this.seen = false,
    this.file,
    this.fileName,
    this.fileType,
  });

  // convert to a map
  Map<String, dynamic> toMap() {
    return {
      'chatRoomId': chatRoomId,
      'sender': sender,
      'receiver': receiver,
      'content': content,
      'createdAt': createdAt,
      'seen': seen,
      'file': file,
      'fileName': fileName,
      'fileType': fileType,
    };
  }

  // create Message from map
  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      chatRoomId: map['chatRoomId'],
      sender: map['sender'],
      receiver: map['receiver'],
      content: map['content'],
      createdAt: map['createdAt'],
      seen: map['seen'],
      file: map['file'],
      fileName: map['fileName'],
      fileType: map['fileType'],
    );
  }
}
