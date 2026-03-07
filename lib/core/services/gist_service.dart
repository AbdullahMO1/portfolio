import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:portoflio/core/models/resume_model.dart';

/// Service responsible for fetching resume data from a GitHub Gist or local assets.
///
/// When [local] is true, loads from [localResumeAssetPath].
/// When [local] is false, fetches from [gistUrl].
/// Uses [compute] to parse the JSON on a background isolate.
class GistService {
  GistService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  /// When true, resume is loaded from [localResumeAssetPath].
  /// When false, resume is fetched from [gistUrl].
  static const bool local = true;

  /// Asset path for local resume JSON (used when [local] is true).
  static const String localResumeAssetPath = 'assets/data/resume.json';

  /// The raw URL of the GitHub Gist containing `resume.json` (used when [local] is false).
  static const String gistUrl =
      'https://gist.githubusercontent.com/'
      'YOUR_GITHUB_USERNAME/YOUR_GIST_ID/raw/resume.json';

  /// Fetches and parses the resume from local assets or the GitHub Gist.
  Future<ResumeModel> fetchResume() async {
    final String rawJson;
    if (local) {
      rawJson = await rootBundle.loadString(localResumeAssetPath);
    } else {
      final response = await _client.get(Uri.parse(gistUrl));
      if (response.statusCode != 200) {
        throw Exception(
          'Failed to load resume data (HTTP ${response.statusCode})',
        );
      }
      rawJson = response.body;
    }
    return compute(_parseResume, rawJson);
  }

  /// Top-level / static function required by [compute].
  static ResumeModel _parseResume(String rawJson) {
    final Map<String, dynamic> json =
        jsonDecode(rawJson) as Map<String, dynamic>;
    return ResumeModel.fromJson(json);
  }
}
