import 'package:noamooz/Views/Blog/blog_screen.dart';
import 'package:noamooz/Views/Blog/post_screen.dart';
import 'package:noamooz/Views/Blog/posts_screen.dart';
import 'package:noamooz/Views/Categories/categories_screen.dart';
import 'package:noamooz/Views/Courses/courses_screen.dart';
import 'package:noamooz/Views/Courses/single_course_screen.dart';
import 'package:noamooz/Views/Faq/faq_screen.dart';
import 'package:noamooz/Views/Forum/forum_screen.dart';
import 'package:noamooz/Views/Forum/single_forum_screen.dart';
import 'package:noamooz/Views/FreeCourses/free_courses_screen.dart';
import 'package:noamooz/Views/Installments/installments_screen.dart';
import 'package:noamooz/Views/Login/login_screen.dart';
import 'package:noamooz/Views/Lotteries/lotteries_screen.dart';
import 'package:noamooz/Views/Lotteries/lottery_screen.dart';
import 'package:noamooz/Views/MyCourses/my_courses_screen.dart';
import 'package:noamooz/Views/Onboarding/onboarding_screen.dart';
import 'package:noamooz/Views/Partnership/partnership_screen.dart';
import 'package:noamooz/Views/Profile/profile_screen.dart';
import 'package:noamooz/Views/Quiz/day_quiz_screen.dart';
import 'package:noamooz/Views/Splash/splash_screen.dart';
import 'package:noamooz/Views/Support/support_screen.dart';
import 'package:noamooz/Views/main_screen.dart';

import '../Plugins/get/get.dart';

class RoutingUtils {
  static GetPage splash = GetPage(
    name: '/',
    transition: Transition.fade,
    page: () => SplashScreen(),
  );
  static GetPage main = GetPage(
    name: '/main',
    transition: Transition.fade,
    page: () => MainScreen(),
  );
  static GetPage login = GetPage(
    name: '/login',
    transition: Transition.fade,
    page: () => LoginScreen(),
  );
  static GetPage profile = GetPage(
    name: '/profile',
    transition: Transition.fade,
    page: () => ProfileScreen(),
  );
  static GetPage onBoarding = GetPage(
    name: '/on-boarding',
    transition: Transition.fade,
    page: () => OnBoardingScreen(),
  );
  static GetPage blog = GetPage(
    name: '/blog',
    transition: Transition.fade,
    page: () => BlogScreen(),
  );
  static GetPage posts = GetPage(
    name: '/posts',
    transition: Transition.fade,
    page: () => PostsScreen(),
  );
  static GetPage partnership = GetPage(
    name: '/partnership',
    transition: Transition.fade,
    page: () => PartnershipScreen(),
  );
  static GetPage post = GetPage(
    name: '/post/:id',
    transition: Transition.fade,
    page: () => PostScreen(),
  );
  static GetPage categories = GetPage(
    name: '/categories',
    transition: Transition.fade,
    page: () => CategoriesScreen(),
  );
  static GetPage support = GetPage(
    name: '/support',
    transition: Transition.fade,
    page: () => SupportScreen(),
  );
  static GetPage courses = GetPage(
    name: '/courses/:id',
    transition: Transition.fade,
    page: () => CoursesScreen(),
  );
  static GetPage freeCourses = GetPage(
    name: '/free-courses/:id',
    transition: Transition.fade,
    page: () => FreeCoursesScreen(),
  );
  static GetPage singleCourse = GetPage(
    name: '/course/:id',
    transition: Transition.fade,
    page: () => SingleCourseScreen(),
  );
  static GetPage myCourses = GetPage(
    name: '/my-courses',
    transition: Transition.fade,
    page: () => MyCoursesScreen(),
  );
  static GetPage quizzes = GetPage(
    name: '/quizzes',
    transition: Transition.fade,
    page: () => DayQuizScreen(),
  );

  static GetPage lotteries = GetPage(
    name: '/lotteries',
    transition: Transition.fade,
    page: () => LotteriesScreen(),
  );

  static GetPage lottery = GetPage(
    name: '/lottery',
    transition: Transition.fade,
    page: () => LotteryScreen(),
  );

  static GetPage faq = GetPage(
    name: '/faq',
    transition: Transition.fade,
    page: () => FaqScreen(),
  );

  static GetPage forums = GetPage(
    name: '/forums',
    transition: Transition.fade,
    page: () => ForumScreen(),
  );

  static GetPage forum = GetPage(
    name: '/forum/:id',
    transition: Transition.fade,
    page: () => SingleForumScreen(),
  );

  static GetPage installments = GetPage(
    name: '/installments/:id',
    transition: Transition.fade,
    page: () => InstallmentsScreen(),
  );

  static String postRoute(int id) => "/post/$id";
  static String coursesRoute(int id) => "/courses/$id";
  static String lotteryRoute(int id) => "/lottery/$id";
  static String freeCoursesRoute(int id) => "/free-courses/$id";
  static String singleCourseRoute(int id)  => "/course/$id";
  static String answerSheetRoute(int id) => "/answerSheet/$id";

  static String forumRoute(int id)  => "/forum/$id";

  static String installmentsRoute(int id) => "/installments/$id";

}
