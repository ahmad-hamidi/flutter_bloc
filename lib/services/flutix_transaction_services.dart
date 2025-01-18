part of 'services.dart';

class FlutixTransactionServices {
  static final CollectionReference transactionCollection =
      FirebaseFirestore.instance.collection('transactions');

  static Future<void> saveTransaction(
      FlutixTransaction flutixTransaction) async {
    await transactionCollection.doc().set({
      'userID': flutixTransaction.userID,
      'title': flutixTransaction.title,
      'subtitle': flutixTransaction.subtitle,
      'time': flutixTransaction.time.millisecondsSinceEpoch,
      'amount': flutixTransaction.amount,
      'picture': flutixTransaction.picture ?? "",
    });
  }

  static Future<List<FlutixTransaction>> getTransaction(String userID) async {
    QuerySnapshot snapshot = await transactionCollection.get();

    var documents = snapshot.docs.where((document) {
      final data = document.data() as Map<String, dynamic>;
      return data['userID'] == userID;
    });

    return documents.map((doc) {
      final data = doc.data() as Map<String, dynamic>;

      return FlutixTransaction(
        userID: data['userID'] ?? "",
        title: data['title'] ?? "",
        subtitle: data['subtitle'] ?? "",
        time: DateTime.fromMillisecondsSinceEpoch(data['time'] ?? 0),
        amount: data['amount'] ?? 0,
        picture: data['picture'],
      );
    }).toList();
  }
}
