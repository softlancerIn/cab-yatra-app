  // Step 4: API Constants (lib/core/constants/api_constants.dart)
  class ApiConstants {
   //https://cabyatra.com/api/driver
 static const String baseUrl = 'https://cabyatra.com/';
//static const String baseUrl = 'http://35.154.123.59/';
   // static const String baseUrl = 'https://vl9639nz-5009.inc1.devtunnels.ms/';
    static const String sendOtp = 'api/driver/send-otp';
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


    static const String location = 'api/driver/home/location';

    static const String dashboardEndpoint = 'dashboard';
    static const String settingsEndpoint = 'settings';
    static const String uploadEndpoint = 'upload';
    static const String tokenKey = 'token';
    static const String userID = 'userId';
    static const String isAgentKey = 'isAgent';
    static const String isdriverKey = 'isdriver';
  }