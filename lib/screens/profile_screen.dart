import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:urban_council/models/resident.dart';
import 'package:urban_council/services/user_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? _selectedImage;
  String? _uploadedImageUrl;
  bool isLoading = false;
  String profileImage = '';

  setUser() async {
    setState(() {
      profileImage = UserService().currentUser.profileUrl;
    });
  }

  @override
  void initState() {
    setUser();
    super.initState();
  }

  void _updateSelectedImage(String? imagePath) {
    setState(() {
      _selectedImage = imagePath;
    });
  }

  void _updateUploadedImageUrl(String imageUrl) {
    setState(() async {
      _uploadedImageUrl = imageUrl;
      Resident currentUser = UserService().currentUser;
      Resident newResident = Resident(
          uid: currentUser.uid,
          firstName: currentUser.firstName,
          lastName: currentUser.lastName,
          email: currentUser.email,
          profileUrl: imageUrl,
          phone: currentUser.phone);
      UserService().setCurrentUser(newResident);
      isLoading = false;
    });
  }

  Future<void> _uploadImage() async {
    if (_selectedImage == null) return;
    setState(() {
      isLoading = true;
    });

    try {
      // Get current user ID
      String userId = FirebaseAuth.instance.currentUser!.uid;

      // Upload image to Firebase Storage
      File imageFile = File(_selectedImage!);
      Reference storageRef = FirebaseStorage.instance
          .ref()
          .child('profile_images')
          .child('$userId.jpg');
      UploadTask uploadTask = storageRef.putFile(imageFile);
      TaskSnapshot snapshot = await uploadTask;

      // Get the download URL
      String downloadUrl = await snapshot.ref.getDownloadURL();

      // Save the download URL to Firestore
      await FirebaseFirestore.instance
          .collection('residents')
          .doc(userId)
          .update({'profileImage': downloadUrl});

      _updateUploadedImageUrl(downloadUrl);
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      // Handle the error (e.g., show a message to the user)
      print('Error uploading image: $e');
    }
  }

  Future<void> _showUploadDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Center(
                child: CircleAvatar(
                  radius: 80,
                  backgroundImage: FileImage(File(_selectedImage!)),
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              onPressed: isLoading
                  ? null
                  : () async {
                      await _uploadImage();
                      if (!isLoading) {
                        Navigator.of(context).pop();
                      }
                    },
              child:
                  isLoading ? const Text('Uploading...') : const Text('Upload'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text('View Profile'),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Column(
          children: [
            const SizedBox(
              height: 40,
            ),
            Stack(
              children: [
                _uploadedImageUrl != null
                    ? CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage(_uploadedImageUrl!),
                        onBackgroundImageError: (_, __) =>
                            const AssetImage('assets/user.png')
                                as ImageProvider<Object>,
                      )
                    : CircleAvatar(
                        radius: 50,
                        backgroundImage: profileImage.isNotEmpty
                            ? CachedNetworkImageProvider(
                                UserService().currentUser.profileUrl)
                            : const AssetImage('assets/user.png'),
                        onBackgroundImageError: (_, __) =>
                            const AssetImage('assets/user.png')
                                as ImageProvider<Object>,
                      ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: () async {
                      final ImagePicker picker = ImagePicker();
                      final XFile? image =
                          await picker.pickImage(source: ImageSource.gallery);

                      if (image != null) {
                        String filePath = image.path;
                        _updateSelectedImage(filePath);
                        _showUploadDialog();
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white,
                          width: 1.0,
                        ),
                      ),
                      child: CircleAvatar(
                        radius: 15,
                        backgroundColor: Colors.grey[400],
                        child: Icon(
                          Icons.camera_alt_outlined,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            profileCard('First Name', 'Esha', Icons.account_circle_outlined),
            profileCard('Last Name', 'Keshari', Icons.account_circle_outlined),
            profileCard('Email', 'esha@gmail.com', Icons.email_outlined),
            profileCard('Phone Number', '+94719026357', Icons.phone_outlined),
          ],
        ),
      ),
    );
  }

  Widget profileCard(String title, String value, IconData icon) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 13),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 30),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              Text(
                value,
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[500]),
              ),
            ],
          )
        ],
      ),
    );
  }
}
