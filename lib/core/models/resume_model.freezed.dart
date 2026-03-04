// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'resume_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ResumeModel {

 MetaInfo get meta; String get about; List<SkillCategory> get skills; List<ExperienceEntry> get experience; List<ProjectEntry> get projects; List<EducationEntry> get education; List<CertificationEntry> get certifications;
/// Create a copy of ResumeModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ResumeModelCopyWith<ResumeModel> get copyWith => _$ResumeModelCopyWithImpl<ResumeModel>(this as ResumeModel, _$identity);

  /// Serializes this ResumeModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ResumeModel&&(identical(other.meta, meta) || other.meta == meta)&&(identical(other.about, about) || other.about == about)&&const DeepCollectionEquality().equals(other.skills, skills)&&const DeepCollectionEquality().equals(other.experience, experience)&&const DeepCollectionEquality().equals(other.projects, projects)&&const DeepCollectionEquality().equals(other.education, education)&&const DeepCollectionEquality().equals(other.certifications, certifications));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,meta,about,const DeepCollectionEquality().hash(skills),const DeepCollectionEquality().hash(experience),const DeepCollectionEquality().hash(projects),const DeepCollectionEquality().hash(education),const DeepCollectionEquality().hash(certifications));

@override
String toString() {
  return 'ResumeModel(meta: $meta, about: $about, skills: $skills, experience: $experience, projects: $projects, education: $education, certifications: $certifications)';
}


}

/// @nodoc
abstract mixin class $ResumeModelCopyWith<$Res>  {
  factory $ResumeModelCopyWith(ResumeModel value, $Res Function(ResumeModel) _then) = _$ResumeModelCopyWithImpl;
@useResult
$Res call({
 MetaInfo meta, String about, List<SkillCategory> skills, List<ExperienceEntry> experience, List<ProjectEntry> projects, List<EducationEntry> education, List<CertificationEntry> certifications
});


$MetaInfoCopyWith<$Res> get meta;

}
/// @nodoc
class _$ResumeModelCopyWithImpl<$Res>
    implements $ResumeModelCopyWith<$Res> {
  _$ResumeModelCopyWithImpl(this._self, this._then);

  final ResumeModel _self;
  final $Res Function(ResumeModel) _then;

/// Create a copy of ResumeModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? meta = null,Object? about = null,Object? skills = null,Object? experience = null,Object? projects = null,Object? education = null,Object? certifications = null,}) {
  return _then(_self.copyWith(
meta: null == meta ? _self.meta : meta // ignore: cast_nullable_to_non_nullable
as MetaInfo,about: null == about ? _self.about : about // ignore: cast_nullable_to_non_nullable
as String,skills: null == skills ? _self.skills : skills // ignore: cast_nullable_to_non_nullable
as List<SkillCategory>,experience: null == experience ? _self.experience : experience // ignore: cast_nullable_to_non_nullable
as List<ExperienceEntry>,projects: null == projects ? _self.projects : projects // ignore: cast_nullable_to_non_nullable
as List<ProjectEntry>,education: null == education ? _self.education : education // ignore: cast_nullable_to_non_nullable
as List<EducationEntry>,certifications: null == certifications ? _self.certifications : certifications // ignore: cast_nullable_to_non_nullable
as List<CertificationEntry>,
  ));
}
/// Create a copy of ResumeModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MetaInfoCopyWith<$Res> get meta {
  
  return $MetaInfoCopyWith<$Res>(_self.meta, (value) {
    return _then(_self.copyWith(meta: value));
  });
}
}


