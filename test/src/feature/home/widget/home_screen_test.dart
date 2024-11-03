import 'package:flutter_test/flutter_test.dart';
import 'package:sizzle_starter/src/core/utils/logger.dart';
import 'package:sizzle_starter/src/core/utils/test/test_widget_controller.dart';
import 'package:sizzle_starter/src/feature/home/widget/home_screen.dart';
import 'package:sizzle_starter/src/feature/initialization/model/dependencies_container.dart';

void main() {
  group('HomeScreen', () {
    testWidgets('renders correctly', (widgetTester) async {
      final controller = TestWidgetController(widgetTester);

      await controller.pumpWidget(
        const HomeScreen(),
        dependencies: const HomeScreenDependenciesContainer(),
      );

      expect(find.text('Welcome to Sizzle Starter!'), findsOneWidget);
    });
  });
}

/// Example of how to create a dependencies container for testing purposes.
base class HomeScreenDependenciesContainer extends TestDependenciesContainer {
  const HomeScreenDependenciesContainer();

  @override
  Logger get logger => const NoOpLogger();
}
