# Tasks: Senior Flutter Developer Portfolio

**Input**: `implementation_plan.md`, `constitution.md`, `clarify.md`
**Stack**: Flutter (Web/WASM) · Riverpod 2.x · go_router · freezed · Fragment Shaders · alchemist · GitHub Actions

---

## Phase 1: Project Setup & Toolchain

**Purpose**: Initialize the project with all dependencies, strict linting, and CI scaffolding.

- [ ] T001 Clean out default Flutter counter boilerplate from `lib/`
- [ ] T002 [P] Add all `pubspec.yaml` dependencies: `flutter_riverpod`, `riverpod_annotation`, `riverpod_generator`, `go_router`, `freezed`, `freezed_annotation`, `json_serializable`, `http`, `flutter_markdown`, `alchemist`
- [ ] T003 [P] Add all `pubspec.yaml` dev dependencies: `build_runner`, `custom_lint`, `riverpod_lint`, `very_good_analysis`
- [ ] T004 Configure `analysis_options.yaml` with `very_good_analysis` and add project-specific rule overrides
- [ ] T005 [P] Create folder structure: `lib/features/`, `lib/core/`, `lib/shared/`, `lib/router/`, `lib/theme/`, `assets/shaders/`, `assets/fonts/`
- [ ] T006 Set up GitHub Actions workflow at `.github/workflows/ci.yml` (format → analyze → test → build WASM → deploy to GitHub Pages)
- [ ] T007 Configure `web/index.html` for WASM target (CanvasKit renderer, correct `<base href>` for GitHub Pages)

**Checkpoint**: `flutter analyze` passes with zero warnings; `flutter build web --wasm` succeeds.

---

## Phase 2: Core Infrastructure (Blocking Prerequisites)

**Purpose**: Data layer, routing, theming, and app entry point — everything features depend on.

⚠️ **CRITICAL**: No feature work can begin until this phase is complete.

### T2-A: Data & Models

- [ ] T008 Create `resume.json` GitHub Gist with the finalized schema (meta, about, skills, experience, projects, education, certifications)
- [ ] T009 Create `lib/core/models/` with `Freezed` data classes: `ResumeModel`, `SkillCategory`, `ExperienceEntry`, `ProjectEntry`, `EducationEntry`, `CertificationEntry`
- [ ] T010 Run `build_runner` to generate `.g.dart` / `.freezed.dart` files
- [ ] T011 Create `lib/core/services/gist_service.dart` — `fetchResume()` using `http.get()` + `compute()` for JSON parsing in an Isolate

### T2-B: State Management

- [ ] T012 Create `lib/core/providers/portfolio_provider.dart` — `@riverpod` `FutureProvider` that calls `GistService.fetchResume()` and exposes `AsyncValue<ResumeModel>`
- [ ] T013 [P] Create `lib/theme/theme_notifier.dart` — `@riverpod` `Notifier` managing `ThemeMode` (light / dark / system)
- [ ] T014 [P] Create `lib/theme/app_theme.dart` — Material 3 `ThemeData` with seed color, dynamic color scheme, and custom text theme

### T2-C: Routing

- [ ] T015 Create `lib/router/app_router.dart` — `GoRouter` with `ShellRoute` (persistent nav), routes: `/`, `/about`, `/skills`, `/experience`, `/projects`, `/projects/:id`, `/contact`
- [ ] T016 Create `lib/router/route_transitions.dart` — custom `CustomTransitionPage` implementations: fade slide for shell children, hero expand for project detail
- [ ] T017 Create `lib/shared/widgets/app_shell.dart` — `ShellRoute` scaffold with adaptive `NavigationRail` (desktop ≥1200px), drawer (tablet), `NavigationBar` (mobile)

### T2-D: App Entry

- [ ] T018 Rewrite `lib/main.dart` — `ProviderScope`, `MaterialApp.router` wired to `AppRouter`, `ThemeNotifier` consumption

**Checkpoint**: App launches on web, routing between empty placeholder screens works, Gist data loads and logs correctly.

---

## Phase 3: Hero / Home (US1 — First Impression) 🎯 MVP

