import 'package:auto_route/auto_route.dart';
import 'package:sizzle_starter/src/feature/sample/widget/sample_page.dart';

part 'router.gr.dart';

/// The configuration of app routes.
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
