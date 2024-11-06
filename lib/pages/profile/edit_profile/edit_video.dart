import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile/services/files_service.dart';
import 'package:mobile/theme/theme_text_style.dart';
import 'package:video_compress/video_compress.dart';
import 'package:video_player/video_player.dart';
import 'package:provider/provider.dart';
import 'package:mobile/pages/auth/providers/auth_session_provider.dart';

class EditVideoPage extends StatefulWidget {
  const EditVideoPage({super.key});

  @override
  _EditVideoPageState createState() => _EditVideoPageState();
}

class _EditVideoPageState extends State<EditVideoPage> {
  File? _videoFile;
  VideoPlayerController? _videoController;
  bool _isMuted = false;
  final ImagePicker _picker = ImagePicker();
  String? videoUrl;
  bool isLoading = true;
  bool isUploading = false;
  final FilesService filesService = FilesService();

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

  Future<void> _pickVideo() async {
    final XFile? pickedFile =
        await _picker.pickVideo(source: ImageSource.gallery);
    if (pickedFile != null) {
      final File videoFile = File(pickedFile.path);

      // Convertimos el video a .mp4
      final MediaInfo? compressedVideo = await VideoCompress.compressVideo(
        videoFile.path,
        quality: VideoQuality.MediumQuality,
        deleteOrigin: true,
      );

      if (compressedVideo != null) {
        setState(() {
          _videoFile = File(compressedVideo.path!);
        });
        _initializeVideoPlayer(file: _videoFile);
      } else {
        print("Error en la conversión de video.");
      }
    }
  }

  void _initializeVideoPlayer({File? file, String? url}) {
    _videoController?.dispose();
    if (file != null) {
      _videoController = VideoPlayerController.file(file)
        ..initialize().then((_) {
          setState(() {});
          _videoController?.play();
        });
    } else if (url != null) {
      _videoController = VideoPlayerController.networkUrl(Uri.parse(url))
        ..initialize().then((_) {
          setState(() {});
          _videoController?.play();
        });
    }
  }

  void _toggleMute() {
    setState(() {
      _isMuted = !_isMuted;
      _videoController?.setVolume(_isMuted ? 0 : 1);
    });
  }

  void _deleteVideo() {
    final authProvider =
        Provider.of<AuthSessionProvider>(context, listen: false);
    final userId = authProvider.user?.uid ?? '';
    if (videoUrl != null) {
      filesService.deleteIntroVideo(userId);
    }
    setState(() {
      _videoFile = null;
      videoUrl = null;
      _videoController?.dispose();
      _videoController = null;
    });
  }

  Future<void> _loadVideo() async {
    final authProvider =
        Provider.of<AuthSessionProvider>(context, listen: false);
    final userId = authProvider.user?.uid ?? '';
    final url = await filesService.getIntroVideo(userId);

    setState(() {
      videoUrl = url;
      isLoading = false;
    });

    if (videoUrl != null) {
      _initializeVideoPlayer(url: videoUrl);
    }
  }

  Future<void> _saveVideo(File videoFile) async {
    setState(() {
      isUploading = true;
    });

    final authProvider =
        Provider.of<AuthSessionProvider>(context, listen: false);
    final userId = authProvider.user?.uid ?? '';

    await filesService.uploadIntroVideo(
      userId: userId,
      videoFile: videoFile,
      onProgress: (progress) {
        // Actualizar UI con el progreso si es necesario
      },
      onComplete: (downloadUrl) {
        setState(() {
          videoUrl = downloadUrl;
          isUploading = false;
        });
      },
      onError: (errorMessage) {
        setState(() {
          isUploading = false;
        });
        print("Error al subir video: $errorMessage");
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
            onPressed: () async {
              if (_videoFile != null) {
                await _saveVideo(_videoFile!);
              }
              Navigator.pop(context, true);
            },
          ),
        ],
      ),
      body: isLoading || isUploading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 48),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Editar Video Introductorio',
                      style: TextStyle(fontSize: 24),
                      textAlign: TextAlign.left,
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Cargá un video en el que te presentes y cuentes sobre vos.\nNo puede superar el minuto.',
                      style: ThemeTextStyle.titleInfoSmallOutline(context),
                      textAlign: TextAlign.left,
                    ),
                    SizedBox(height: 20),
                    if (_videoController != null &&
                        _videoController!.value.isInitialized)
                      FractionallySizedBox(
                        widthFactor: 0.7,
                        child: AspectRatio(
                          aspectRatio: _videoController!.value.aspectRatio,
                          child: Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              VideoPlayer(_videoController!),
                              IconButton(
                                icon: Icon(_isMuted
                                    ? Icons.volume_off
                                    : Icons.volume_up),
                                color: Colors.white,
                                onPressed: _toggleMute,
                              ),
                            ],
                          ),
                        ),
                      )
                    else if (_videoController != null)
                      Center(
                        child: CircularProgressIndicator(),
                      )
                    else
                      Center(
                        child: Text("No hay video cargado"),
                      ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton.icon(
                          onPressed: _pickVideo,
                          icon: Icon(Icons.upload),
                          label: Text("Cargar"),
                        ),
                        ElevatedButton.icon(
                          onPressed: _videoFile != null || videoUrl != null
                              ? _deleteVideo
                              : null,
                          icon: Icon(Icons.delete),
                          label: Text("Eliminar"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
