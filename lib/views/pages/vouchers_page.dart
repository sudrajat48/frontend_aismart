part of 'pages.dart';

class VouchersPage extends StatefulWidget {
  const VouchersPage({Key? key}) : super(key: key);

  @override
  State<VouchersPage> createState() => _VouchersPageState();
}

class _VouchersPageState extends State<VouchersPage> {
  int points = -1;
  String? userID;
  Future<List<VoucherModel?>> getVouchers() async {
    SharedPreferences sharedPref = await GlobalService.sharedPreference;
    String? id = sharedPref.getString(UserPreferenceModel.userID);
    GlobalModel response =
        // ignore: use_build_context_synchronously
        await GlobalService.getData(
            "${BaseURL.apiGetVouchers}?user_id=$id", context);
    if (response.status == 'success') {
      List<VoucherModel> vouchers = [];
      for (var item in response.result['data']) {
        vouchers.add(VoucherModel.fromJson(item));
      }
      points = response.result['point_user'] ?? 0;
      userID = id;
      return vouchers;
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
        appBar: AppBar(title: const Text('Promotional Offers')),
        body: FutureBuilder(
            future: getVouchers(),
            builder: (context, snapshot) {
              List<VoucherModel>? voucherData;
              if (snapshot.hasData) {
                voucherData = snapshot.data as List<VoucherModel>;
              }
              if (snapshot.connectionState == ConnectionState.done) {
                return RefreshIndicator(
                  onRefresh: () async {
                    setState(() {});
                  },
                  child: ListView(
                      children: voucherData!
                          .map((e) => Column(children: [
                                ListTile(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) => VoucherDetailPage(
                                                  coinsUser: points,
                                                  userID: userID!,
                                                  voucherModel: e))).then(
                                          (value) {
                                        setState(() {});
                                      });
                                    },
                                    leading: SizedBox(
                                        height: 50,
                                        width: 50,
                                        child: (e.image == null ||
                                                e.image == '' ||
                                                e.image == 'null')
                                            ? Image.asset(
                                                '$assetImagePath/placeholder.png')
                                            : Image.network(
                                                '${BaseURL.pahtImageNetwork}/vouchers/${e.image}')),
                                    title: Text(e.name ?? '',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: blackTextStyle.copyWith(
                                            fontWeight: semibold)),
                                    subtitle: Text(e.description ?? '',
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: blackTextStyle)),
                                Divider(height: 0, color: kGreyColor)
                              ]))
                          .toList()),
                );
              }
              return const Center(child: WidgetLoadingProcess());
            }));
  }
}
