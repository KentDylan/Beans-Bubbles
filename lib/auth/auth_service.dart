import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<User?> loginUser(String email, String password) async {
    try {
      UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      return userCredential.user;
    } catch (e) {
      print('Error logging in user: $e');
      return null;
    }
  }

  Future<void> registerUser(String email, String password, String fullName, String phoneNo) async {
    try {
      UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;

      if (user != null) {
        await _firestore.collection('users').doc(user.uid).set({
          'fullName': fullName,
          'email': email,
          'phoneNo': phoneNo,
        });
      }
    } catch (e) {
      print('Error registering user: $e');
      throw e;
    }
  }

  Future<bool> isEmailRegistered(String email) async {
    try {
      List<String> signInMethods = await _firebaseAuth.fetchSignInMethodsForEmail(email);
      return signInMethods.isNotEmpty;
    } catch (e) {
      print('Error checking email: $e');
      throw e;
    }
  }

  Future<Map<String, dynamic>?> getCurrentUserProfile() async {
    try {
      User? user = _firebaseAuth.currentUser;
      if (user != null) {
        DocumentSnapshot userProfile = await _firestore.collection('users').doc(user.uid).get();
        return userProfile.data() as Map<String, dynamic>?;
      }
      return null;
    } catch (e) {
      print('Error getting user profile: $e');
      return null;
    }
  }

Future<void> updateUserProfile(String fullName, String email, String phoneNo, String? password, String? imageUrl) async {
  try {
    User? user = _firebaseAuth.currentUser;
    if (user != null) {
      // Get current user data
      DocumentSnapshot userData = await _firestore.collection('users').doc(user.uid).get();
      String currentEmail = userData['email'];

      // Check if email is being changed
      if (email != currentEmail) {
        print('Error updating user profile: Email cannot be changed.');
        return;
      }

      // Update user profile data
      Map<String, dynamic> updateData = {
        'fullName': fullName,
        'phoneNo': phoneNo,
      };
      if (imageUrl != null) {
        updateData['profileImageUrl'] = imageUrl;
      }

      await _firestore.collection('users').doc(user.uid).update(updateData);

      // Update password if provided and different from current
      if (password != null && password.isNotEmpty) {
        await user.updatePassword(password);
      }

      // Print success message
      print('Update berhasil');
    }
  } catch (e) {
    print('Error updating user profile: $e');
    throw e;
  }
}


}
