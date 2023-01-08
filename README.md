# Sizzle Starter

Great template for Flutter projects.
During the development of this template, I learned best practices of other Flutter templates and repositories, tried to combine them in one, adding something special and new.

The starter reduces time spent on creating new project. Just click **Use this template** and here you go.
Below there are some instructions on how to use this template and useful topics to read.

Credits:

- [Purple Starter](https://github.com/purplenoodlesoop/purple-starter) - Yakov Karpov
- [Plugfox](https://github.com/PlugFox) - Michael Matiunin

## How to run

1. Click `Use this template` button
2. Clone this repository via `git clone`(you can choose HTTPs, but I would recommend SSH as it is really more comfortable and safe)
3. Decide which platforms your app will be running on
4. Decided, run `flutter create . --org com.yourdomain --platforms ios,android,... or nothing if you are writing an app for each platform` in your terminal.
5. Run `flutter pub get` to install all dependencies
6. Run `flutter run` to run your app
7. Here you go, start coding!

## Recommended libraries

### Core

- async - Future, Stream, Completer, FutureOr, Zone
- collection - List, Map, Queue, extensions
- convert - JSON, UTF8, ASCII, Base64, Hex, LineSplitter
- core - Object, num, int, double, bool, String, RegExp, Duration, DateTime, Stopwatch, Uri
- developer - log, Timeline, TimelineTask, TimelineTaskArgument
- meta - annotations
- typed_data - ByteData, Endian, Float32List, Float64List, Int16List, Int32List, Int64List, Int8List, Uint16List, Uint32List, Uint64List, Uint8ClampedList, Uint8List
- math
- io
- js - interop with JavaScript
- http - HTTP client

### External

- [bloc] - An implementation of the BLoC pattern which helps implement the business logic layer of an application
- [flutter_bloc] - Flutter Widgets that make it easy to integrate blocs into Flutter
- [sentry] - Sentry client for Dart and Flutter
- [firebase_crashlytics] - Firebase Crashlytics for Flutter
- [firebase_analytics] - Firebase Analytics for Flutter
- [firebase_messaging] - Firebase Cloud Messaging for Flutter

## Not Recommended libraries

- [hive] - key-value storage for Flutter and Dart. It loads all data into memory, which is not good for large data sets. It is better to use [sqflite](https://pub.dev/packages/sqflite) or [drift](https://pub.dev/packages/drift) for this purpose. If you need a KV storage for small data sets, you can use [shared_preferences](https://pub.dev/packages/shared_preferences). In addition, you cannot apply migrations, which is a big problem.

- [getx] - GetX is a library for Flutter that tries to combine everything in one package like navigation, state-management, storage, etc. Therefore, it is usually considered as a framework. However, everything is not so good. Even an idea to combine all the stuff is mad from the beginning. Moreover, the source code is awful. It has a lot of bugs, not only talking about the documentation, coverage, etc. On top of that, there is no single approach to write the code. In addition, the idea of how to manage the logic\business logic and all the stuff is completely non-engineering. That is why projects that use this lib are very difficult to maintain. Hence many problems arise. It becomes really tough to produce new features, releases.

- [get_it] - Service locator with all the problems that come in. 

## Flutter | Dart resources

1. [Flutter docs](https://flutter.dev/docs) - official docs, one of the best ways of learning
2. [Dart docs](https://dart.dev/guides) - official dart docs
3. [DartPad](https://dartpad.dev/) - it's a great tool to play with Dart, has some examples and tutorials
4. [Flutter CodeLabs](https://flutter.dev/docs/codelabs) - Flutter Google Codelabs(great starting point)
5. [Dart CodeLabs](https://dart.dev/codelabs) - Dart Google Codelabs(very little, but still)
6. [Great Roadmap](https://plugfox.dev/flutter-developer-roadmap/)
7. [Communities](https://plugfox.dev/communities/)
8. [Influencers](https://plugfox.dev/influencers/)
9. [Human Resources](https://plugfox.dev/hr/)
10. [Flutter Fundamentals](https://plugfox.dev/flutter-fundamentals/)
11. [Flutter Awesome](https://github.com/Solido/awesome-flutter)
12. [Dart Awesome](https://github.com/yissachar/awesome-dart)
13. [Flutter Channel](https://www.youtube.com/@flutterdev)

## Features

- Runners|hooks
- Initialization
- Scopes and **ScopeMixin** for easy scopes usage and nesting using **ScopeProvider**
- BLoC library
- Feature Oriented Structure - **BLoC**, **Data**, **Model**, **Widget**
- Many Useful Libraries
- Tools | Utils ready to use (native splash, launcher icons ..)
- Linter rules
- Build.yaml configured
- l10n configured
- Errors logging into Sentry
- Comfortable logger
- Assets configured
- Zones and right errors catching

[//]: recommended
[bloc]: https://pub.dev/packages/bloc
[flutter_bloc]: https://pub.dev/packages/flutter_bloc
[sqflite]: https://pub.dev/packages/sqflite
[drift]: https://pub.dev/packages/drift
[shared_preferences]: https://pub.dev/packages/shared_preferences
[sentry]: https://pub.dev/packages/sentry
[firebase_crashlytics]: https://pub.dev/packages/firebase_crashlytics
[firebase_analytics]: https://pub.dev/packages/firebase_analytics
[firebase_messaging]: https://pub.dev/packages/firebase_messaging
[//]: <not recommended>
[hive]: https://pub.dev/packages/hive
[getx]: https://pub.dev/packages/get
[get_it]: https://pub.dev/packages/get_it
[injectable]: https://pub.dev/packages/injectable