/// Adds pattern-matching-related methods to [ResumeModel].
extension ResumeModelPatterns on ResumeModel {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ResumeModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ResumeModel() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ResumeModel value)  $default,){
final _that = this;
switch (_that) {
case _ResumeModel():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ResumeModel value)?  $default,){
final _that = this;
switch (_that) {
case _ResumeModel() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( MetaInfo meta,  String about,  List<SkillCategory> skills,  List<ExperienceEntry> experience,  List<ProjectEntry> projects,  List<EducationEntry> education,  List<CertificationEntry> certifications)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ResumeModel() when $default != null:
return $default(_that.meta,_that.about,_that.skills,_that.experience,_that.projects,_that.education,_that.certifications);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( MetaInfo meta,  String about,  List<SkillCategory> skills,  List<ExperienceEntry> experience,  List<ProjectEntry> projects,  List<EducationEntry> education,  List<CertificationEntry> certifications)  $default,) {final _that = this;
switch (_that) {
case _ResumeModel():
return $default(_that.meta,_that.about,_that.skills,_that.experience,_that.projects,_that.education,_that.certifications);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( MetaInfo meta,  String about,  List<SkillCategory> skills,  List<ExperienceEntry> experience,  List<ProjectEntry> projects,  List<EducationEntry> education,  List<CertificationEntry> certifications)?  $default,) {final _that = this;
switch (_that) {
case _ResumeModel() when $default != null:
return $default(_that.meta,_that.about,_that.skills,_that.experience,_that.projects,_that.education,_that.certifications);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ResumeModel implements ResumeModel {
  const _ResumeModel({required this.meta, required this.about, required final  List<SkillCategory> skills, required final  List<ExperienceEntry> experience, required final  List<ProjectEntry> projects, final  List<EducationEntry> education = const [], final  List<CertificationEntry> certifications = const []}): _skills = skills,_experience = experience,_projects = projects,_education = education,_certifications = certifications;
  factory _ResumeModel.fromJson(Map<String, dynamic> json) => _$ResumeModelFromJson(json);

@override final  MetaInfo meta;
@override final  String about;
 final  List<SkillCategory> _skills;
@override List<SkillCategory> get skills {
  if (_skills is EqualUnmodifiableListView) return _skills;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_skills);
}

 final  List<ExperienceEntry> _experience;
@override List<ExperienceEntry> get experience {
  if (_experience is EqualUnmodifiableListView) return _experience;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_experience);
}

 final  List<ProjectEntry> _projects;
@override List<ProjectEntry> get projects {
  if (_projects is EqualUnmodifiableListView) return _projects;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_projects);
}

 final  List<EducationEntry> _education;
@override@JsonKey() List<EducationEntry> get education {
  if (_education is EqualUnmodifiableListView) return _education;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_education);
}

 final  List<CertificationEntry> _certifications;
@override@JsonKey() List<CertificationEntry> get certifications {
  if (_certifications is EqualUnmodifiableListView) return _certifications;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_certifications);
}


/// Create a copy of ResumeModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ResumeModelCopyWith<_ResumeModel> get copyWith => __$ResumeModelCopyWithImpl<_ResumeModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ResumeModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ResumeModel&&(identical(other.meta, meta) || other.meta == meta)&&(identical(other.about, about) || other.about == about)&&const DeepCollectionEquality().equals(other._skills, _skills)&&const DeepCollectionEquality().equals(other._experience, _experience)&&const DeepCollectionEquality().equals(other._projects, _projects)&&const DeepCollectionEquality().equals(other._education, _education)&&const DeepCollectionEquality().equals(other._certifications, _certifications));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,meta,about,const DeepCollectionEquality().hash(_skills),const DeepCollectionEquality().hash(_experience),const DeepCollectionEquality().hash(_projects),const DeepCollectionEquality().hash(_education),const DeepCollectionEquality().hash(_certifications));

@override
String toString() {
  return 'ResumeModel(meta: $meta, about: $about, skills: $skills, experience: $experience, projects: $projects, education: $education, certifications: $certifications)';
}


}

/// @nodoc
abstract mixin class _$ResumeModelCopyWith<$Res> implements $ResumeModelCopyWith<$Res> {
  factory _$ResumeModelCopyWith(_ResumeModel value, $Res Function(_ResumeModel) _then) = __$ResumeModelCopyWithImpl;
@override @useResult
$Res call({
 MetaInfo meta, String about, List<SkillCategory> skills, List<ExperienceEntry> experience, List<ProjectEntry> projects, List<EducationEntry> education, List<CertificationEntry> certifications
});


@override $MetaInfoCopyWith<$Res> get meta;

}
/// @nodoc
class __$ResumeModelCopyWithImpl<$Res>
    implements _$ResumeModelCopyWith<$Res> {
  __$ResumeModelCopyWithImpl(this._self, this._then);

  final _ResumeModel _self;
  final $Res Function(_ResumeModel) _then;

/// Create a copy of ResumeModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? meta = null,Object? about = null,Object? skills = null,Object? experience = null,Object? projects = null,Object? education = null,Object? certifications = null,}) {
  return _then(_ResumeModel(
meta: null == meta ? _self.meta : meta // ignore: cast_nullable_to_non_nullable
as MetaInfo,about: null == about ? _self.about : about // ignore: cast_nullable_to_non_nullable
as String,skills: null == skills ? _self._skills : skills // ignore: cast_nullable_to_non_nullable
as List<SkillCategory>,experience: null == experience ? _self._experience : experience // ignore: cast_nullable_to_non_nullable
as List<ExperienceEntry>,projects: null == projects ? _self._projects : projects // ignore: cast_nullable_to_non_nullable
as List<ProjectEntry>,education: null == education ? _self._education : education // ignore: cast_nullable_to_non_nullable
as List<EducationEntry>,certifications: null == certifications ? _self._certifications : certifications // ignore: cast_nullable_to_non_nullable
as List<CertificationEntry>,
  ));
}

