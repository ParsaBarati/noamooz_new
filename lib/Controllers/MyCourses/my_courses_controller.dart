import 'dart:convert';

import 'package:noamooz/Globals/Globals.dart';
import 'package:noamooz/Models/Courses/course_model.dart';
import 'package:noamooz/Models/db_models/my_courses_model.dart';
import 'package:noamooz/Plugins/get/get.dart';
import 'package:noamooz/Utils/Api/project_request_utils.dart';
import 'package:noamooz/Utils/view_utils.dart';

class MyCoursesController extends GetxController {
  List<MyCourseModel> courses = [];
  final RxBool isLoading = true.obs;

  void fetchCourses() async {
    isLoading.value = true;
    if (!Globals.offlineStream.isOffline) {
      ApiResult result = await RequestsUtil.instance.course.my();
      if (result.isDone) {
        courses = MyCourseModel.listFromJson(result.data);
        await MyCoursesDbModel().truncate();
        await MyCoursesDbModel().insertAll(courses.map((e) {
          return {
            'content': e.toJson(),
          };
        }).toList());
      } else {
        ViewUtils.showErrorDialog("خطایی در بارگذاری دوره های شما رخ داد، لطفا بعدا امتحان کنید");

      }
    } else {
      // try {
        List homeIcons = await MyCoursesDbModel().getAll();
        courses = MyCourseModel.listFromJson(
            homeIcons.map((e) => jsonDecode(e['content'])).toList());
      // } catch (e){
      //   print(e);
      //   print('MyCoursesDb not found');
      // }
    }


    isLoading.value = false;
  }

  @override
  void onInit() {
    fetchCourses();
    super.onInit();
  }
}