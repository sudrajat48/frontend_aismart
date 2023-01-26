part of '../pages.dart';

class DestinationAdminPage extends StatefulWidget {
  const DestinationAdminPage({Key? key}) : super(key: key);

  @override
  State<DestinationAdminPage> createState() => _DestinationAdminPageState();
}

class _DestinationAdminPageState extends State<DestinationAdminPage> {
  Future<List<ProductModel?>> getProducts() async {
    GlobalModel response =
        // ignore: use_build_context_synchronously
        await GlobalService.getData(BaseURL.apiAdminDestinations, context);
    if (response.status == 'success') {
      List<ProductModel> products = [];
      for (var item in response.result) {
        products.add(ProductModel.fromJson(item));
      }
      return products;
    } else {
      // ignore: use_build_context_synchronously
      Utilities.showAlertDialog(
          context, alertPeringatan, response.errorMessage);
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Destinations')),
        body: FutureBuilder(
            future: getProducts(),
            builder: (context, snapshot) {
              List<ProductModel>? productData;
              if (snapshot.hasData) {
                productData = snapshot.data as List<ProductModel>;
              }
              if (snapshot.connectionState == ConnectionState.done) {
                return RefreshIndicator(
                    onRefresh: () async {
                      setState(() {});
                    },
                    child: ListView(
                        children: productData!
                            .map((e) => Column(children: [
                                  ListTile(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (_) =>
                                                    DetailDestinationAdminPage(
                                                        productModel: e))).then(
                                            (value) {
                                          setState(() {});
                                        });
                                      },
                                      leading: SizedBox(
                                          height: 50,
                                          width: 50,
                                          child: (e.defaultImage == null ||
                                                  e.defaultImage == '' ||
                                                  e.defaultImage == 'null')
                                              ? ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  child: Image.asset(
                                                      '$assetImagePath/placeholder.png',
                                                      fit: BoxFit.cover),
                                                )
                                              : ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  child: Image.network(
                                                      '${BaseURL.pahtImageNetwork}/product/${e.defaultImage}',
                                                      fit: BoxFit.cover),
                                                )),
                                      title: Text(e.name ?? '',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: blackTextStyle.copyWith(
                                              fontWeight: semibold)),
                                      subtitle: Text(
                                          (e.description == null ||
                                                  e.description == '')
                                              ? 'Not Description'
                                              : e.description!,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: blackTextStyle)),
                                  Divider(height: 0, color: kGreyColor)
                                ]))
                            .toList()));
              }
              return const Center(child: WidgetLoadingProcess());
            }),
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const FormDestinationAdminPage()))
                  .then((value) {
                setState(() {});
              });
            },
            child: const Icon(Icons.add)));
  }
}
