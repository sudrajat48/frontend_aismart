part of 'pages.dart';

class NewPasswordPage extends StatefulWidget {
  final String email;
  const NewPasswordPage({Key? key, required this.email}) : super(key: key);

  @override
  State<NewPasswordPage> createState() => _NewPasswordPageState();
}

class _NewPasswordPageState extends State<NewPasswordPage> {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController retypePasswordController =
      TextEditingController();

  List<String> errValPassword = [], errValTypePassword = [];
  bool isLoading = false;

  Future<void> savePassword() async {
    setState(() {
      isLoading = true;
    });
    GlobalModel response = await GlobalService.postData(BaseURL.apiNewPassword,
        {'email': widget.email, 'password': passwordController.text}, context);
    setState(() {
      isLoading = false;
    });
    if (!mounted) return;
    if (response.status == 'success') {
      Utilities.showToast(response.result, context);
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
    passwordController.dispose();
    retypePasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Helpers.focusScope(context);
        },
        child: Scaffold(
            appBar: AppBar(title: const Text('Create New Password')),
            body: ListView(padding: EdgeInsets.all(defaultMargin), children: [
              WidgetInputBox(
                  controller: passwordController,
                  label: 'New Password',
                  prefixIcon: const Icon(Icons.lock_outline),
                  obscureText: true,
                  hintText: 'Password',
                  errVal: errValPassword),
              WidgetInputBox(
                  controller: retypePasswordController,
                  label: 'New Password Confirmation',
                  prefixIcon: const Icon(Icons.lock_outline),
                  obscureText: true,
                  hintText: 'Re-Type Password',
                  errVal: errValTypePassword),
              WidgetButtonPrimary(
                  label: 'SAVE PASSWORD',
                  isLoading: isLoading,
                  onClick: () {
                    setState(() {
                      errValPassword.clear();
                      errValTypePassword.clear();
                      if (passwordController.text.isEmpty) {
                        errValPassword.add('Password must not be empty');
                      }
                      if (passwordController.text.length < 8) {
                        errValPassword
                            .add('Password must be at least 8 characters');
                      }
                      if (retypePasswordController.text.isEmpty) {
                        errValTypePassword
                            .add('Password Confirm must not be empty');
                      }
                      if (retypePasswordController.text.length < 8) {
                        errValTypePassword.add(
                            'Password Confirm must be at least 8 characters');
                      }
                      if (retypePasswordController.text !=
                          passwordController.text) {
                        errValTypePassword
                            .add('Confirmations must match the password');
                      }

                      if (errValPassword.isEmpty &&
                          errValTypePassword.isEmpty) {
                        savePassword();
                      }
                    });
                  })
            ])));
  }
}
