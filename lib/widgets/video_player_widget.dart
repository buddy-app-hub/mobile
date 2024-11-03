import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:mobile/services/files_service.dart';

class VideoPlayerWidget extends StatefulWidget {
  final String userId;

  const VideoPlayerWidget({Key? key, required this.userId}) : super(key: key);

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();

  static Widget buildIntroVideo(BuildContext context, String userId) {
    return VideoPlayerWidget(userId: userId);
  }
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  VideoPlayerController? _videoController;
  bool isLoading = true;
  bool _isMuted = false;

  @override
  void initState() {
    super.initState();
    _loadVideo();
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  void _toggleMute() {
    setState(() {
      _isMuted = !_isMuted;
      _videoController?.setVolume(_isMuted ? 0 : 1);
    });
  }

  Future<void> _loadVideo() async {
    final filesService = FilesService();
    final videoUrl = await filesService.getIntroVideo(widget.userId);

    if (videoUrl != null) {
      _videoController = VideoPlayerController.networkUrl(Uri.parse(videoUrl))
        ..initialize().then((_) {
          setState(() {
            isLoading = false;
          });
          _videoController?.play();
        });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(child: CircularProgressIndicator())
        : _videoController != null && _videoController!.value.isInitialized
            ? FractionallySizedBox(
                widthFactor: 0.5,
                child: AspectRatio(
                  aspectRatio: _videoController!.value.aspectRatio,
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      VideoPlayer(_videoController!),
                      IconButton(
                        icon:
                            Icon(_isMuted ? Icons.volume_off : Icons.volume_up),
                        color: Colors.white,
                        onPressed: _toggleMute,
                      ),
                    ],
                  ),
                ))
            : SizedBox.shrink();
  }
}
