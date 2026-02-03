import 'package:get/get.dart';
import '../core/network_service.dart';
import '../models/wallet_model.dart';


class WalletController extends GetxController {
  NetworkService service = NetworkService();

  var walletResponse = WalletResponse(
    status: false,
    message: '',
    driverData: DriverData(id: 0, wallet: '', driverImageUrl: '', aadharFrontImageUrl: '', aadharBackImageUrl: '', dlImageUrl: ''),
    transactionData: [],
  ).obs;

  var walletLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    getWalletData();
  }

  Future<void> getWalletData() async {
    try {
      walletLoading.value = true;
      final response = await service.getWalletData();

      if (response != null && response.status) {
        walletResponse.value = response;
      } else {
        print('Failed to load wallet data');
      }
    } catch (e) {
      print('Error fetching wallet data: $e');
    } finally {
      walletLoading.value = false;
    }
  }


  Future<void> addMoney(double amount) async {
    // try {
    //   walletLoading.value = true;
    //
    //   // Call the API to add money to the wallet
    //   final response = await service.addMoneyToWallet(amount);
    //
    //   if (response != null && response.status) {
    //     // If the money is added successfully, fetch updated wallet data
    //     await getWalletData();
    //   } else {
    //     print('Failed to add money');
    //     // Optionally show an error message to the user
    //   }
    // } catch (e) {
    //   print('Error adding money: $e');
    //   // Optionally show an error message to the user
    // } finally {
    //   walletLoading.value = false;
    // }
  }

}
