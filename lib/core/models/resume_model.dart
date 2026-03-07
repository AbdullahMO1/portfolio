import 'package:freezed_annotation/freezed_annotation.dart';

part 'resume_model.freezed.dart';
part 'resume_model.g.dart';

/// Root resume data model — maps 1:1 to the GitHub Gist JSON.
@freezed
abstract class ResumeModel with _$ResumeModel {
  const factory ResumeModel({
    required MetaInfo meta,
    required String about,
    required List<SkillCategory> skills,
    required List<ExperienceEntry> experience,
    required List<ProjectEntry> projects,
    @Default([]) List<EducationEntry> education,
    @Default([]) List<CertificationEntry> certifications,
  }) = _ResumeModel;

  factory ResumeModel.fromJson(Map<String, dynamic> json) =>
      _$ResumeModelFromJson(json);
}

@freezed
abstract class MetaInfo with _$MetaInfo {
  const factory MetaInfo({
    required String name,
    required String tagline,
    required String email,
    @Default('') String github,
    @Default('') String linkedin,
    @Default('') String location,
    @Default('') String avatarUrl,
  }) = _MetaInfo;

  factory MetaInfo.fromJson(Map<String, dynamic> json) =>
      _$MetaInfoFromJson(json);
}

@freezed
abstract class SkillCategory with _$SkillCategory {
  const factory SkillCategory({
    required String category,
    required List<String> items,
  }) = _SkillCategory;

  factory SkillCategory.fromJson(Map<String, dynamic> json) =>
      _$SkillCategoryFromJson(json);
}

@freezed
abstract class ExperienceEntry with _$ExperienceEntry {
  const factory ExperienceEntry({
    required String company,
    required String role,
    required String period,
    @Default('') String location,
    @Default([]) List<String> highlights,
  }) = _ExperienceEntry;

  factory ExperienceEntry.fromJson(Map<String, dynamic> json) =>
      _$ExperienceEntryFromJson(json);
}

@freezed
abstract class ProjectEntry with _$ProjectEntry {
  const factory ProjectEntry({
    required String id,
    required String title,
    required String description,
    @Default([]) List<String> tech,
    String? github,
    String? demo,
    String? imageUrl,
    String? googlePlayUrl,
    String? appStoreUrl,
    String? liveDemoUrl,
    @Default([]) List<String> responsibilities,
    @Default([]) List<String> hardestFeatures,
  }) = _ProjectEntry;

  factory ProjectEntry.fromJson(Map<String, dynamic> json) =>
      _$ProjectEntryFromJson(json);
}

@freezed
abstract class EducationEntry with _$EducationEntry {
  const factory EducationEntry({
    required String institution,
    required String degree,
    @Default('') String year,
  }) = _EducationEntry;

  factory EducationEntry.fromJson(Map<String, dynamic> json) =>
      _$EducationEntryFromJson(json);
}

@freezed
abstract class CertificationEntry with _$CertificationEntry {
  const factory CertificationEntry({
    required String title,
    required String issuer,
    @Default('') String year,
  }) = _CertificationEntry;

  factory CertificationEntry.fromJson(Map<String, dynamic> json) =>
      _$CertificationEntryFromJson(json);
}
