part of 'pages.dart';

class WelcomeScreenPage extends StatelessWidget {
  const WelcomeScreenPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
            padding: EdgeInsets.all(defaultMargin),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Image.asset('$assetImagePath/img_onboarding.png'),
              Text('Welcome To AISmarT App',
                  style: blackTextStyle.copyWith(
                      fontSize: 20, fontWeight: semibold)),
              const SizedBox(height: 5),
              Text(
                  'Ready to Travel Around Places Which Very Attractive And Nice In The City Tangerang',
                  textAlign: TextAlign.center,
                  style: blackTextStyle.copyWith(fontSize: 16)),
              SizedBox(height: defaultMargin * 2),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: defaultMargin),
                  child: WidgetButtonPrimary(
                      label: 'GETTING STARTED',
                      onClick: () {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const SignInPage()),
                            (route) => false);
                      }))
            ])));
  }
}
