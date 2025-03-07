part of 'pages.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        context.read<PageBloc>().add(GoToMainPage());
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: defaultMargin),
              child: ListView(
                children: <Widget>[
                  BlocBuilder<UserBloc, UserState>(
                    builder: (_, userState) {
                      if (userState is UserLoaded) {
                        User user = userState.user;

                        return Column(
                          children: <Widget>[
                            Container(
                              margin:
                                  const EdgeInsets.only(top: 74, bottom: 10),
                              width: 120,
                              height: 120,
                              child: Stack(
                                children: <Widget>[
                                  Center(
                                    child: SizedBox(
                                      width: 50,
                                      height: 50,
                                      child: SpinKitFadingCircle(
                                        color: mainColor,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                        image:
                                            (user.profilePicture?.isNotEmpty ==
                                                    true)
                                                ? NetworkImage(
                                                    user.profilePicture ?? '')
                                                : const AssetImage(
                                                    "assets/user_pic.png",
                                                  ) as ImageProvider<Object>,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width -
                                  2 * defaultMargin,
                              child: Text(
                                user.name ?? '',
                                maxLines: 2,
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.clip,
                                style: blackTextFont.copyWith(fontSize: 18),
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width -
                                  2 * defaultMargin,
                              margin: const EdgeInsets.only(top: 8, bottom: 30),
                              child: Text(
                                user.email,
                                textAlign: TextAlign.center,
                                style: greyTextFont.copyWith(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ),
                          ],
                        );
                      } else {
                        return const SizedBox();
                      }
                    },
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      BlocBuilder<UserBloc, UserState>(
                        builder: (_, userState) {
                          if (userState is UserLoaded) {
                            return GestureDetector(
                              onTap: () {
                                context
                                    .read<PageBloc>()
                                    .add(GoToEditProfilePage(userState.user));
                              },
                              child: Row(
                                children: <Widget>[
                                  SizedBox(
                                    width: 24,
                                    height: 24,
                                    child:
                                        Image.asset("assets/edit_profile.png"),
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    "Edit Profile",
                                    style: blackTextFont.copyWith(fontSize: 16),
                                  ),
                                ],
                              ),
                            );
                          }
                          return const SizedBox();
                        },
                      ),
                      const SizedBox(height: 16),
                      generateDashedDivider(
                        MediaQuery.of(context).size.width - 2 * defaultMargin,
                      ),
                      GestureDetector(
                        onTap: () {
                          context
                              .read<PageBloc>()
                              .add(GoToWalletPage(GoToProfilePage()));
                        },
                        child: Row(
                          children: <Widget>[
                            SizedBox(
                              width: 24,
                              height: 24,
                              child: Image.asset("assets/my_wallet.png"),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              "My Wallet",
                              style: blackTextFont.copyWith(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      generateDashedDivider(
                        MediaQuery.of(context).size.width - 2 * defaultMargin,
                      ),
                      GestureDetector(
                        onTap: () async {
                          await AuthServices.signOut();
                          context.read<UserBloc>().add(SignOut());
                        },
                        child: Row(
                          children: <Widget>[
                            SizedBox(
                              width: 24,
                              height: 24,
                              child: Icon(
                                MdiIcons.logout,
                                color: mainColor,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              "Sign Out",
                              style: blackTextFont.copyWith(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      generateDashedDivider(
                        MediaQuery.of(context).size.width - 2 * defaultMargin,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SafeArea(
              child: Container(
                margin: const EdgeInsets.only(top: 20, left: defaultMargin),
                child: GestureDetector(
                  onTap: () {
                    context.read<PageBloc>().add(GoToMainPage());
                  },
                  child: const Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
