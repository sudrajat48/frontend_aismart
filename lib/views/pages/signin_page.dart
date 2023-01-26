part of 'pages.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isLoading = false, isLoadingGoogle = false;
  List<String> errValEmail = [], errValPassword = [];

  Future<void> signIn(email, password, {bool? isGoogle = false}) async {
    if (!isGoogle!) {
      setState(() {
        isLoading = true;
      });
    }
    GlobalModel response = await GlobalService.postData(
        BaseURL.apiSignIN, {'email': email, 'password': password}, context);
    if (!isGoogle) {
      setState(() {
        isLoading = false;
      });
    }
    if (!mounted) return;
    if (response.status == 'success') {
      SharedPreferences prefs = await GlobalService.sharedPreference;
      if (!mounted) return;
      prefs.setString(
          UserPreferenceModel.userID, response.result['data']['id']);
      Utilities.showToast(response.result['message'], context);
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const MainPage()),
          (route) => false);
    } else {
      Utilities.showAlertDialog(
          context, alertPeringatan, response.errorMessage);
    }
  }

  Future<void> signInGoogle() async {
    try {
      setState(() {
        isLoadingGoogle = true;
      });
      GoogleSignInAccount? account = await GoogleSignIn().signIn();

      if (account != null) {
        GoogleSignInAuthentication auth = await account.authentication;
        OAuthCredential credential = GoogleAuthProvider.credential(
          accessToken: auth.accessToken,
          idToken: auth.idToken,
        );

        await FirebaseAuth.instance.signInWithCredential(credential);

        // String status = await checkEmailFromGoogleSignIn(account.email);
        if (!mounted) return;
        GlobalModel responseCheckEmail = await GlobalService.postData(
            BaseURL.checkEmailFromGoogleSignIn,
            {'email': account.email},
            context);

        if (responseCheckEmail.status == 'sign_up') {
          await signUp(account.displayName, account.email, account.id);
        } else if (responseCheckEmail.status == 'success') {
          await signIn(account.email, account.id, isGoogle: true);
        } else {
          if (FirebaseAuth.instance.currentUser != null) {
            GoogleSignIn().signOut();
            FirebaseAuth.instance.signOut();
          }
          if (!mounted) return;
          Utilities.showAlertDialog(
              context, alertPeringatan, responseCheckEmail.errorMessage);
        }
      }
    } catch (e) {
      if (e is PlatformException) {
        if (e.code == 'sign_in_canceled') {
          Utilities.showAlertDialog(
              context, alertPeringatan, e.message.toString());
        }
        return;
      }
      Utilities.showAlertDialog(context, alertPeringatan, e.toString());
    } finally {
      setState(() {
        isLoadingGoogle = false;
      });
    }
  }

  Future<void> signUp(fullname, email, password) async {
    GlobalModel response = await GlobalService.postData(BaseURL.apiSignUP,
        {'fullname': fullname, 'email': email, 'password': password}, context);
    if (!mounted) return;
    if (response.status == 'success') {
      await signIn(email, password, isGoogle: true);
    } else {
      Utilities.showAlertDialog(
          context, alertPeringatan, response.errorMessage);
    }
  }

  @override
  void dispose() {
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
              Text('Login',
                  style: blackTextStyle.copyWith(
                      fontSize: 22, fontWeight: semibold)),
              SizedBox(height: defaultMargin),
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
              Align(
                  alignment: Alignment.centerRight,
                  child: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const ReqForgotPassword()));
                      },
                      borderRadius: BorderRadius.circular(5),
                      child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Forgot Password ?',
                              style: greyTextStyle)))),
              Container(
                  margin: EdgeInsets.only(top: defaultMargin + 10, bottom: 10),
                  child: WidgetButtonPrimary(
                      isLoading: isLoading,
                      label: 'SIGN IN',
                      onClick: () {
                        setState(() {
                          errValEmail.clear();
                          errValPassword.clear();
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

                          if (errValEmail.isEmpty && errValPassword.isEmpty) {
                            signIn(
                                emailController.text, passwordController.text);
                          }
                        });
                      })),
              Center(
                  child: Text('OR',
                      style: blackTextStyle.copyWith(
                          fontSize: 16, fontWeight: semibold))),
              Container(
                  margin: EdgeInsets.only(top: 10, bottom: defaultMargin),
                  child: WidgetButtonOutline(
                      btnText: 'Sign In with Google',
                      isLoading: isLoadingGoogle,
                      btnFunction: () async {
                        await signInGoogle();
                        // GoogleSignIn().signOut();
                        // FirebaseAuth.instance.signOut();
                      })),
              Center(
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                    Text('Don’t Have An Account ? ',
                        style: greyTextStyle.copyWith(fontSize: 16)),
                    InkWell(
                        borderRadius: BorderRadius.circular(5),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const SignUpPage()));
                        },
                        child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Text('Register Now',
                                style: greyTextStyle.copyWith(
                                    fontSize: 16,
                                    color: kPrimaryColor,
                                    fontWeight: semibold,
                                    decoration: TextDecoration.underline))))
                  ]))
            ])));
  }
}
