import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_share/flutter_share.dart';
import 'package:iconsax/iconsax.dart';
import 'package:ionicons/ionicons.dart';
import 'package:noamooz/Controllers/Quiz/day_quiz_controller.dart';
import 'package:noamooz/Globals/Globals.dart';
import 'package:noamooz/Models/Exam/question_model.dart';
import 'package:noamooz/Models/Exam/quiz_model.dart';
import 'package:noamooz/Plugins/datepicker/persian_datetime_picker.dart';
import 'package:noamooz/Plugins/highlight_text.dart';
import 'package:noamooz/Utils/color_utils.dart';
import 'package:noamooz/Utils/image_utils.dart';
import 'package:noamooz/Utils/routing_utils.dart';
import 'package:noamooz/Utils/view_utils.dart';
import 'package:noamooz/Utils/widget_utils.dart';

import '../../Plugins/get/get.dart';

class DayQuizScreen extends StatelessWidget {
  final DayQuizController controller = Get.put(DayQuizController());

  DayQuizScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Obx(
        () => Scaffold(
          backgroundColor: ColorUtils.bgColor,
          appBar: buildAppBar(),
          body: Column(
            children: [
              ViewUtils.sizedBox(),
              Expanded(
                child: controller.isLoading.isTrue
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : Stack(
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                height: Get.height / 1.7,
                                decoration: BoxDecoration(
                                  color: ColorUtils.white,
                                  borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(50),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Expanded(
                                child: PageView(
                                  physics: const NeverScrollableScrollPhysics(),
                                  controller: controller.controller,
                                  scrollDirection: Axis.horizontal,
                                  children: [
                                    buildStep1(),
                                    buildStep2(),
                                    buildStep3(),
                                    ...controller.exam.questions
                                        .map((e) => buildStep4(e))
                                        .toList(),
                                    buildStep5(),
                                  ],
                                ),
                              ),
                              buildButtons(),
                              ViewUtils.sizedBox(),
                            ],
                          ),
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget buildAppBar() {
    return AppBar(
      elevation: 0,
      toolbarHeight: 50,
      shadowColor: ColorUtils.orange,
      backgroundColor: ColorUtils.white,
      foregroundColor: ColorUtils.black,
      leadingWidth: 40,
      actions: [
        IconButton(
          splashRadius: 20,
          onPressed: () => Globals.toggleDarkMode(),
          icon: Icon(
            Globals.darkModeStream.darkMode
                ? Iconsax.lamp_on
                : Iconsax.lamp_slash,
            size: 26,
          ),
        ),
      ],
      title: Text(
        "آزمون روزانه",
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: ColorUtils.black,
        ),
      ),
      centerTitle: true,
    );
  }

  Widget buildButtons() {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: Get.width / 4,
      ),
      child: Row(
        children: [
          Obx(
            () => controller.currentText.value.isNotEmpty
                ? Expanded(
                    child: WidgetUtils.softButton(
                      title: controller.currentText.value,
                      loading: controller.isNextLoading,
                      onTap: () => controller.nextStep(),
                      color: ColorUtils.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : Container(),
          ),
        ],
      ),
    );
  }

  Widget buildQuiz(int index) {
    QuizModel quiz = controller.quizzes[index];
    return Obx(
      () => Stack(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            width: Get.width,
            decoration: BoxDecoration(
              color: ColorUtils.white,
              borderRadius: BorderRadius.circular(10.0),
              border: Border.all(
                color: quiz.isSelected.isTrue
                    ? ColorUtils.green
                    : ColorUtils.white,
              ),
              boxShadow: [
                BoxShadow(
                  color: ColorUtils.gray.withOpacity(
                    0.05,
                  ),
                  spreadRadius: 3,
                  blurRadius: 12,
                ),
              ],
            ),
            child: Material(
              type: MaterialType.transparency,
              child: InkWell(
                borderRadius: BorderRadius.circular(10.0),
                onTap: () {
                  for (QuizModel element in controller.quizzes) {
                    element.isSelected.value = false;
                  }
                  quiz.isSelected.value = true;
                },
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ImageUtils.cachedImage(
                        quiz.category.icon.path,
                        height: Get.height / 12,
                      ),
                      const SizedBox(
                        width: 12,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'نام آزمون: ',
                                  style: TextStyle(
                                    color: ColorUtils.textGray,
                                  ),
                                ),
                                Text(
                                  quiz.title,
                                  style: TextStyle(
                                    color: ColorUtils.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            Row(
                              children: [
                                Text(
                                  'دوره: ',
                                  style: TextStyle(
                                    color: ColorUtils.textGray,
                                  ),
                                ),
                                Text(
                                  quiz.course.name,
                                  style: TextStyle(
                                    color: ColorUtils.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            Text(
                              "${quiz.questions} سوال",
                              style: TextStyle(
                                color: ColorUtils.black.withOpacity(0.8),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 8,
            left: 8,
            child: Container(
              decoration: BoxDecoration(
                color: ColorUtils.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(5),
              ),
              padding: const EdgeInsets.all(4),
              child: Text(
                quiz.category.name,
                style: TextStyle(
                  color: ColorUtils.orange,
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 8,
            left: 8,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: quiz.isSelected.isTrue
                  ? Icon(
                      Ionicons.checkbox,
                      color: ColorUtils.green,
                    )
                  : const Center(),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildStep2() {
    return Column(
      children: [
        Image.asset(
          'assets/img/edu_2.png',
        ),
        ViewUtils.sizedBox(),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
          ),
          child: Row(
            children: [
              Text(
                "${Globals.userStream.user?.fullName ?? "دوست "} عزیز، ",
                style: TextStyle(
                  color: ColorUtils.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
              Expanded(
                child: Text(
                  "لطفا از بین آزمون های زیر یک مورد را انتخاب کنید.",
                  style: TextStyle(
                    color: ColorUtils.black,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
        ViewUtils.sizedBox(48),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 12,
            ),
            itemCount: controller.quizzes.length,
            itemBuilder: (_, int index) => buildQuiz(index),
          ),
        ),
      ],
    );
  }

  Widget buildStep3() {
    return Column(
      children: [
        Image.asset(
          'assets/img/edu_3.png',
        ),
        ViewUtils.sizedBox(48),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "قبل از آزمون بخوانید!",
                    style: TextStyle(
                      color: ColorUtils.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              ViewUtils.sizedBox(),
              buildInfoRow(
                title: "نام آزمون: ",
                text: controller.exam.quiz?.title ?? "-",
              ),
              const SizedBox(
                height: 12,
              ),
              buildInfoRow(
                title: "تاریخ آزمون: ",
                text: Jalali.now().formatFullDate(),
              ),
              const SizedBox(
                height: 12,
              ),
              buildInfoRow(
                title: "تعداد سوالات: ",
                text: controller.exam.quiz?.questions.toString() ?? "-",
              ),
              const SizedBox(
                height: 12,
              ),
              buildInfoRow(
                title: "امتیاز: ",
                text: controller.exam.quiz?.score.toString() ?? "-",
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildStep5() {
    return Column(
      children: [
        Image.asset(
          'assets/img/edu_5.png',
          height: Get.height - Get.height / 1.38,
        ),
        ViewUtils.sizedBox(),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "نو آموزی عزیز، آزمون شما پایان یافت!",
                    style: TextStyle(
                      color: ColorUtils.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              ViewUtils.sizedBox(),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildInfoRow(
                          title: "نام آزمون: ",
                          text: controller.exam.quiz?.title ?? "-",
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        buildInfoRow(
                          title: "تاریخ آزمون: ",
                          text: Jalali.now().formatCompactDate(),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        buildInfoRow(
                          title: "تعداد سوالات: ",
                          text:
                              controller.exam.quiz?.questions.toString() ?? "-",
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: ColorUtils.white,
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: [
                        BoxShadow(
                          color: ColorUtils.gray.withOpacity(
                            0.1,
                          ),
                          spreadRadius: 1,
                          blurRadius: 12,
                        ),
                      ],
                    ),
                    child: Material(
                      type: MaterialType.transparency,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(10),
                        onTap: () => Get.toNamed(
                          RoutingUtils.answerSheetRoute(
                              controller.exam.result?.id ?? 0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Iconsax.activity,
                                color: ColorUtils.orange,
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              Text(
                                "مشاهده پاسخ نامه",
                                style: TextStyle(
                                  color: ColorUtils.orange,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: Get.height / 4,
                width: Get.width,
                child: Row(
                  children: [
                    SizedBox(
                      width: Get.width / 3.5,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          3,
                          (index) => Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    height: 12.5,
                                    width: 12.5,
                                    decoration: BoxDecoration(
                                      color: controller.colors[index],
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                  ),
                                  const SizedBox(width: 8.0),
                                  Text(
                                    controller.titles[index],
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: ColorUtils.black.withOpacity(0.5),
                                    ),
                                  ),
                                  const SizedBox(width: 8.0),
                                  Expanded(
                                    child: Divider(
                                      color: ColorUtils.blue,
                                    ),
                                  ),
                                  const SizedBox(width: 8.0),
                                  Text(
                                    index == 0
                                        ? (controller.exam.result?.wrong ?? 0)
                                            .toString()
                                        : (index == 1
                                            ? (controller
                                                        .exam.result?.correct ??
                                                    0)
                                                .toString()
                                            : ((controller.exam.result?.wrong ??
                                                        0) +
                                                    (controller.exam.result
                                                            ?.correct ??
                                                        0))
                                                .toString()),
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: ColorUtils.black,
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    Expanded(
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          PieChart(
                            controller.pieChart(),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "${controller.exam.result?.correct ?? 0} پاسخ صحیح",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: ColorUtils.black.withOpacity(0.8),
                                ),
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                              Text(
                                "در",
                                style: TextStyle(
                                  color: ColorUtils.black.withOpacity(0.5),
                                  fontSize: 10,
                                ),
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                              Text(
                                "${(controller.exam.result?.correct ?? 0) + (controller.exam.result?.wrong ?? 0)} سوال",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: ColorUtils.black.withOpacity(0.8),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildStep4(QuestionModel question) {
    return Column(
      children: [
        ImageUtils.cachedImage(
          question.image.path,
          height: Get.height - Get.height / 1.38,
        ),
        ViewUtils.sizedBox(48),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Expanded(
                    child: Divider(),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Icon(
                    Iconsax.message_question,
                    color: ColorUtils.black,
                    size: 20,
                  ),
                  const SizedBox(
                    width: 6,
                  ),
                  Text(
                    "سوال شماره ${controller.exam.questions.indexOf(question) + 1}",
                    style: TextStyle(
                      color: ColorUtils.black,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  const Expanded(
                    child: Divider(),
                  ),
                ],
              ),
              ViewUtils.sizedBox(),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      const SizedBox(
                        height: 6,
                      ),
                      Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: ColorUtils.orange,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  Expanded(
                    child: Text(
                      question.text,
                      style: TextStyle(
                        color: ColorUtils.black,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
              ViewUtils.sizedBox(48),
              Column(
                children: List.generate(
                  question.answers.length,
                  (index) => buildAnswer(
                    question,
                    index,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildInfoRow({
    required String title,
    required String text,
  }) {
    return Row(
      children: [
        Text(
          title,
          style: TextStyle(
            color: ColorUtils.textColor,
          ),
        ),
        Text(
          text,
          style: TextStyle(
            color: ColorUtils.black,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget buildAnswer(QuestionModel question, int index) {
    Answer answer = question.answers[index];
    return Container(
      margin: const EdgeInsets.only(
        bottom: 12,
      ),
      decoration: BoxDecoration(
        color: ColorUtils.white,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: ColorUtils.gray.withOpacity(
              0.1,
            ),
            spreadRadius: 1,
            blurRadius: 12,
          ),
        ],
      ),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          borderRadius: BorderRadius.circular(10.0),
          onTap: () {
            question.currentAnswer.value = answer.id;
          },
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Text(
                  "${index + 1}) ",
                  style: TextStyle(
                    color: ColorUtils.textColor,
                    fontSize: 12,
                  ),
                ),
                Expanded(
                  child: Text(
                    answer.text,
                    style: TextStyle(
                      color: ColorUtils.black,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: ColorUtils.green,
                    ),
                    color: question.currentAnswer.value == answer.id
                        ? ColorUtils.green
                        : ColorUtils.white,
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(2),
                  child: Icon(
                    Ionicons.checkmark,
                    color: ColorUtils.white,
                    size: 15,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildStep1() {
    return Column(
      children: [
        Image.asset(
          'assets/img/edu_1.png',
        ),
        ViewUtils.sizedBox(),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
          ),
          child: Row(
            children: [
              Text(
                "${Globals.userStream.user?.fullName ?? "دوست "} عزیز، ",
                style: TextStyle(
                  color: ColorUtils.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  wordSpacing: 1.2,
                ),
              ),
              Text(
                "سلام!",
                style: TextStyle(
                  color: ColorUtils.black,
                  fontSize: 18,
                  wordSpacing: 1.2,
                ),
              ),
            ],
          ),
        ),
        ViewUtils.sizedBox(96),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
          ),
          child: Row(
            children: [
              Expanded(
                child: HighlightText(
                  text:
                      "امـروز در تاریخ ${Jalali.now().formatFullDate()} شمـا در آزمـون های روزانه ی ما شرکت می کنید و با شرکت در این آزمون علاوه بر بالا بردن میزان دانش خود، امتیازات خود هم بالا خواهید برد.",
                  highlight: Jalali.now().formatFullDate(),
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: ColorUtils.textColor,
                    fontSize: 14,
                    height: 1.4,
                    wordSpacing: 1.2,
                  ),
                  highlightStyle: TextStyle(
                    color: ColorUtils.black,
                    fontSize: 14,
                    height: 1.4,
                    wordSpacing: 1.2,
                  ),
                ),
              ),
            ],
          ),
        ),
        ViewUtils.sizedBox(96),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            children: [
              SizedBox(
                width: Get.width / 2,
              ),
              Expanded(
                child: Container(
                  height: Get.height / 21,
                  decoration: BoxDecoration(
                    color: ColorUtils.white,
                    borderRadius: BorderRadius.circular(10.0),
                    boxShadow: [
                      BoxShadow(
                        color: ColorUtils.gray.withOpacity(
                          0.1,
                        ),
                        spreadRadius: 3,
                        blurRadius: 12,
                      ),
                    ],
                  ),
                  child: Material(
                    type: MaterialType.transparency,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: () {
                        // FlutterShare.share(
                        //   title:
                        //       "آزمون های روزانه ${Globals.settingStream.setting!.name} را از دست ندهید!",
                        //   text:
                        //       "آزمون های گوناگون و آموزنده فقط در اپلیکیشن ${Globals.settingStream.setting!.name}",
                        //   linkUrl: "https://noamooz.ir/app",
                        // );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Iconsax.share,
                            color: ColorUtils.orange,
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Text(
                            "اشتراک گذاری",
                            style: TextStyle(
                              color: ColorUtils.orange,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
