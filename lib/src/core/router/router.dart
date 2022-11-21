import 'package:auto_route/auto_route.dart';
import 'package:blaze_starter/src/feature/sample/widget/sample_page.dart';

part 'router.gr.dart';

@MaterialAutoRouter(
  replaceInRouteName: 'Page,Route',
  routes: [
    AutoRoute<SamplePage>(
      page: SamplePage,
      path: '/',
      initial: true,
    ),
  ],
)
class AppRouter extends _$AppRouter {
  AppRouter();
}
