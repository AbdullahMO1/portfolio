// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'portfolio_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides the resume data fetched from the GitHub Gist.
///
/// Returns an [AsyncValue<ResumeModel>] so the UI can elegantly
/// handle loading, error, and data states.

@ProviderFor(portfolioData)
final portfolioDataProvider = PortfolioDataProvider._();

/// Provides the resume data fetched from the GitHub Gist.
///
/// Returns an [AsyncValue<ResumeModel>] so the UI can elegantly
/// handle loading, error, and data states.

final class PortfolioDataProvider
    extends
        $FunctionalProvider<
          AsyncValue<ResumeModel>,
          ResumeModel,
          FutureOr<ResumeModel>
        >
    with $FutureModifier<ResumeModel>, $FutureProvider<ResumeModel> {
  /// Provides the resume data fetched from the GitHub Gist.
  ///
  /// Returns an [AsyncValue<ResumeModel>] so the UI can elegantly
  /// handle loading, error, and data states.
  PortfolioDataProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'portfolioDataProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$portfolioDataHash();

  @$internal
  @override
  $FutureProviderElement<ResumeModel> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<ResumeModel> create(Ref ref) {
    return portfolioData(ref);
  }
}

String _$portfolioDataHash() => r'bdea11fd55092223237a196618e42bcdf485372c';
