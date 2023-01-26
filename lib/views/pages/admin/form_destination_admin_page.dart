part of '../pages.dart';

class FormDestinationAdminPage extends StatefulWidget {
  final ProductModel? productModel;
  const FormDestinationAdminPage({Key? key, this.productModel})
      : super(key: key);

  @override
  State<FormDestinationAdminPage> createState() =>
      _FormDestinationAdminPageState();
}

class _FormDestinationAdminPageState extends State<FormDestinationAdminPage> {
  final TextEditingController nameProductController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController urlAddressController = TextEditingController();
  final ImagePicker picker = ImagePicker();
  List<String> images = [],
      errImages = [],
      errNames = [],
      errCategory = [],
      errAddress = [],
      errUrlAddress = [];
  List dropdownCategory = [];
  String valCategory = "";
  bool isLoading = false, isPopular = false;

  Future<void> getCategories() async {
    setState(() {
      isLoading = true;
    });
    GlobalModel response =
        await GlobalService.getData(BaseURL.apiDropdownCategory, context);
    setState(() {
      isLoading = false;
    });
    if (!mounted) return;
    if (response.status == 'success') {
      List list = [
        {'label': '-- Choose Category --', 'value': ''}
      ];
      for (var item in response.result) {
        list.add({'label': item['name'], 'value': item['id']});
      }
      dropdownCategory = list;
      setState(() {});
    } else {
      Utilities.showAlertDialog(
          context, alertPeringatan, response.errorMessage);
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
      uploadImage(File(pickedFile.path));
    } else {
      if (!mounted) return;
      Utilities.showToast('No image selected', context, status: 'error');
    }
  }

  Future<void> uploadImage(File image) async {
    setState(() {
      isLoading = true;
    });
    MultipartRequest request = http.MultipartRequest(
        'POST', Uri.parse(BaseURL.apiUploadPhotoDestination));
    request.files.add(await http.MultipartFile.fromPath('image', image.path));
    StreamedResponse streamedResponse = await request.send();
    Response response = await http.Response.fromStream(streamedResponse);
    GlobalModel responseModel = GlobalModel.fromJson(jsonDecode(response.body));
    setState(() {
      isLoading = false;
    });
    if (!mounted) return;
    if (responseModel.status == 'success') {
      setState(() {
        images.add(responseModel.result);
      });
    } else {
      Utilities.showAlertDialog(
          context, alertPeringatan, responseModel.errorMessage);
    }
  }

  Future<void> saveDestination() async {
    setState(() {
      isLoading = true;
    });
    Map<String, dynamic> postParams = {
      "id": widget.productModel?.id ?? '',
      "category_id": valCategory,
      "name": nameProductController.text,
      "description": descriptionController.text,
      "address": addressController.text,
      "url_address": urlAddressController.text,
      "is_favorit": (isPopular) ? "1" : "0",
      "images": images
    };
    GlobalModel response = await GlobalService.postData(
        BaseURL.apiAdminFormDestination, jsonEncode(postParams), context,
        headers: {'Content-type': 'application/json'});
    setState(() {
      isLoading = false;
    });
    if (!mounted) return;
    if (response.status == 'success') {
      Utilities.showAlertDialogWithFunction(context, 'Success', response.result,
          () {
        Navigator.pop(context);
        if (widget.productModel != null) {
          Navigator.pop(context);
        }
      });
    } else {
      Utilities.showAlertDialog(
          context, alertPeringatan, response.errorMessage);
    }
  }

