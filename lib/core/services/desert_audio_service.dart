import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Audio service for Persian Prince desert ambient sounds
class DesertAudioService {
  factory DesertAudioService() => _instance;
  DesertAudioService._internal();

  static final DesertAudioService _instance = DesertAudioService._internal();
  static DesertAudioService get instance => _instance;

  final AudioPlayer _bgPlayer = AudioPlayer();
  final AudioPlayer _effectPlayer = AudioPlayer();
  bool _isInitialized = false;

  /// Initialize audio service
  Future<void> initialize() async {
    if (_isInitialized) return;
    await _bgPlayer.setReleaseMode(ReleaseMode.loop);
    _isInitialized = true;
  }

  /// Play ambient desert background sound
  Future<void> playBackgroundSound(DesertSound sound) async {
    if (!_isInitialized) await initialize();

    try {
      await _bgPlayer.stop();
      await _bgPlayer.setSource(
        AssetSource(sound.assetPath.replaceFirst('assets/', '')),
      );
      await _bgPlayer.setVolume(0.3);
      await _bgPlayer.resume();
    } catch (e) {
      debugPrint('Failed to play background sound: $e');
    }
  }

  /// Play one-time sound effect
  Future<void> playSoundEffect(DesertSound sound) async {
    if (!_isInitialized) await initialize();

    try {
      await _effectPlayer.stop();
      await _effectPlayer.setSource(
        AssetSource(sound.assetPath.replaceFirst('assets/', '')),
      );
      await _effectPlayer.setVolume(0.6);
      await _effectPlayer.resume();
    } catch (e) {
      debugPrint('Failed to play sound effect: $e');
    }
  }

  /// Stop background sound
  Future<void> stopBackgroundSound() async {
    if (!_isInitialized) return;
    try {
      await _bgPlayer.stop();
    } catch (e) {
      debugPrint('Failed to stop background sound: $e');
    }
  }

  /// Set overall volume
  Future<void> setVolume(double volume) async {
    if (!_isInitialized) await initialize();
    try {
      final clampedVolume = volume.clamp(0.0, 1.0);
      await _bgPlayer.setVolume(clampedVolume * 0.3);
      await _effectPlayer.setVolume(clampedVolume * 0.6);
    } catch (e) {
      debugPrint('Failed to set volume: $e');
    }
  }

  /// Dispose audio resources
  Future<void> dispose() async {
    await _bgPlayer.dispose();
    await _effectPlayer.dispose();
    _isInitialized = false;
  }
}

/// Desert sound effects enumeration
enum DesertSound {
  // Ambient background sounds
  desertAmbient('assets/audio/desert_ambient.mp3'),
  desertWind('assets/audio/desert_wind.mp3'),
  desertNight('assets/audio/desert_night.mp3'),
  oasisWater('assets/audio/oasis_water.mp3'),
  caravanBells('assets/audio/caravan_bells.mp3'),

  // Interactive sound effects
  swordClick('assets/audio/sword_click.mp3'),
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
