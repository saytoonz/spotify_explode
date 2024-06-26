import '../spotify.dart';
import '../utils/enums.dart';
import 'package:dio/dio.dart';
import '../entities/user.dart';
import '../entities/album.dart';
import '../entities/track.dart';
import 'spotify_repository.dart';
import '../entities/artist.dart';
import '../utils/constants.dart';
import '../entities/playlist.dart';
import '../entities/search_result.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:html/parser.dart' show parse;
import 'package:dio_cookie_manager/dio_cookie_manager.dart';

class SpotifyRepositoryImpl implements SpotifyRepository {
  final SpotifyTokenGetter _getToken;
  final Dio _dio = Dio();
  final CookieJar cookieJar = CookieJar();

  SpotifyRepositoryImpl(this._getToken) {
    _dio.interceptors.add(CookieManager(cookieJar));
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
      return track;
    } catch (e) {
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

      return result["id"];
    } catch (e) {
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
      url = await _getSpotifyMateUrl(trackId);
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

  Future<String?> _getSpotifyMateUrl(String trackId) async {
    try {
      final token = await _getSpotifyMateToken();
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
      return null;
    }
  }

  Future<Map<String?, String?>> _getSpotifyMateToken() async {
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

        albumList.addAll(albums);

        if (albums.length < Constants.defaultLimit) {
          break;
        }

        offset += albums.length;
      }

      return albumList;
    } catch (e) {
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
      throw e.toString();
    }
  }

  @override
  Future<T?> search<T>({
    required String query,
    SearchType searchTyp = SearchType.track,
    int offset = Constants.defaultOffset,
    int limit = Constants.defaultLimit,
  }) async {
    if (limit < Constants.minLimit || limit > Constants.maxLimit) {
      throw Exception(
          "Limit must be between ${Constants.minLimit} and ${Constants.maxLimit}");
    }

    try {
      final result = (await _dio.get(
        'https://api.spotify.com/v1/search',
        queryParameters: {
          'q': query,
          'type': searchTyp.name,
          'offset': offset,
          'limit': limit,
          'market': 'us'
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer ${await _getToken.call()}',
            'Content-Type': 'application/json',
          },
        ),
      ))
          .data;

      if (searchTyp == SearchType.track) {
        return SearchTrackResult.fromJson(result['tracks']) as T;
      } else if (searchTyp == SearchType.album) {
        return SearchAlbumResult.fromJson(result['albums']) as T;
      } else if (searchTyp == SearchType.artist) {
        return SearchArtistResult.fromJson(result['artists']) as T;
      } else if (searchTyp == SearchType.playlist) {
        return SearchPlaylistResult.fromJson(result['playlists']) as T;
      } else {
        throw 'Unknow search type';
      }
    } catch (e) {
      throw e.toString();
    }
  }
}
