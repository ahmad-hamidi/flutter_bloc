part of 'pages.dart';

class EditProfilePage extends StatefulWidget {
  final User user;

  EditProfilePage(this.user);

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController nameController;
  String profilePath = "";
  bool isDataEdited = false;
  File? profileImageFile;
  bool isUpdating = false;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.user.name ?? "");
    profilePath = widget.user.profilePicture ?? "";
  }

  @override
  Widget build(BuildContext context) {
    context
        .read<ThemeBloc>()
        .add(ChangeTheme(ThemeData().copyWith(primaryColor: accentColor2)));

    return WillPopScope(
      onWillPop: () async {
        context.read<PageBloc>().add(GoToProfilePage());
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(horizontal: defaultMargin),
              child: ListView(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      SizedBox(height: 20),
                      Text(
                        "Edit Your\nProfile",
                        textAlign: TextAlign.center,
                        style: blackTextFont.copyWith(fontSize: 20),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 22, bottom: 10),
                        width: 90,
                        height: 104,
                        child: Stack(
                          children: <Widget>[
                            Container(
                              width: 90,
                              height: 90,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: (profileImageFile != null)
                                      ? FileImage(profileImageFile!)
                                      : (profilePath.isNotEmpty)
                                          ? NetworkImage(profilePath)
                                              as ImageProvider
                                          : AssetImage("assets/user_pic.png"),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: GestureDetector(
                                onTap: () async {
                                  if (profilePath.isEmpty) {
                                    profileImageFile = await getImage();

                                    if (profileImageFile != null) {
                                      profilePath =
                                          basename(profileImageFile!.path);
                                    }
                                  } else {
                                    profileImageFile = null;
                                    profilePath = "";
                                  }

                                  setState(() {
                                    isDataEdited = nameController.text.trim() !=
                                            widget.user.name ||
                                        profilePath !=
                                            widget.user.profilePicture;
                                  });
                                },
                                child: Container(
                                  width: 28,
                                  height: 28,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      image: AssetImage(profilePath.isEmpty
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
                      AbsorbPointer(
                        child: TextField(
                          controller:
                              TextEditingController(text: widget.user.id),
                          style: whiteNumberFont.copyWith(color: accentColor3),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            labelText: "User ID",
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      AbsorbPointer(
                        child: TextField(
                          controller:
                              TextEditingController(text: widget.user.email),
                          style: greyTextFont,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            labelText: "Email Address",
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      TextField(
                        controller: nameController,
                        onChanged: (text) {
                          setState(() {
                            isDataEdited = text.trim() != widget.user.name ||
                                profilePath != widget.user.profilePicture;
                          });
                        },
                        style: blackTextFont,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          labelText: "Full Name",
                          hintText: "Full Name",
                        ),
                      ),
                      SizedBox(height: 30),
                      SizedBox(
                        width: 250,
                        height: 45,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red[400]),
                          child: Text(
                            "Change Password",
                            style: whiteTextFont.copyWith(fontSize: 16),
                          ),
                          onPressed: isUpdating
                              ? null
                              : () async {
                                  await AuthServices.resetPassword(
                                      widget.user.email);

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        "The link to change your password has been sent to your email.",
                                      ),
                                    ),
                                  );
                                },
                        ),
                      ),
                      SizedBox(height: 16),
                      if (isUpdating)
                        SizedBox(
                          width: 50,
                          height: 50,
                          child: SpinKitFadingCircle(color: Color(0xFF3E9D9D)),
                        )
                      else
                        SizedBox(
                          width: 250,
                          height: 45,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF3E9D9D)),
                            child: Text(
                              "Update My Profile",
                              style: whiteTextFont.copyWith(fontSize: 16),
                            ),
                            onPressed: isDataEdited
                                ? () async {
                                    setState(() {
                                      isUpdating = true;
                                    });

                                    if (profileImageFile != null) {
                                      profilePath = await uploadImage(
                                              profileImageFile!) ??
                                          '';
                                    }

                                    context.read<UserBloc>().add(
                                          UpdateData(
                                            name: nameController.text,
                                            profileImage: profilePath,
                                          ),
                                        );

                                    context
                                        .read<PageBloc>()
                                        .add(GoToProfilePage());
                                  }
                                : null,
                          ),
                        ),
                    ],
                  )
                ],
              ),
            ),
            SafeArea(
              child: Container(
                margin: EdgeInsets.only(top: 20, left: defaultMargin),
                child: GestureDetector(
                  onTap: () {
                    context.read<PageBloc>().add(GoToProfilePage());
                  },
                  child: Icon(Icons.arrow_back, color: Colors.black),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
