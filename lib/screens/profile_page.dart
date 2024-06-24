import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'edited_profile.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late User? currentUser;
  String? _profileImageUrl; // Store profile image URL

  @override
  void initState() {
    super.initState();
    currentUser = _auth.currentUser;
    _fetchUserData(); // Fetch user data including profile image
  }

  Future<void> _fetchUserData() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        final userData =
            await _firestore.collection('users').doc(user.uid).get();
        setState(() {
          _profileImageUrl = userData['profileImgUrl']; // Get image URL
        });
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.orange,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _signOut(context),
          ),
        ],
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: _firestore.collection('users').doc(currentUser!.uid).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('No data found'));
          }

          var userData = snapshot.data!;

          String? fullName = userData['fullName'];
          String? phoneNumber = userData['phoneNo'];

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const SizedBox(height: 40), // Add some spacing above the image
              Center(
                // Center the profile image container
                child: Container(
                  width: 150, // Adjust size as needed
                  height: 150,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: _profileImageUrl != null
                          ? CachedNetworkImageProvider(_profileImageUrl!)
                          : const AssetImage('assets/img/profpic.png')
                              as ImageProvider,
                      fit: BoxFit.cover,
                    ),
                    border: Border.all(
                      color: Colors.white,
                      width: 3.0, // Thicker border
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40.0), // A
              buildProfileInfo(
                  'Email', currentUser!.email ?? 'Email not available'),
              buildProfileInfo(
                  'Full Name', fullName ?? 'Full Name not available'),
              buildProfileInfo(
                  'Phone Number', phoneNumber ?? 'Phone Number not available'),
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const EditedProfilePage()),
                  );

                  // Setelah kembali dari EditedProfilePage, perbarui tampilan
                  setState(() {});
                },
                child: const Text('Update Profile'),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget buildProfileInfo(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            '$title:',
            style: const TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 5.0),
          Text(
            value,
            style: const TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 15.0,
              fontWeight: FontWeight.w200,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _signOut(BuildContext context) async {
    try {
      await _auth.signOut();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Logged out successfully'),
          duration: Duration(seconds: 2),
        ),
      );
      Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
    } catch (e) {
      print('Error signing out: $e');
    }
  }
}