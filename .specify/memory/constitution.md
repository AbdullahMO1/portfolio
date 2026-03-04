# Senior Flutter Portfolio — Constitution

A Flutter Web portfolio for a Senior Team Lead Flutter Developer. It must demonstrate engineering excellence through advanced architectural patterns, high-performance animations, WASM compilation, and comprehensive quality gates.

## Core Principles

### I. Feature-Driven Architecture (NON-NEGOTIABLE)
Every new domain concern (Skills, Projects, Experience, About) lives in a self-contained feature folder under `lib/features/`. No cross-feature imports at the widget level. State Management (Riverpod providers) communicates directly with services — no repository layer for this scale. Add a feature folder before writing any widget.

### II. Data-Driven Content via GitHub Gist
All portfolio content (resume data: name, bio, skills, experience, projects) must be sourced from a single external `resume.json` hosted on a GitHub Gist. No hardcoded strings in widgets. The only exception is static config values (Gist URL, app name). This principle ensures the portfolio can be updated without a code change or redeployment.

### III. Code-Generated State — Riverpod 2.x
All Riverpod providers MUST use `@riverpod` annotation and `riverpod_generator`. No legacy `Provider(...)` or `StateNotifierProvider(...)` direct instantiation. Auto-generated `.g.dart` files must be committed to source control. `AsyncValue` must be fully handled (data / loading / error) in every consumer widget — no unchecked `.value!` unwrapping.

### IV. Performance-First Rendering (NON-NEGOTIABLE)
- Compile target: Flutter WebAssembly (WASM). All dependencies must be WASM-compatible.  
- No `setState` inside animation ticks — use `AnimationController` + `AnimatedBuilder` or `Ticker`-based custom painters.  
- Heavy JSON parsing (Gist response) must run in a `compute()` / `Isolate` call, never on the main UI thread.  
- The interactive background shader must maintain 60fps — use `FragmentShader` + `CustomPainter` with `repaint` isolation.

### V. Visual Excellence — 3D & Advanced Animations
The portfolio is a living demonstration. Every major section must include at least one advanced animation:
- **Hero / Background**: Custom Fragment Shader (GLSL `.frag`) interactive particle/mesh — not a static gradient.
- **Cards / Project Tiles**: `Matrix4` 3D tilt effect responding to mouse cursor `Offset`.
- **Section Entry**: Staggered `AnimationController` with custom `Curve` (no default `Curves.easeIn`).
- **Theme Toggle**: Circular reveal `ClipPath` transition (not an instant color swap).
- No placeholder assets — generate or use production-quality visuals only.

## Technology Standards

| Concern | Choice |
|---|---|
| State Management | Riverpod 2.x with `@riverpod` code generation |
| Routing | `go_router` — ShellRoute + deep linking |
| Data Models | `freezed` + `json_serializable` |
| Theming | Material 3 dynamic color schemes |
| Background | Flutter Fragment Shader (GLSL) |
| Scrolling | `CustomScrollView` + Slivers |
| Testing | Unit · Widget · Golden (`alchemist`) |
| CI/CD | GitHub Actions → GitHub Pages (WASM build) |
| Linting | `flutter_lints` + `very_good_analysis` rules |
| Accessibility | Full `Semantics` widget coverage |

## Development Workflow & Quality Gates

- **Strict lint compliance**: `flutter analyze --fatal-infos` must pass with zero warnings before any PR merge.
- **Golden test lock**: Every public widget with visual complexity ≥ moderate must have an `alchemist` golden test. Goldens must be regenerated after any UI change and committed.
- **WASM build verification**: `flutter build web --wasm` must succeed in CI before deployment.
- **Accessibility audit**: Use `flutter test --reporter=expanded` to run semantic tests; `Semantics` nodes must cover all interactive elements.
- **Commit discipline**: Each numbered task (T0xx) maps to one atomic commit.

## Governance

This constitution supersedes any other convention. Any deviation requires a justification comment in the code. Complexity introduced must be purposeful and demonstrable as a senior engineering decision. The constitution is the source of truth for AI-assisted implementation — all generated code must comply with these principles.

**Version**: 1.0.0 | **Ratified**: 2026-03-03 | **Last Amended**: 2026-03-03
