import 'package:common/common.dart';

import 'package:sizzle_starter/src/feature/settings/data/mappers/general_settings_codec.dart';
import 'package:sizzle_starter/src/feature/settings/domain/model/general.dart';
import 'package:sizzle_starter/src/feature/settings/domain/model/settings.dart';

class SettingsCodec extends JsonMapCodec<Settings> {
  const SettingsCodec();

  @override
  Settings $decode(Map<String, Object?> input) {
    final generalMap = input['general'] as Map<String, Object?>?;

    GeneralSettings? general;

    if (generalMap != null) {
      general = generalSettingsCodec.decode(generalMap);
    }

    return Settings(general: general ?? const GeneralSettings());
  }

  @override
  Map<String, Object?> $encode(Settings input) => {
    'general': generalSettingsCodec.encode(input.general),
  };
}
