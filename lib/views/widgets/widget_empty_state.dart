part of 'widgets.dart';

class WidgetEmptyState extends StatelessWidget {
  final String imageAsset;
  final String title;
  final String subtitle;
  const WidgetEmptyState(
      {Key? key,
      required this.imageAsset,
      required this.title,
      required this.subtitle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: defaultMargin),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Image.asset(imageAsset,
              width: MediaQuery.of(context).size.width * 0.7),
          SizedBox(height: defaultMargin * 2),
          Text(title,
              textAlign: TextAlign.center,
              style:
                  blackTextStyle.copyWith(fontSize: 16, fontWeight: semibold)),
          const SizedBox(height: 5),
          Text(subtitle,
              textAlign: TextAlign.center,
              style: greyTextStyle.copyWith(fontSize: 13, height: 1.4))
        ]));
  }
}
