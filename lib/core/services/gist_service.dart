import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:portoflio/core/models/resume_model.dart';

/// Service responsible for fetching resume data from a GitHub Gist.
///
/// Uses [compute] to parse the JSON on a background isolate,
/// keeping the main UI thread completely free.
class GistService {
  GistService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  /// The raw URL of the GitHub Gist containing `resume.json`.
  ///
  /// Replace this with your actual Gist raw URL.
  static const String gistUrl =
      'https://gist.githubusercontent.com/'
      'YOUR_GITHUB_USERNAME/YOUR_GIST_ID/raw/resume.json';

  /// Fetches and parses the resume from the GitHub Gist.
  ///
  /// Heavy JSON parsing is offloaded to a background isolate via [compute].
  Future<ResumeModel> fetchResume() async {
    final response = await _client.get(Uri.parse(gistUrl));

    if (response.statusCode != 200) {
      throw Exception(
        'Failed to load resume data (HTTP ${response.statusCode})',
      );
    }

    // Offload JSON decoding + model parsing to a background isolate
    return compute(_parseResume, response.body);
  }

  /// Top-level / static function required by [compute].
  static ResumeModel _parseResume(String rawJson) {
    final Map<String, dynamic> json =
        jsonDecode(rawJson) as Map<String, dynamic>;
    return ResumeModel.fromJson(json);
  }
}
