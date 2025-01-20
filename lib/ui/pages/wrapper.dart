part of 'pages.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final firebaseUser = Provider.of<auth.User?>(context);

    if (firebaseUser == null) {
      if (prevPageEvent is! GoToSplashPage) {
        prevPageEvent = GoToSplashPage();
        context.read<PageBloc>().add(prevPageEvent!);
      }
    } else {
      if (prevPageEvent is! GoToMainPage) {
        context.read<UserBloc>().add(LoadUser(firebaseUser.uid));
        context.read<TicketBloc>().add(GetTickets(firebaseUser.uid));

        prevPageEvent = GoToMainPage();
        context.read<PageBloc>().add(prevPageEvent!);
      }
    }

    return BlocBuilder<PageBloc, PageState>(
      builder: (_, pageState) {
        if (pageState is OnSplashPage) {
          return SplashPage();
        } else if (pageState is OnLoginPage) {
          return SignInPage();
        } else if (pageState is OnRegistrationPage) {
          return SignUpPage(pageState.registrationData);
        } else if (pageState is OnPreferencePage) {
          return PreferencePage(pageState.registrationData);
        } else if (pageState is OnAccountConfirmationPage) {
          return AccountConfirmationPage(pageState.registrationData);
        } else if (pageState is OnMovieDetailPage) {
          return MovieDetailPage(pageState.movie);
        } else if (pageState is OnSelectSchedulePage) {
          return SelectSchedulePage(pageState.movieDetail);
        } else if (pageState is OnSelectSeatPage) {
          return SelectSeatPage(pageState.ticket);
        } else if (pageState is OnCheckoutPage) {
          return CheckoutPage(pageState.ticket);
        } else if (pageState is OnSuccessPage) {
          return SuccessPage(pageState.ticket, pageState.transaction);
        } else if (pageState is OnTicketDetailPage) {
          return TicketDetailPage(pageState.ticket);
        } else if (pageState is OnProfilePage) {
          return ProfilePage();
        } else if (pageState is OnTopUpPage) {
          return TopUpPage(pageState.pageEvent);
        } else if (pageState is OnWalletPage) {
          return WalletPage(pageState.pageEvent);
        } else if (pageState is OnEditProfilePage) {
          return EditProfilePage(pageState.user);
        } else if (pageState is OnMainPage) {
          return MainPage(
            bottomNavBarIndex: pageState.bottomNavBarIndex,
            isExpired: pageState.isExpired,
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}
