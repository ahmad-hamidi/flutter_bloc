part of 'pages.dart';

class TicketPage extends StatefulWidget {
  final bool isExpiredTicket;

  const TicketPage({this.isExpiredTicket = false, Key? key}) : super(key: key);

  @override
  _TicketPageState createState() => _TicketPageState();
}

class _TicketPageState extends State<TicketPage> {
  late bool isExpiredTickets;

  @override
  void initState() {
    super.initState();
    isExpiredTickets = widget.isExpiredTicket;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          // Content
          BlocBuilder<TicketBloc, TicketState>(
            builder: (_, ticketState) {
              if (ticketState is TicketLoaded) {
                final tickets = isExpiredTickets
                    ? ticketState.tickets
                        .where((ticket) => ticket.time.isBefore(DateTime.now()))
                        .toList()
                    : ticketState.tickets
                        .where(
                            (ticket) => !ticket.time.isBefore(DateTime.now()))
                        .toList();
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: defaultMargin),
                  child: TicketViewer(tickets),
                );
              }
              return Center(
                child: CircularProgressIndicator(color: accentColor1),
              );
            },
          ),
          // Header
          Container(
            height: 113,
            color: accentColor1,
          ),
          SafeArea(
            child: ClipPath(
              clipper: HeaderClipper(),
              child: Container(
                height: 113,
                color: accentColor1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Container(
                      margin: const EdgeInsets.only(left: 24, bottom: 32),
                      child: Text(
                        "My Tickets",
                        style: whiteTextFont.copyWith(fontSize: 20),
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        buildTabButton(
                          title: "Newest",
                          isSelected: !isExpiredTickets,
                          onTap: () => setState(() {
                            isExpiredTickets = false;
                          }),
                        ),
                        buildTabButton(
                          title: "Oldest",
                          isSelected: isExpiredTickets,
                          onTap: () => setState(() {
                            isExpiredTickets = true;
                          }),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTabButton({
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: Column(
        children: <Widget>[
          GestureDetector(
            onTap: onTap,
            child: Text(
              title,
              style: whiteTextFont.copyWith(
                fontSize: 16,
                color: isSelected ? Colors.white : const Color(0xFF6F678E),
              ),
            ),
          ),
          const SizedBox(height: 15),
          Container(
            height: 4,
            color: isSelected ? accentColor2 : Colors.transparent,
          ),
        ],
      ),
    );
  }
}

class HeaderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 20);
    path.quadraticBezierTo(0, size.height, 20, size.height);
    path.lineTo(size.width - 20, size.height);
    path.quadraticBezierTo(
        size.width, size.height, size.width, size.height - 20);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class TicketViewer extends StatelessWidget {
  final List<Ticket> tickets;

  const TicketViewer(this.tickets, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final sortedTickets = [...tickets]
      ..sort((ticket1, ticket2) => ticket1.time.compareTo(ticket2.time));

    return ListView.builder(
      itemCount: sortedTickets.length,
      itemBuilder: (_, index) => GestureDetector(
        onTap: () {
          context
              .read<PageBloc>()
              .add(GoToTicketDetailPage(sortedTickets[index]));
        },
        child: Container(
          margin: EdgeInsets.only(top: index == 0 ? 133 : 20),
          child: Row(
            children: <Widget>[
              Container(
                width: 70,
                height: 90,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                    image: NetworkImage(
                      imageBaseURL +
                          'w500' +
                          (sortedTickets[index].movieDetail.posterPath ?? ''),
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              SizedBox(
                width: MediaQuery.of(context).size.width -
                    2 * defaultMargin -
                    70 -
                    16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      (sortedTickets[index].movieDetail.title ?? ''),
                      style: blackTextFont.copyWith(fontSize: 18),
                      maxLines: 2,
                      overflow: TextOverflow.clip,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      sortedTickets[index].movieDetail.genresAndLanguage,
                      style: greyTextFont.copyWith(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      sortedTickets[index].theater.name,
                      style: greyTextFont.copyWith(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
