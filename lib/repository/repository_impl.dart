import 'repository.dart';
import 'package:dio/dio.dart';
import '../entities/artist.dart';
import '../utils/constants.dart';
import 'package:spotify_explode/di.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:html/parser.dart' show parse;
import 'package:spotify_explode/entities/user.dart';
import 'package:spotify_explode/entities/album.dart';
import 'package:spotify_explode/entities/track.dart';
import 'package:spotify_explode/entities/playlist.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';

class RepositoryImpl implements Repository {
  late AuthTokenGetter _getToken;
  final Dio _dio = Dio();
  final CookieJar cookieJar = CookieJar();

  RepositoryImpl({
    required AuthTokenGetter token,
  }) {
    _dio.interceptors.add(CookieManager(cookieJar));
    _getToken = token;
  }

  @override
  Future<Track> getTrack({required String trackId}) async {
    try {
      final result = (await _dio.get(
        'https://api.spotify.com/v1/tracks/$trackId',
        options: Options(
          headers: {
            'Authorization': 'Bearer ${await _getToken.call()}',
            'Content-Type': 'application/json'
          },
        ),
      ))
          .data;

      Track track = Track.fromJson(result);
      logger.d(track.toJson());

      return track;
    } catch (e) {
      logger.e(e);
      throw e.toString();
    }
  }

  @override
  Future<String?> getYoutubeId({required String trackId}) async {
    try {
      final result = (await _dio.get(
        'https://api.spotifydown.com/getId/$trackId',
        options: Options(
          headers: {
            'Authorization': 'Bearer ${await _getToken.call()}',
            'Content-Type': 'application/json',
            "referer": "https://spotifydown.com/",
            "origin": "https://spotifydown.com"
          },
        ),
      ))
          .data;
      if (!(result["success"] ?? false)) throw result["message"];

      logger.d(result);

      return result["id"];
    } catch (e) {
      logger.e(e);
      throw e.toString();
    }
  }

  @override
  Future<String?> getDownloadUrl({required String trackId}) async {
    String? url;

    try {
      url = await _getSpotifyDownloaderUrl(trackId);
    } catch (e) {
      // Handle exceptions if necessary
    }

    if (url == null || url.isEmpty) {
      url = await _getSpotifymateUrl(trackId);
    }
    // logger.d(url);

    return url;
  }

  Future<String?> _getSpotifyDownloaderUrl(String trackId) async {
    final formData =
        FormData.fromMap({'link': 'https://open.spotify.com/track/$trackId'});

    final result = (await _dio.post(
      'https://api.spotify-downloader.com/',
      data: formData,
      options: Options(
        headers: {
          'Authorization': 'Bearer ${await _getToken.call()}',
          'Content-Type': 'application/json'
        },
      ),
    ))
        .data;

    // final jsonResponse = jsonDecode(response.data);

    return result['audio']?['url'];
  }

  Future<String?> _getSpotifymateUrl(String trackId) async {
    try {
      final token = await _getSpotifymateToken();
      final formData = FormData.fromMap({
        'url': 'https://open.spotify.com/track/$trackId',
        token.keys.first!: token.values.first!
      });

      final response = (await _dio.post(
        'https://spotifymate.com/action',
        data: formData,
      ));

      final result = response.data;
      if (result.isEmpty) return null;
      final document = parse(result);

      return document
          .getElementById('download-block')
          ?.querySelector('a')
          ?.attributes['href'];
    } catch (e) {
      logger.d(e);
      return null;
    }
  }

  Future<Map<String?, String?>> _getSpotifymateToken() async {
    try {
      final result = (await _dio.get('https://spotifymate.com/')).data;
      final document = parse(result);

      final hiddenInput = document
          .getElementById('get_video')
          ?.querySelector('input[type="hidden"]');

      return {
        hiddenInput?.attributes['name']: hiddenInput?.attributes['value']
      };
    } catch (e) {
      logger.d(e);
      return {};
    }
  }

  ///
  ///
  ///
  /// PlayList
  ///
  @override
  Future<Playlist> getPlaylist({required String playlistId}) async {
    try {
      final result = (await _dio.get(
        'https://api.spotify.com/v1/playlists/$playlistId',
        options: Options(
          headers: {
            'Authorization': 'Bearer ${await _getToken.call()}',
            'Content-Type': 'application/json',
          },
        ),
      ))
          .data;

      return Playlist.fromJson(result);
    } catch (e) {
      logger.e(e);
      throw e.toString();
    }
  }

  @override
  Future<List<Track>> getAllPlaylistTracks({required String playlistId}) async {
    List<PlaylistItem> items = await getAllPlaylistItems(playlistId);
    return items.map((item) => item.track).toList();
  }

  @override
  Future<List<Track>> getPlaylistTracksPaginated({
    required String playlistId,
    int offset = Constants.defaultOffset,
    int limit = Constants.defaultLimit,
  }) async {
    var items =
        await _getPlaylistItems(playlistId, offset: offset, limit: limit);
    return items.map((item) => item.track).toList();
  }

  Future<List<PlaylistItem>> getAllPlaylistItems(String playlistId) async {
    List<PlaylistItem> playlistItems = [];
    int offset = 0;

    while (true) {
      List<PlaylistItem> tracks = await _getPlaylistItems(playlistId,
          offset: offset, limit: Constants.maxLimit);

      playlistItems.addAll(tracks);

      if (tracks.length < Constants.maxLimit) {
        break;
      }

      offset += tracks.length;
    }

    return playlistItems;
  }

