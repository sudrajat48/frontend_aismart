part of 'pages.dart';

class SeeMoreReview extends StatelessWidget {
  final List listReview;
  final String nameProduct;
  const SeeMoreReview(
      {Key? key, required this.listReview, required this.nameProduct})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Reviews $nameProduct')),
        body: ListView(children: [
          for (int i = 0; i < listReview.length; i++)
            Column(children: [
              ListTile(
                  title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(listReview[i]['name_user'],
                            style:
                                blackTextStyle.copyWith(fontWeight: semibold)),
                        (listReview[i]['review'] == '')
                            ? const SizedBox(height: 5)
                            : const SizedBox(),
                        RatingBar.builder(
                            initialRating:
                                double.parse(listReview[i]['rating'] ?? '0.0'),
                            minRating: 0,
                            direction: Axis.horizontal,
                            allowHalfRating: false,
                            itemCount: 5,
                            itemSize: 14,
                            ignoreGestures: true,
                            itemBuilder: (context, _) =>
                                const Icon(Icons.star, color: Colors.amber),
                            onRatingUpdate: (val) {
                              null;
                            }),
                        const SizedBox(height: 4)
                      ]),
                  subtitle: (listReview[i]['review'] == '')
                      ? const SizedBox()
                      : Text(listReview[i]['review'],
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: blackTextStyle),
                  leading: SizedBox(
                      height: 40,
                      width: 40,
                      child: (listReview[i]['image_user'] == null ||
                              listReview[i]['image_user'] == "")
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: Image.asset(
                                  '$assetImagePath/placeholder_profile.png'),
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: Image.network(
                                  '${BaseURL.pahtImageNetwork}/${listReview[i]['image_user']}'),
                            ))),
              Divider(height: 0, color: kGreyColor)
            ]),
          SizedBox(height: defaultMargin)
        ]));
  }
}