  @override
  void dispose() {
    nameProductController.dispose();
    descriptionController.dispose();
    addressController.dispose();
    urlAddressController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    getCategories();
    if (widget.productModel != null) {
      for (var item in widget.productModel!.images!) {
        images.add(item['image']);
      }
      nameProductController.text = widget.productModel?.name ?? '';
      valCategory = widget.productModel?.categoryID ?? '';
      descriptionController.text = widget.productModel?.description ?? '';
      addressController.text = widget.productModel?.address ?? '';
      urlAddressController.text = widget.productModel?.urlAddress ?? '';
      isPopular = (widget.productModel?.isFavorit == "1") ? true : false;
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget fotoProduct() =>
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text("Photo Destination",
              style: blackTextStyle.copyWith(fontWeight: medium)),
          const SizedBox(height: 5),
          Wrap(spacing: 10, runSpacing: 10, children: [
            if (images.isNotEmpty)
              for (int i = 0; i < images.length; i++)
                Container(
                    width: MediaQuery.of(context).size.width * 0.5 -
                        defaultMargin -
                        5,
                    height: 150,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(width: 1, color: kPrimaryColor),
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: Image.network(
                                    "${BaseURL.pahtImageNetwork}/product/${images[i]}")
                                .image)),
                    child: Align(
                        alignment: Alignment.topRight,
                        child: Material(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.transparent,
                            elevation: 0,
                            child: InkWell(
                                borderRadius: BorderRadius.circular(5),
                                onTap: () {
                                  images.removeAt(i);
                                  setState(() {});
                                },
                                child: const Padding(
                                    padding: EdgeInsets.all(5.0),
                                    child: Icon(Icons.close,
                                        color: Colors.red, size: 28)))))),
            InkWell(
                onTap: () {
                  _showBottomFotoDialog();
                },
                child: Container(
                    width: MediaQuery.of(context).size.width * 0.5 -
                        defaultMargin -
                        5,
                    height: 150,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(width: 1, color: kPrimaryColor)),
                    child: Icon(Icons.camera_alt_outlined, color: kGreyColor)))
          ]),
          if (errImages.isNotEmpty) const SizedBox(height: 6),
          if (errImages.isNotEmpty)
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: errImages
                        .map((e) => Text(e.capitalizeFirstofEach,
                            style: redTextStyle.copyWith(fontSize: 13)))
                        .toList())),
          const SizedBox(height: 10)
        ]);
    return GestureDetector(
        onTap: () {
          Helpers.focusScope(context);
        },
        child: Scaffold(
            appBar: AppBar(
                title: Text(
                    'Form ${(widget.productModel == null) ? 'Add' : 'Update'} Destination')),
            body: WidgetLoadingOverlay(
                isLoading: isLoading,
                child:
                    ListView(padding: EdgeInsets.all(defaultMargin), children: [
                  fotoProduct(),
                  WidgetInputBox(
                      controller: nameProductController,
                      label: 'Name Destination',
                      errVal: errNames,
                      hintText: 'Enter destination name'),
                  WidgetSelectBox(
                      label: 'Category Destination',
                      valueItem: valCategory,
                      listItems: dropdownCategory,
                      errVal: errCategory,
                      onChange: (val) {
                        setState(() {
                          valCategory = val;
                        });
                      }),
                  WidgetInputBox(
                      controller: descriptionController,
                      label: 'Description Destination',
                      hintText: 'Enter description destination',
                      maxLines: null,
                      keyboardType: TextInputType.multiline),
                  WidgetInputBox(
                      controller: addressController,
                      label: 'Address Destination',
                      hintText: 'Enter address destination',
                      errVal: errAddress,
                      maxLines: null,
                      keyboardType: TextInputType.multiline),
                  Row(children: [
                    Expanded(
                        child: WidgetInputBox(
                            controller: urlAddressController,
                            errVal: errUrlAddress,
                            label:
                                'Destination URL Address (*Only Enter Link Address)',
                            hintText: 'Enter destination URL Address')),
                    IconButton(
                        onPressed: () {
                          Helpers().urlLaunchMethod(
                              'https://www.google.com/maps/',
                              mode: LaunchMode.externalApplication);
                        },
                        tooltip: 'Open Google Maps',
                        icon: Icon(Icons.map_outlined, color: kGreyColor))
                  ]),
                  Row(children: [
                    Expanded(
                        child: Text('is this a popular destination ?',
                            style: blackTextStyle)),
                    Switch(
                        value: isPopular,
                        onChanged: (val) {
                          setState(() {
                            isPopular = val;
                          });
                        })
                  ]),
                  Container(
                      margin: EdgeInsets.only(top: defaultMargin),
                      child: WidgetButtonPrimary(
                          label: 'Save Destination',
                          onClick: () {
                            setState(() {
                              errImages.clear();
                              errNames.clear();
                              errCategory.clear();
                              errAddress.clear();
                              errUrlAddress.clear();

                              if (images.isEmpty) {
                                errImages
                                    .add('Image destination must not be empty');
                              }
                              if (nameProductController.text.isEmpty) {
                                errNames
                                    .add('Name destination must not be empty');
                              }
                              if (valCategory == '') {
                                errCategory.add(
                                    'Category destination must not be empty');
                              }
                              if (addressController.text.isEmpty) {
                                errAddress.add(
                                    'Address destination must not be empty');
                              }
                              if (urlAddressController.text.isEmpty) {
                                errUrlAddress.add(
                                    'URL address destination must not be empty');
                              }

                              if (errImages.isEmpty &&
                                  errNames.isEmpty &&
                                  errCategory.isEmpty &&
                                  errAddress.isEmpty &&
                                  errUrlAddress.isEmpty) {
                                saveDestination();
                              }
                            });
                          }))
                ]))));
  }
}
