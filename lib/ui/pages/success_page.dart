part of 'pages.dart';

class SuccessPage extends StatelessWidget {
  final Ticket? ticket;
  final FlutixTransaction transaction;

  SuccessPage(this.ticket, this.transaction);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: FutureBuilder(
          future: ticket != null
              ? processingTicketOrder(context)
              : processingTopUp(context),
          builder: (_, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 150,
                    height: 150,
                    margin: const EdgeInsets.only(bottom: 70),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(ticket == null
                            ? "assets/top_up_done.png"
                            : "assets/ticket_done.png"),
                      ),
                    ),
                  ),
                  Text(
                    ticket == null ? "Emmm Yummy!" : "Happy Watching!",
                    style: blackTextFont.copyWith(fontSize: 20),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    ticket == null
                        ? "You have successfully\ntopped up your wallet"
                        : "You have successfully\nbought the ticket",
                    textAlign: TextAlign.center,
                    style: blackTextFont.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  Container(
                    height: 45,
                    width: 250,
                    margin: const EdgeInsets.only(top: 70, bottom: 20),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: mainColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        ticket == null ? "My Wallet" : "My Tickets",
                        style: whiteTextFont.copyWith(fontSize: 16),
                      ),
                      onPressed: () {
                        if (ticket == null) {
                          context
                              .read<PageBloc>()
                              .add(GoToWalletPage(GoToMainPage()));
                        } else {
                          context
                              .read<PageBloc>()
                              .add(GoToMainPage(bottomNavBarIndex: 1));
                        }
                      },
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Discover new movie? ",
                        style:
                            greyTextFont.copyWith(fontWeight: FontWeight.w400),
                      ),
                      GestureDetector(
                        onTap: () {
                          context.read<PageBloc>().add(GoToMainPage());
                        },
                        child: Text(
                          "Back to Home",
                          style: purpleTextFont,
                        ),
                      ),
                    ],
                  ),
                ],
              );
            } else {
              return Center(
                child: SpinKitFadingCircle(
                  color: mainColor,
                  size: 50,
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Future<void> processingTicketOrder(BuildContext context) async {
    context.read<UserBloc>().add(Purchase(ticket!.totalPrice));
    context.read<TicketBloc>().add(BuyTicket(ticket!, transaction.userID));
    await FlutixTransactionServices.saveTransaction(transaction);
  }

  Future<void> processingTopUp(BuildContext context) async {
    context.read<UserBloc>().add(TopUp(transaction.amount));
    await FlutixTransactionServices.saveTransaction(transaction);
  }
}
