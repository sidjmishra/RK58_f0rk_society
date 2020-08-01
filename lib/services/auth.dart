import 'package:block/modal/user.dart';
import 'package:block/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'location.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _db = Firestore.instance;
  final FirebaseMessaging _fcm = FirebaseMessaging();
  var token;
  Location location = Location();
  String errorMessage;
  String err;

  /// Condition ? TRUE : FALSE
  User _userFromFirebaseUser(FirebaseUser user) {
    return user != null ? User(userId: user.uid) : null;
  }

  Stream<User> get user {
    return _auth.onAuthStateChanged
        .map(_userFromFirebaseUser);
  }

  Future<String> getCurrentuid() async {
    return (await _auth.currentUser()).uid;
  }

  Future signInWithEmailAndPassword(String email, String password) async {
    FirebaseUser user;

    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      user = result.user;
      await _saveDeviceToken();
      updateUserData(user);
      return _userFromFirebaseUser(user);
    } catch (error) {
      switch (error.code) {
        case 'ERROR_INVALID_EMAIL':
          errorMessage = 'Your email address appears to be malformed.';
          break;
        case 'ERROR_WRONG_PASSWORD':
          errorMessage = 'Your password is wrong.';
          break;
        case 'ERROR_USER_NOT_FOUND':
          errorMessage = "User with this email doesn't exist.";
          break;
        case 'ERROR_USER_DISABLED':
          errorMessage = 'User with this email has been disabled.';
          break;
        case 'ERROR_TOO_MANY_REQUESTS':
          errorMessage = 'Too many requests. Try again later.';
          break;
        case 'ERROR_OPERATION_NOT_ALLOWED':
          errorMessage = 'Signing in with Email and Password is not enabled.';
          break;
        default:
          errorMessage = 'An undefined Error happened.';
      }
      return 'error';
    }
  }

  Future signUpWithEmailAndPassword(
      String email, String password, String username) async {
    String errorMessage;

    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;
      await _saveDeviceToken();
      // create a new document for user with the uid
      await UserDatabaseServices(uid: user.uid, fcmToken: token)
          .userSigned(username, email);
      return _userFromFirebaseUser(user);
    } catch (error) {
      print(error.message);
      err = error.message;
      switch (error.code) {
        case 'ERROR_OPERATION_NOT_ALLOWED':
          errorMessage = 'Indicates that Anonymous accounts are not enabled.';
          break;
        case 'ERROR_WEAK_PASSWORD':
          errorMessage = 'The password is not strong enough.';
          break;
        case 'ERROR_INVALID_EMAIL':
          errorMessage = 'The email address is malformed.';
          break;
        case 'ERROR_EMAIL_ALREADY_IN_USE':
          errorMessage = 'The email is already in use by a different account.';
          break;
        case 'ERROR_INVALID_CREDENTIAL':
          errorMessage = 'The email address is malformed.';
          break;
        default:
          errorMessage = 'Add proper credentials ';
      }
      return 'error';
    }

    if (errorMessage != null) {
      return Future.error(errorMessage);
    }
  }

  Future resetPassword(String email) async {
    try {
      return await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print(e.toString());
    }
  }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );

  bool stat = false;

  Future<FirebaseUser> handleSignIn() async {
    GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    print(credential);

    FirebaseUser user = (await _auth.signInWithCredential(credential)).user;
    print('signed in ' + user.displayName + '\n' + 'email ' + user.email);
    stat = true;
    await _saveDeviceToken();
    updateUserData(user);
    return user;
  }

  Future _saveDeviceToken() async {
    String fcmToken = await _fcm.getToken();
    if (fcmToken != null) {
      token = fcmToken;
    }
    print('this is the fcmtoken' + fcmToken);
  }

  void updateUserData(FirebaseUser user) async {
    await locator();
    DocumentReference ref = _db.collection('users').document(user.uid);

    return ref.setData({
      'uid': user.uid,
      'email': user.email,
      'lastSeen': DateTime.now(),
      'fcmToken': token,
      'pincode': location.pin,
    }, merge: true);
  }

  void locator() async {
    await location.getCurrentLocation();
  }
}
