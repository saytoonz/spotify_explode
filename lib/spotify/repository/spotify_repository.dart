import '../utils/enums.dart';
import '../entities/user.dart';
import '../entities/track.dart';
import '../entities/album.dart';
import '../utils/constants.dart';
import '../entities/artist.dart';
import '../entities/playlist.dart';

abstract class SpotifyRepository {
  //! Tracks
  ///Get a single track detail
  Future<Track> getTrack({required String trackId});

  /// Get YouTube video id
  Future<String?> getYoutubeId({required String trackId});

  /// Get download url from spotify-mate
  Future<String?> getDownloadUrl({required String trackId});

  //! Playlist
  /// Get playlist info with all tracks
  Future<Playlist> getPlaylist({required String playlistId});

  /// Get all tracks in a playlist
  Future<List<Track>> getAllPlaylistTracks({required String playlistId});

  ///
  /// Get only tracks in a playlist paginated
  /// @param {required String playlistId}
  /// @param {optional int offset}
  /// @param {optional int limit}
  ///
  Future<List<Track>> getPlaylistTracksPaginated({
    required String playlistId,
    int offset = Constants.defaultOffset,
    int limit = Constants.defaultLimit,
  });

  //! Album
  /// Get album info with all tracks
  Future<Album> getAlbum({required String albumId});

  // Get tracks in a album
  Future<List<Track>> getAllAlbumTracks({required String albumId});

  ///
  /// Get only tracks in a album paginated
  /// @param {required String playlistId}
  /// @param {optional int offset}
  /// @param {optional int limit}
  ///
  Future<List<Track>> getAlbumTracksPaginated({
    required String albumId,
    int offset = Constants.defaultOffset,
    int limit = Constants.defaultLimit,
  });

  //! Artist
  ///Get an artist detail
  Future<Artist> getArtist({required String artistId});

  /// Get all albums in an artist
  Future<List<Album>> getAllArtistAlbums({
    required String artistId,
    String? albumType,
  });

  ///
  /// Get only album in an artist paginated
  /// @param {required String playlistId}
  /// @param {optional int offset}
  /// @param {optional int limit}
  ///
  Future<List<Album>> getArtistAlbumsPaginated({
    required String artistId,
    String? albumType,
    int offset = Constants.defaultOffset,
    int limit = Constants.defaultLimit,
  });

  //! User
  ///Get user detail
  Future<User> getUser({required String userId});

  /// Search for albums, artists, tracks, playlists
  /// Depending on the SearchType
  Future<T?> search<T>({
    required String query,
    SearchType searchTyp = SearchType.track,
    int offset = Constants.defaultOffset,
    int limit = Constants.defaultLimit,
  });
}
