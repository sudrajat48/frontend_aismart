part of 'pages.dart';

class DetailProductPage extends StatefulWidget {
  final ProductModel productModel;
  const DetailProductPage({Key? key, required this.productModel})
      : super(key: key);

  @override
  State<DetailProductPage> createState() => _DetailProductPageState();
}

class _DetailProductPageState extends State<DetailProductPage> {
  final CarouselController _controllerCarousel = CarouselController();
  final TextEditingController _myReviewController = TextEditingController();
  int currentSliders = 0;
  double myRating = 0.0;
  bool isLoadingPage = false, isUpdate = false, isContent = false;
  String userID = '', idReview = '';
  List listReview = [], listReviewsThisPage = [];

  Future<void> sendRatings(userID) async {
    setState(() {
      isLoadingPage = true;
    });
    GlobalModel response = await GlobalService.postData(
        BaseURL.apiCreateReview,
        {
          'user_id': userID,
          'product_id': widget.productModel.id,
          'rating': myRating.toString(),
          'review': _myReviewController.text
        },
        context);
    setState(() {
      isLoadingPage = false;
    });
    if (!mounted) return;
    if (response.status == 'success') {
      Utilities.showToast(response.result['message'], context);
      if (response.result['message_points'] != null) {
        Utilities.showAlertDialog(
            context,
            response.result['message_points']['title'],
            response.result['message_points']['message']);
      }
      await getDetailReview();
    } else {
      Utilities.showAlertDialog(
          context, alertPeringatan, response.errorMessage);
    }
  }

  Future<void> getDetailReview() async {
    setState(() {
      isLoadingPage = true;
    });
    if (!mounted) return;
    GlobalModel response = await GlobalService.postData(BaseURL.apiGetReviews,
        {'user_id': userID, 'product_id': widget.productModel.id}, context);
    setState(() {
      isLoadingPage = false;
    });
    if (!mounted) return;
    if (response.status == 'success') {
      setState(() {
        idReview = response.result['data_review_personal']['id_review'];
        myRating = (response.result['data_review_personal']['rating'] == "")
            ? 0.0
            : double.parse(
                response.result['data_review_personal']['rating'].toString());
        _myReviewController.text =
            response.result['data_review_personal']['review'];
        if (idReview != "") {
          isUpdate = true;
        }
        listReview = response.result['reviews'] ?? [];
        listReviewsThisPage = response.result['reviews']
                .where((element) => element['user_id'] != userID)
                .take(8)
                .toList() ??
            [];
        isContent = true;
      });
    } else {
      Utilities.showAlertDialog(
          context, alertPeringatan, response.errorMessage);
    }
  }

  Future<void> getUserID() async {
    SharedPreferences sharedPref = await GlobalService.sharedPreference;
    userID = sharedPref.getString(UserPreferenceModel.userID)!;
    setState(() {});
    if (!mounted) return;
    await getDetailReview();
  }

  @override
  void dispose() {
    _myReviewController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    getUserID();
  }

