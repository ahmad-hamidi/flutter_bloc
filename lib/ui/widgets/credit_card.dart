part of 'widgets.dart';

class CreditCard extends StatelessWidget {
  final Credit credit;

  CreditCard(this.credit);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          height: 80,
          width: 70,
          decoration: BoxDecoration(
            color: Colors.blueGrey[100],
            borderRadius: BorderRadius.circular(8),
            image:
                (credit.profilePath != null && credit.profilePath!.isNotEmpty)
                    ? DecorationImage(
                        image: NetworkImage(
                          imageBaseURL + "w185" + credit.profilePath!,
                        ),
                        fit: BoxFit.cover,
                      )
                    : null,
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 6),
          width: 70,
          child: Text(
            credit.name ?? "No Name", // Fallback in case `name` is null
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: blackTextFont.copyWith(
              fontSize: 10,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }
}