**Goal**: Landing section with an interactive GLSL shader background, animated name entrance, and animated scroll-down CTA.

**Independent Test**: Hero screen renders, shader animates, name text appears with staggered animation.

### T3 — Tests
- [ ] T019 [P] Write `alchemist` golden test for `HeroSection` in dark and light mode

### T3 — Implementation

- [ ] T020 Write GLSL fragment shader `assets/shaders/hero_bg.frag` — animated plasma/particle-wave effect with `u_time` and `u_resolution` uniforms, `u_mouse` for cursor interaction
- [ ] T021 Create `lib/features/home/widgets/shader_background.dart` — `AnimatedBuilder` + `CustomPainter` using `FragmentShader`, `Ticker`-driven time update
- [ ] T022 Create `lib/features/home/widgets/hero_section.dart` — full-viewport `Stack` with `ShaderBackground`, animated name headline (`TweenAnimationBuilder` + custom `Curve`), tagline, CTA button with hover magnetic effect
- [ ] T023 Create `lib/features/home/home_screen.dart` — `CustomScrollView` root, HeroSection as first Sliver

**Checkpoint**: Hero section renders with live shader background and staggered text entrance animation at 60fps.

---

## Phase 4: About Me (US2)

**Goal**: Personal bio section with Markdown rendering, profile image with 3D tilt, and scroll-triggered entrance.

- [ ] T024 [P] Write `alchemist` golden test for `AboutSection`
- [ ] T025 Create `lib/features/about/widgets/profile_card.dart` — `MouseRegion` tracking `Offset`, `Matrix4` 3D tilt transform driven by cursor position, animated on hover
- [ ] T026 Create `lib/features/about/widgets/about_section.dart` — `SliverToBoxAdapter` with `ProfileCard`, `MarkdownBody` (from `flutter_markdown`) rendering `ResumeModel.about`
- [ ] T027 Wire `AboutSection` into `HomeScreen`'s `CustomScrollView` as next Sliver

**Checkpoint**: About section appears below Hero, profile card tilts on cursor hover in 3D.

---

## Phase 5: Skills Grid (US3)

**Goal**: Visual skill tags grouped by category with staggered pop-in animation.

- [ ] T028 [P] Write `alchemist` golden test for `SkillsSection`
- [ ] T029 Create `lib/features/skills/widgets/skill_chip.dart` — custom chip with M3 surface tonal color, elastic pop-in `AnimationController` with `ElasticOutCurve`, hover scale effect
- [ ] T030 Create `lib/features/skills/widgets/skills_section.dart` — `SliverPersistentHeader` sticky category label + `SliverGrid` of `SkillChip`s, stagger-driven by scroll visibility
- [ ] T031 Wire `SkillsSection` into `HomeScreen`'s `CustomScrollView`

**Checkpoint**: Skills load from Gist, chips animate in with elastic pop stagger.

---

## Phase 6: Experience Timeline (US4)

**Goal**: Vertical animated timeline using Slivers to showcase work history.

- [ ] T032 [P] Write `alchemist` golden test for `ExperienceSection`
- [ ] T033 Create `lib/features/experience/widgets/timeline_entry.dart` — `AnimatedContainer` card with left-border accent line, role/company/period from `ExperienceEntry`, `MarkdownBody` for highlights, staggered slide-in on scroll
- [ ] T034 Create `lib/features/experience/widgets/experience_section.dart` — `SliverList` of `TimelineEntry` widgets with a connecting vertical line `CustomPainter`
- [ ] T035 Wire `ExperienceSection` into `HomeScreen`'s `CustomScrollView`

**Checkpoint**: Full work history renders from Gist data with animated timeline connector.

---

## Phase 7: Projects Showcase (US5)

**Goal**: Masonry grid of project cards with 3D tilt hover, deep-link support, and project detail page.