  Future<List<PlaylistItem>> _getPlaylistItems(String playlistId,
      {int offset = Constants.defaultOffset,
      int limit = Constants.defaultLimit}) async {
    if (limit < Constants.minLimit || limit > Constants.maxLimit) {
      throw Exception(
          "Limit must be between ${Constants.minLimit} and ${Constants.maxLimit}");
    }

    final result = (await _dio.get(
      'https://api.spotify.com/v1/playlists/$playlistId/tracks',
      queryParameters: {
        'offset': offset,
        'limit': limit,
      },
      options: Options(
        headers: {
          'Authorization': 'Bearer ${await _getToken.call()}',
          'Content-Type': 'application/json',
        },
      ),
    ))
        .data;

    return (result['items'] as Iterable)
        .map((json) => PlaylistItem.fromJson(json))
        .toList();
  }

  ///
  ///
  ///
  ///
  /// Album
  ///
  @override
  Future<Album> getAlbum({required String albumId}) async {
    try {
      final result = (await _dio.get(
        'https://api.spotify.com/v1/albums/$albumId',
        options: Options(
          headers: {
            'Authorization': 'Bearer ${await _getToken.call()}',
            'Content-Type': 'application/json',
          },
        ),
      ))
          .data;

      return Album.fromJson(result);
    } catch (e) {
      logger.e(e);
      throw e.toString();
    }
  }

  @override
  Future<List<Track>> getAllAlbumTracks({required String albumId}) async {
    try {
      List<Track> trackList = [];
      int offset = 0;

      while (true) {
        List<Track> tracks = await getAlbumTracksPaginated(
          albumId: albumId,
          offset: offset,
          limit: Constants.defaultLimit,
        );

        trackList.addAll(tracks);

        if (tracks.length < Constants.defaultLimit) {
          break;
        }

        offset += tracks.length;
      }

      return trackList;
    } catch (e) {
      logger.e(e);
      throw e.toString();
    }
  }

  @override
  Future<List<Track>> getAlbumTracksPaginated({
    required String albumId,
    int offset = Constants.defaultOffset,
    int limit = Constants.defaultLimit,
  }) async {
    if (limit < Constants.minLimit || limit > Constants.maxLimit) {
      throw Exception(
          "Limit must be between ${Constants.minLimit} and ${Constants.maxLimit}");
    }

    final result = (await _dio.get(
      'https://api.spotify.com/v1/albums/$albumId/tracks',
      queryParameters: {
        'offset': offset,
        'limit': limit,
      },
      options: Options(
        headers: {
          'Authorization': 'Bearer ${await _getToken.call()}',
          'Content-Type': 'application/json',
        },
      ),
    ))
        .data;

    return (result['items'] as Iterable)
        .map((json) => Track.fromJson(json))
        .toList();
  }

  ///
  ///
  ///
  ///
  ///
  /// Artist
  ///
  @override
  Future<Artist> getArtist({required String artistId}) async {
    try {
      final result = (await _dio.get(
        'https://api.spotify.com/v1/artists/$artistId',
        options: Options(
          headers: {
            'Authorization': 'Bearer ${await _getToken.call()}',
            'Content-Type': 'application/json',
          },
        ),
      ))
          .data;

      return Artist.fromJson(result);
    } catch (e) {
      logger.e(e);
      throw e.toString();
    }
  }

  @override
  Future<List<Album>> getAllArtistAlbums({
    required String artistId,
    String? albumType,
  }) async {
    try {
      List<Album> albumList = [];
      int offset = 0;

      while (true) {
        List<Album> albums = await getArtistAlbumsPaginated(
          artistId: artistId,
          offset: offset,
          limit: Constants.defaultLimit,
          albumType: albumType,
        );

        logger.d("New additions: ${albums.length}");

        albumList.addAll(albums);

        if (albums.length < Constants.defaultLimit) {
          break;
        }

        offset += albums.length;
      }

      return albumList;
    } catch (e) {
      logger.e(e);
      throw e.toString();
    }
  }

  @override
  Future<List<Album>> getArtistAlbumsPaginated({
    required String artistId,
    String? albumType,
    int offset = Constants.defaultOffset,
    int limit = Constants.defaultLimit,
  }) async {
    if (limit < Constants.minLimit || limit > Constants.maxLimit) {
      throw Exception(
          "Limit must be between ${Constants.minLimit} and ${Constants.maxLimit}");
    }

    final result = (await _dio.get(
      'https://api.spotify.com/v1/artists/$artistId/albums',
      queryParameters: {
        'offset': offset,
        'limit': limit,
      }..addAll(albumType != null
          ? {
              'album_type': albumType.toUpperCase(),
            }
          : {}),
      options: Options(
        headers: {
          'Authorization': 'Bearer ${await _getToken.call()}',
          'Content-Type': 'application/json',
        },
      ),
    ))
        .data;

    return (result['items'] as Iterable)
        .map((json) => Album.fromJson(json))
        .toList();
  }

  ///
  ///
  ///
  ///
  ///
  /// User
  ///
  @override
  Future<User> getUser({required String userId}) async {
    try {
      final result = (await _dio.get(
        'https://api.spotify.com/v1/users/$userId',
        options: Options(
          headers: {
            'Authorization': 'Bearer ${await _getToken.call()}',
            'Content-Type': 'application/json',
          },
        ),
      ))
          .data;

      return User.fromJson(result);
    } catch (e) {
      logger.e(e);
      throw e.toString();
    }
  }
}
