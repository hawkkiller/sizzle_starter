This is a Flutter workspace:

- [app](app) — entry point; features and wiring.
- [common](common) — reusable, app-independent; use `common` prefix.

## Architecture

Pragmatic layered architecture:

- *Presentation* — Widgets, Scopes (InheritedWidget), Cubits/Blocs.
  Widgets interact with BLoCs or other widgets (Scopes/InheritedWidgets).
- *Application* (optional) — Services, Use Cases.
  For complex scenarios or long-running tasks inconvenient in a BLoC (e.g. multi-file export).
- *Domain* — Entities, Value Objects, Repository interfaces (contracts, not implementations).
  Entities are immutable; may contain helper methods (calculations, convenient field updates).
- *Data* — Repository implementations using actual data providers (DB, API, etc).

Dependency rule: *Presentation → Application → Domain ← Data*. Domain never imports other layers.
BLoCs may call Application services or Repositories directly.

### Features

Code is split into features inside *app/*.
Features are independent. When something from a feature needs to be reused by another feature, move it into a *public/* folder within that feature.
*public/* mirrors feature layers but excludes Data (implementation detail, never shared).

## Widgets

- Prefer specific widgets (DecoratedBox, Padding, SizedBox) over Container.
- Do not use shrinkWrap in scrollable widgets.
- Do not create functions that return other widgets (e.g, *_buildColorItem*). Create a separate class instead.

## Dependency Injection

- Manual DI via composition root (composeDependencies).
- Each feature defines its own dependency container, registered in the app-level *DependenciesContainer* and provided via *DependenciesScope*.

## Documentation

- Write dartdoc comments for public APIs.
- Start with a single-sentence summary: The first sentence should be a concise, user-centric summary.
- Don't repeat information that's obvious from the code's context.