/// Create a copy of ResumeModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MetaInfoCopyWith<$Res> get meta {
  
  return $MetaInfoCopyWith<$Res>(_self.meta, (value) {
    return _then(_self.copyWith(meta: value));
  });
}
}


/// @nodoc
mixin _$MetaInfo {

 String get name; String get tagline; String get email; String get github; String get linkedin; String get location; String get avatarUrl;
/// Create a copy of MetaInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MetaInfoCopyWith<MetaInfo> get copyWith => _$MetaInfoCopyWithImpl<MetaInfo>(this as MetaInfo, _$identity);

  /// Serializes this MetaInfo to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MetaInfo&&(identical(other.name, name) || other.name == name)&&(identical(other.tagline, tagline) || other.tagline == tagline)&&(identical(other.email, email) || other.email == email)&&(identical(other.github, github) || other.github == github)&&(identical(other.linkedin, linkedin) || other.linkedin == linkedin)&&(identical(other.location, location) || other.location == location)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,tagline,email,github,linkedin,location,avatarUrl);

@override
String toString() {
  return 'MetaInfo(name: $name, tagline: $tagline, email: $email, github: $github, linkedin: $linkedin, location: $location, avatarUrl: $avatarUrl)';
}


}

/// @nodoc
abstract mixin class $MetaInfoCopyWith<$Res>  {
  factory $MetaInfoCopyWith(MetaInfo value, $Res Function(MetaInfo) _then) = _$MetaInfoCopyWithImpl;
@useResult
$Res call({
 String name, String tagline, String email, String github, String linkedin, String location, String avatarUrl
});




}
/// @nodoc
class _$MetaInfoCopyWithImpl<$Res>
    implements $MetaInfoCopyWith<$Res> {
  _$MetaInfoCopyWithImpl(this._self, this._then);

  final MetaInfo _self;
  final $Res Function(MetaInfo) _then;

/// Create a copy of MetaInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? tagline = null,Object? email = null,Object? github = null,Object? linkedin = null,Object? location = null,Object? avatarUrl = null,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,tagline: null == tagline ? _self.tagline : tagline // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,github: null == github ? _self.github : github // ignore: cast_nullable_to_non_nullable
as String,linkedin: null == linkedin ? _self.linkedin : linkedin // ignore: cast_nullable_to_non_nullable
as String,location: null == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String,avatarUrl: null == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [MetaInfo].
extension MetaInfoPatterns on MetaInfo {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MetaInfo value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MetaInfo() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MetaInfo value)  $default,){
final _that = this;
switch (_that) {
case _MetaInfo():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MetaInfo value)?  $default,){
final _that = this;
switch (_that) {
case _MetaInfo() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  String tagline,  String email,  String github,  String linkedin,  String location,  String avatarUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MetaInfo() when $default != null:
return $default(_that.name,_that.tagline,_that.email,_that.github,_that.linkedin,_that.location,_that.avatarUrl);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  String tagline,  String email,  String github,  String linkedin,  String location,  String avatarUrl)  $default,) {final _that = this;
switch (_that) {
case _MetaInfo():
return $default(_that.name,_that.tagline,_that.email,_that.github,_that.linkedin,_that.location,_that.avatarUrl);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  String tagline,  String email,  String github,  String linkedin,  String location,  String avatarUrl)?  $default,) {final _that = this;
switch (_that) {
case _MetaInfo() when $default != null:
return $default(_that.name,_that.tagline,_that.email,_that.github,_that.linkedin,_that.location,_that.avatarUrl);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MetaInfo implements MetaInfo {
  const _MetaInfo({required this.name, required this.tagline, required this.email, this.github = '', this.linkedin = '', this.location = '', this.avatarUrl = ''});
  factory _MetaInfo.fromJson(Map<String, dynamic> json) => _$MetaInfoFromJson(json);

@override final  String name;
@override final  String tagline;
@override final  String email;
@override@JsonKey() final  String github;
@override@JsonKey() final  String linkedin;
@override@JsonKey() final  String location;
@override@JsonKey() final  String avatarUrl;

/// Create a copy of MetaInfo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MetaInfoCopyWith<_MetaInfo> get copyWith => __$MetaInfoCopyWithImpl<_MetaInfo>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MetaInfoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MetaInfo&&(identical(other.name, name) || other.name == name)&&(identical(other.tagline, tagline) || other.tagline == tagline)&&(identical(other.email, email) || other.email == email)&&(identical(other.github, github) || other.github == github)&&(identical(other.linkedin, linkedin) || other.linkedin == linkedin)&&(identical(other.location, location) || other.location == location)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,tagline,email,github,linkedin,location,avatarUrl);

@override
String toString() {
  return 'MetaInfo(name: $name, tagline: $tagline, email: $email, github: $github, linkedin: $linkedin, location: $location, avatarUrl: $avatarUrl)';
}


}

/// @nodoc
abstract mixin class _$MetaInfoCopyWith<$Res> implements $MetaInfoCopyWith<$Res> {
  factory _$MetaInfoCopyWith(_MetaInfo value, $Res Function(_MetaInfo) _then) = __$MetaInfoCopyWithImpl;
@override @useResult
$Res call({
 String name, String tagline, String email, String github, String linkedin, String location, String avatarUrl
});




}
/// @nodoc
class __$MetaInfoCopyWithImpl<$Res>
    implements _$MetaInfoCopyWith<$Res> {
  __$MetaInfoCopyWithImpl(this._self, this._then);

  final _MetaInfo _self;
  final $Res Function(_MetaInfo) _then;

/// Create a copy of MetaInfo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? tagline = null,Object? email = null,Object? github = null,Object? linkedin = null,Object? location = null,Object? avatarUrl = null,}) {
  return _then(_MetaInfo(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,tagline: null == tagline ? _self.tagline : tagline // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,github: null == github ? _self.github : github // ignore: cast_nullable_to_non_nullable
as String,linkedin: null == linkedin ? _self.linkedin : linkedin // ignore: cast_nullable_to_non_nullable
as String,location: null == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String,avatarUrl: null == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$SkillCategory {

 String get category; List<String> get items;
/// Create a copy of SkillCategory
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SkillCategoryCopyWith<SkillCategory> get copyWith => _$SkillCategoryCopyWithImpl<SkillCategory>(this as SkillCategory, _$identity);

  /// Serializes this SkillCategory to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SkillCategory&&(identical(other.category, category) || other.category == category)&&const DeepCollectionEquality().equals(other.items, items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,category,const DeepCollectionEquality().hash(items));

@override
String toString() {
  return 'SkillCategory(category: $category, items: $items)';
}


}

/// @nodoc
abstract mixin class $SkillCategoryCopyWith<$Res>  {
  factory $SkillCategoryCopyWith(SkillCategory value, $Res Function(SkillCategory) _then) = _$SkillCategoryCopyWithImpl;
@useResult
$Res call({
 String category, List<String> items
});




}
/// @nodoc
class _$SkillCategoryCopyWithImpl<$Res>
    implements $SkillCategoryCopyWith<$Res> {
  _$SkillCategoryCopyWithImpl(this._self, this._then);

  final SkillCategory _self;
  final $Res Function(SkillCategory) _then;

/// Create a copy of SkillCategory
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? category = null,Object? items = null,}) {
  return _then(_self.copyWith(
category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [SkillCategory].
extension SkillCategoryPatterns on SkillCategory {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SkillCategory value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SkillCategory() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SkillCategory value)  $default,){
final _that = this;
switch (_that) {
case _SkillCategory():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SkillCategory value)?  $default,){
final _that = this;
switch (_that) {
case _SkillCategory() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String category,  List<String> items)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SkillCategory() when $default != null:
return $default(_that.category,_that.items);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String category,  List<String> items)  $default,) {final _that = this;
switch (_that) {
case _SkillCategory():
return $default(_that.category,_that.items);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String category,  List<String> items)?  $default,) {final _that = this;
switch (_that) {
case _SkillCategory() when $default != null:
return $default(_that.category,_that.items);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SkillCategory implements SkillCategory {
  const _SkillCategory({required this.category, required final  List<String> items}): _items = items;
  factory _SkillCategory.fromJson(Map<String, dynamic> json) => _$SkillCategoryFromJson(json);

@override final  String category;
 final  List<String> _items;
@override List<String> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}


/// Create a copy of SkillCategory
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SkillCategoryCopyWith<_SkillCategory> get copyWith => __$SkillCategoryCopyWithImpl<_SkillCategory>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SkillCategoryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SkillCategory&&(identical(other.category, category) || other.category == category)&&const DeepCollectionEquality().equals(other._items, _items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,category,const DeepCollectionEquality().hash(_items));

@override
String toString() {
  return 'SkillCategory(category: $category, items: $items)';
}


}

/// @nodoc
abstract mixin class _$SkillCategoryCopyWith<$Res> implements $SkillCategoryCopyWith<$Res> {
  factory _$SkillCategoryCopyWith(_SkillCategory value, $Res Function(_SkillCategory) _then) = __$SkillCategoryCopyWithImpl;
@override @useResult
$Res call({
 String category, List<String> items
});




}
/// @nodoc
class __$SkillCategoryCopyWithImpl<$Res>
    implements _$SkillCategoryCopyWith<$Res> {
  __$SkillCategoryCopyWithImpl(this._self, this._then);

  final _SkillCategory _self;
  final $Res Function(_SkillCategory) _then;

/// Create a copy of SkillCategory
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? category = null,Object? items = null,}) {
  return _then(_SkillCategory(
category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}


/// @nodoc
mixin _$ExperienceEntry {

 String get company; String get role; String get period; String get location; List<String> get highlights;
/// Create a copy of ExperienceEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExperienceEntryCopyWith<ExperienceEntry> get copyWith => _$ExperienceEntryCopyWithImpl<ExperienceEntry>(this as ExperienceEntry, _$identity);

  /// Serializes this ExperienceEntry to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExperienceEntry&&(identical(other.company, company) || other.company == company)&&(identical(other.role, role) || other.role == role)&&(identical(other.period, period) || other.period == period)&&(identical(other.location, location) || other.location == location)&&const DeepCollectionEquality().equals(other.highlights, highlights));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,company,role,period,location,const DeepCollectionEquality().hash(highlights));

@override
String toString() {
  return 'ExperienceEntry(company: $company, role: $role, period: $period, location: $location, highlights: $highlights)';
}


}

/// @nodoc
abstract mixin class $ExperienceEntryCopyWith<$Res>  {
  factory $ExperienceEntryCopyWith(ExperienceEntry value, $Res Function(ExperienceEntry) _then) = _$ExperienceEntryCopyWithImpl;
@useResult
$Res call({
 String company, String role, String period, String location, List<String> highlights
});




}
/// @nodoc
class _$ExperienceEntryCopyWithImpl<$Res>
    implements $ExperienceEntryCopyWith<$Res> {
  _$ExperienceEntryCopyWithImpl(this._self, this._then);

  final ExperienceEntry _self;
  final $Res Function(ExperienceEntry) _then;

/// Create a copy of ExperienceEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? company = null,Object? role = null,Object? period = null,Object? location = null,Object? highlights = null,}) {
  return _then(_self.copyWith(
company: null == company ? _self.company : company // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,period: null == period ? _self.period : period // ignore: cast_nullable_to_non_nullable
as String,location: null == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String,highlights: null == highlights ? _self.highlights : highlights // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [ExperienceEntry].
extension ExperienceEntryPatterns on ExperienceEntry {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ExperienceEntry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ExperienceEntry() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ExperienceEntry value)  $default,){
final _that = this;
switch (_that) {
case _ExperienceEntry():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ExperienceEntry value)?  $default,){
final _that = this;
switch (_that) {
case _ExperienceEntry() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String company,  String role,  String period,  String location,  List<String> highlights)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ExperienceEntry() when $default != null:
return $default(_that.company,_that.role,_that.period,_that.location,_that.highlights);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String company,  String role,  String period,  String location,  List<String> highlights)  $default,) {final _that = this;
switch (_that) {
case _ExperienceEntry():
return $default(_that.company,_that.role,_that.period,_that.location,_that.highlights);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String company,  String role,  String period,  String location,  List<String> highlights)?  $default,) {final _that = this;
switch (_that) {
case _ExperienceEntry() when $default != null:
return $default(_that.company,_that.role,_that.period,_that.location,_that.highlights);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ExperienceEntry implements ExperienceEntry {
  const _ExperienceEntry({required this.company, required this.role, required this.period, this.location = '', final  List<String> highlights = const []}): _highlights = highlights;
  factory _ExperienceEntry.fromJson(Map<String, dynamic> json) => _$ExperienceEntryFromJson(json);

@override final  String company;
@override final  String role;
@override final  String period;
@override@JsonKey() final  String location;
 final  List<String> _highlights;
@override@JsonKey() List<String> get highlights {
  if (_highlights is EqualUnmodifiableListView) return _highlights;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_highlights);
}


/// Create a copy of ExperienceEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExperienceEntryCopyWith<_ExperienceEntry> get copyWith => __$ExperienceEntryCopyWithImpl<_ExperienceEntry>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ExperienceEntryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExperienceEntry&&(identical(other.company, company) || other.company == company)&&(identical(other.role, role) || other.role == role)&&(identical(other.period, period) || other.period == period)&&(identical(other.location, location) || other.location == location)&&const DeepCollectionEquality().equals(other._highlights, _highlights));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,company,role,period,location,const DeepCollectionEquality().hash(_highlights));

@override
String toString() {
  return 'ExperienceEntry(company: $company, role: $role, period: $period, location: $location, highlights: $highlights)';
}


}

/// @nodoc
abstract mixin class _$ExperienceEntryCopyWith<$Res> implements $ExperienceEntryCopyWith<$Res> {
  factory _$ExperienceEntryCopyWith(_ExperienceEntry value, $Res Function(_ExperienceEntry) _then) = __$ExperienceEntryCopyWithImpl;
@override @useResult
$Res call({
 String company, String role, String period, String location, List<String> highlights
});




}
/// @nodoc
class __$ExperienceEntryCopyWithImpl<$Res>
    implements _$ExperienceEntryCopyWith<$Res> {
  __$ExperienceEntryCopyWithImpl(this._self, this._then);

  final _ExperienceEntry _self;
  final $Res Function(_ExperienceEntry) _then;

/// Create a copy of ExperienceEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? company = null,Object? role = null,Object? period = null,Object? location = null,Object? highlights = null,}) {
  return _then(_ExperienceEntry(
company: null == company ? _self.company : company // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,period: null == period ? _self.period : period // ignore: cast_nullable_to_non_nullable
as String,location: null == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String,highlights: null == highlights ? _self._highlights : highlights // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}


/// @nodoc
mixin _$ProjectEntry {

 String get id; String get title; String get description; List<String> get tech; String? get github; String? get demo; String? get imageUrl;
/// Create a copy of ProjectEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProjectEntryCopyWith<ProjectEntry> get copyWith => _$ProjectEntryCopyWithImpl<ProjectEntry>(this as ProjectEntry, _$identity);

  /// Serializes this ProjectEntry to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProjectEntry&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&const DeepCollectionEquality().equals(other.tech, tech)&&(identical(other.github, github) || other.github == github)&&(identical(other.demo, demo) || other.demo == demo)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,description,const DeepCollectionEquality().hash(tech),github,demo,imageUrl);

@override
String toString() {
  return 'ProjectEntry(id: $id, title: $title, description: $description, tech: $tech, github: $github, demo: $demo, imageUrl: $imageUrl)';
}


}

/// @nodoc
abstract mixin class $ProjectEntryCopyWith<$Res>  {
  factory $ProjectEntryCopyWith(ProjectEntry value, $Res Function(ProjectEntry) _then) = _$ProjectEntryCopyWithImpl;
@useResult
$Res call({
 String id, String title, String description, List<String> tech, String? github, String? demo, String? imageUrl
});




}
/// @nodoc
class _$ProjectEntryCopyWithImpl<$Res>
    implements $ProjectEntryCopyWith<$Res> {
  _$ProjectEntryCopyWithImpl(this._self, this._then);

  final ProjectEntry _self;
  final $Res Function(ProjectEntry) _then;

/// Create a copy of ProjectEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? description = null,Object? tech = null,Object? github = freezed,Object? demo = freezed,Object? imageUrl = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,tech: null == tech ? _self.tech : tech // ignore: cast_nullable_to_non_nullable
as List<String>,github: freezed == github ? _self.github : github // ignore: cast_nullable_to_non_nullable
as String?,demo: freezed == demo ? _self.demo : demo // ignore: cast_nullable_to_non_nullable
as String?,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ProjectEntry].
extension ProjectEntryPatterns on ProjectEntry {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProjectEntry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProjectEntry() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProjectEntry value)  $default,){
final _that = this;
switch (_that) {
case _ProjectEntry():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProjectEntry value)?  $default,){
final _that = this;
switch (_that) {
case _ProjectEntry() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  String description,  List<String> tech,  String? github,  String? demo,  String? imageUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProjectEntry() when $default != null:
return $default(_that.id,_that.title,_that.description,_that.tech,_that.github,_that.demo,_that.imageUrl);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  String description,  List<String> tech,  String? github,  String? demo,  String? imageUrl)  $default,) {final _that = this;
switch (_that) {
case _ProjectEntry():
return $default(_that.id,_that.title,_that.description,_that.tech,_that.github,_that.demo,_that.imageUrl);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  String description,  List<String> tech,  String? github,  String? demo,  String? imageUrl)?  $default,) {final _that = this;
switch (_that) {
case _ProjectEntry() when $default != null:
return $default(_that.id,_that.title,_that.description,_that.tech,_that.github,_that.demo,_that.imageUrl);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProjectEntry implements ProjectEntry {
  const _ProjectEntry({required this.id, required this.title, required this.description, final  List<String> tech = const [], this.github, this.demo, this.imageUrl}): _tech = tech;
  factory _ProjectEntry.fromJson(Map<String, dynamic> json) => _$ProjectEntryFromJson(json);

@override final  String id;
@override final  String title;
@override final  String description;
 final  List<String> _tech;
@override@JsonKey() List<String> get tech {
  if (_tech is EqualUnmodifiableListView) return _tech;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tech);
}

@override final  String? github;
@override final  String? demo;
@override final  String? imageUrl;

/// Create a copy of ProjectEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProjectEntryCopyWith<_ProjectEntry> get copyWith => __$ProjectEntryCopyWithImpl<_ProjectEntry>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProjectEntryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProjectEntry&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&const DeepCollectionEquality().equals(other._tech, _tech)&&(identical(other.github, github) || other.github == github)&&(identical(other.demo, demo) || other.demo == demo)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,description,const DeepCollectionEquality().hash(_tech),github,demo,imageUrl);

@override
String toString() {
  return 'ProjectEntry(id: $id, title: $title, description: $description, tech: $tech, github: $github, demo: $demo, imageUrl: $imageUrl)';
}


}

/// @nodoc
abstract mixin class _$ProjectEntryCopyWith<$Res> implements $ProjectEntryCopyWith<$Res> {
  factory _$ProjectEntryCopyWith(_ProjectEntry value, $Res Function(_ProjectEntry) _then) = __$ProjectEntryCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, String description, List<String> tech, String? github, String? demo, String? imageUrl
});




}
/// @nodoc
class __$ProjectEntryCopyWithImpl<$Res>
    implements _$ProjectEntryCopyWith<$Res> {
  __$ProjectEntryCopyWithImpl(this._self, this._then);

  final _ProjectEntry _self;
  final $Res Function(_ProjectEntry) _then;

/// Create a copy of ProjectEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? description = null,Object? tech = null,Object? github = freezed,Object? demo = freezed,Object? imageUrl = freezed,}) {
  return _then(_ProjectEntry(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,tech: null == tech ? _self._tech : tech // ignore: cast_nullable_to_non_nullable
as List<String>,github: freezed == github ? _self.github : github // ignore: cast_nullable_to_non_nullable
as String?,demo: freezed == demo ? _self.demo : demo // ignore: cast_nullable_to_non_nullable
as String?,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$EducationEntry {

 String get institution; String get degree; String get year;
/// Create a copy of EducationEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EducationEntryCopyWith<EducationEntry> get copyWith => _$EducationEntryCopyWithImpl<EducationEntry>(this as EducationEntry, _$identity);

  /// Serializes this EducationEntry to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EducationEntry&&(identical(other.institution, institution) || other.institution == institution)&&(identical(other.degree, degree) || other.degree == degree)&&(identical(other.year, year) || other.year == year));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,institution,degree,year);

@override
String toString() {
  return 'EducationEntry(institution: $institution, degree: $degree, year: $year)';
}


}

/// @nodoc
abstract mixin class $EducationEntryCopyWith<$Res>  {
  factory $EducationEntryCopyWith(EducationEntry value, $Res Function(EducationEntry) _then) = _$EducationEntryCopyWithImpl;
@useResult
$Res call({
 String institution, String degree, String year
});




}
/// @nodoc
class _$EducationEntryCopyWithImpl<$Res>
    implements $EducationEntryCopyWith<$Res> {
  _$EducationEntryCopyWithImpl(this._self, this._then);

  final EducationEntry _self;
  final $Res Function(EducationEntry) _then;

/// Create a copy of EducationEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? institution = null,Object? degree = null,Object? year = null,}) {
  return _then(_self.copyWith(
institution: null == institution ? _self.institution : institution // ignore: cast_nullable_to_non_nullable
as String,degree: null == degree ? _self.degree : degree // ignore: cast_nullable_to_non_nullable
as String,year: null == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [EducationEntry].
extension EducationEntryPatterns on EducationEntry {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EducationEntry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EducationEntry() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EducationEntry value)  $default,){
final _that = this;
switch (_that) {
case _EducationEntry():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EducationEntry value)?  $default,){
final _that = this;
switch (_that) {
case _EducationEntry() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String institution,  String degree,  String year)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EducationEntry() when $default != null:
return $default(_that.institution,_that.degree,_that.year);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String institution,  String degree,  String year)  $default,) {final _that = this;
switch (_that) {
case _EducationEntry():
return $default(_that.institution,_that.degree,_that.year);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String institution,  String degree,  String year)?  $default,) {final _that = this;
switch (_that) {
case _EducationEntry() when $default != null:
return $default(_that.institution,_that.degree,_that.year);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _EducationEntry implements EducationEntry {
  const _EducationEntry({required this.institution, required this.degree, this.year = ''});
  factory _EducationEntry.fromJson(Map<String, dynamic> json) => _$EducationEntryFromJson(json);

@override final  String institution;
@override final  String degree;
@override@JsonKey() final  String year;

/// Create a copy of EducationEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EducationEntryCopyWith<_EducationEntry> get copyWith => __$EducationEntryCopyWithImpl<_EducationEntry>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EducationEntryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EducationEntry&&(identical(other.institution, institution) || other.institution == institution)&&(identical(other.degree, degree) || other.degree == degree)&&(identical(other.year, year) || other.year == year));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,institution,degree,year);

@override
String toString() {
  return 'EducationEntry(institution: $institution, degree: $degree, year: $year)';
}


}

/// @nodoc
abstract mixin class _$EducationEntryCopyWith<$Res> implements $EducationEntryCopyWith<$Res> {
  factory _$EducationEntryCopyWith(_EducationEntry value, $Res Function(_EducationEntry) _then) = __$EducationEntryCopyWithImpl;
@override @useResult
$Res call({
 String institution, String degree, String year
});




}
/// @nodoc
class __$EducationEntryCopyWithImpl<$Res>
    implements _$EducationEntryCopyWith<$Res> {
  __$EducationEntryCopyWithImpl(this._self, this._then);

  final _EducationEntry _self;
  final $Res Function(_EducationEntry) _then;

/// Create a copy of EducationEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? institution = null,Object? degree = null,Object? year = null,}) {
  return _then(_EducationEntry(
institution: null == institution ? _self.institution : institution // ignore: cast_nullable_to_non_nullable
as String,degree: null == degree ? _self.degree : degree // ignore: cast_nullable_to_non_nullable
as String,year: null == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$CertificationEntry {

 String get title; String get issuer; String get year;
/// Create a copy of CertificationEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CertificationEntryCopyWith<CertificationEntry> get copyWith => _$CertificationEntryCopyWithImpl<CertificationEntry>(this as CertificationEntry, _$identity);

  /// Serializes this CertificationEntry to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CertificationEntry&&(identical(other.title, title) || other.title == title)&&(identical(other.issuer, issuer) || other.issuer == issuer)&&(identical(other.year, year) || other.year == year));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,issuer,year);

@override
String toString() {
  return 'CertificationEntry(title: $title, issuer: $issuer, year: $year)';
}


}

/// @nodoc
abstract mixin class $CertificationEntryCopyWith<$Res>  {
  factory $CertificationEntryCopyWith(CertificationEntry value, $Res Function(CertificationEntry) _then) = _$CertificationEntryCopyWithImpl;
@useResult
$Res call({
 String title, String issuer, String year
});




}
/// @nodoc
class _$CertificationEntryCopyWithImpl<$Res>
    implements $CertificationEntryCopyWith<$Res> {
  _$CertificationEntryCopyWithImpl(this._self, this._then);

  final CertificationEntry _self;
  final $Res Function(CertificationEntry) _then;

/// Create a copy of CertificationEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? title = null,Object? issuer = null,Object? year = null,}) {
  return _then(_self.copyWith(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,issuer: null == issuer ? _self.issuer : issuer // ignore: cast_nullable_to_non_nullable
as String,year: null == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [CertificationEntry].
extension CertificationEntryPatterns on CertificationEntry {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CertificationEntry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CertificationEntry() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CertificationEntry value)  $default,){
final _that = this;
switch (_that) {
case _CertificationEntry():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CertificationEntry value)?  $default,){
final _that = this;
switch (_that) {
case _CertificationEntry() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String title,  String issuer,  String year)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CertificationEntry() when $default != null:
return $default(_that.title,_that.issuer,_that.year);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String title,  String issuer,  String year)  $default,) {final _that = this;
switch (_that) {
case _CertificationEntry():
return $default(_that.title,_that.issuer,_that.year);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String title,  String issuer,  String year)?  $default,) {final _that = this;
switch (_that) {
case _CertificationEntry() when $default != null:
return $default(_that.title,_that.issuer,_that.year);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CertificationEntry implements CertificationEntry {
  const _CertificationEntry({required this.title, required this.issuer, this.year = ''});
  factory _CertificationEntry.fromJson(Map<String, dynamic> json) => _$CertificationEntryFromJson(json);

@override final  String title;
@override final  String issuer;
@override@JsonKey() final  String year;

/// Create a copy of CertificationEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CertificationEntryCopyWith<_CertificationEntry> get copyWith => __$CertificationEntryCopyWithImpl<_CertificationEntry>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CertificationEntryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CertificationEntry&&(identical(other.title, title) || other.title == title)&&(identical(other.issuer, issuer) || other.issuer == issuer)&&(identical(other.year, year) || other.year == year));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,issuer,year);

@override
String toString() {
  return 'CertificationEntry(title: $title, issuer: $issuer, year: $year)';
}


}

/// @nodoc
abstract mixin class _$CertificationEntryCopyWith<$Res> implements $CertificationEntryCopyWith<$Res> {
  factory _$CertificationEntryCopyWith(_CertificationEntry value, $Res Function(_CertificationEntry) _then) = __$CertificationEntryCopyWithImpl;
@override @useResult
$Res call({
 String title, String issuer, String year
});




}
/// @nodoc
class __$CertificationEntryCopyWithImpl<$Res>
    implements _$CertificationEntryCopyWith<$Res> {
  __$CertificationEntryCopyWithImpl(this._self, this._then);

  final _CertificationEntry _self;
  final $Res Function(_CertificationEntry) _then;

/// Create a copy of CertificationEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = null,Object? issuer = null,Object? year = null,}) {
  return _then(_CertificationEntry(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,issuer: null == issuer ? _self.issuer : issuer // ignore: cast_nullable_to_non_nullable
as String,year: null == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
