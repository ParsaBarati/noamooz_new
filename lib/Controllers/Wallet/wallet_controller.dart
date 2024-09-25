import 'package:noamooz/Models/Wallet/transaction_model.dart';
import 'package:noamooz/Plugins/get/get.dart';
import 'package:noamooz/Utils/Api/project_request_utils.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class WalletController extends GetxController {
  final RxInt addPrice = 0.obs;
  final RxBool isPayLoading = false.obs;
  final RxBool isTransactionLoading = false.obs;
  List<TransactionModel> transactions = [];
  int page = 0;

  void pay() async {
    isPayLoading.value = true;
    ApiResult result = await RequestsUtil.instance.wallet.charge(
      addPrice.value,
    );
    isPayLoading.value = false;
    if (result.isDone) {
      await launchUrlString(
        result.data['url'],
        mode: LaunchMode.externalApplication,
      );
      addPrice.value = 0;
    }
  }

  void fetchTransactions() async {
    isTransactionLoading.value = true;
    ApiResult result = await RequestsUtil.instance.wallet.transactions(page);
    if (result.isDone) {
      transactions = TransactionModel.listFromJson(result.data);
    }
    isTransactionLoading.value = false;
  }
  @override
  void onInit() {
    fetchTransactions();
    super.onInit();
  }
}
