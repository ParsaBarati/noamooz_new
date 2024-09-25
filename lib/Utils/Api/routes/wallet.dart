import 'package:noamooz/Utils/Api/WebControllers.dart';
import 'package:noamooz/Utils/Api/project_request_utils.dart';

class WalletApi {
  Future<ApiResult> charge(int amount) async {
    return RequestsUtil.instance.makeRequest(
      webController: WebControllers.wallet,
      webMethod: 'charge',
      postRequest: true,
      auth: true,
      body: {
        'amount': amount.toString(),
      },
    );
  }

  Future<ApiResult> transactions(int page) async {
    return RequestsUtil.instance.makeRequest(
      webController: WebControllers.wallet,
      webMethod: 'transactions/$page',
      auth: true,
    );
  }
}
