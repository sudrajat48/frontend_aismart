part of 'pages.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController fullnameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isLoading = false;
  List<String> errValFullname = [], errValEmail = [], errValPassword = [];

  Future<void> signUp() async {
    setState(() {
      isLoading = true;
    });
    GlobalModel response = await GlobalService.postData(
        BaseURL.apiSignUP,
        {
          'fullname': fullnameController.text,
          'email': emailController.text,
          'password': passwordController.text
        },
        context);
    setState(() {
      isLoading = false;
    });
    if (!mounted) return;
    if (response.status == 'success') {
      Utilities.showToast(response.result['message'], context);
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const SignInPage()),
          (route) => false);
    } else {
      Utilities.showAlertDialog(
          context, alertPeringatan, response.errorMessage);
    }
  }

  @override
  void dispose() {
    fullnameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Helpers.focusScope(context);
        },
        child: Scaffold(
            body: ListView(
                padding: EdgeInsets.symmetric(horizontal: defaultMargin),
                children: [
              Container(
                  height: 120,
                  margin: EdgeInsets.only(
                      top: defaultMargin * 3, bottom: defaultMargin),
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image:
                              AssetImage('$assetImagePath/logo_primary.png')))),
              Text('Register',
                  style: blackTextStyle.copyWith(
                      fontSize: 22, fontWeight: semibold)),
              SizedBox(height: defaultMargin),
              WidgetInputBox(
                  controller: fullnameController,
                  prefixIcon: const Icon(Icons.person_outline),
                  hintText: 'Full Name',
                  errVal: errValFullname),
              WidgetInputBox(
                  controller: emailController,
                  prefixIcon: const Icon(Icons.mail_outline),
                  hintText: 'Email Address',
                  keyboardType: TextInputType.emailAddress,
                  errVal: errValEmail),
              WidgetInputBox(
                  controller: passwordController,
                  prefixIcon: const Icon(Icons.lock_outline),
                  obscureText: true,
                  hintText: 'Password',
                  errVal: errValPassword),
              Container(
                  margin: EdgeInsets.only(top: defaultMargin, bottom: 10),
                  child: WidgetButtonPrimary(
                      isLoading: isLoading,
                      label: 'SIGN UP',
                      onClick: () {
                        setState(() {
                          errValFullname.clear();
                          errValEmail.clear();
                          errValPassword.clear();
                          if (fullnameController.text.isEmpty) {
                            errValFullname.add('Fullname must not be empty');
                          }
                          if (emailController.text.isEmpty) {
                            errValEmail.add('Email must not be empty');
                          }
                          if (!EmailValidator.validate(emailController.text)) {
                            errValEmail.add('Email is not valid');
                          }
                          if (passwordController.text.isEmpty) {
                            errValPassword.add('Password must not be empty');
                          }
                          if (passwordController.text.length < 8) {
                            errValPassword
                                .add('Password must be at least 8 characters');
                          }

                          if (errValFullname.isEmpty &&
                              errValEmail.isEmpty &&
                              errValPassword.isEmpty) {
                            signUp();
                          }
                        });
                      })),
              Center(
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                    Text('Already Have Account ? ',
                        style: greyTextStyle.copyWith(fontSize: 16)),
                    InkWell(
                        borderRadius: BorderRadius.circular(5),
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Text('Sign In Now',
                                style: greyTextStyle.copyWith(
                                    fontSize: 16,
                                    color: kPrimaryColor,
                                    fontWeight: semibold,
                                    decoration: TextDecoration.underline))))
                  ]))
            ])));
  }
}
