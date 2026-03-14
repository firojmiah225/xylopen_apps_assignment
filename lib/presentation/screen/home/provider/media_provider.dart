import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import '../../../../data/model/song_model.dart';
import '../../../../domain/entities/song.dart';

class MediaProvider extends ChangeNotifier {

  final AudioPlayer _audioPlayer = AudioPlayer();

  final List<Song> _playlist = SongModel.getSampleSongs();


  int _currentIndex = 0;
  bool _isPlaying = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  List<Song> get playlist => _playlist;
  Song? get currentSong =>
      _playlist.isNotEmpty ? _playlist[_currentIndex] : null;
  bool get isPlaying => _isPlaying;
  Duration get duration => _duration;
  Duration get position => _position;
  int get currentIndex => _currentIndex;

  MediaProvider() {

    _initAudioPlayer();
  }

  void _initAudioPlayer() {
    _audioPlayer.onDurationChanged.listen((newDuration) {
      _duration = newDuration;

      notifyListeners();
    });

    _audioPlayer.onPositionChanged.listen((newPosition) {
      _position = newPosition;
      notifyListeners();
    });

    _audioPlayer.onPlayerStateChanged.listen((state) {
      _isPlaying = state == PlayerState.playing;
      notifyListeners();
    });


    _audioPlayer.onPlayerComplete.listen((event) {
      playNext();
    });

    if (_playlist.isNotEmpty) {
      _setAudioSource();
    }
  }

  Future<void> _setAudioSource() async {
    if (currentSong != null) {
      final url = currentSong!.url;
      await _audioPlayer.setSourceUrl(url!);
      _duration = Duration(seconds: currentSong!.durationSeconds);
      _position = Duration.zero;
      notifyListeners();
    }
  }

  Future<void> playPause() async {
    if (_isPlaying) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.play(UrlSource(currentSong!.url!));
    }
  }

  Future<void> playSongAtIndex(int index) async {
    if (index >= 0 && index < _playlist.length) {
      _currentIndex = index;
      await _setAudioSource();
      await _audioPlayer.play(UrlSource(currentSong!.url!));
      notifyListeners();
    }
  }

  Future<void> _playCurrentSong() async {
    await _setAudioSource();
    await _audioPlayer.play(UrlSource(currentSong!.url!));
    notifyListeners();
  }

  Future<void> playNext() async {
    _currentIndex = (_currentIndex + 1) % _playlist.length;
    await _playCurrentSong();
  }


  Future<void> playPrevious() async {
    _currentIndex = (_currentIndex - 1 + _playlist.length) % _playlist.length;
    await _playCurrentSong();
  }
  Future<void> seek(Duration position) async {
    await _audioPlayer.seek(position);
  }

  @override
  void dispose() {

    _audioPlayer.dispose();
    super.dispose();
  }
}