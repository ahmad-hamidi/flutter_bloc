part of 'pages.dart';

class SignUpPage extends StatefulWidget {
  final RegistrationData registrationData;

  SignUpPage(this.registrationData);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController retypePasswordController =
      TextEditingController();

  @override
  void initState() {
    super.initState();

    nameController.text = widget.registrationData.name;
    emailController.text = widget.registrationData.email;
  }

  @override
  Widget build(BuildContext context) {
    context
        .read<ThemeBloc>()
        .add(ChangeTheme(ThemeData().copyWith(primaryColor: accentColor1)));

    return WillPopScope(
      onWillPop: () async {
        context.read<PageBloc>().add(GoToSplashPage());
        return true;
      },
      child: Scaffold(
        body: Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: defaultMargin),
          child: ListView(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.only(top: 20, bottom: 22),
                    height: 56,
                    child: Stack(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.centerLeft,
                          child: GestureDetector(
                            onTap: () {
                              context.read<PageBloc>().add(GoToSplashPage());
                            },
                            child: const Icon(Icons.arrow_back,
                                color: Colors.black),
                          ),
                        ),
                        Center(
                          child: Text(
                            "Create New\nAccount",
                            style: blackTextFont.copyWith(fontSize: 20),
                            textAlign: TextAlign.center,
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    width: 90,
                    height: 104,
                    child: Stack(
                      children: <Widget>[
                        Container(
                          height: 90,
                          width: 90,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: widget.registrationData.profileImage ==
                                      null
                                  ? const AssetImage("assets/user_pic.png")
                                  : FileImage(
                                          widget.registrationData.profileImage!)
                                      as ImageProvider,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: GestureDetector(
                            onTap: () async {
                              if (widget.registrationData.profileImage ==
                                  null) {
                                widget.registrationData.profileImage =
                                    await getImage();
                              } else {
                                widget.registrationData.profileImage = null;
                              }
                              setState(() {});
                            },
                            child: Container(
                              height: 28,
                              width: 28,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: AssetImage(
                                      widget.registrationData.profileImage ==
                                              null
                                          ? "assets/btn_add_photo.png"
                                          : "assets/btn_del_photo.png"),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 36),
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      labelText: "Full Name",
                      hintText: "Full Name",
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      labelText: "Email",
                      hintText: "Email",
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      labelText: "Password",
                      hintText: "Password",
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: retypePasswordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      labelText: "Confirm Password",
                      hintText: "Confirm Password",
                    ),
                  ),
                  const SizedBox(height: 30),
                  FloatingActionButton(
                    child: const Icon(Icons.arrow_forward),
                    backgroundColor: mainColor,
                    elevation: 0,
                    onPressed: () {
                      if (!(nameController.text.trim().isNotEmpty &&
                          emailController.text.trim().isNotEmpty &&
                          passwordController.text.trim().isNotEmpty &&
                          retypePasswordController.text.trim().isNotEmpty)) {
                        showFlushbar(context, "Please fill all the fields");
                      } else if (passwordController.text !=
                          retypePasswordController.text) {
                        showFlushbar(context,
                            "Mismatch password and confirmed password");
                      } else if (passwordController.text.length < 6) {
                        showFlushbar(
                            context, "Password's length min 6 characters");
                      } else if (!EmailValidator.validate(
                          emailController.text)) {
                        showFlushbar(context, "Wrong formatted email address");
                      } else {
                        widget.registrationData.name = nameController.text;
                        widget.registrationData.email = emailController.text;
                        widget.registrationData.password =
                            passwordController.text;

                        context
                            .read<PageBloc>()
                            .add(GoToPreferencePage(widget.registrationData));
                      }
                    },
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void showFlushbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message ?? "Unknown error occurred"),
      ),
    );
  }
}
