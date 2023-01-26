part of '../pages.dart';

class FormVoucherAdminPage extends StatefulWidget {
  final VoucherModel? voucherModel;
  const FormVoucherAdminPage({Key? key, this.voucherModel}) : super(key: key);

  @override
  State<FormVoucherAdminPage> createState() => _FormVoucherAdminPageState();
}

class _FormVoucherAdminPageState extends State<FormVoucherAdminPage> {
  final TextEditingController nameVoucher = TextEditingController();
  final TextEditingController pointVoucher = TextEditingController();
  final TextEditingController descriptionVoucher = TextEditingController();
  final TextEditingController discountPercentVoucher = TextEditingController();
  final TextEditingController discountPriceVoucher = TextEditingController();
  final TextEditingController activeAt = TextEditingController();
  final TextEditingController expiredAt = TextEditingController();
  final ImagePicker picker = ImagePicker();
  String image = "", imageURLModel = "";
  List<String> errImage = [],
      errName = [],
      errPoint = [],
      errDiscountPercents = [],
      errDiscountPrice = [],
      errActiveAt = [],
      errExpiredAt = [];
  int selectedDiscount = 0;
  bool isLoading = false;

  Future<void> saveVoucher() async {
    SharedPreferences preferences = await GlobalService.sharedPreference;
    String? userID = preferences.getString(UserPreferenceModel.userID);
    setState(() {
      isLoading = true;
    });
    MultipartRequest request =
        http.MultipartRequest('POST', Uri.parse(BaseURL.apiFormVouchers));
    request.fields['id'] = widget.voucherModel?.id ?? '';
    request.fields['user_id'] = userID!;
    request.fields['name_voucher'] = nameVoucher.text;
    request.fields['point'] =
        pointVoucher.text.replaceAll(RegExp('[^A-Za-z0-9]'), '');
    request.fields['description'] = descriptionVoucher.text;
    request.fields['is_discount'] = selectedDiscount.toString();
    request.fields['discount_percent'] = discountPercentVoucher.text;
    request.fields['discount_price'] =
        discountPriceVoucher.text.replaceAll(RegExp('[^A-Za-z0-9]'), '');
    request.fields['active_at'] = activeAt.text;
    request.fields['expired_at'] = expiredAt.text;
    if (image != "") {
      request.files.add(await http.MultipartFile.fromPath('image', image));
    } else {
      if (widget.voucherModel != null) {
        request.fields['image_url'] = imageURLModel;
      }
    }
    // Map<String, dynamic> postParams = {
    //   'id': widget.voucherModel?.id ?? '',
    //   'user_id': userID,
    //   'name_voucher': nameVoucher.text,
    //   'point': pointVoucher.text.replaceAll(RegExp('[^A-Za-z0-9]'), ''),
    //   'description': descriptionVoucher.text,
    //   'image': image,
    //   'is_discount': selectedDiscount.toString(),
    //   'discount_percent': discountPercentVoucher.text,
    //   'discount_price':
    //       discountPriceVoucher.text.replaceAll(RegExp('[^A-Za-z0-9]'), ''),
    //   'active_at': activeAt.text,
    //   'expired_at': expiredAt.text,
    // };
    StreamedResponse streamedResponse = await request.send();
    Response response = await http.Response.fromStream(streamedResponse);
    GlobalModel responseModel = GlobalModel.fromJson(jsonDecode(response.body));
    setState(() {
      isLoading = false;
    });
    if (!mounted) return;
    if (responseModel.status == 'success') {
      Utilities.showAlertDialogWithFunction(
          context, alertPeringatan, responseModel.result, () {
        Navigator.pop(context);
      });
    } else {
      Utilities.showAlertDialog(
          context, alertPeringatan, responseModel.errorMessage);
    }
  }

