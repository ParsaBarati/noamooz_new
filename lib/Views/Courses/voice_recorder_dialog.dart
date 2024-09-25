import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:noamooz/Utils/color_utils.dart';
import 'package:noamooz/Utils/widget_utils.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../Plugins/get/get.dart';

class VoiceRecorderDialog extends StatefulWidget {
  @override
  _VoiceRecorderDialogState createState() => _VoiceRecorderDialogState();
}

class _VoiceRecorderDialogState extends State<VoiceRecorderDialog> {
  FlutterSoundRecorder? _recorder;
  FlutterSoundPlayer? _player;
  String? _recordedFilePath;
  bool _isRecording = false;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _initializeAudio();
  }

  Future<void> _initializeAudio() async {
    _recorder = await FlutterSoundRecorder().openRecorder();
    _player = await FlutterSoundPlayer().openPlayer();
  }

  Future<void> _startRecording() async {
    try {
      PermissionStatus status = await Permission.microphone.request();
      if (status != PermissionStatus.granted) {
        throw RecordingPermissionException("Microphone permission not granted");
      }

      Directory appDocDirectory = await getApplicationDocumentsDirectory();
      String recordingPath =
          '${appDocDirectory.path}/recording_${DateTime.now().millisecondsSinceEpoch}.aac';
      await _recorder?.startRecorder(
        toFile: recordingPath,
        codec: Codec.aacADTS,
      );
      setState(() {
        _isRecording = true;
        _recordedFilePath = recordingPath;
      });
    } catch (e) {
      print("Error starting recording: $e");
    }
  }

  Future<void> _stopRecording() async {
    try {
      await _recorder?.stopRecorder();
      setState(() {
        _isRecording = false;
      });
    } catch (e) {
      print("Error stopping recording: $e");
    }
  }

  Future<void> _playRecording() async {
    try {
      await _player?.startPlayer(
          fromURI: _recordedFilePath,
          whenFinished: () {
            setState(() {
              _isPlaying = false;
            });
          });
      setState(() {
        _isPlaying = true;
      });
    } catch (e) {
      print("Error playing recording: $e");
    }
  }

  Future<void> _stopPlaying() async {
    try {
      await _player?.stopPlayer();
      setState(() {
        _isPlaying = false;
      });
    } catch (e) {
      print("Error stopping playback: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      contentPadding: const EdgeInsets.all(8),
      titlePadding: const EdgeInsets.all(12),
      title: const Text(
        'ضبط نظر صوتی',
        style: TextStyle(
          fontSize: 16,
          letterSpacing: 0,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: Icon(
                  Icons.fiber_manual_record,
                  color: _isRecording ? ColorUtils.red.withOpacity(0.5) : ColorUtils.red,
                ),
                onPressed: _isRecording ? null : _startRecording,
              ),
              IconButton(
                icon: Icon(
                  Icons.stop,
                  color: !_isRecording
                      ? ColorUtils.gray.withOpacity(0.5)
                      : ColorUtils.black,
                ),
                onPressed: _isRecording ? _stopRecording : null,
              ),
              IconButton(
                icon: Icon(
                  _isPlaying ? Icons.pause : Icons.play_arrow,
                  color: _isRecording || _recordedFilePath == null
                      ? ColorUtils.gray.withOpacity(0.5)
                      : ColorUtils.black,
                ),
                onPressed: _isRecording || _recordedFilePath == null
                    ? null
                    : _isPlaying
                        ? _stopPlaying
                        : _playRecording,
              ),
            ],
          ),
        ],
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            GestureDetector(
              onTap: () {
                _recorder?.closeRecorder();
                _player?.closePlayer();
                Get.back();
              },
              child: Text(
                "انصراف",
                style: TextStyle(
                  color: ColorUtils.gray,
                  fontSize: 14,
                ),
              ),
            ),
            const SizedBox(
              width: 18,
            ),
            WidgetUtils.softButton(
              title: "تایید",
              onTap: (){
                Get.back(result: _recordedFilePath);
              }
            ),
          ],
        ),
      ],
    );
  }

  @override
  void dispose() {
    _recorder?.closeRecorder();
    _player?.closePlayer();
    super.dispose();
  }
}
