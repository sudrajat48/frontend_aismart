part of 'pages.dart';

class SeeMorePage extends StatefulWidget {
  final List<ProductModel> products;
  final String title;
  const SeeMorePage({Key? key, required this.products, required this.title})
      : super(key: key);

  @override
  State<SeeMorePage> createState() => _SeeMorePageState();
}

class _SeeMorePageState extends State<SeeMorePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(widget.title)),
        body: OrientationBuilder(
            builder: (context, orientation) => GridView(
                    padding: EdgeInsets.all(defaultMargin),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        // childAspectRatio: (orientation == Orientation.landscape)
                        //     ? MediaQuery.of(context).size.width /
                        //         (MediaQuery.of(context).size.height / 0.8)
                        //     : MediaQuery.of(context).size.width /
                        //         (MediaQuery.of(context).size.height / 1.5),
                        crossAxisCount: 2,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8),
                    children: [
                      for (int i = 0; i < widget.products.length; i++)
                        WidgetCardProduct(
                            isExpanded: true,
                            image: widget.products[i].defaultImage,
                            title: widget.products[i].name,
                            rating: widget.products[i].rating,
                            width: double.infinity,
                            onTap: () {
                              Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => DetailProductPage(
                                              productModel:
                                                  widget.products[i])))
                                  .then((value) async {
                                // await getDataHome();
                              });
                            },
                            address: widget.products[i].address)
                    ])));
  }
}
