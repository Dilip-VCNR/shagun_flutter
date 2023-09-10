class UrlConstant {
  static const String googleApiKey = "AIzaSyC6O2CG9zBAksJH4SCgCZlbx3XRWVwzY1E";

  static const String websiteBaseUrl =
      "http://santhuofficial123.pythonanywhere.com/";
  static const String imageBaseUrl = "http://103.74.138.223:8012";
  static const String apiBaseUrl = "http://103.74.138.223:8012/api/";
  static const String compatibility = "${apiBaseUrl}app_compatibility";
  static const String registerCustomer = "${apiBaseUrl}customer/registerUser";
  static const String getUser = "${apiBaseUrl}customer/getUser";
  static const String updateUser = "${apiBaseUrl}customer/updateUser";
  static const String addNewAddress =
      "${apiBaseUrl}customer/customerNewAddress";
  static const String userHomePage = "${apiBaseUrl}customer/userHomepage";
  static const String searchApi = "${apiBaseUrl}store/searchApi";
  static const String inStore = "${apiBaseUrl}store/getCategoryAndProductOnStore";
  static const String orderHistory = "${apiBaseUrl}customer/customerOrderHistory";
  static const String getCustomerPoints = "${apiBaseUrl}customerPoint/getCustomerPoints";
  static const String placeOrder = "${apiBaseUrl}order/placeOrder";
  static const String privacyPolicy = "${websiteBaseUrl}p/privacy-policy";
  static const String termsOfUse = "${websiteBaseUrl}p/t-c";
  static const String faq = "${websiteBaseUrl}p/t-c";
  static const String about = "${websiteBaseUrl}p/t-c";
}
