// Step 4: API Constants (lib/core/constants/api_constants.dart)
class ApiConstants {
  static const String baseUrl = 'https://cabyatra.com/';

  static const String sendOtp = 'api/driver/send-otp';
  static const String getCities = 'api/driver/V2/get-cities';
  static const String getCarCategory = 'api/driver/V2/get-car-category';
  static const String updateAssignMethod = 'api/driver/V2/updateAssign-method';
  static const String addBooking = 'api/driver/V2/booking';
  static const String home = 'api/driver/home';
  static const String registration = 'api/driver/registration';
  static const String cmsPages = 'api/driver/cmsPages';
  static const String verifyOtp = 'api/driver/login';
  static const String settingData = 'api/driver/my_booking';
  static const String login = 'api/driver/login';
  static const String registerEndpoint = 'auth/register';

  static const String homeData = 'api/driver/V2/home';
  static const String booking = 'api/driver/V2/booking';
  static const String bookingDetail = 'api/driver/V2/booking';
  static const String profile = 'api/driver/V2/profile/';
  static const String transactions = 'api/driver/V2/profile/transactions';
  static const String reviews = 'api/driver/V2/profile/reviews';
  static const String paymentMethods = 'api/driver/V2/profile/payment-methods';
  static const String alerts = 'api/driver/V2/alerts';
  static const String alertsClear = 'api/driver/V2/alerts/clear';

  static const String location = 'api/driver/home/location';
  static const String allChatDrivers = 'api/driver/V2/all-chat-drivers';
  static const String chatMessages = 'api/driver/V2/get-messages';
  static const String sendMessage = 'api/driver/V2/send-message';
  static const String allChatUsers = 'api/driver/V2/all-chat-users';

  static const String dashboardEndpoint = 'dashboard';
  static const String settingsEndpoint = 'settings';
  static const String uploadEndpoint = 'upload';
  static const String tokenKey = 'token';
  static const String userID = 'userId';
  static const String isAgentKey = 'isAgent';
  static const String isdriverKey = 'isdriver';
  static const String authEndpoint = 'api/driver/V2/broadcasting/auth';
}
