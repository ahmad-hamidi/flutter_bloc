part of 'services.dart';

class TicketServices {
  static final CollectionReference ticketCollection =
      FirebaseFirestore.instance.collection('tickets');

  static Future<void> saveTicket(String id, Ticket ticket) async {
    await ticketCollection.doc().set({
      'movieID': ticket.movieDetail?.id ?? "",
      'userID': id,
      'theaterName': ticket.theater?.name ?? "",
      'time': ticket.time.millisecondsSinceEpoch,
      'bookingCode': ticket.bookingCode,
      'seats': ticket.seatsInString,
      'name': ticket.name,
      'totalPrice': ticket.totalPrice
    });
  }

  static Future<List<Ticket>> getTickets(String userId) async {
    QuerySnapshot snapshot = await ticketCollection.get();

    var documents = snapshot.docs.where((document) {
      final data = document.data() as Map<String, dynamic>?;
      return data?['userID'] == userId;
    });

    List<Ticket> tickets = [];
    for (var document in documents) {
      final data = document.data() as Map<String, dynamic>?;

      if (data == null) continue;

      MovieDetail? movieDetail = await MovieServices.getDetails(
        null,
        movieID: data['movieID'] as int?,
      );

      tickets.add(
        Ticket(
          movieDetail!,
          Theater(data['theaterName'] ?? ""),
          DateTime.fromMillisecondsSinceEpoch(data['time'] ?? 0),
          data['bookingCode'] ?? "",
          (data['seats'] ?? "").split(','),
          data['name'] ?? "",
          data['totalPrice'] ?? 0,
        ),
      );
    }

    return tickets;
  }
}
