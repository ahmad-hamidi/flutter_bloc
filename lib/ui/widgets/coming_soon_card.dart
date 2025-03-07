part of 'widgets.dart';

class ComingSoonCard extends StatelessWidget {
  final Movie movie;
  final VoidCallback? onTap;

  ComingSoonCard(this.movie, {this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 160,
        width: 120,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          image: DecorationImage(
            image: NetworkImage(
              imageBaseURL + "w500" + (movie.posterPath ?? ""),
            ),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