- [ ] T036 [P] Write `alchemist` golden test for `ProjectCard` and `ProjectDetailScreen`
- [ ] T037 Create `lib/features/projects/widgets/project_card.dart` — `MouseRegion` + `Matrix4` 3D perspective tilt, tech chip row, animated gradient overlay on hover, `GestureDetector` → `context.go('/projects/:id')`
- [ ] T038 Create `lib/features/projects/widgets/projects_section.dart` — adaptive masonry grid (`CustomMultiChildLayout` or `flutter_staggered_grid_view`) of `ProjectCard`s
- [ ] T039 Create `lib/features/projects/screens/project_detail_screen.dart` — hero expand transition, full description `MarkdownBody`, live demo / GitHub link buttons
- [ ] T040 Wire `ProjectsSection` into `HomeScreen`'s `CustomScrollView`; register `/projects/:id` route in `AppRouter`

**Checkpoint**: Projects grid loads from Gist, cards tilt in 3D, deep-linking to `/projects/my-app` works.

---

## Phase 8: Contact (US6)

**Goal**: Clean contact section with social links and an optional email CTA.

- [ ] T041 Create `lib/features/contact/widgets/contact_section.dart` — social link icon buttons (`GitHub`, `LinkedIn`, `Email`) with `url_launcher`, animated hover scale, `SliverToBoxAdapter`
- [ ] T042 Wire `ContactSection` as final Sliver in `HomeScreen`'s `CustomScrollView`

---

## Phase 9: Theme & Transitions (US7)

**Goal**: Circular reveal dark/light mode transition and polished M3 theme toggle.

- [ ] T043 Create `lib/theme/widgets/theme_toggle_button.dart` — FAB-style toggle button, positioned in `AppShell`
- [ ] T044 Create `lib/theme/widgets/theme_reveal_overlay.dart` — `ClipPath` with circular reveal `Tween<double>` expanding from toggle button position, overlaid during mode transition
- [ ] T045 Wire theme toggle into `ThemeNotifier` and trigger reveal overlay animation on mode switch

**Checkpoint**: Toggling theme produces a smooth circular reveal animation from the button position.

---

## Phase 10: Adaptive Layout Polish

**Goal**: Verify and polish the layout across all breakpoints.

- [ ] T046 Validate layout on mobile (<600px) — `NavigationBar`, single-column content, shader performance
- [ ] T047 [P] Validate layout on tablet (600–1199px) — drawer navigation, two-column project grid
- [ ] T048 [P] Validate layout on desktop/4K (≥1200px) — `NavigationRail`, masonry project grid, expanded timeline
- [ ] T049 Audit all `Semantics` widget coverage — interactive elements, images, navigation items

---

## Phase 11: Testing & CI/CD Finalization

**Purpose**: Lock in all golden tests, CI pipeline, and deployment.

- [ ] T050 [P] Regenerate all `alchemist` golden images for dark + light modes: `HeroSection`, `AboutSection`, `SkillsSection`, `ExperienceSection`, `ProjectCard`, `ProjectDetailScreen`
- [ ] T051 Write unit tests for `GistService` (mock HTTP) and `portfolioDataProvider` (`AsyncValue` lifecycle)
- [ ] T052 Verify full GitHub Actions CI pipeline runs: format → analyze → test (goldens) → WASM build → deploy
- [ ] T053 Add `flutter_lints` final pass — zero warnings, zero infos

---

## Dependencies & Execution Order

| Phase | Depends On | Can Parallelize |
|---|---|---|
| Phase 1: Setup | — | T002, T003, T005 |
| Phase 2: Core Infra | Phase 1 | T009–T011 ‖ T013–T014 |
| Phase 3–8: Features | Phase 2 complete | Phases 3–8 with each other (separate files) |
| Phase 9: Theme | Phase 2 | After Phase 3 (needs shell widget) |
| Phase 10: Polish | Phase 3–8 |  T047, T048 |
| Phase 11: CI/CD | All features done | T050, T051 |

---

## Notes

- `[P]` = no file conflicts, safe to run in parallel
- Each task maps 1:1 to an atomic Git commit
- Golden test workflow: write test → regenerate goldens → commit `.png` files
- Run `flutter pub run build_runner build --delete-conflicting-outputs` after any model change (T009) or provider change
- WASM constraint: avoid any package that uses `dart:mirrors` — verify with `flutter build web --wasm`
