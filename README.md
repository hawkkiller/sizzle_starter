# Blaze Starter

# Starting up

Yep. Let's imagine you are starting a new project OR starting learning flutter.
If second, I would recommend you to read [this](https://flutter.dev/docs) first.
This project is supposed to be as easy as it could be, at same time flexible 
and clean. But, you need kinda good knowledge in Dart and Flutter to understand it.

## Few ways to study Flutter\Dart
*note*: read this readme till down before you start studying / while you are studying
1. [Flutter docs](https://flutter.dev/docs) - official docs, one of the best ways of learning
2. [Dart docs](https://dart.dev/guides) - official dart docs
3. [DartPad](https://dartpad.dev/) - it's a great tool to play with Dart, has some examples and tutorials
4. [Flutter official codelabs](https://flutter.dev/docs/codelabs) - Flutter Google Codelabs(great starting point)
5. [Dart official codelabs](https://dart.dev/codelabs) - Dart Google Codelabs(very little, but still)
6. [Great Roadmap](https://github.com/MbIXjkee/flutter-developer-map)
7. [Communities](https://plugfox.dev/communities/)
8. [Influencers](https://plugfox.dev/influencers/)
9. [Human Resources](https://plugfox.dev/hr/)
10. [Flutter Fundamentals](https://plugfox.dev/flutter-fundamentals/)
11. [Flutter Awesome](https://github.com/Solido/awesome-flutter)
12. [Dart Awesome](https://github.com/yissachar/awesome-dart)

## How to run
1. Click `Use this template` button
2. Clone this repository via `git clone`(you can choose HTTPs, but I would recommend SSH as it is really more comfortable and safe)
3. Decide which platforms your app will be running on
4. Decided, run `flutter create . --org com.yourdomain --platforms ios,android,... or nothing if you are writing an app for each platform` in your terminal.
5. Run `flutter pub get` to install all dependencies
6. Run `flutter run` to run your app
7. Here you go, start coding!

## Features:

- Runners|hooks
- Initialization
- Scopes and **ScopeMixin** for easy scopes usage and nesting using **ScopeProvider**
- GoRouter with **go_route_builder** configured
- BLoC library - stream bloc instead of bloc with the **Stream API**
- Feature Oriented Structure - **BLoC**, **Data**, **Model**, **Widget**
- Many Useful Libraries
- Tools|Utils ready to use (native splash, launcher icons ..)
- Linter rules
- Build.yaml configured
- l10n configured
- Errors logging into Sentry
- Comfortable logger
- Assets configured
- Zones and right errors catching
- Themes using tailor
- AppColors