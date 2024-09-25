import 'package:flutter/material.dart';
import 'package:noamooz/Models/Exam/daily_exam_model.dart';
import 'package:noamooz/Models/Exam/quiz_model.dart';
import 'package:noamooz/Plugins/get/get.dart';
import 'package:noamooz/Utils/Api/project_request_utils.dart';
import 'package:noamooz/Utils/color_utils.dart';
import 'package:noamooz/Utils/view_utils.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class DayQuizController extends GetxController {
  late PageController controller;
  late DailyExamModel exam;
  final RxString currentText = "بزن بریم!".obs;
  final RxInt currentStep = 0.obs;
  final RxInt pieTouchedIndex = (-1).obs;
  final RxBool isLoading = true.obs;
  final RxBool isNextLoading = false.obs;
  List<QuizModel> quizzes = [];
  final List<Color> colors = [
    ColorUtils.red,
    ColorUtils.green,
    ColorUtils.gray,
  ];
  final List<String> titles = [
    "نادرست",
    "درست",
    "همه"
  ];

  void nextStep() async {
    switch (currentStep.value) {
      case 0:
        currentText.value = "ادامه";
        _next();
        break;
      case 1:
        if (quizzes.any((element) => element.isSelected.isTrue)) {
          isNextLoading.value = true;
          ApiResult result = await RequestsUtil.instance.exam.selectQuiz(
            examId: exam.id,
            quizId: quizzes
                .singleWhere(
                  (element) => element.isSelected.isTrue,
                )
                .id,
          );
          isNextLoading.value = false;
          if (result.isDone) {
            exam = DailyExamModel.fromJson(
              result.data['exam'],
            );
            isLoading.value = true;
            isLoading.value = false;
            currentText.value = "شروع آزمون";
            _next();
          } else {
            ViewUtils.showErrorDialog(
              result.data['message'].toString(),
            );
          }
        } else {
          ViewUtils.showErrorDialog(
            "لطفا یک آزمون را انتخاب کنید",
            1,
          );
        }
        break;
      case 2:
        isNextLoading.value = true;
        ApiResult result = await RequestsUtil.instance.exam.questions(
          examId: exam.id,
        );
        isNextLoading.value = false;
        if (result.isDone) {
          exam = DailyExamModel.fromJson(
            result.data['exam'],
          );
          isLoading.value = true;
          isLoading.value = false;
          await Future.delayed(const Duration(milliseconds: 100));
          currentText.value = "سوال بعد";
          _next();
        } else {
          ViewUtils.showErrorDialog(
            result.data['message'].toString(),
          );
        }
        break;
      default:
        if (exam.questions[currentStep.value - 3].currentAnswer.value > 0) {
          isNextLoading.value = true;
          ApiResult result = await RequestsUtil.instance.exam.answer(
            examId: exam.id,
            question: exam.questions[currentStep.value - 3].id,
            index: currentStep.value - 3,
            answer: exam.questions[currentStep.value - 3].currentAnswer.value,
          );
          isNextLoading.value = false;
          if (result.isDone) {
            exam = DailyExamModel.fromJson(
              result.data['exam'],
            );
            isLoading.value = true;
            isLoading.value = false;
            await Future.delayed(const Duration(milliseconds: 100));
            print(exam.questions.length);
            print(currentStep.value);
            if (currentStep.value -2 == exam.questions.length) {
              currentText.value = "";
            }
            _next();

          } else {
            ViewUtils.showErrorDialog(
              result.data['message'].toString(),
            );
          }
        } else {
          ViewUtils.showErrorDialog(
            "لطفا یکی از گزینه ها را انتخاب کنید",
          );
        }
        break;
    }
  }

  void _next() {
    controller.nextPage(
      duration: const Duration(milliseconds: 250),
      curve: Curves.ease,
    );
    currentStep.value++;
  }

  void fetchDailyExam() async {
    isLoading.value = true;
    ApiResult result = await RequestsUtil.instance.exam.initDaily();
    if (result.isDone) {
      exam = DailyExamModel.fromJson(result.data['exam']);
      quizzes = QuizModel.listFromJson(result.data['quizzes']);
      controller = PageController(
        initialPage: exam.step,
      );
      currentStep.value = exam.step;
      if (currentStep.value >= (exam.quiz?.questions ?? 0) + 3){
        currentText.value = "";
      }
    } else {
      Get.back();
      ViewUtils.showErrorDialog(result.data['message'].toString());
    }
    isLoading.value = false;
  }

  @override
  void onInit() {
    fetchDailyExam();
    super.onInit();
  }


  Widget getTitles(double value, TitleMeta meta) {
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 16,
      child: Container(
        height: 15,
        width: 15,
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }

  PieChartData pieChart() {
    return PieChartData(
      pieTouchData: PieTouchData(
        touchCallback: (FlTouchEvent event, pieTouchResponse) {
          if (!event.isInterestedForInteractions ||
              pieTouchResponse == null ||
              pieTouchResponse.touchedSection == null) {
            pieTouchedIndex.value = -1;
            return;
          }
          pieTouchedIndex.value =
              pieTouchResponse.touchedSection!.touchedSectionIndex;
        },
      ),
      borderData: FlBorderData(
        show: false,
      ),

      sectionsSpace: 2,
      startDegreeOffset: 10,
      centerSpaceColor: Colors.transparent,
      centerSpaceRadius: Get.height / 12,
      sections: showingSections(),
    );
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(2, (i) {
      final isTouched = i == pieTouchedIndex.value;
      final radius = isTouched ? 30.0 : 5.0;

      return PieChartSectionData(
        color: colors[i],
        value: i == 0 ? (exam.result?.wrong ?? 0).toDouble() : (exam.result?.correct ?? 0).toDouble(),
        title: i == 0 ? (exam.result?.wrong ?? 0).toString() : (exam.result?.correct ?? 0).toString(),
        showTitle: isTouched,
        radius: radius,

        titleStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    });
  }
}
