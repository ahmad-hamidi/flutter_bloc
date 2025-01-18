part of 'pages.dart';

class CheckoutPage extends StatefulWidget {
  final Ticket ticket;

  const CheckoutPage(this.ticket, {Key? key}) : super(key: key);

  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  @override
  Widget build(BuildContext context) {
    int total = 26500 * widget.ticket.seats.length;

    return WillPopScope(
      onWillPop: () async {
        context.read<PageBloc>().add(GoToSelectSeatPage(widget.ticket));
        return true;
      },
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            Container(
              color: accentColor1,
            ),
            SafeArea(
              child: Container(
                color: Colors.white,
              ),
            ),
            ListView(
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    // Back Button
                    Row(
                      children: <Widget>[
                        Container(
                          margin: const EdgeInsets.only(
                              top: 20, left: defaultMargin),
                          padding: const EdgeInsets.all(1),
                          child: GestureDetector(
                            onTap: () {
                              context
                                  .read<PageBloc>()
                                  .add(GoToSelectSeatPage(widget.ticket));
                            },
                            child: const Icon(
                              Icons.arrow_back,
                              color: Colors.black,
                            ),
                          ),
                        )
                      ],
                    ),
                    BlocBuilder<UserBloc, UserState>(
                      builder: (_, userState) {
                        if (userState is! UserLoaded) return SizedBox.shrink();

                        User user = userState.user;

                        return Column(
                          children: <Widget>[
                            // Page Title
                            Container(
                              margin: const EdgeInsets.symmetric(vertical: 20),
                              child: Text(
                                "Checkout\nMovie",
                                style: blackTextFont.copyWith(fontSize: 20),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            // Movie Description
                            Row(
                              children: <Widget>[
                                Container(
                                  width: 70,
                                  height: 90,
                                  margin: const EdgeInsets.only(
                                      left: defaultMargin, right: 20),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    image: DecorationImage(
                                      image: NetworkImage(
                                        imageBaseURL +
                                            'w342' +
                                            (widget.ticket.movieDetail
                                                    .posterPath ??
                                                ''),
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width -
                                          2 * defaultMargin -
                                          70 -
                                          20,
                                      child: Text(
                                        widget.ticket.movieDetail.title ?? '',
                                        style: blackTextFont.copyWith(
                                            fontSize: 18),
                                        maxLines: 2,
                                        overflow: TextOverflow.clip,
                                      ),
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width -
                                          2 * defaultMargin -
                                          70 -
                                          20,
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 6),
                                      child: Text(
                                        widget.ticket.movieDetail
                                            .genresAndLanguage,
                                        style: greyTextFont.copyWith(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                    RatingStars(
                                      voteAverage: widget
                                              .ticket.movieDetail.voteAverage ??
                                          0,
                                      color: accentColor3,
                                    ),
                                  ],
                                )
                              ],
                            ),
                            Container(
                              margin: const EdgeInsets.symmetric(
                                  vertical: 20, horizontal: defaultMargin),
                              child: const Divider(
                                color: Color(0xFFE4E4E4),
                                thickness: 1,
                              ),
                            ),
                            // Order Details
                            buildOrderDetails("Order ID",
                                widget.ticket.bookingCode, Colors.black),
                            buildOrderDetails(
                                "Cinema", widget.ticket.theater.name),
                            buildOrderDetails(
                                "Date & Time", widget.ticket.time.dateAndTime),
                            buildOrderDetails(
                                "Seat Numbers", widget.ticket.seatsInString),
                            buildOrderDetails("Price",
                                "IDR 25.000 x ${widget.ticket.seats.length}"),
                            buildOrderDetails("Fee",
                                "IDR 1.500 x ${widget.ticket.seats.length}"),
                            buildOrderDetails(
                              "Total",
                              NumberFormat.currency(
                                locale: 'id_ID',
                                decimalDigits: 0,
                                symbol: 'IDR ',
                              ).format(total),
                              Colors.black,
                            ),
                            // Your Wallet
                            Container(
                              margin: const EdgeInsets.symmetric(
                                  vertical: 20, horizontal: defaultMargin),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text("Your Wallet",
                                      style: greyTextFont.copyWith(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400)),
                                  Text(
                                    NumberFormat.currency(
                                      locale: 'id_ID',
                                      decimalDigits: 0,
                                      symbol: 'IDR ',
                                    ).format(user.balance),
                                    style: whiteNumberFont.copyWith(
                                      color: ((user.balance ?? 0) >= total)
                                          ? const Color(0xFF3E9D9D)
                                          : const Color(0xFFFF5C83),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Button
                            Container(
                              width: 250,
                              height: 46,
                              margin:
                                  const EdgeInsets.only(top: 36, bottom: 50),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: (user.balance ?? 0) >= total
                                      ? const Color(0xFF3E9D9D)
                                      : mainColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: Text(
                                  (user.balance ?? 0) >= total
                                      ? "Checkout Now"
                                      : "Top Up My Wallet",
                                  style: whiteTextFont.copyWith(fontSize: 16),
                                ),
                                onPressed: () {
                                  if ((user.balance ?? 0) >= total) {
                                    FlutixTransaction transaction =
                                        FlutixTransaction(
                                      userID: user.id,
                                      title:
                                          widget.ticket.movieDetail.title ?? '',
                                      subtitle: widget.ticket.theater.name,
                                      time: DateTime.now(),
                                      amount: -total,
                                      picture:
                                          widget.ticket.movieDetail.posterPath,
                                    );

                                    context.read<PageBloc>().add(
                                          GoToSuccessPage(
                                            widget.ticket
                                                .copyWith(totalPrice: total),
                                            transaction,
                                          ),
                                        );
                                  } else {
                                    // Handle insufficient balance
                                  }
                                },
                              ),
                            )
                          ],
                        );
                      },
                    ),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildOrderDetails(String label, String value,
      [Color color = Colors.black]) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: defaultMargin),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(label,
              style: greyTextFont.copyWith(
                  fontSize: 16, fontWeight: FontWeight.w400)),
          Text(
            value,
            style: whiteNumberFont.copyWith(
              color: color,
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          )
        ],
      ),
    );
  }
}