  _showBottomFotoDialog() {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
            ListTile(
              title: Text('Choose Source Photo',
                  style: blackTextStyle.copyWith(fontWeight: semibold)),
            ),
            ListTile(
                leading: const Icon(Icons.photo),
                title: Text('Gallery', style: blackTextStyle),
                onTap: () {
                  getImagePicker('gallery');
                  Navigator.pop(context);
                }),
            ListTile(
                leading: const Icon(Icons.camera_alt),
                title: Text('Camera', style: blackTextStyle),
                onTap: () {
                  getImagePicker('camera');
                  Navigator.pop(context);
                })
          ]);
        });
  }

  Future getImagePicker(String sumber) async {
    XFile? pickedFile;
    if (sumber == "camera") {
      pickedFile =
          await picker.pickImage(source: ImageSource.camera, maxWidth: 800);
    } else {
      pickedFile =
          await picker.pickImage(source: ImageSource.gallery, maxWidth: 800);
    }

    if (pickedFile != null) {
      setState(() {
        image = pickedFile!.path;
      });
    } else {
      if (!mounted) return;
      Utilities.showToast('No image selected', context, status: 'error');
    }
  }

  @override
  void dispose() {
    nameVoucher.dispose();
    pointVoucher.dispose();
    descriptionVoucher.dispose();
    discountPercentVoucher.dispose();
    discountPriceVoucher.dispose();
    activeAt.dispose();
    expiredAt.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    if (widget.voucherModel != null) {
      nameVoucher.text = widget.voucherModel?.name ?? '';
      pointVoucher.text = widget.voucherModel!.point.toString();
      descriptionVoucher.text = widget.voucherModel?.description ?? '';
      discountPercentVoucher.text =
          widget.voucherModel!.discountPercent.toString();
      discountPriceVoucher.text = widget.voucherModel!.discountPrice.toString();
      selectedDiscount = widget.voucherModel!.isDiscount!;
      activeAt.text = DateFormat('yyyy-MM-dd')
          .format(DateTime.parse(widget.voucherModel!.activeAt!));
      expiredAt.text = DateFormat('yyyy-MM-dd')
          .format(DateTime.parse(widget.voucherModel!.expiredAt!));
      imageURLModel = widget.voucherModel!.image.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget fotoVoucher() =>
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text("Photo Voucher",
              style: blackTextStyle.copyWith(fontWeight: medium)),
          const SizedBox(height: 5),
          Container(
              height: 200,
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(bottom: defaultMargin - 5),
              decoration: BoxDecoration(
                  border: Border.all(width: 0.5, color: kGreyColor),
                  borderRadius: BorderRadius.circular(5),
                  image: DecorationImage(
                      image: (image == '' && widget.voucherModel == null)
                          ? const AssetImage('$assetImagePath/placeholder.png')
                          : (widget.voucherModel != null && image == '')
                              ? (widget.voucherModel?.image == '' ||
                                      widget.voucherModel?.image == null)
                                  ? const AssetImage(
                                      '$assetImagePath/placeholder.png')
                                  : Image.network(
                                          "${BaseURL.pahtImageNetwork}/vouchers/${widget.voucherModel?.image}")
                                      .image
                              : Image.file(File(image)).image,
                      fit: BoxFit.cover)),
              child: Stack(children: [
                Align(
                    alignment: Alignment.bottomRight,
                    child: Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.symmetric(horizontal: 50),
                        child: Material(
                            color: kPrimaryColor,
                            borderRadius: BorderRadius.circular(5),
                            child: InkWell(
                                borderRadius: BorderRadius.circular(5),
                                onTap: _showBottomFotoDialog,
                                child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 8),
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.add_a_photo_outlined,
                                              color: kWhiteColor, size: 16),
                                          const SizedBox(width: 10),
                                          Text('Upload Photo',
                                              style: whiteTextStyle)
                                        ]))))))
              ])),
          if (errImage.isNotEmpty)
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: errImage
                        .map((e) => Text(e.capitalizeFirstofEach,
                            style: redTextStyle.copyWith(fontSize: 13)))
                        .toList())),
          if (errImage.isNotEmpty) const SizedBox(height: 10),
        ]);
    return GestureDetector(
        onTap: () {
          Helpers.focusScope(context);
        },
        child: Scaffold(
            appBar: AppBar(
                title: Text(
                    'Form ${(widget.voucherModel == null) ? 'Add' : 'Update'} Voucher')),
            body: WidgetLoadingOverlay(
                isLoading: isLoading,
                child:
                    ListView(padding: EdgeInsets.all(defaultMargin), children: [
                  fotoVoucher(),
                  WidgetInputBox(
                      controller: nameVoucher,
                      label: 'Name Voucher',
                      errVal: errName,
                      hintText: 'Enter voucher name'),
                  WidgetInputBox(
                      controller: descriptionVoucher,
                      label: 'Description Voucher',
                      hintText: 'Enter description voucher',
                      maxLines: null,
                      keyboardType: TextInputType.multiline),
                  WidgetInputBox(
                      controller: pointVoucher,
                      label: 'Coin Voucher',
                      readOnly: (widget.voucherModel != null) ? true : false,
                      hintText: 'Enter coin voucher',
                      errVal: errPoint,
                      keyboardType: TextInputType.number,
                      inputFormatter: [
                        FilteringTextInputFormatter.digitsOnly,
                        CurrencyFormat()
                      ]),
                  Row(children: [
                    Expanded(
                        child: RadioListTile(
                            value: 0,
                            groupValue: selectedDiscount,
                            title:
                                Text('Discount Price', style: blackTextStyle),
                            onChanged: (val) {
                              if (widget.voucherModel == null) {
                                setState(() {
                                  selectedDiscount = int.parse(val.toString());
                                });
                              }
                            })),
                    Expanded(
                        child: RadioListTile(
                            value: 1,
                            groupValue: selectedDiscount,
                            title:
                                Text('Discount Percent', style: blackTextStyle),
                            onChanged: (val) {
                              if (widget.voucherModel == null) {
                                setState(() {
                                  selectedDiscount = int.parse(val.toString());
                                });
                              }
                            }))
                  ]),
                  const SizedBox(height: 10),
                  if (selectedDiscount == 1)
                    WidgetInputBox(
                        controller: discountPercentVoucher,
                        label: 'Discount Voucher (percent %)',
                        hintText: 'Enter discount voucher percentage',
                        errVal: errDiscountPercents,
                        readOnly: (widget.voucherModel != null) ? true : false,
                        keyboardType: TextInputType.number,
                        inputFormatter: [
                          FilteringTextInputFormatter.digitsOnly,
                          CurrencyFormat(),
                          LengthLimitingTextInputFormatter(2)
                        ]),
                  if (selectedDiscount == 0)
                    WidgetInputBox(
                        controller: discountPriceVoucher,
                        label: 'Discount Voucher (price)',
                        hintText: 'Enter discount voucher price',
                        readOnly: (widget.voucherModel != null) ? true : false,
                        errVal: errDiscountPrice,
                        keyboardType: TextInputType.number,
                        inputFormatter: [
                          FilteringTextInputFormatter.digitsOnly,
                          CurrencyFormat()
                        ]),
                  Row(children: [
                    Expanded(
                        child: GestureDetector(
                      onTap: () async {
                        DateTime? startDate = await showDatePicker(
                            context: context,
                            initialDate: (activeAt.text.isEmpty)
                                ? DateTime.now()
                                : DateTime.parse(
                                    widget.voucherModel!.activeAt!),
                            firstDate: DateTime.now(),
                            lastDate: DateTime(DateTime.now().year + 20));

                        if (startDate != null) {
                          activeAt.text =
                              DateFormat('yyyy-MM-dd').format(startDate);
                          if (kDebugMode) {
                            print("Active Date ==> $startDate");
                            print(
                                "Active At Date Controller ==> ${activeAt.text}");
                          }
                        }
                        setState(() {});
                      },
                      child: WidgetInputBox(
                          controller: activeAt,
                          label: 'Active Voucher At',
                          enabled: false,
                          errVal: errActiveAt,
                          hintText: 'Active voucher at'),
                    )),
                    const SizedBox(width: 10),
                    Expanded(
                        child: GestureDetector(
                            onTap: () async {
                              DateTime? endDate = await showDatePicker(
                                  context: context,
                                  initialDate: (expiredAt.text.isEmpty)
                                      ? DateTime.now()
                                      : DateTime.parse(
                                          widget.voucherModel!.expiredAt!),
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime(DateTime.now().year + 20));

                              if (endDate != null) {
                                expiredAt.text =
                                    DateFormat('yyyy-MM-dd').format(endDate);
                                if (kDebugMode) {
                                  print("Expired Date ==> $endDate");
                                  print(
                                      "Expired At Date Controller ==> ${expiredAt.text}");
                                }
                              }
                              setState(() {});
                            },
                            child: WidgetInputBox(
                                controller: expiredAt,
                                label: 'Expired Voucher At',
                                enabled: false,
                                errVal: errExpiredAt,
                                hintText: 'Expired voucher at')))
                  ]),
                  WidgetButtonPrimary(
                      label: 'Save Voucher',
                      onClick: () {
                        setState(() {
                          errImage.clear();
                          errName.clear();
                          errPoint.clear();
                          errDiscountPercents.clear();
                          errDiscountPrice.clear();
                          errActiveAt.clear();
                          errExpiredAt.clear();
                          if (widget.voucherModel == null) {
                            if (image == '') {
                              errImage.add('Image must not be empty');
                            }
                          }
                          if (nameVoucher.text.isEmpty) {
                            errName.add('Voucher Name must not be empty');
                          }
                          if (pointVoucher.text.isEmpty) {
                            errPoint.add('Coin Voucher must not be empty');
                          }
                          if (selectedDiscount == 0) {
                            if (discountPriceVoucher.text.isEmpty) {
                              errDiscountPrice
                                  .add('Discount Price must not be empty');
                            }
                          } else {
                            if (discountPercentVoucher.text.isEmpty) {
                              errDiscountPercents
                                  .add('Discount percent must not be empty');
                            }
                          }
                          if (activeAt.text.isEmpty) {
                            errActiveAt.add('Voucher Active must not be empty');
                          }
                          if (expiredAt.text.isEmpty) {
                            errExpiredAt
                                .add('Voucher Expired must not be empty');
                          }
                          if (errImage.isEmpty &&
                              errName.isEmpty &&
                              errPoint.isEmpty &&
                              errDiscountPercents.isEmpty &&
                              errDiscountPrice.isEmpty &&
                              errActiveAt.isEmpty &&
                              errExpiredAt.isEmpty) {
                            saveVoucher();
                          }
                        });
                      })
                ]))));
  }
}