  @override
  Widget build(BuildContext context) {
    Widget carouselSlider() {
      List<Widget> imageSliders = widget.productModel.images!
          .map((item) => Container(
                margin: const EdgeInsets.all(2.5),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: Image.network(
                        "${BaseURL.pahtImageNetwork}/product/${item['image']}",
                        fit: BoxFit.cover,
                        width: MediaQuery.of(context).size.width)),
              ))
          .toList();

      return Column(children: [
        CarouselSlider(
            items: imageSliders,
            carouselController: _controllerCarousel,
            options: CarouselOptions(
                aspectRatio: 1.85 / 1,
                viewportFraction: 1,
                enableInfiniteScroll: false,
                height: 200,
                reverse: false,
                onPageChanged: (index, reason) {
                  setState(() {
                    currentSliders = index;
                  });
                })),
        Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: widget.productModel.images!
                .map((e) => Container(
                    width: 8.0,
                    height: 8.0,
                    margin: const EdgeInsets.symmetric(
                        vertical: 5.0, horizontal: 4.0),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: (Theme.of(context).brightness == Brightness.dark
                                ? Colors.white
                                : Colors.black)
                            .withOpacity(currentSliders ==
                                    widget.productModel.images?.indexOf(e)
                                ? 0.9
                                : 0.4))))
                .toList())
      ]);
    }

    Widget titleAndRating() =>
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(widget.productModel.name ?? '',
              style:
                  blackTextStyle.copyWith(fontWeight: semibold, fontSize: 18)),
          const SizedBox(height: 5),
          RatingBar.builder(
              initialRating: widget.productModel.rating ?? 0.0,
              minRating: 0,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemSize: 16,
              ignoreGestures: true,
              itemBuilder: (context, _) =>
                  const Icon(Icons.star, color: Colors.amber),
              onRatingUpdate: (val) {
                null;
              }),
          const SizedBox(height: 10),
        ]);

    Widget descriptionWidget() =>
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text("Description",
              style: blackTextStyle.copyWith(fontWeight: semibold)),
          const SizedBox(height: 3),
          Text(widget.productModel.description ?? "",
              textAlign: TextAlign.justify, style: blackTextStyle),
          const SizedBox(height: 10)
        ]);

    Widget locationWidget() =>
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text("Location",
              style: blackTextStyle.copyWith(fontWeight: semibold)),
          const SizedBox(height: 3),
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Icon(Icons.location_on, color: kPrimaryColor, size: 18),
            const SizedBox(width: 5),
            Expanded(
                child: Text(widget.productModel.address ?? "",
                    style: blackTextStyle))
          ]),
          const SizedBox(height: 10),
          InkWell(
              onTap: () {
                Utilities().urlLaunchMethod(widget.productModel.urlAddress!);
              },
              borderRadius: BorderRadius.circular(5),
              child: Container(
                  height: 150,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      image: const DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage("$assetImagePath/maps.png"))))),
          const SizedBox(height: 10)
        ]);

    Widget myReviewsWidget() =>
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text("My Review",
              style: blackTextStyle.copyWith(fontWeight: semibold)),
          const SizedBox(height: 5),
          Row(children: [
            Expanded(
              child: RatingBar.builder(
                  initialRating: myRating,
                  minRating: 0,
                  direction: Axis.horizontal,
                  allowHalfRating: false,
                  itemCount: 5,
                  itemSize: 24,
                  ignoreGestures: isUpdate,
                  itemBuilder: (context, _) =>
                      const Icon(Icons.star, color: Colors.amber),
                  onRatingUpdate: (val) {
                    setState(() {
                      myRating = val;
                    });
                  }),
            ),
            if (isUpdate)
              InkWell(
                  onTap: () {
                    Utilities.showConfirmationDialog(context, alertPeringatan,
                        'Are you sure to update review?', () {
                      setState(() {
                        isUpdate = false;
                      });
                    });
                  },
                  borderRadius: BorderRadius.circular(5),
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text("Update Review",
                        style: blackTextStyle.copyWith(color: Colors.blue)),
                  ))
          ]),
          const SizedBox(height: 8),
          WidgetInputBox(
              controller: _myReviewController,
              hintText: 'Give your review for this place',
              readOnly: isUpdate,
              maxLines: null,
              keyboardType: TextInputType.multiline),
          if (!isUpdate)
            WidgetButtonPrimary(
                label: 'Send Review',
                onClick: () {
                  if (myRating == 0.0) {
                    Utilities.showAlertDialog(
                        context, alertPeringatan, 'Please select a rating !');
                    return;
                  }
                  sendRatings(userID);
                })
        ]);

    Widget listReviewsWidget() =>
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
              padding: EdgeInsets.symmetric(horizontal: defaultMargin),
              child: Text("Visitor Reviews",
                  style: blackTextStyle.copyWith(fontWeight: semibold))),
          const SizedBox(height: 5),
          if (listReview.isEmpty)
            Center(child: Text('-- No Data Review --', style: blackTextStyle)),
          if (listReview.isNotEmpty)
            for (int i = 0; i < listReview.length; i++)
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Column(
                    children: [
                      ListTile(
                          title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(listReview[i]['name_user'],
                                    style: blackTextStyle.copyWith(
                                        fontWeight: semibold)),
                                (listReview[i]['review'] == '')
                                    ? const SizedBox(height: 5)
                                    : const SizedBox(),
                                RatingBar.builder(
                                    initialRating: double.parse(
                                        listReview[i]['rating'] ?? '0.0'),
                                    minRating: 0,
                                    direction: Axis.horizontal,
                                    allowHalfRating: false,
                                    itemCount: 5,
                                    itemSize: 14,
                                    ignoreGestures: true,
                                    itemBuilder: (context, _) => const Icon(
                                        Icons.star,
                                        color: Colors.amber),
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
                    ],
                  )),
          if (listReview.isNotEmpty)
            Container(
                margin: const EdgeInsets.only(top: 10),
                alignment: Alignment.center,
                child: InkWell(
                    onTap: () {
                      Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => SeeMoreReview(
                                      listReview: listReview,
                                      nameProduct: widget.productModel.name!)))
                          .then((value) async {
                        await getUserID();
                      });
                    },
                    borderRadius: BorderRadius.circular(5),
                    child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text("See More Review",
                            style:
                                blackTextStyle.copyWith(color: Colors.blue))))),
          SizedBox(height: defaultMargin)
        ]);

    return Scaffold(
        appBar: AppBar(title: const Text('Detail Product')),
        body: WidgetLoadingOverlay(
            isLoading: isLoadingPage,
            child: (!isContent)
                ? const SizedBox()
                : ListView(children: [
                    carouselSlider(),
                    Container(
                        width: double.infinity,
                        padding: EdgeInsets.fromLTRB(
                            defaultMargin, defaultMargin, defaultMargin, 0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              titleAndRating(),
                              descriptionWidget(),
                              locationWidget(),
                              myReviewsWidget()
                            ])),
                    const WidgetGreyLine(),
                    listReviewsWidget()
                  ])));
  }
}
