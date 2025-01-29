import 'package:academy/welcome_to_academy/export.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

// class YouTubePlayerWidget extends StatefulWidget {
//   final String videoId;
//   final Employee employee;
//   final AcademyRespond academy;
//   final String Function(String) videoView;
//   final String Authorization;
//   const YouTubePlayerWidget(
//       {Key? key,
//       required this.videoId,
//       required this.employee,
//       required this.academy,
//       required this.videoView, required this.Authorization})
//       : super(key: key);
//
//   @override
//   _YouTubePlayerWidgetState createState() => _YouTubePlayerWidgetState();
// }
//
// class _YouTubePlayerWidgetState extends State<YouTubePlayerWidget> {
//   // late YoutubePlayerController _controller;
//   int? _lastStopTime;
//   final Duration _startTime =
//       Duration(seconds: 70); // Start Time เริ่มวินาทีที่ 10
//   Duration _currentPosition =
//       Duration.zero; // Variable to store current position
//
//   @override
//   void initState() {
//     super.initState();
//     // _controller = YoutubePlayerController(
//     //   initialVideoId: widget.videoId,
//     //   flags: YoutubePlayerFlags(
//     //     autoPlay: false,
//     //     mute: false,
//     //   ),
//     // );
//
//     //  // Listen to player state changes to update the current time
//     // _controller.addListener(() {
//     //   if (_controller.value.isPlaying && _controller.value.isReady) {
//     //     setState(() {
//     //       _currentPosition = _controller.value.position;
//     //     });
//     //   }
//     //
//     //   // Save the stop time when video is paused or stopped
//     //   if (!_controller.value.isPlaying) {
//     //     _lastStopTime = _controller.value.position.inSeconds;
//     //     // Save StopTime
//     //     widget.videoView(_lastStopTime.toString());
//     //     print('Video stopped at: $_lastStopTime');
//     //   }
//     // });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         backgroundColor: Colors.black,
//         appBar: AppBar(
//           backgroundColor: Colors.black,
//           title: Text('YouTube Player',
//             style: TextStyle(fontFamily: 'Arial',
//               color: Colors.white,
//             ),),
//           leading: IconButton(
//             icon: Icon(Icons.arrow_back_ios_new_sharp,color: Colors.white,),
//             onPressed: () {
//               // Navigator.pushReplacement(
//               //   context,
//               //   MaterialPageRoute(
//               //       builder: (context) => EvaluateModule(
//               //           employee: widget.employee,
//               //           academy: widget.academy,
//               //           selectedPage: 1)),
//               // );
//               Navigator.pop(context);
//             },
//           ),
//         ),
//         body: Scaffold(
//           body: Container(
//             color: Colors.black,
//             child: Center(
//               child: Text('YOUTUBE',
//                 style: TextStyle(fontFamily: 'Arial',
//                   color: Colors.white,
//                 ),)
//               // YoutubePlayerBuilder(
//               //   player: YoutubePlayer(
//               //     controller: _controller,
//               //     showVideoProgressIndicator: true,
//               //     // aspectRatio : 1 / 1,
//               //     onReady: () {
//               //       print('Player is ready.');
//               //       // Seek to the start time when the player is ready
//               //       _controller.seekTo(_startTime);
//               //     },
//               //   ),
//               //   builder: (context, player) {
//               //     return SafeArea(
//               //       child: Container(
//               //         color: Colors.black,
//               //         width: double.infinity,
//               //         child: player,
//               //       ),
//               //     );
//               //   },
//               // ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   @override
//   void dispose() {
//     // _controller.dispose();
//     super.dispose();
//   }
// }

import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../curriculum/curriculum.dart';

class YouTubePlayerWidget extends StatefulWidget {
  final String videoId;
  final Employee employee;
  final AcademyRespond academy;
  final String Authorization;
  final Topic topic;
  final String learning_seq;
  final String courseId;

  const YouTubePlayerWidget({
    Key? key,
    required this.videoId,
    required this.employee,
    required this.academy,
    required this.Authorization,
    required this.topic,
    required this.learning_seq,
    required this.courseId,
  }) : super(key: key);

  @override
  _YouTubePlayerWidgetState createState() => _YouTubePlayerWidgetState();
}

class _YouTubePlayerWidgetState extends State<YouTubePlayerWidget> {
  late YoutubePlayerController _controller;
  int? _lastStopTime;
  final Duration _startTime = Duration(milliseconds: 5568); // เปลี่ยนเป็น 5568 มิลลิวินาที (5.5686 วินาที)
  Duration _currentPosition = Duration.zero;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: widget.videoId,
      flags: YoutubePlayerFlags(autoPlay: true, mute: false),
    );

    // เพิ่ม listener เพื่อติดตามสถานะของวิดีโอ
    _controller.addListener(() {
      if (_controller.value.isPlaying && _controller.value.isReady) {
        setState(() {
          _currentPosition = _controller.value.position;
        });
      }

      if (!_controller.value.isPlaying &&
          (_lastStopTime != _controller.value.position?.inSeconds)) {
        _lastStopTime = _controller.value.position?.inSeconds ?? 0;
        print('Video stopped at: $_lastStopTime');
      }
    });
  }

  @override
  void dispose() {
    // แปลงตำแหน่งปัจจุบันเป็นมิลลิวินาที
    final int videoViewedInMillisec = _currentPosition.inMilliseconds;

    // เรียก API พร้อมข้อมูลเวลาที่ดูวิดีโอ
    fetchStatus(videoViewedInMillisec);
    
    _controller.dispose();
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
          'Youtube Player',
          style: TextStyle(
            fontFamily: 'Arial',
            fontSize: 24,
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: YoutubePlayerBuilder(
        player: YoutubePlayer(
          controller: _controller,
          showVideoProgressIndicator: true,
          onReady: () {
            print('Player is ready.');
            if (_lastStopTime != null) {
              _controller.seekTo(Duration(seconds: _lastStopTime!));
            } else {
              _controller.seekTo(_startTime); // เริ่มต้นที่ 5.5686 วินาที
            }
          },
        ),
        builder: (context, player) {
          return Stack(
            children: [
              Center(child: player),
              Positioned(
                bottom: 20,
                right: 20,
                child: Text(
                  'Current Position: ${_currentPosition.inSeconds}s',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> fetchStatus(int videoViewed) async {
    try {
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
          'video_viewed': videoViewed.toString(), // ส่งเวลาในมิลลิวินาที
          'video_duration': widget.topic.topicDuration,
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        print('Status: $jsonResponse');
      } else {
        print('Failed to save status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred while saving status: $e');
    }
  }

}


