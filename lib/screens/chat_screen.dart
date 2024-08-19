import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:urban_council/controllers/chat_controller.dart';
import 'package:urban_council/models/resident.dart';
import 'package:urban_council/screens/chat_open_screen.dart';
import 'package:urban_council/services/user_service.dart';
import 'package:urban_council/utils/common_helper.dart';
import 'package:urban_council/widgets/resident_card.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  final ValueNotifier<bool> _isSearching = ValueNotifier<bool>(false);
  List<Resident> _filteredResidents = [];
  List<Resident> _allResidents = [];

  @override
  void initState() {
    super.initState();
    _fetchResidents();
    _searchController.addListener(_filterResidents);

    // Add listener to the search focus node
    _searchFocusNode.addListener(() {
      _isSearching.value = _searchFocusNode.hasFocus; // Update the visibility
    });
  }

  Future<void> _fetchResidents() async {
    _allResidents = await ChatController().fetchResidents();
    _filteredResidents = _allResidents; // Initialize with all residents
    setState(() {});
  }

  void _filterResidents() {
    final query = _searchController.text.toLowerCase();
    _filteredResidents = _allResidents.where((resident) {
      return resident.firstName.toLowerCase().contains(query) ||
          resident.lastName.toLowerCase().contains(query);
    }).toList();

    // Update the state to reflect changes
    setState(() {});
  }

  void _clearSearch() {
    _searchController.clear(); // Clear the text
    _searchFocusNode.unfocus(); // Unfocus the search bar
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 10),
              const Text(
                'Resident Chat',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),

              // Search Bar
              TextField(
                controller: _searchController,
                focusNode: _searchFocusNode, // Attach focus node
                decoration: InputDecoration(
                  hintText: 'Search',
                  hintStyle: const TextStyle(height: 1.3),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: BorderSide.none,
                  ),
                  constraints:
                      const BoxConstraints(minHeight: 45, maxHeight: 45),
                  filled: true,
                  fillColor: Colors.grey[200],
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _clearSearch(); // Clear search when icon is pressed
                    },
                  ),
                ),
              ),
              const SizedBox(height: 15),

              // Conversations Section
              ValueListenableBuilder<bool>(
                valueListenable: _isSearching,
                builder: (context, isSearching, child) {
                  if (isSearching) {
                    return Container(); // Hide the conversations section
                  }
                  return Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 15),
                        const Text(
                          'Conversations',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w500),
                        ),
                        Expanded(
                          child: StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection('chatrooms')
                                .where(
                                  'users',
                                  arrayContains: UserService().currentUser.uid,
                                )
                                .orderBy('updatedAt', descending: true)
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.hasError) {
                                return const Text('error');
                              }

                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(child: Text('loading...'));
                              }

                              return ListView(
                                children: snapshot.data!.docs.isEmpty
                                    ? [Container()]
                                    : snapshot.data!.docs.map<Widget>((doc) {
                                        Map<String, dynamic> data = doc.data();

                                        String receiverName = data['names'][0]
                                                    ['id'] !=
                                                UserService().currentUser.uid
                                            ? data['names'][0]['name']
                                            : data['names'][1]['name'];
                                        String receiverId = data['users'][0] !=
                                                UserService().currentUser.uid
                                            ? data['users'][0]
                                            : data['users'][1];

                                        return ListTile(
                                          contentPadding: EdgeInsets.zero,
                                          leading: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            child: SizedBox(
                                                height: 45,
                                                width: 45,
                                                child: CachedNetworkImage(
                                                  imageUrl: '',
                                                  placeholder: (context, url) =>
                                                      const Center(
                                                          child:
                                                              CircularProgressIndicator()),
                                                  errorWidget:
                                                      (context, url, error) =>
                                                          Container(
                                                    color: Colors.blue[600],
                                                    child: Center(
                                                      child: Text(
                                                        receiverName
                                                            .split(" ")
                                                            .map((part) => part[
                                                                    0]
                                                                .toUpperCase())
                                                            .join(),
                                                        style: const TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 14),
                                                      ),
                                                    ),
                                                  ),
                                                  fit: BoxFit.cover,
                                                )),
                                          ),
                                          title: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                receiverName,
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 13.5),
                                              ),
                                              if (data['lastMessage'] != '')
                                                Column(
                                                  children: [
                                                    const SizedBox(height: 2),
                                                    Text(
                                                      data['lastMessage'],
                                                      style: TextStyle(
                                                          color:
                                                              Colors.grey[500],
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          fontSize: 11),
                                                    ),
                                                  ],
                                                ),
                                            ],
                                          ),
                                          trailing: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Text(
                                                CommonHelper.getTime(
                                                    (data['updatedAt']
                                                            as Timestamp)
                                                        .toDate())!,
                                                style: TextStyle(
                                                    color: Colors.grey[500],
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 11),
                                              ),
                                              if (data['unReadMessages'][
                                                      UserService()
                                                          .currentUser
                                                          .uid] !=
                                                  0)
                                                Column(
                                                  children: [
                                                    const SizedBox(height: 2),
                                                    Icon(Icons.circle,
                                                        color: Colors.blue[500],
                                                        size: 12),
                                                  ],
                                                ),
                                            ],
                                          ),
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) => ChatOpenScreen(
                                                  chatRoomId: doc.id,
                                                  receiverId: receiverId,
                                                  receiverName: receiverName,
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      }).toList(),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 30),
                      ],
                    ),
                  );
                },
              ),
              const Text(
                'Residents List',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  itemCount: _filteredResidents.length,
                  itemBuilder: (context, index) {
                    final resident = _filteredResidents[index];
                    return Column(
                      children: [
                        ResidentCard(
                          receiverUid: resident.uid,
                          receiverName:
                              '${resident.firstName} ${resident.lastName}',
                          profileImage: resident.profileUrl,
                        ),
                        const SizedBox(height: 10),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
