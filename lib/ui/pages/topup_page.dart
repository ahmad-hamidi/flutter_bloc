part of 'pages.dart';

class TopUpPage extends StatefulWidget {
  final PageEvent pageEvent;

  const TopUpPage(this.pageEvent, {Key? key}) : super(key: key);

  @override
  _TopUpPageState createState() => _TopUpPageState();
}

class _TopUpPageState extends State<TopUpPage> {
  TextEditingController amountController = TextEditingController(text: 'IDR 0');
  int selectedAmount = 0;

  @override
  Widget build(BuildContext context) {
    context.read<ThemeBloc>().add(ChangeTheme(
        ThemeData().copyWith(primaryColor: const Color(0xFFE4E4E4))));

    double cardWidth =
        (MediaQuery.of(context).size.width - 2 * defaultMargin - 40) / 3;

    return WillPopScope(
      onWillPop: () async {
        context.read<PageBloc>().add(widget.pageEvent);
        return false;
      },
      child: Scaffold(
        body: ListView(
          children: <Widget>[
            Stack(
              children: <Widget>[
                // Back Arrow
                SafeArea(
                  child: Container(
                    margin: const EdgeInsets.only(top: 20, left: defaultMargin),
                    child: GestureDetector(
                      onTap: () {
                        context.read<PageBloc>().add(widget.pageEvent);
                      },
                      child: const Icon(Icons.arrow_back, color: Colors.black),
                    ),
                  ),
                ),
                // Content
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(horizontal: defaultMargin),
                  child: Column(
                    children: <Widget>[
                      const SizedBox(height: 20),
                      Text(
                        "Top Up",
                        style: blackTextFont.copyWith(fontSize: 20),
                      ),
                      const SizedBox(height: 30),
                      TextField(
                        onChanged: (text) {
                          String temp = '';

                          for (int i = 0; i < text.length; i++) {
                            if (text[i].isDigit == true) temp += text[i];
                          }

                          setState(() {
                            selectedAmount = int.tryParse(temp) ?? 0;
                          });

                          amountController.text = NumberFormat.currency(
                            locale: 'id_ID',
                            symbol: 'IDR ',
                            decimalDigits: 0,
                          ).format(selectedAmount);

                          amountController.selection =
                              TextSelection.fromPosition(
                            TextPosition(offset: amountController.text.length),
                          );
                        },
                        controller: amountController,
                        decoration: InputDecoration(
                          labelStyle: greyTextFont,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                          labelText: "Amount",
                        ),
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                          margin: const EdgeInsets.only(top: 20, bottom: 14),
                          child:
                              Text("Choose by Template", style: blackTextFont),
                        ),
                      ),
                      Wrap(
                        spacing: 20,
                        runSpacing: 14,
                        children: <Widget>[
                          for (var amount in [
                            50000,
                            100000,
                            150000,
                            200000,
                            250000,
                            500000,
                            1000000,
                            2500000,
                            5000000
                          ])
                            makeMoneyCard(amount: amount, width: cardWidth),
                        ],
                      ),
                      const SizedBox(height: 100),
                      SizedBox(
                        width: 250,
                        height: 46,
                        child: BlocBuilder<UserBloc, UserState>(
                          builder: (a, userState) {
                            if (userState is UserLoaded) {
                              return ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  elevation: 0,
                                  backgroundColor: const Color(0xFF3E9D9D),
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                onPressed: (selectedAmount > 0)
                                    ? () {
                                        context.read<PageBloc>().add(
                                              GoToSuccessPage(
                                                null,
                                                FlutixTransaction(
                                                  userID: userState.user.id,
                                                  title: "Top Up Wallet",
                                                  amount: selectedAmount,
                                                  subtitle:
                                                      "${DateTime.now().dayName}, ${DateTime.now().day} ${DateTime.now().monthName} ${DateTime.now().year}",
                                                  time: DateTime.now(),
                                                ),
                                              ),
                                            );
                                      }
                                    : null,
                                child: Text(
                                  "Top Up My Wallet",
                                  style: whiteTextFont.copyWith(
                                    fontSize: 16,
                                    color: selectedAmount > 0
                                        ? Colors.white
                                        : const Color(0xFFBEBEBE),
                                  ),
                                ),
                              );
                            }
                            return const SizedBox();
                          },
                        ),
                      ),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  MoneyCard makeMoneyCard({required int amount, required double width}) {
    return MoneyCard(
      amount: amount,
      width: width,
      isSelected: amount == selectedAmount,
      onTap: () {
        setState(() {
          if (selectedAmount != amount) {
            selectedAmount = amount;
          } else {
            selectedAmount = 0;
          }

          amountController.text = NumberFormat.currency(
            locale: 'id_ID',
            decimalDigits: 0,
            symbol: 'IDR ',
          ).format(selectedAmount);

          amountController.selection = TextSelection.fromPosition(
            TextPosition(offset: amountController.text.length),
          );
        });
      },
    );
  }
}
