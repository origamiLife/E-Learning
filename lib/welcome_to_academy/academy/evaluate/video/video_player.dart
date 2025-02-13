import 'package:academy/welcome_to_academy/export.dart';
import 'package:academy/welcome_to_academy/export.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

import '../curriculum/curriculum.dart';

class NetworkVideoPlayer extends StatefulWidget {
  final String videoUrl;
  final Employee employee;
  final AcademyRespond academy;
  final String Authorization;
  final Topic topic;
  final String learning_seq;
  final String courseId;
  const NetworkVideoPlayer({
    Key? key,
    required this.videoUrl,
    required this.employee,
    required this.academy,
    required this.Authorization,
    required this.topic,
    required this.learning_seq,
    required this.courseId,
  }) : super(key: key);

  @override
  _NetworkVideoPlayerState createState() => _NetworkVideoPlayerState();
}

class _NetworkVideoPlayerState extends State<NetworkVideoPlayer> {
  late VideoPlayerController _videoPlayerController;
  int? _lastStopTime;
  final Duration _startTime = Duration(milliseconds: 5568); // 5.5686 วินาที
  Duration _currentPosition = Duration.zero;

  @override
  void initState() {
    super.initState();
    // กำหนด VideoPlayerController จาก URL ของวิดีโอ
    _videoPlayerController = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        // เมื่อคอนโทรลเลอร์พร้อมแล้ว ให้เริ่มเล่น
        setState(() {
          _videoPlayerController.play();
          _videoPlayerController.seekTo(_startTime);
        });
      });

    // เรียก API พร้อมข้อมูลเวลาที่ดูวิดีโอ
    // fetchStatus(videoViewedInMillisec);
    // เพิ่ม listener เพื่อติดตามสถานะของวิดีโอ
    _videoPlayerController.addListener(() {
      if (_videoPlayerController.value.isPlaying) {
        setState(() {
          // แปลงตำแหน่งปัจจุบันเป็นมิลลิวินาที
          _currentPosition = _videoPlayerController.value.position;
          final int videoViewedInMillisec = _currentPosition.inMilliseconds;
          print('Video at: $videoViewedInMillisec s');
        });
      }

      if (!_videoPlayerController.value.isPlaying &&
          (_lastStopTime != _videoPlayerController.value.position.inSeconds)) {
        _lastStopTime = _videoPlayerController.value.position.inSeconds ?? 0;
        final int videoViewedInMillisec = _currentPosition.inMilliseconds;
        fetchStatus(videoViewedInMillisec);
        print('Video stopped at: $_lastStopTime s');
      }
    });
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  void dispose() {
    // แปลงตำแหน่งปัจจุบันเป็นมิลลิวินาที
    final int videoViewedInMillisec = _currentPosition.inMilliseconds;

    // เรียก API พร้อมข้อมูลเวลาที่ดูวิดีโอ
    fetchStatus(videoViewedInMillisec);
    _videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      // canPop: true, // ป้องกันการออกจากหน้าก่อนเรียก fetchStatus()
      onPopInvoked: (didPop) async {
        if (!didPop) {
          final int videoViewedInMillisec = _currentPosition.inMilliseconds;
          fetchStatus(videoViewedInMillisec);
        }
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          foregroundColor: Colors.white,
          backgroundColor: Color(0xFFFF9900),
          title: Text(
            'Video Player',
            style: TextStyle(
              fontFamily: 'Arial',
              fontSize: 24,
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new), // ใช้ไอคอนย้อนกลับแบบ iOS
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: _videoPlayerController.value.isInitialized
            ? Stack(
                children: [
                  Stack(
                    children: [
                      Center(
                        child: AspectRatio(
                          aspectRatio: _videoPlayerController
                              .value.aspectRatio, // ✅ อัตราส่วนอัตโนมัติ
                          child: VideoPlayer(_videoPlayerController),
                        ),
                      ),
                      Positioned(
                        bottom: 20,
                        left: 20,
                        right: 20,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                IconButton(
                                  icon: Icon(
                                    _videoPlayerController.value.isPlaying
                                        ? Icons.pause
                                        : Icons.play_arrow,
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      if (_videoPlayerController
                                          .value.isPlaying) {
                                        _videoPlayerController
                                            .pause(); // ✅ หยุดวิดีโอ
                                      } else {
                                        _videoPlayerController
                                            .play(); // ✅ เล่นวิดีโอ
                                      }
                                    });
                                  },
                                ),
                                Expanded(
                                  child: Slider(
                                    value: _currentPosition.inMilliseconds
                                        .toDouble(),
                                    min: 0,
                                    max: _videoPlayerController
                                        .value.duration.inMilliseconds
                                        .toDouble(),
                                    activeColor: Colors.orange,
                                    inactiveColor: Colors.white54,
                                    onChanged: (value) {
                                      setState(() {
                                        _videoPlayerController.seekTo(Duration(
                                            milliseconds: value.toInt()));
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                            // แสดงเวลาเริ่มต้น / ความยาววิดีโอ
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  _formatDuration(_currentPosition),
                                  style: TextStyle(
                                      fontFamily: 'Arial',
                                      color: Colors.white,
                                      fontSize: 14),
                                ),
                                Text(
                                  _formatDuration(
                                      _videoPlayerController.value.duration),
                                  style: TextStyle(
                                      fontFamily: 'Arial',
                                      color: Colors.white,
                                      fontSize: 14),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  // Positioned(
                  //   bottom: 20,
                  //   right: 20,
                  //   child: Text(
                  //     'Current Position: ${_currentPosition.inSeconds}s',
                  //     style: const TextStyle(color: Colors.white),
                  //   ),
                  // ),
                ],
              )
            : Center(child: CircularProgressIndicator()),
      ),
    );
  }

  Future<void> fetchStatus(int videoViewedInMillisec) async {
    final int videoViewedInMillisec = _currentPosition.inMilliseconds;

    // ตัวอย่างการเรียก API กับเวลา
    final uri = Uri.parse("$host/api/origami/academy/save.php");
    final response = await http.post(
      uri,
      headers: {'Authorization': 'Bearer ${widget.Authorization}'},
      body: {
        'comp_id': widget.employee.comp_id,
        'emp_id': widget.employee.emp_id,
        'Authorization': widget.Authorization,
        'academy_id': widget.academy.academy_id,
        'academy_type': widget.academy.academy_type,
        'course_id': widget.courseId,
        'topic_id': widget.topic.topicId,
        'topic_no': widget.topic.topicNo,
        'topic_option': widget.topic.topicOption,
        'topic_item': widget.topic.topicItem,
        'learning_seq': widget.learning_seq,
        'video_viewed': '$videoViewedInMillisec', // ส่งเวลาเป็นมิลลิวินาที
        'video_duration': widget.topic.topicDuration,
      },
    );
    if (response.statusCode == 200) {
      try {
        final jsonResponse = json.decode(response.body);

        if (jsonResponse is List) {
          print('Status List: $jsonResponse');
        } else if (jsonResponse is Map<String, dynamic>) {
          print('Status Map: $jsonResponse');
        } else {
          print('Unexpected response type: ${jsonResponse.runtimeType}');
        }
      } catch (e) {
        print('JSON decode error: $e');
      }
    } else {
      print('Failed to load status data: ${response.statusCode}');
    }
  }
}
