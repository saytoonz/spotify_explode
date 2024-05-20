import '../entities/track.dart';
import '../utils/constants.dart';
import '../entities/playlist.dart';

abstract class Repository {
  //! Tracks
  ///Get a single track detail
  Future<Track> getTrack({required String trackId});

  /// Get YouTube video id
  Future<String?> getYoutubeId({required String trackId});

  /// Get download url from spotify-mate
  Future<String?> getDownloadUrl({required String trackId});

  //! Playlist
  /// Get all tracks in a playlist
  Future<Playlist> getPlaylist({required String playlistId});
  Future<List<Track>> getAllPlaylistTracks({required String playlistId});
  Future<List<Track>> getPlaylistTracksPaginated({
    required String playlistId,
    int offset = Constants.defaultOffset,
    int limit = Constants.defaultLimit,
  });
}
