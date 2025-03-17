class AppConstants {
  // basic
  static const String APP_NAME = 'Rheel Estate Limited';

  static const String BASE_URL = 'https://apidoc.rheel.ng';

  static const String TOKEN = 'token';

  static const String LOGIN_URI = '/user/auth/signin';

  static const String APPLE_SIGNIN = '/user/auth/apple';

  static const String SIGNUP_URI = '/user/auth/signup';

  static const String UPDATE_PROFILE = '/user/auth/update-profile';

  static const String SUBMIT_INQUIRIES = '/user/submit-enquiries';

  static const String AFFILIATE_REGISTER = '/user/affiliate-register';

  static const String GET_PROPERTIES = '/data/properties';

  static const String GET_BANNERS = '/data/banners';

  static const String GET_ANNOUNCEMENTS = '/data/announcements';


  static const String FORGOT_PASSWORD = '/user/auth/forgot-password';

  static const String VERIFY_OTP = '/user/auth/verify-otp';

  static const String RESET_PASSWORD = '/user/auth/reset-password';

  static const String DELETE_ACCOUNT = '/user/auth/delete';




  static const String FIRST_INSTALL = 'first-install';

  static const String REMEMBER_KEY = 'remember-me';

  static const String SELLER_KEY = 'seller-key';



  static String getPngAsset(String image) {
    return 'assets/images/$image.png';
  }
  static String getGifAsset(String image) {
    return 'assets/gifs/$image.gif';
  }
  static String getMenuIcon(String image) {
    return 'assets/menu_icons/$image.png';
  }

}
