part of 'services.dart';

class AuthServices {
  static final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;

  static Future<SignInSignUpResult> signUp(String email, String password,
      String name, List<String> selectedGenres, String selectedLanguage) async {
    try {
      auth.UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User user = result.user!.convertToUser(
        name: name,
        selectedGenres: selectedGenres,
        selectedLanguage: selectedLanguage,
      );

      await UserServices.updateUser(user);

      return SignInSignUpResult(user: user);
    } catch (e) {
      return SignInSignUpResult(
        message: e.toString().split(',').length > 1
            ? e.toString().split(',')[1].trim()
            : e.toString(),
      );
    }
  }

  static Future<SignInSignUpResult> signIn(
      String email, String password) async {
    try {
      auth.UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = await result.user?.fromFireStore();

      if (user != null) {
        return SignInSignUpResult(user: user);
      } else {
        return SignInSignUpResult(
          message: "Failed to fetch user from Firestore.",
        );
      }
    } catch (e) {
      return SignInSignUpResult(
        message: e.toString().split(',').length > 1
            ? e.toString().split(',')[1].trim()
            : e.toString(),
      );
    }
  }

  static Future<void> signOut() async {
    await _auth.signOut();
  }

  static Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  static Stream<auth.User?> get userStream => _auth.authStateChanges();
}

class SignInSignUpResult {
  final User? user;
  final String? message;

  SignInSignUpResult({this.user, this.message});
}
