import 'di.dart';
import 'entities/track.dart';
import 'entities/playlist.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:spotify_explode/entities/album.dart';
import 'package:spotify_explode/entities/artist.dart';
import 'package:spotify_explode/repository/repository.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await diSetup();
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Repository get repository => getIt<Repository>();
  final player = AudioPlayer();
  Track? track;
  Playlist? playList;

  String trackId = '6O5A41opiGbG2PphOnzZ6b'; // '37R0bQOQj5a7DOqh1TGzvB';
  String playlistId = '7hFdF3Wrqg74DXAk9z6a0G'; // '37R0bQOQj5a7DOqh1TGzvB';
  String albumId = '2wiPF3m0ylst0JSk1IvZL8'; // 336m0kejdM5Fkw2HUX46Bw
  String artistId = '4GNC7GD6oZMSxPGyXy4MNB'; // 0bAsR2unSRpn6BQPEnNlZm
  String userId = 'xxu0yww90v07gbh9veqta7ze0'; // 336m0kejdM5Fkw2HUX46Bw

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
        child: Text('Hello World!'),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Row(
          children: [
            StreamBuilder<PlayerState>(
              stream: player.onPlayerStateChanged,
              builder: (_, shot) {
                bool isPlaying = shot.data == PlayerState.playing;
                return IconButton(
                  onPressed: () {
                    if (isPlaying) {
                      player.pause();
                    } else {
                      player.resume();
                    }
                  },
                  icon: Icon(
                    isPlaying
                        ? Icons.pause_circle_outline
                        : Icons.play_circle_outline,
                    size: 50,
                  ),
                );
              },
            ),
            Expanded(
              child: StreamBuilder(
                  stream: player.onPositionChanged,
                  builder: (context, data) {
                    return ProgressBar(
                      progress: data.data ?? const Duration(seconds: 0),
                      total: Duration(
                          milliseconds: track?.durationMs ?? (1000 * 6 * 4)),
                      bufferedBarColor: const Color.fromARGB(97, 255, 134, 134),
                      baseBarColor: const Color.fromARGB(26, 79, 79, 79),
                      thumbColor: const Color.fromARGB(255, 252, 207, 207),
                      timeLabelTextStyle: const TextStyle(
                          color: Color.fromARGB(255, 255, 187, 187)),
                      progressBarColor: Colors.blue,
                      onSeek: (duration) {
                        player.seek(duration);
                      },
                    );
                  }),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          //! Track
          // track = await repository.getTrack(trackId: trackId);
          // setState(() {});
          // logger.d(track?.toJson());
          // String? ytUid = await repository.getYoutubeId(trackId: trackId);
          // logger.i(ytUid);
          // if (track == null) return;

          // String? downloadUrl =
          //     await repository.getDownloadUrl(trackId: track!.id);
          // if ((downloadUrl ?? '').isEmpty) return;
          // await player.play(UrlSource('$downloadUrl.mp3', mimeType: '.mp3'));
          // logger.i(downloadUrl);

          //! Playlist
          // playList = await repository.getPlaylist(playlistId: playlistId);
          // setState(() {});å
          // logger.d(playList?.tracks.items[1].track.toJson());
          // logger.w(playList?.tracks.items.length);

          // List<Track> playlistTracks =
          //     await repository.getAllPlaylistTracks(playlistId: playlistId);
          // logger.d(playlistTracks.first.toJson());
          // logger.w(playlistTracks.length);

          // List<Track> paginatedPlaylistTracks =
          //     await repository.getPlaylistTracksPaginated(
          //   playlistId: playlistId,
          //   limit: 1, // optional
          //   offset: 1, //optional
          // );
          // logger.d(paginatedPlaylistTracks.first.toJson());
          // logger.w(paginatedPlaylistTracks.length);

          //! Album
          // Album album = await repository.getAlbum(albumId: albumId);
          // logger.d(album.toJson());
          // logger.w(album.totalTracks);
          // logger.f(album.tracks.items.length);

          // List<Track> albumTracks =
          //     await repository.getAllAlbumTracks(albumId: albumId);
          // logger.d(albumTracks.first.toJson());
          // logger.w(albumTracks.length);

          // List<Track> paginatedPAlbumTracks =
          //     await repository.getAlbumTracksPaginated(
          //   albumId: albumId,
          //   // limit: 1, // optional
          //   offset: 0, //optional
          // );
          // logger.d(paginatedPAlbumTracks.first.toJson());
          // logger.w(paginatedPAlbumTracks.length);

          //! Artist
          // Artist artist = await repository.getArtist(artistId: artistId);
          // logger.d(artist.toJson());
          // logger.w(artist.images.length);
          // logger.f(artist.followers?.total);

          List<Album> artistAlbums =
              await repository.getAllArtistAlbums(artistId: artistId);
          logger.d(artistAlbums.first.toJson());
          logger.w(artistAlbums.length);

          // List<Album> paginatedArtistsAlbums =
          //     await repository.getArtistAlbumsPaginated(
          //   artistId: artistId,
          //   limit: 5, // optional
          //   offset: 0, //optional
          // );
          // logger.d(paginatedArtistsAlbums.first.toJson());
          // logger.w(paginatedArtistsAlbums.length);

          //! User
          // User user = await repository.getUser(userId: userId);
          // logger.d(user.toJson());
        },
      ),
    );
  }
}
