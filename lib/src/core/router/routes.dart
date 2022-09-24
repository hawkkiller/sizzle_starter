import 'package:blaze_starter/src/core/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

part 'routes.g.dart';

@TypedGoRoute<HomeRoute>(path: '/')
class HomeRoute extends GoRouteData {
  const HomeRoute();

  @override
  Widget build(BuildContext context) => Material(
        child: Center(
          child: Text(
            'Home',
            style: context.appTheme.h1,
          ),
        ),
      );
}
