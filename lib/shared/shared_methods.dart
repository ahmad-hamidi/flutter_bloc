part of 'shared.dart';

Future<File?> getImage() async {
  final picker = ImagePicker();
  XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

  if (pickedFile != null) {
    return File(pickedFile.path);
  } else {
    return null; // Return null if no image is picked
  }
}

Future<String?> uploadImage(File image) async {
  try {
    String fileName = basename(image.path);

    Reference ref = FirebaseStorage.instance.ref().child(fileName);
    UploadTask task = ref.putFile(image);
    TaskSnapshot snapshot = await task;

    return await snapshot.ref.getDownloadURL();
  } catch (e) {
    print("Error uploading image: $e");
    return null; // Return null if there's an error
  }
}

Widget generateDashedDivider(double width) {
  int n = width ~/ 5;
  return Row(
    children: List.generate(
      n,
      (index) => (index % 2 == 0)
          ? Container(
              height: 2,
              width: width / n,
              color: const Color(0xFFE4E4E4),
            )
          : SizedBox(
              width: width / n,
            ),
    ),
  );
}
