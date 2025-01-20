part of 'widgets.dart';

class RatingStars extends StatelessWidget {
  final double voteAverage;
  final double starSize;
  final double fontSize;
  final Color? color;
  final MainAxisAlignment alignment;

  RatingStars({
    this.voteAverage = 0,
    this.starSize = 20,
    this.fontSize = 12,
    this.color,
    this.alignment = MainAxisAlignment.start,
  });

  @override
  Widget build(BuildContext context) {
    int filledStars = (voteAverage / 2).round();

    List<Widget> starWidgets = List.generate(
      5,
      (index) => Icon(
        index < filledStars ? MdiIcons.star : MdiIcons.starOutline,
        color: accentColor2,
        size: starSize,
      ),
    );

    return Row(
      mainAxisAlignment: alignment,
      children: [
        ...starWidgets,
        SizedBox(width: 3),
        Text(
          "${voteAverage.toStringAsFixed(1)}/10",
          style: whiteNumberFont.copyWith(
            color: color ?? Colors.white,
            fontWeight: FontWeight.w300,
            fontSize: fontSize,
          ),
        ),
      ],
    );
  }
}
