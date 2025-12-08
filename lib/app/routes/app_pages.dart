import 'package:get/get.dart';
import 'package:test_project/app/views/chat/chat_view.dart';
import 'package:test_project/app/views/home/home_view.dart';
import 'package:test_project/app/views/news_detail/news_detail_view.dart';
import 'package:test_project/app/views/webview/webview_page.dart';

import '../bindings/auth_binding.dart';
import '../views/login/login_view.dart';
import 'app_routes.dart';

class AppPages {
  static const initial = AppRoutes.login;

  static final routes = [
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginView(),
      binding: AuthBinding(),
    ),
    GetPage(name: AppRoutes.home, page: () => const HomeView()),
    GetPage(name: AppRoutes.newsDetail, page: () => const NewsDetailView()),
    GetPage(name: AppRoutes.chat, page: () => const ChatView()),
    GetPage(name: AppRoutes.webview, page: () => const WebViewPage()),
  ];
}
