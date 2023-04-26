import 'package:auto_route/auto_route.dart';
import 'package:sizzle_starter/src/feature/sample/widget/sample_screen.dart';

part 'router.gr.dart';

/// The configuration of app routes.
@AutoRouterConfig(replaceInRouteName: 'Screen,Route')
class AppRouter extends _$AppRouter {
  AppRouter();

  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: SampleRoute.page, path: '/'),
      ];
}
