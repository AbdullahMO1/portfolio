import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Audio service for Persian Prince desert ambient sounds
class DesertAudioService {
  static final DesertAudioService _instance = DesertAudioService._internal();
  factory DesertAudioService() => _instance;

  DesertAudioService._internal();

  MethodChannel? _audioChannel;
  bool _isInitialized = false;

  /// Initialize audio service
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Create method channel for audio calls
      _audioChannel = const MethodChannel('desert_audio');
      _isInitialized = true;
    } catch (e) {
      print('Audio service initialization failed: $e');
    }
  }

  /// Play ambient desert background sound
  Future<void> playBackgroundSound(DesertSound sound) async {
    if (!_isInitialized) return;

    try {
      await _audioChannel!.invokeMethod('playBackground', {
        'soundPath': sound.assetPath,
        'volume': 0.3, // Subtle ambient volume
        'loop': true,
      });
    } catch (e) {
      print('Failed to play background sound: $e');
    }
  }

  /// Play one-time sound effect
  Future<void> playSoundEffect(DesertSound sound) async {
    if (!_isInitialized) return;

    try {
      await _audioChannel!.invokeMethod('playSoundEffect', {
        'soundPath': sound.assetPath,
        'volume': 0.6, // Effect sounds are more prominent
      });
    } catch (e) {
      print('Failed to play sound effect: $e');
    }
  }

  /// Stop background sound
  Future<void> stopBackgroundSound() async {
    if (!_isInitialized) return;

    try {
      await _audioChannel!.invokeMethod('stopBackground');
    } catch (e) {
      print('Failed to stop background sound: $e');
    }
  }

  /// Set overall volume
  Future<void> setVolume(double volume) async {
    if (!_isInitialized) return;

    try {
      await _audioChannel!.invokeMethod('setVolume', {'volume': volume.clamp(0.0, 1.0)});
    } catch (e) {
      print('Failed to set volume: $e');
    }
  }

  /// Dispose audio resources
  Future<void> dispose() async {
    try {
      await _audioChannel?.invokeMethod('dispose');
    } catch (e) {
      print('Audio service disposal failed: $e');
    }

    _isInitialized = false;
  }
}

/// Desert sound effects enumeration
enum DesertSound {
  // Ambient background sounds
  desertWind('assets/audio/desert_wind.mp3'),
  desertNight('assets/audio/desert_night.mp3'),
  oasisWater('assets/audio/oasis_water.mp3'),
  caravanBells('assets/audio/caravan_bells.mp3'),

  // Interactive sound effects
  magicLamp('assets/audio/magic_lamp.mp3'),
  footstepInSand('assets/audio/footstep_sand.mp3'),
  scrollReveal('assets/audio/sand_reveal.mp3'),
  magicCarpet('assets/audio/magic_carpet.mp3'),
  camelSound('assets/audio/camel_sound.mp3');

  const DesertSound(this.assetPath);

  final String assetPath;
}

/// Provider for desert audio service
final desertAudioServiceProvider = Provider<DesertAudioService>((ref) {
  final audioService = DesertAudioService();

  // Initialize audio on first use
  ref.onDispose(() {
    audioService.dispose();
  });

  return audioService;
});
