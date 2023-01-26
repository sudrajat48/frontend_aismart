part of 'pages.dart';

class AboutAppPage extends StatelessWidget {
  const AboutAppPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('About App')),
        body: ListView(padding: EdgeInsets.all(defaultMargin), children: [
          Container(
              height: 120,
              margin: EdgeInsets.only(bottom: defaultMargin),
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('$assetImagePath/logo_primary.png')))),
          Text(
              'Applications That Facilitate Travelers Foreign Countries And Foreigners Who Want Visiting, Knowing Places Historic, Culinary And School And Existing Colleges Or Universities In Tangerang City.',
              textAlign: TextAlign.justify,
              style: blackTextStyle.copyWith(fontSize: 15, height: 2))
        ]));
  }
}
