part of 'pages.dart';

class TicketDetailPage extends StatelessWidget {
  final Ticket ticket;

  TicketDetailPage(this.ticket);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        context.read<PageBloc>().add(GoToMainPage(
              bottomNavBarIndex: 1,
              isExpired: ticket.time.isBefore(DateTime.now()),
            ));
        return false;
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF6F7F9),
        body: Container(
          padding:
              const EdgeInsets.fromLTRB(defaultMargin, 0, defaultMargin, 0),
          child: ListView(
            children: <Widget>[
              Column(
                children: <Widget>[
                  const SizedBox(height: 20),
                  Stack(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.topLeft,
                        child: GestureDetector(
                          onTap: () {
                            context.read<PageBloc>().add(GoToMainPage(
                                  bottomNavBarIndex: 1,
                                  isExpired:
                                      ticket.time.isBefore(DateTime.now()),
                                ));
                          },
                          child: const Icon(
                            Icons.arrow_back,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Center(
                        child: Text(
                          "Ticket Details",
                          style: blackTextFont.copyWith(fontSize: 20),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 20),
                    height: 170,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(
                          imageBaseURL +
                              "w500" +
                              (ticket.movieDetail.backdropPath ?? ''),
                        ),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                    ),
                  ),
                  ClipPath(
                    clipper: TicketTopClipper(),
                    child: Container(
                      width: double.infinity,
                      color: Colors.white,
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            ticket.movieDetail.title ?? '-',
                            maxLines: 2,
                            overflow: TextOverflow.clip,
                            style: blackTextFont.copyWith(fontSize: 18),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            ticket.movieDetail.genresAndLanguage,
                            style: greyTextFont.copyWith(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(height: 6),
                          RatingStars(
                              voteAverage: ticket.movieDetail.voteAverage ?? 0),
                          const SizedBox(height: 16),
                          ticketDetailsRow("Cinema", ticket.theater.name),
                          const SizedBox(height: 9),
                          ticketDetailsRow(
                              "Date & Time", ticket.time.dateAndTime),
                          const SizedBox(height: 9),
                          ticketDetailsRow(
                              "Seat Numbers", ticket.seatsInString),
                          const SizedBox(height: 9),
                          ticketDetailsRow("Order ID", ticket.bookingCode),
                          const SizedBox(height: 20),
                          generateDashedDivider(
                            MediaQuery.of(context).size.width -
                                2 * defaultMargin -
                                40,
                          ),
                        ],
                      ),
                    ),
                  ),
                  ClipPath(
                    clipper: TicketBottomClipper(),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                      color: Colors.white,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              ticketDetailsColumn("Name: ", ticket.name),
                              const SizedBox(height: 8),
                              ticketDetailsColumn(
                                "Paid: ",
                                NumberFormat.currency(
                                  locale: "id_ID",
                                  decimalDigits: 0,
                                  symbol: "IDR ",
                                ).format(ticket.totalPrice),
                              ),
                            ],
                          ),
                          QrImageView.withQr(
                            qr: QrCode.fromData(
                              data: ticket.bookingCode,
                              errorCorrectLevel: QrErrorCorrectLevel.M,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 50),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget ticketDetailsRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          label,
          style: greyTextFont.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(
          width: 200,
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: whiteNumberFont.copyWith(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }

  Widget ticketDetailsColumn(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: greyTextFont.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
        ),
        Text(
          value,
          style: whiteNumberFont.copyWith(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}

class TicketTopClipper extends CustomClipper<Path> {
  final double radius = 15;

  @override
  Path getClip(Size size) {
    Path path = Path()
      ..lineTo(0, size.height - radius)
      ..quadraticBezierTo(radius, size.height - radius, radius, size.height)
      ..lineTo(size.width - radius, size.height)
      ..quadraticBezierTo(size.width - radius, size.height - radius, size.width,
          size.height - radius)
      ..lineTo(size.width, 0)
      ..close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class TicketBottomClipper extends CustomClipper<Path> {
  final double radius = 15;

  @override
  Path getClip(Size size) {
    Path path = Path()
      ..moveTo(0, size.height)
      ..lineTo(size.width, size.height)
      ..lineTo(size.width, radius)
      ..quadraticBezierTo(size.width - radius, radius, size.width - radius, 0)
      ..lineTo(radius, 0)
      ..quadraticBezierTo(radius, radius, 0, radius)
      ..close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
