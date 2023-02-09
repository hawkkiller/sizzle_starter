import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizzle_starter/src/core/model/initialization_hook.dart';
import 'package:sizzle_starter/src/core/router/router.dart';
import 'package:sizzle_starter/src/feature/initialization/logic/initialization_processor.dart';
import 'package:sizzle_starter/src/feature/initialization/logic/initialization_steps.dart';

void main() {
  group('Initialization Processor >', () {
    test('processInitialization', () async {
      const processor = _TestInitializationProcessor();
      final result = await processor.processInitialization(
        steps: <String, StepAction>{
          'Init Shared Preferences': (progress) async {
            SharedPreferences.setMockInitialValues({});
            final sharedPreferences = await SharedPreferences.getInstance();
            return progress.copyWith(
              preferences: sharedPreferences,
            );
          },
          'Init Router': (progress) {
            final router = AppRouter();
            return progress.copyWith(
              router: router,
            );
          }
        },
        factory: const _TestInitializationFactory(),
        hook: InitializationHook.setup(),
      );
      expect(result, isNotNull);
      expect(result.stepCount, 2);
    });
  });
}

class _TestInitializationFactory = Object with InitializationFactoryImpl;

class _TestInitializationProcessor = Object with InitializationProcessor;
