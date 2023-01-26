part of 'pages.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentSliders = 0, pointUser = -1, notifications = -1;
  double myPoint = 0.0;
  bool isLoadingPage = false;
  final CarouselController _controllerCarousel = CarouselController();
  UserModel userModel = UserModel();
  List<BannerModel> listBannerModel = [];
  List<CategoryModel> listCategoryModel = [];
  List<ProductModel> listProductModel = [];

  Future<UserModel?> getUserDetails(userID) async {
    // ignore: use_build_context_synchronously
    GlobalModel response = await GlobalService.postData(
        BaseURL.apiUserDetail, {'user_id': userID}, context);
    if (response.status == 'success') {
      return UserModel.fromJson(response.result['data']);
    } else {
      // ignore: use_build_context_synchronously
      Utilities.showAlertDialog(
          context, alertPeringatan, response.errorMessage);
      return null;
    }
  }

  Future<void> getDataHome() async {
    listBannerModel.clear();
    listCategoryModel.clear();
    listProductModel.clear();
    currentSliders = 0;
    SharedPreferences sharedPref = await GlobalService.sharedPreference;
    String? id = sharedPref.getString(UserPreferenceModel.userID);
    setState(() {
      isLoadingPage = true;
    });
    if (!mounted) return;
    GlobalModel response =
        await GlobalService.getData("${BaseURL.apiHome}?user_id=$id", context);
    if (!mounted) return;
    if (response.status == 'success') {
      userModel = (await getUserDetails(id))!;
      setState(() {
        for (var item in response.result['data_banner']) {
          listBannerModel.add(BannerModel.fromJson(item));
        }
        for (var item in response.result['data_category']) {
          listCategoryModel.add(CategoryModel.fromJson(item));
        }
        for (var item in response.result['data_product']) {
          listProductModel.add(ProductModel.fromJson(item));
        }
        pointUser = response.result['point_user'] ?? 0;
        myPoint = pointUser / bagianPoints(pointUser);
        notifications = int.parse(response.result['notification'] ?? '0');
      });
    } else {
      Utilities.showAlertDialog(
          context, alertPeringatan, response.errorMessage);
    }
    setState(() {
      isLoadingPage = false;
    });
  }

  int bagianPoints(point) {
    if (point < 100) {
      return 100;
    } else if (point < 1000) {
      return 1000;
    } else if (point < 10000) {
      return 10000;
    } else {
      return 100;
    }
  }

  @override
  void initState() {
    super.initState();
    getDataHome();
  }

  @override
  Widget build(BuildContext context) {
    Widget headerWelcome() => Container(
        margin: EdgeInsets.only(top: defaultMargin, bottom: 15),
        padding: EdgeInsets.symmetric(horizontal: defaultMargin),
        child: Row(children: [
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text('Hello, Welcome ...',
                    style: blackTextStyle.copyWith(
                        fontSize: 15, color: kGreyColor)),
                Text(userModel.name ?? "",
                    style: blackTextStyle.copyWith(
                        fontSize: 20, fontWeight: semibold))
              ])),
          IconButton(
              onPressed: () {
                Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const NotificationsPage()))
                    .then((value) async {
                  await getDataHome();
                });
              },
              icon: Stack(children: [
                const Icon(Icons.inbox_outlined),
                if (notifications > 0)
                  Positioned(
                      right: 0,
                      child: Container(
                          height: 15,
                          width: 15,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle, color: kRedColor),
                          child: Center(
                              child: Text(notifications.toString(),
                                  style: whiteTextStyle.copyWith(
                                      fontWeight: semibold, fontSize: 12)))))
              ]),
              tooltip: 'Message')
        ]));

    Widget carouselSlider() {
      List<Widget> imageSliders = listBannerModel
          .map((item) => Container(
              margin: const EdgeInsets.all(5.0),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Image.network(
                      "${BaseURL.pahtImageNetwork}/banner/${item.name}",
                      fit: BoxFit.cover,
                      width: MediaQuery.of(context).size.width))))
          .toList();

      return Column(children: [
        CarouselSlider(
            items: imageSliders,
            carouselController: _controllerCarousel,
            options: CarouselOptions(
                aspectRatio: 1.85 / 1,
                viewportFraction: 0.9,
                height: 180,
                reverse: false,
                onPageChanged: (index, reason) {
                  setState(() {
                    currentSliders = index;
                  });
                })),
        Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: listBannerModel
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
                            .withOpacity(
                                currentSliders == listBannerModel.indexOf(e)
                                    ? 0.9
                                    : 0.4))))
                .toList())
      ]);
    }

    Widget pointsIndicator() => Container(
        margin: EdgeInsets.all(defaultMargin),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: kGreyColor.withOpacity(0.3)),
        padding: EdgeInsets.all(defaultMargin),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Expanded(
                child: Text("My Coins",
                    style: blackTextStyle.copyWith(
                        fontWeight: medium, fontSize: 15))),
            Text("${Helpers.formatCurrencyID(pointUser.toString())} pts",
                style: blackTextStyle.copyWith(fontWeight: medium))
          ]),
          const SizedBox(height: 5),
          LinearProgressIndicator(value: myPoint)
        ]));

    Widget productFavorite() => Padding(
        padding: EdgeInsets.symmetric(horizontal: defaultMargin),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Expanded(
                child: Text("Favourite Place",
                    style: blackTextStyle.copyWith(
                        fontWeight: semibold, fontSize: 15))),
            InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => SeeMorePage(
                              title: 'Favourite Place',
                              products: listProductModel
                                  .where((element) => element.isFavorit == '1')
                                  .toList()))).then((value) async {
                    await getDataHome();
                  });
                },
                borderRadius: BorderRadius.circular(5),
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Text("See More",
                      style: blackTextStyle.copyWith(color: Colors.blue)),
                ))
          ]),
          const SizedBox(height: 10),
          SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Row(
                  children: listProductModel
                      .where((element) => element.isFavorit == '1')
                      .map((e) => Container(
                          margin: const EdgeInsets.only(right: 10),
                          child: WidgetCardProduct(
                              image: e.defaultImage,
                              title: e.name,
                              rating: e.rating,
                              onTap: () {
                                Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) => DetailProductPage(
                                                productModel: e)))
                                    .then((value) async {
                                  await getDataHome();
                                });
                              },
                              address: e.address)))
                      .take(6)
                      .toList()))
        ]));

    Widget productCatalog() => Container(
        margin: EdgeInsets.only(bottom: defaultMargin),
        padding: EdgeInsets.symmetric(horizontal: defaultMargin),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: listCategoryModel
                .map((cat) => Container(
                    margin: EdgeInsets.only(top: defaultMargin),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(children: [
                            Expanded(
                                child: Text(cat.name ?? "",
                                    style: blackTextStyle.copyWith(
                                        fontWeight: semibold, fontSize: 15))),
                            InkWell(
                                onTap: () {
                                  Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) => SeeMorePage(
                                                  title: cat.name ?? "",
                                                  products: listProductModel
                                                      .where((element) =>
                                                          element.categoryID ==
                                                          cat.id)
                                                      .toList())))
                                      .then((value) async {
                                    await getDataHome();
                                  });
                                },
                                borderRadius: BorderRadius.circular(5),
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Text("See More",
                                      style: blackTextStyle.copyWith(
                                          color: Colors.blue)),
                                ))
                          ]),
                          const SizedBox(height: 10),
                          if (listProductModel
                              .where((element) => element.categoryID == cat.id)
                              .toList()
                              .isEmpty)
                            Text("Product not found", style: blackTextStyle),
                          SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              physics: const BouncingScrollPhysics(),
                              child: Row(
                                  children: listProductModel
                                      .where((element) =>
                                          element.categoryID == cat.id)
                                      .map((e) => Container(
                                          margin:
                                              const EdgeInsets.only(right: 10),
                                          child: WidgetCardProduct(
                                              image: e.defaultImage,
                                              rating: e.rating,
                                              title: e.name,
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (_) =>
                                                            DetailProductPage(
                                                                productModel:
                                                                    e))).then(
                                                    (value) async {
                                                  await getDataHome();
                                                });
                                              },
                                              address: e.address)))
                                      .take(6)
                                      .toList()))
                        ])))
                .take(4)
                .toList()));

    return Scaffold(
        body: SafeArea(
            child: RefreshIndicator(
                onRefresh: () async {
                  await getDataHome();
                },
                child: (isLoadingPage)
                    ? const Center(child: WidgetLoadingProcess())
                    : ListView(children: [
                        headerWelcome(),
                        if (listBannerModel.isNotEmpty) carouselSlider(),
                        pointsIndicator(),
                        if (listProductModel
                            .where((element) => element.isFavorit == '1')
                            .isNotEmpty)
                          productFavorite(),
                        if (listCategoryModel.isNotEmpty) productCatalog()
                      ]))));
  }
}
