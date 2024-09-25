import 'package:noamooz/Utils/Api/WebControllers.dart';
import 'package:noamooz/Utils/Api/project_request_utils.dart';

class ExamApi {
  Future<ApiResult> initDaily() async {
    return RequestsUtil.instance.makeRequest(
      webController: WebControllers.exam,
      webMethod: 'daily/init',
      auth: true,
    );
  }

  Future<ApiResult> selectQuiz({
    required int examId,
    required int quizId,
  }) async {
    return RequestsUtil.instance.makeRequest(
      webController: WebControllers.exam,
      webMethod: 'daily/select/$examId',
      auth: true,
      postRequest: true,
      body: {
        'quizId': quizId,
      },
    );
  }

  Future<ApiResult> questions({
    required int examId,
  }) async {
    return RequestsUtil.instance.makeRequest(
      webController: WebControllers.exam,
      webMethod: 'daily/questions/$examId',
      auth: true,
    );
  }

  Future<ApiResult> answer({
    required int examId,
    required int question,
    required int answer,
    required int index,
  }) async {
    return RequestsUtil.instance.makeRequest(
      webController: WebControllers.exam,
      webMethod: 'daily/answer/$examId',
      auth: true,
      postRequest: true,
      body: {
        'question': question,
        'index': index,
        'answer': answer,
      },
    );
  }

  Future<ApiResult> result(int id) async {
    return RequestsUtil.instance.makeRequest(
      webController: WebControllers.exam,
      webMethod: 'daily/result/$id',
      auth: true,
      postRequest: false,
    );
  }
}
