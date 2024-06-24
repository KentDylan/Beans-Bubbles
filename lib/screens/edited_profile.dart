import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/edited_profile_widget.dart';

class EditedProfilePage extends StatefulWidget {
  const EditedProfilePage({Key? key}) : super(key: key);

  @override
  _EditedProfilePageState createState() => _EditedProfilePageState();
}

class _EditedProfilePageState extends State<EditedProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final ImagePicker _imagePicker = ImagePicker();

  File? _imageFile;
  String? _profileImageUrl;
  bool _isLoading = false;
  Map<String, dynamic>? _userProfile;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  void _handleImageSelected(File? image) {
    setState(() {
      _imageFile = image;
    });
    
    // Trigger the image upload immediately
    if (_imageFile != null) {
      _updateProfileImage();
    }
  }

  Future<void> _fetchUserData() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        final userData =
            await _firestore.collection('users').doc(user.uid).get();
        setState(() {
          _userProfile = userData.data();
          _profileImageUrl = _userProfile?['profileImgUrl'];
        });
      }
    } catch (e) {
      print('Error fetching user data: $e');
      // TODO: Handle error (e.g., show a SnackBar)
    }
  }

  // Function to update profile image
  Future<void> _updateProfileImage() async {
    try {
      final pickedFile =
          await _imagePicker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
          _isLoading = true; // Start loading
        });

        final user = _auth.currentUser;
        if (user != null) {
          final storageRef = firebase_storage.FirebaseStorage.instance
              .ref()
              .child('profile_images/${user.uid}.jpg');
          await storageRef.putFile(_imageFile!);
          String downloadURL = await storageRef.getDownloadURL();
          await _firestore
              .collection('users')
              .doc(user.uid)
              .update({'profileImgUrl': downloadURL});
          setState(() {
            _profileImageUrl = downloadURL;
            _isLoading = false; // Stop loading
          });
        }
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error updating profile image: $e');
      // TODO: Handle image upload errors (e.g., show a snackbar)
    }
  }

  Future<void> _handleUpdateProfile(
      String fullName, String email, String phoneNo, String password) async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        await _firestore.collection('users').doc(user.uid).update({
          'fullName': fullName,
          'email': email,
          'phoneNo': phoneNo,
        });
        if (password.isNotEmpty) {
          await user.updatePassword(password);
        }

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile updated successfully.'),
            duration: Duration(seconds: 2),
          ),
        );

        // Navigate back
        Navigator.of(context).pop();
      }
    } catch (e) {
      print('Error updating profile: $e');
      // Show an error message to the user
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to update profile.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var isSmallScreen = MediaQuery.of(context).size.width < 600;
    var colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: const Color.fromRGBO(248, 116, 4, 1.0),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(248, 116, 4, 1.0),
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: _userProfile == null
          ? const Center(child: CircularProgressIndicator())
          : EditProfileWidget(
              userProfile: _userProfile!, // Pass userProfile map
              profileImageUrl: _profileImageUrl,
              isLoading: _isLoading,
              onUpdateProfile: _handleUpdateProfile,
              onImageSelected: () => _updateProfileImage(),  // Pass the function reference
            ),
    );
  }
}