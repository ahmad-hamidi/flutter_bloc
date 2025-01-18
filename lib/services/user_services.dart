part of 'services.dart';

class UserServices {
  static final CollectionReference _userCollection =
      FirebaseFirestore.instance.collection('users');

  static Future<void> updateUser(User user) async {
    await _userCollection.doc(user.id).set({
      'email': user.email,
      'name': user.name,
      'balance': user.balance,
      'selectedGenres': user.selectedGenres,
      'selectedLanguage': user.selectedLanguage,
      'profilePicture': user.profilePicture ?? "",
    });
  }

  static Future<User?> getUser(String id) async {
    DocumentSnapshot snapshot = await _userCollection.doc(id).get();

    final data = snapshot.data() as Map<String, dynamic>?;

    if (data == null) return null;

    return User(
      id,
      data['email'] ?? "",
      balance: data['balance'] ?? 0,
      profilePicture: data['profilePicture'] ?? "",
      selectedGenres: (data['selectedGenres'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      selectedLanguage: data['selectedLanguage'] ?? "English",
      name: data['name'] ?? "No Name",
    );
  }
}
