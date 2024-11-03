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
  bool _isPlaying = false;

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

  void _togglePlayPause() {
    if (_isPlaying) {
      _videoController?.pause();
    } else {
      _videoController?.play();
    }
    setState(() {
      _isPlaying = !_isPlaying;
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
          _videoController?.addListener(_onVideoEnded);
        });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _onVideoEnded() {
    if (_videoController!.value.position == _videoController!.value.duration) {
      setState(() {
        _isPlaying = false;
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
                    alignment: Alignment.center,
                    children: [
                      VideoPlayer(_videoController!),
                      if (!_isPlaying)
                        IconButton(
                          icon: Icon(Icons.play_arrow,
                              size: 48, color: Colors.white),
                          onPressed: _togglePlayPause,
                        ),
                      Positioned(
                        bottom: 8,
                        right: 8,
                        child: IconButton(
                          icon: Icon(
                            _isMuted ? Icons.volume_off : Icons.volume_up,
                            color: Colors.white,
                          ),
                          onPressed: _toggleMute,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : SizedBox.shrink();
  }
}
