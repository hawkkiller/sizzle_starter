# Flutter Agent

## General

This is a Flutter workspace:

- [app](app) — entry point; features and wiring.
- [common](common) — reusable, app-independent, pub.dev-publishable; use `common` prefix.

## Architecture

Pragmatic clean architecture with 3-4 layers:

- **Presentation** — Widgets, Scopes (InheritedWidget), Cubits/Blocs.
  Widgets interact with BLoCs or other widgets (Scopes/InheritedWidgets).
- **Application** (optional) — Services, Use Cases.
  For complex scenarios or long-running tasks inconvenient in a BLoC (e.g. multi-file export).
- **Domain** — Entities, Value Objects, Repository interfaces (contracts, not implementations).
  Entities are immutable; may contain helper methods (calculations, convenient field updates).
- **Data** — Repository implementations using actual data providers (DB, API, etc).

Dependency rule: `Presentation → Application → Domain ← Data`. Domain never imports other layers.
BLoCs may call Application services or Repositories directly.

### Features

Code is split into features inside `app/`. Each feature may contain any of the layers above.
Features should be independent. When something from a feature needs to be reused by another feature, move it into a `public/` folder within that feature.
This signals shared usage and requires a formal deprecation process before removal.
`public/` mirrors feature layers but excludes Data (implementation detail, never shared):

```
public/
  domain/        # shared models, repository interfaces
  application/   # shared services (if needed)
  presentation/  # shared scopes, widgets (if needed)
```

Prefer exporting interfaces/contracts. Concrete Widgets and Scopes are acceptable when other features need to consume them (e.g. SettingsScope).

## Widgets

- Prefer specific widgets (`DecoratedBox`, `Padding`, `SizedBox`) over `Container`.
- Do not use shrinkWrap in scrollable widgets.
- Do not create functions that return other widgets (e.g, `_buildColorItem`). Create a separate class instead.

## Dependency Injection

- Manual DI via composition root (`composeDependencies()`). No service locators (GetIt, Riverpod).
- Each feature defines its own dependency container (e.g. `SettingsContainer`), registered in the app-level `DependenciesContainer` and provided via `DependenciesScope`.

## Documentation

- Write `dartdoc` comments for public APIs.
- Start with a single-sentence summary: The first sentence should be a concise, user-centric summary.
- Don't repeat information that's obvious from the code's context.