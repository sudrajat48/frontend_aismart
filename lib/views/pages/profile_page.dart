// ignore_for_file: use_build_context_synchronously

part of 'pages.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    Future<UserModel?> getUserDetails() async {
      SharedPreferences sharedPref = await GlobalService.sharedPreference;
      String? id = sharedPref.getString(UserPreferenceModel.userID);
      GlobalModel response = await GlobalService.postData(
          BaseURL.apiUserDetail, {'user_id': id}, context);
      if (response.status == 'success') {
        return UserModel.fromJson(response.result['data']);
      } else {
        Utilities.showAlertDialog(
            context, alertPeringatan, response.errorMessage);
        return null;
      }
    }

    return Scaffold(
        body: FutureBuilder(
      future: getUserDetails(),
      builder: (context, snapshot) {
        UserModel? userData;
        if (snapshot.hasData) {
          userData = snapshot.data as UserModel;
        }
        if (snapshot.connectionState == ConnectionState.done) {
          return SingleChildScrollView(
              child: Column(children: [
            Center(
                child: Container(
                    height: 100,
                    width: 100,
                    margin: EdgeInsets.only(
                        top: defaultMargin * 4, bottom: defaultMargin - 5),
                    decoration: BoxDecoration(
                        border: Border.all(width: 0.5, color: kGreyColor),
                        shape: BoxShape.circle,
                        image: (userData?.image != '')
                            ? DecorationImage(
                                image: NetworkImage(
                                    "${BaseURL.pahtImageNetwork}/${userData?.image}"),
                                fit: BoxFit.cover)
                            : const DecorationImage(
                                image: AssetImage(
                                    '$assetImagePath/placeholder_profile.png'),
                                fit: BoxFit.cover))
                    // child: Stack(children: [
                    //   Align(
                    //       alignment: Alignment.bottomRight,
                    //       child: Container(
                    //           height: 50,
                    //           width: 50,
                    //           decoration: BoxDecoration(
                    //               color: kPrimaryColor,
                    //               borderRadius: BorderRadius.circular(50)),
                    //           child: Center(
                    //               child: Icon(Icons.add_a_photo_outlined,
                    //                   color: kWhiteColor))))
                    // ])
                    )),
            Text(userData?.name ?? '',
                style: blackTextStyle.copyWith(fontSize: 20)),
            const SizedBox(height: 3),
            Text(userData?.email ?? '', style: greyTextStyle),
            SizedBox(height: defaultMargin),
            Divider(color: kBlackColor, height: 0),
            ListTile(
                onTap: () {
                  Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) =>
                                  UpdateProfile(userModel: userData!)))
                      .then((value) {
                    setState(() {});
                  });
                },
                leading: const SizedBox(
                    height: double.infinity, child: Icon(Icons.person_outline)),
                title: Text('Update Profile', style: blackTextStyle),
                trailing: const Icon(Icons.chevron_right)),
            ListTile(
                onTap: () {
                  Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const ChangePasswordPage()))
                      .then((value) {
                    setState(() {});
                  });
                },
                leading: const SizedBox(
                    height: double.infinity, child: Icon(Icons.lock_outline)),
                title: Text('Change Password', style: blackTextStyle),
                trailing: const Icon(Icons.chevron_right)),
            if (userData?.role == 'ADMIN')
              ListTile(
                  onTap: () {
                    Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const VouchersAdminPage()))
                        .then((value) {
                      setState(() {});
                    });
                  },
                  leading: const SizedBox(
                      height: double.infinity,
                      child: Icon(Icons.confirmation_num_outlined)),
                  title: Text('Manage Voucher', style: blackTextStyle),
                  trailing: const Icon(Icons.chevron_right)),
            if (userData?.role == 'SUPERADMIN')
              ListTile(
                  onTap: () {
                    Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const DestinationAdminPage()))
                        .then((value) {
                      setState(() {});
                    });
                  },
                  leading: const SizedBox(
                      height: double.infinity,
                      child: Icon(Icons.location_on_outlined)),
                  title: Text('Manage Destination', style: blackTextStyle),
                  trailing: const Icon(Icons.chevron_right)),
            ListTile(
                onTap: () {
                  Helpers()
                      .urlLaunchMethod(
                          'mailto:${"hallo@alphabetincubator.id"}?subject=${Uri.encodeFull("Help Center")}&body=${Uri.encodeFull("")}',
                          mode: LaunchMode.externalApplication)
                      .then((value) {
                    setState(() {});
                  });
                },
                leading: const SizedBox(
                    height: double.infinity,
                    child: Icon(Icons.help_center_outlined)),
                title: Text('Help Center', style: blackTextStyle),
                trailing: const Icon(Icons.chevron_right)),
            ListTile(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const AboutAppPage())).then((value) {
                    setState(() {});
                  });
                },
                leading: const SizedBox(
                    height: double.infinity, child: Icon(Icons.info_outline)),
                title: Text('About App', style: blackTextStyle),
                trailing: const Icon(Icons.chevron_right)),
            ListTile(
                onTap: () {
                  Utilities.showConfirmationDialog(
                      context, alertPeringatan, 'Are you sure sign out?', () {
                    GlobalService.logout(context);
                  });
                },
                leading: const SizedBox(
                    height: double.infinity,
                    child: Icon(Icons.logout_outlined)),
                title: Text('Logout', style: blackTextStyle),
                trailing: const Icon(Icons.chevron_right)),
          ]));
        }
        return const Center(child: WidgetLoadingProcess());
      },
    ));
  }
}
