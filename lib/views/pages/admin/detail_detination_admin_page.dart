part of '../pages.dart';

class DetailDestinationAdminPage extends StatefulWidget {
  final ProductModel productModel;
  const DetailDestinationAdminPage({Key? key, required this.productModel})
      : super(key: key);

  @override
  State<DetailDestinationAdminPage> createState() =>
      _DetailDestinationAdminPageState();
}

class _DetailDestinationAdminPageState
    extends State<DetailDestinationAdminPage> {
  final CarouselController _controllerCarousel = CarouselController();
  int currentSliders = 0;
  bool isLoadingPage = false;

  Future<void> deleteProduct() async {
    setState(() {
      isLoadingPage = true;
    });
    GlobalModel response = await GlobalService.postData(
        BaseURL.apiAdminDeleteDestination,
        {'id': widget.productModel.id},
        context);
    setState(() {
      isLoadingPage = false;
    });
    if (!mounted) return;
    if (response.status == 'success') {
      Utilities.showAlertDialogWithFunction(
          context, alertPeringatan, response.result, () {
        Navigator.pop(context);
      });
    } else {
      Utilities.showAlertDialog(
          context, alertPeringatan, response.errorMessage);
    }
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

    return Scaffold(
        appBar: AppBar(title: const Text('Detail Product')),
        body: ListView(children: [
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
                    locationWidget()
                  ]))
        ]),
        bottomNavigationBar: Column(mainAxisSize: MainAxisSize.min, children: [
          Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: defaultMargin, vertical: 10),
              child: Row(children: [
                Expanded(
                    child: WidgetButtonOutline(
                        btnText: 'Delete Destination',
                        btnFunction: () {
                          Utilities.showConfirmationDialog(
                              context,
                              alertPeringatan,
                              'Are you sure delete destination?', () {
                            deleteProduct();
                          });
                        })),
                const SizedBox(width: 5),
                Expanded(
                    child: WidgetButtonPrimary(
                        label: 'Update Destination',
                        onClick: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => FormDestinationAdminPage(
                                      productModel: widget.productModel)));
                        }))
              ]))
        ]));
  }
}
