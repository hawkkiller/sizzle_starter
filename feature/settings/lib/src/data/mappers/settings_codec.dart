import 'package:common/common.dart';
import 'package:settings/settings.dart';
import 'package:settings/src/data/mappers/general_settings_codec.dart';

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
