import 'package:portoflio/core/models/resume_model.dart';
import 'package:portoflio/core/services/gist_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'portfolio_provider.g.dart';

/// Provides the resume data fetched from the GitHub Gist.
///
/// Returns an [AsyncValue<ResumeModel>] so the UI can elegantly
/// handle loading, error, and data states.
@riverpod
Future<ResumeModel> portfolioData(Ref ref) async {
  final service = GistService();
  return service.fetchResume();
}
