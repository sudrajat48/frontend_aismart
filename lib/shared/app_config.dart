part of 'shared.dart';
// This app config contains the application theme, base url, and global API

// this is declaration of theme

// default value double for margin or padding from content app
double defaultMargin = 20.0;
double defaultRadius = 10.0;

// default message, u can add another message
const alertPeringatan = "Warning !";
const msgErrValidation = "Mohon cek kembali data yang anda input !";
const msgBlmLogin = "Mohon Login Terlebih dahulu !";
const assetImagePath = "assets/images";

// this is a collection of colors used in this project
// u can add/update new colors
int hexPrimaryColor = 0xff27DD17;
Color kPrimaryColor = Color(hexPrimaryColor);
Color kBlackColor = const Color(0xff1F1449);
Color kWhiteColor = const Color(0xffFFFFFF);
Color kGreyColor = const Color(0xff9698A9);
Color kGreenColor = const Color(0xff0EC3AE);
Color kRedColor = const Color(0xffEB70A5);
Color kBackgroundColor = const Color(0xffFAFAFA);

// this is a collection of text style used in this project with package GoogleFonts
TextStyle blackTextStyle = GoogleFonts.poppins().copyWith(color: kBlackColor);
TextStyle whiteTextStyle = GoogleFonts.poppins().copyWith(color: kWhiteColor);
TextStyle greyTextStyle = GoogleFonts.poppins().copyWith(color: kGreyColor);
TextStyle greenTextStyle = GoogleFonts.poppins().copyWith(color: kGreenColor);
TextStyle redTextStyle = GoogleFonts.poppins().copyWith(color: kRedColor);
TextStyle purpleTextStyle =
    GoogleFonts.poppins().copyWith(color: kPrimaryColor);

// this is a collection of font weight used in this project
FontWeight light = FontWeight.w300;
FontWeight reguler = FontWeight.w400;
FontWeight medium = FontWeight.w500;
FontWeight semibold = FontWeight.w600;
FontWeight bold = FontWeight.w700;
FontWeight extrabold = FontWeight.w800;
FontWeight blackbold = FontWeight.w900;

extension CapExtension on String {
  // fungsi untuk membuat huruf besar untuk huruf pertama dalam string
  String get inCaps =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1)}' : '';

  // fungsi untuk membuat huruf besar dalam string
  String get allInCaps => toUpperCase();

  // fungsi untuk mengganti huruf kapital disetiap kata dalam string
  String get capitalizeFirstofEach => replaceAll(RegExp(' +'), ' ')
      .split(" ")
      .map((str) => str.inCaps)
      .join(" ");
}

// this is class for path service API
// u can add a url service to this project at class BaseURL
class BaseURL {
  // example domain name and base path url
  // static const apiDomain = "sisir.dev-svr.xyz";
  // static const apiBaseURL = "https://$apiDomain";
  static const apiDomain = "192.168.1.20";
  static const apiBaseURL = "http://$apiDomain/aismart_backend/api";
  static const apiHome = "$apiBaseURL/home.php";
  static const apiDropdownCategory = "$apiBaseURL/dropdown_category.php";
  static const apiSignUP = "$apiBaseURL/auth/sign_up.php";
  static const apiSignIN = "$apiBaseURL/auth/sign_in.php";
  static const checkEmailFromGoogleSignIn =
      "$apiBaseURL/auth/check_email_google_sign_in.php";
  static const apiReqForgotPassword =
      "$apiBaseURL/auth/req_forgot_password.php";
  static const apiVerifyUniqCode = "$apiBaseURL/auth/verify_uniq_code.php";
  static const apiNewPassword = "$apiBaseURL/auth/new_password.php";
  static const apiUserDetail = "$apiBaseURL/users/user_detail.php";
  static const apiUpdateProfile = "$apiBaseURL/users/update_profile.php";
  static const apiUpdatePassword = "$apiBaseURL/users/update_password.php";
  static const apiCreateReview = "$apiBaseURL/reviews/create_review.php";
  static const apiGetReviews = "$apiBaseURL/reviews/get_reviews.php";
  static const apiGetVouchers = "$apiBaseURL/vouchers/get_vouchers.php";
  static const apiGetMyVouchers = "$apiBaseURL/vouchers/my_vouchers.php";
  static const apiUseVoucher = "$apiBaseURL/vouchers/use_voucher.php";
  static const apiDetailMyVouchers =
      "$apiBaseURL/vouchers/my_voucher_detail.php";
  static const apiClaimVouchers = "$apiBaseURL/vouchers/claim_voucher.php";
  static const apiCheckClaimStatus =
      "$apiBaseURL/vouchers/check_status_claim.php";
  static const apiGetNotifications =
      "$apiBaseURL/notifications/get_notifications.php";
  static const apiGetDetailNotifications =
      "$apiBaseURL/notifications/detail_notification.php";
  static const apiReadNotifications =
      "$apiBaseURL/notifications/read_notification.php";
  static const apiAdminVouchers = "$apiBaseURL/admin/list_voucher_owner.php";
  static const apiDetailAdminVouchers =
      "$apiBaseURL/admin/detail_voucher_owner.php";
  static const apiFormVouchers = "$apiBaseURL/admin/form_voucher.php";
  static const apiAdminDestinations = "$apiBaseURL/admin/destinations.php";
  static const apiAdminFormDestination = "$apiBaseURL/admin/form_product.php";
  static const apiAdminDeleteDestination =
      "$apiBaseURL/admin/delete_destination.php";
  static const apiUploadPhotoDestination =
      "$apiBaseURL/admin/upload_foto_product.php";
  static const pahtImageNetwork =
      "http://$apiDomain/aismart_backend/assets/images";
}

// this is class for global service API
// u can add a global service to this project at class
class GlobalService {
  static Future<SharedPreferences> sharedPreference =
      SharedPreferences.getInstance();

  static Future<GlobalModel> postData(
      String url, body, BuildContext context, { Map<String, String>? headers}) async {
    try {
      // await checkConnection(context);
      if (kDebugMode) {
        print(url);
        print(body);
      }
      Response response = await http.post(Uri.parse(url), body: body, headers: headers);
      GlobalModel responseModel =
          GlobalModel.fromJson(jsonDecode(response.body));
      if (kDebugMode) {
        print(response.body);
      }
      return responseModel;
    } on SocketException catch (err) {
      return GlobalModel.fromJson(
          {"status": "error", "error_message": err.osError?.message});
    } catch (e) {
      return GlobalModel.fromJson(
          {"status": "error", "error_message": e.toString()});
    }
  }

  static Future<GlobalModel> getData(String url, BuildContext context) async {
    try {
      // await checkConnection(context);
      if (kDebugMode) {
        print(url);
      }
      Response response = await http.get(Uri.parse(url));
      GlobalModel responseModel =
          GlobalModel.fromJson(jsonDecode(response.body));
      if (kDebugMode) {
        print(response.body);
      }
      return responseModel;
    } on SocketException catch (err) {
      return GlobalModel.fromJson(
          {"status": "error", "error_message": err.osError?.message});
    } catch (e) {
      return GlobalModel.fromJson(
          {"status": "error", "error_message": e.toString()});
    }
  }

  static void logout(BuildContext context) async {
    SharedPreferences preferences = await sharedPreference;

    preferences.remove(UserPreferenceModel.userID);
    if (FirebaseAuth.instance.currentUser != null) {
      GoogleSignIn().signOut();
      FirebaseAuth.instance.signOut();
    }

    // ignore: use_build_context_synchronously
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const SignInPage()),
        (route) => false);

    return;
  }
}
