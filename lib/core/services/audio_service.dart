import 'package:flutter/foundation.dart';
import 'package:portoflio/core/services/desert_audio_service.dart';

/// Audio service for managing ambient sounds and music
class AudioService extends ChangeNotifier {
  factory AudioService() => _instance;
  AudioService._internal();

  static final AudioService _instance = AudioService._internal();
  static AudioService get instance => _instance;

  final DesertAudioService _desertAudio = DesertAudioService.instance;
  bool _isMuted = true;
  bool _isInitialized = false;

  /// Current mute state
  bool get isMuted => _isMuted;

  /// Whether audio service is initialized
  bool get isInitialized => _isInitialized;

  /// Initialize the audio service
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      if (kDebugMode) {
        debugPrint('AudioService: Initializing audio system');
      }
      await _desertAudio.initialize();
      _isInitialized = true;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('AudioService: Failed to initialize - $e');
      }
    }
  }

  /// Toggle mute state and return current playing state
  bool toggle() {
    if (!_isInitialized) {
      initialize();
    }

    _isMuted = !_isMuted;
    notifyListeners();

    if (kDebugMode) {
      debugPrint('AudioService: ${_isMuted ? 'Muted' : 'Unmuted'}');
    }

    if (!_isMuted) {
      _startAmbientSound();
    } else {
      _stopAmbientSound();
    }

    return !_isMuted; // Return playing state (true = playing)
  }

  /// Attempt to unlock audio after user interaction
  Future<void> tryUnlock() async {
    if (!_isInitialized) await initialize();
    if (!_isMuted) {
      await _startAmbientSound();
    }
  }

  /// Set mute state explicitly
  void setMuted(bool muted) {
    if (_isMuted == muted && _isInitialized) return;

    _isMuted = muted;
    notifyListeners();

    if (kDebugMode) {
      debugPrint('AudioService: Set muted to $muted');
    }

    if (!_isMuted) {
      _startAmbientSound();
    } else {
      _stopAmbientSound();
    }
  }

  /// Start playing ambient desert sounds
  Future<void> _startAmbientSound() async {
    if (kDebugMode) {
      debugPrint('AudioService: Starting ambient desert sounds');
    }
    await _desertAudio.playBackgroundSound(DesertSound.desertAmbient);
  }

  /// Stop playing ambient sounds
  void _stopAmbientSound() {
    if (kDebugMode) {
      debugPrint('AudioService: Stopping ambient sounds');
    }
    _desertAudio.stopBackgroundSound();
  }

  /// Update volume based on user preferences or context
  void updateVolume(double volume) {
    if (volume < 0.0 || volume > 1.0) {
      if (kDebugMode) {
        debugPrint('AudioService: Invalid volume value: $volume');
      }
      return;
    }

    if (kDebugMode) {
      debugPrint('AudioService: Setting volume to ${volume * 100}%');
    }

    _desertAudio.setVolume(volume);
  }

  /// Play a one-shot sound effect
  void playSoundEffect(String soundName) {
    if (_isMuted || !_isInitialized) return;

    if (kDebugMode) {
      debugPrint('AudioService: Playing sound effect: $soundName');
    }

    // Map string sound names to DesertSound if applicable
    if (soundName == 'sword_click') {
      _desertAudio.playSoundEffect(DesertSound.swordClick);
    }
  }

  /// Dispose of all audio resources
  @override
  void dispose() {
    if (kDebugMode) {
      debugPrint('AudioService: Disposing audio resources');
    }

    _stopAmbientSound();
    _desertAudio.dispose();
    _isInitialized = false;
    super.dispose();
  }
}
