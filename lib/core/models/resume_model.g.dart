// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'resume_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ResumeModel _$ResumeModelFromJson(Map<String, dynamic> json) => _ResumeModel(
  meta: MetaInfo.fromJson(json['meta'] as Map<String, dynamic>),
  about: json['about'] as String,
  skills: (json['skills'] as List<dynamic>)
      .map((e) => SkillCategory.fromJson(e as Map<String, dynamic>))
      .toList(),
  experience: (json['experience'] as List<dynamic>)
      .map((e) => ExperienceEntry.fromJson(e as Map<String, dynamic>))
      .toList(),
  projects: (json['projects'] as List<dynamic>)
      .map((e) => ProjectEntry.fromJson(e as Map<String, dynamic>))
      .toList(),
  education:
      (json['education'] as List<dynamic>?)
          ?.map((e) => EducationEntry.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  certifications:
      (json['certifications'] as List<dynamic>?)
          ?.map((e) => CertificationEntry.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$ResumeModelToJson(_ResumeModel instance) =>
    <String, dynamic>{
      'meta': instance.meta,
      'about': instance.about,
      'skills': instance.skills,
      'experience': instance.experience,
      'projects': instance.projects,
      'education': instance.education,
      'certifications': instance.certifications,
    };

_MetaInfo _$MetaInfoFromJson(Map<String, dynamic> json) => _MetaInfo(
  name: json['name'] as String,
  tagline: json['tagline'] as String,
  email: json['email'] as String,
  github: json['github'] as String? ?? '',
  linkedin: json['linkedin'] as String? ?? '',
  location: json['location'] as String? ?? '',
  avatarUrl: json['avatarUrl'] as String? ?? '',
);

Map<String, dynamic> _$MetaInfoToJson(_MetaInfo instance) => <String, dynamic>{
  'name': instance.name,
  'tagline': instance.tagline,
  'email': instance.email,
  'github': instance.github,
  'linkedin': instance.linkedin,
  'location': instance.location,
  'avatarUrl': instance.avatarUrl,
};

_SkillCategory _$SkillCategoryFromJson(Map<String, dynamic> json) =>
    _SkillCategory(
      category: json['category'] as String,
      items: (json['items'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$SkillCategoryToJson(_SkillCategory instance) =>
    <String, dynamic>{'category': instance.category, 'items': instance.items};

_ExperienceEntry _$ExperienceEntryFromJson(Map<String, dynamic> json) =>
    _ExperienceEntry(
      company: json['company'] as String,
      role: json['role'] as String,
      period: json['period'] as String,
      location: json['location'] as String? ?? '',
      highlights:
          (json['highlights'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$ExperienceEntryToJson(_ExperienceEntry instance) =>
    <String, dynamic>{
      'company': instance.company,
      'role': instance.role,
      'period': instance.period,
      'location': instance.location,
      'highlights': instance.highlights,
    };

_ProjectEntry _$ProjectEntryFromJson(Map<String, dynamic> json) =>
    _ProjectEntry(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      tech:
          (json['tech'] as List<dynamic>?)?.map((e) => e as String).toList() ??
          const [],
      github: json['github'] as String?,
      demo: json['demo'] as String?,
      imageUrl: json['imageUrl'] as String?,
      googlePlayUrl: json['googlePlayUrl'] as String?,
      appStoreUrl: json['appStoreUrl'] as String?,
      liveDemoUrl: json['liveDemoUrl'] as String?,
      responsibilities:
          (json['responsibilities'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      hardestFeatures:
          (json['hardestFeatures'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$ProjectEntryToJson(_ProjectEntry instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'tech': instance.tech,
      'github': instance.github,
      'demo': instance.demo,
      'imageUrl': instance.imageUrl,
      'googlePlayUrl': instance.googlePlayUrl,
      'appStoreUrl': instance.appStoreUrl,
      'liveDemoUrl': instance.liveDemoUrl,
      'responsibilities': instance.responsibilities,
      'hardestFeatures': instance.hardestFeatures,
    };

_EducationEntry _$EducationEntryFromJson(Map<String, dynamic> json) =>
    _EducationEntry(
      institution: json['institution'] as String,
      degree: json['degree'] as String,
      year: json['year'] as String? ?? '',
    );

Map<String, dynamic> _$EducationEntryToJson(_EducationEntry instance) =>
    <String, dynamic>{
      'institution': instance.institution,
      'degree': instance.degree,
      'year': instance.year,
    };

_CertificationEntry _$CertificationEntryFromJson(Map<String, dynamic> json) =>
    _CertificationEntry(
      title: json['title'] as String,
      issuer: json['issuer'] as String,
      year: json['year'] as String? ?? '',
    );

Map<String, dynamic> _$CertificationEntryToJson(_CertificationEntry instance) =>
    <String, dynamic>{
      'title': instance.title,
      'issuer': instance.issuer,
      'year': instance.year,
    };
