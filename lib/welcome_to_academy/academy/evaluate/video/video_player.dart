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
  final  String courseId;
  const NetworkVideoPlayer({
    Key? key,
    required this.videoUrl,
    required this.employee,
    required this.academy,
    required this.Authorization, required this.topic, required this.learning_seq, required this.courseId,
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

    // เพิ่ม listener เพื่อติดตามสถานะของวิดีโอ
    _videoPlayerController.addListener(() {
      if (_videoPlayerController.value.isPlaying) {
        setState(() {
          _currentPosition = _videoPlayerController.value.position;
        });
      }

      if (!_videoPlayerController.value.isPlaying &&
          (_lastStopTime != _videoPlayerController.value.position?.inSeconds)) {
        _lastStopTime = _videoPlayerController.value.position?.inSeconds ?? 0;
        print('Video stopped at: $_lastStopTime');
      }
    });
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          foregroundColor: Colors.white,
          backgroundColor: Color(0xFFFF9900),
          title: Text(
            'Video',
            style: TextStyle(fontFamily: 'Arial',
              fontSize: 24,
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      body: _videoPlayerController.value.isInitialized
          ? Stack(
        children: [
          Center(
            child: VideoPlayer(_videoPlayerController), // แสดง VideoPlayer
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: Text(
              'Current Position: ${_currentPosition.inSeconds}s',
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      )
          : Center(
        child: CircularProgressIndicator(),
      ),
      );
  }


  Future<void> fetchStatus() async {
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
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      final List<dynamic> dataJson = jsonResponse['status'];
      print('status $dataJson');
    } else {
      throw Exception('Failed to load status data');
    }
  }
}
