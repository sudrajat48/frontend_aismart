part of 'pages.dart';

class MyVoucherPage extends StatefulWidget {
  const MyVoucherPage({Key? key}) : super(key: key);

  @override
  State<MyVoucherPage> createState() => _MyVoucherPageState();
}

class _MyVoucherPageState extends State<MyVoucherPage> {
  @override
  Widget build(BuildContext context) {
    Future<List> getMyVouchers() async {
      SharedPreferences sharedPref = await GlobalService.sharedPreference;
      String? id = sharedPref.getString(UserPreferenceModel.userID);
      GlobalModel response =
          // ignore: use_build_context_synchronously
          await GlobalService.getData(
              "${BaseURL.apiGetMyVouchers}?user_id=$id", context);
      if (response.status == 'success') {
        List vouchers = [];
        vouchers = response.result['data'] ?? [];
        return vouchers;
      } else {
        // ignore: use_build_context_synchronously
        Utilities.showAlertDialog(
            context, alertPeringatan, response.errorMessage);
        return [];
      }
    }

    return Scaffold(
        appBar: AppBar(title: const Text('My Vouchers')),
        body: FutureBuilder(
            future: getMyVouchers(),
            builder: (context, snapshot) {
              List? data;
              if (snapshot.hasData) {
                data = snapshot.data as List?;
              }
              if (snapshot.connectionState == ConnectionState.done) {
                return RefreshIndicator(
                    onRefresh: () async {
                      setState(() {});
                    },
                    child: ListView(
                        children: data!
                            .map((e) => Column(children: [
                                  ListTile(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (_) => DetailMyVoucher(
                                                    id: e['id']))).then(
                                            (value) {
                                          setState(() {});
                                        });
                                      },
                                      leading: SizedBox(
                                          height: 50,
                                          width: 50,
                                          child: (e['image_voucher'] == null ||
                                                  e['image_voucher'] == '' ||
                                                  e['image_voucher'] == 'null')
                                              ? Image.asset(
                                                  '$assetImagePath/placeholder.png')
                                              : Image.network(
                                                  '${BaseURL.pahtImageNetwork}/vouchers/${e['image_voucher']}')),
                                      title: Text(e['name_voucher'] ?? '',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: blackTextStyle.copyWith(
                                              fontWeight: semibold)),
                                      subtitle: Text(e['description'] ?? '',
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: blackTextStyle)),
                                  Divider(height: 0, color: kGreyColor)
                                ]))
                            .toList()));
              }
              return const Center(child: WidgetLoadingProcess());
            }));
  }
}
