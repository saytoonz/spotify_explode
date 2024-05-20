import 'di.dart';
import 'entities/track.dart';
import 'entities/playlist.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
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
    return MaterialApp(
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
  // https://open.spotify.com/track/6O5A41opiGbG2PphOnzZ6b
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
                      bufferedBarColor: Color.fromARGB(97, 255, 134, 134),
                      baseBarColor: const Color.fromARGB(26, 79, 79, 79),
                      thumbColor: Color.fromARGB(255, 252, 207, 207),
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
          logger.d(trackId);
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
          // return;

          // playList = await repository.getPlaylist(playlistId: playlistId);
          // logger.d(playList?.tracks.items[1].track.toJson());
          // logger.w(playList?.tracks.items.length);

          // List<Track> playlistTracks =
          //     await repository.getAllPlaylistTracks(playlistId: playlistId);
          // logger.d(playlistTracks.first.toJson());
          // logger.w(playlistTracks.length);

          List<Track> paginatedPlaylistTracks =
              await repository.getPlaylistTracksPaginated(
            playlistId: playlistId,
            limit: 1, // optional
            offset: 1, //optional
          );
          logger.d(paginatedPlaylistTracks.first.toJson());
          logger.w(paginatedPlaylistTracks.length);

          setState(() {});
        },
      ),
    );
  }
}
