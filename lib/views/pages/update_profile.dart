part of 'pages.dart';

class UpdateProfile extends StatefulWidget {
  final UserModel userModel;
  const UpdateProfile({Key? key, required this.userModel}) : super(key: key);

  @override
  State<UpdateProfile> createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  final TextEditingController fullnameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  final ImagePicker picker = ImagePicker();
  List<String> errValEmail = [], errValFullName = [];
  bool isLoading = false;
  String image = "";

  _showBottomFotoDialog() {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
            ListTile(
              title: Text('Choose Source Photo',
                  style: blackTextStyle.copyWith(fontWeight: semibold)),
            ),
            ListTile(
                leading: const Icon(Icons.photo),
                title: Text('Gallery', style: blackTextStyle),
                onTap: () {
                  getImagePicker('gallery');
                  Navigator.pop(context);
                }),
            ListTile(
                leading: const Icon(Icons.camera_alt),
                title: Text('Camera', style: blackTextStyle),
                onTap: () {
                  getImagePicker('camera');
                  Navigator.pop(context);
                })
          ]);
        });
  }

  Future getImagePicker(String sumber) async {
    XFile? pickedFile;
    if (sumber == "camera") {
      pickedFile =
          await picker.pickImage(source: ImageSource.camera, maxWidth: 800);
    } else {
      pickedFile =
          await picker.pickImage(source: ImageSource.gallery, maxWidth: 800);
    }

    if (pickedFile != null) {
      setState(() {
        image = pickedFile!.path;
      });
    } else {
      if (!mounted) return;
      Utilities.showToast('No image selected', context, status: 'error');
    }
  }

  Future<void> update() async {
    setState(() {
      isLoading = true;
    });
    SharedPreferences prefs = await GlobalService.sharedPreference;
    MultipartRequest request =
        http.MultipartRequest('POST', Uri.parse(BaseURL.apiUpdateProfile));
    request.fields['user_id'] = prefs.getString(UserPreferenceModel.userID)!;
    request.fields['fullname'] = fullnameController.text;
    request.fields['email'] = emailController.text;
    if (image != "") {
      request.files.add(await http.MultipartFile.fromPath('image', image));
    }
    StreamedResponse streamedResponse = await request.send();
    Response response = await http.Response.fromStream(streamedResponse);
    GlobalModel responseModel = GlobalModel.fromJson(jsonDecode(response.body));
    if (!mounted) return;
    if (responseModel.status == 'success') {
      Navigator.pop(context);
      Utilities.showToast(responseModel.result['message'], context);
    } else {
      Utilities.showToast(responseModel.errorMessage, context, status: 'error');
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  void dispose() {
    fullnameController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    fullnameController.text = widget.userModel.name!;
    emailController.text = widget.userModel.email!;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Helpers.focusScope(context);
        },
        child: Scaffold(
            appBar: AppBar(title: const Text('Update Profile')),
            body: ListView(padding: EdgeInsets.all(defaultMargin), children: [
              Center(
                  child: Container(
                      height: 120,
                      width: 120,
                      margin: EdgeInsets.only(bottom: defaultMargin - 5),
                      decoration: BoxDecoration(
                          border: Border.all(width: 0.5, color: kGreyColor),
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image: (image == "")
                                  ? (widget.userModel.image != "")
                                      ? Image.network(
                                              "${BaseURL.pahtImageNetwork}/${widget.userModel.image}")
                                          .image
                                      : const AssetImage(
                                          '$assetImagePath/placeholder_profile.png')
                                  : Image.file(File(image)).image,
                              fit: BoxFit.cover)),
                      child: Stack(children: [
                        Align(
                            alignment: Alignment.bottomRight,
                            child: Material(
                                color: kPrimaryColor,
                                borderRadius: BorderRadius.circular(50),
                                child: InkWell(
                                    borderRadius: BorderRadius.circular(50),
                                    onTap: _showBottomFotoDialog,
                                    child: Container(
                                        height: 45,
                                        width: 45,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(50)),
                                        child: Center(
                                            child: Icon(
                                                Icons.add_a_photo_outlined,
                                                color: kWhiteColor,
                                                size: 16))))))
                      ]))),
              WidgetInputBox(
                  controller: fullnameController,
                  label: 'Full Name',
                  hintText: 'Full Name',
                  prefixIcon: const Icon(Icons.person_outline),
                  errVal: errValFullName),
              WidgetInputBox(
                  controller: emailController,
                  prefixIcon: const Icon(Icons.mail_outline),
                  hintText: 'Email Address',
                  label: 'Email Address',
                  readOnly: true,
                  keyboardType: TextInputType.emailAddress,
                  errVal: errValEmail),
              WidgetButtonPrimary(
                  isLoading: isLoading,
                  label: 'UPDATE',
                  onClick: () {
                    setState(() {
                      errValFullName.clear();
                      errValEmail.clear();
                      if (fullnameController.text.isEmpty) {
                        errValFullName.add('Fullname must not be empty');
                      }
                      if (emailController.text.isEmpty) {
                        errValEmail.add('Email must not be empty');
                      }
                      if (!EmailValidator.validate(emailController.text)) {
                        errValEmail.add('Email is not valid');
                      }

                      if (errValEmail.isEmpty && errValFullName.isEmpty) {
                        update();
                      }
                    });
                  })
            ])));
  }
}
