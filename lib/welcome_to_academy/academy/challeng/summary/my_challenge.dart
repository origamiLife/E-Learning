import 'package:academy/welcome_to_academy/export.dart';
import '../challenge_start.dart';
import '../challenge_test.dart';
import 'finished_challenge.dart';
import 'package:http/http.dart' as http;

import 'finished_choice_challenge.dart';

class MyChallenge extends StatefulWidget {
  MyChallenge({
    super.key,
    required this.employee,
    required this.Authorization,
    required this.duration,
    required this.total_point,
    required this.time_used,
    required this.topChallenge,
    required this.challengeData,
    required this.total_point_all,
    required this.challenge,
    required this.questionList,
    required this.isQuestion,
  });
  final Employee employee;
  final String Authorization;
  final String duration;
  final String total_point;
  final String time_used;
  final TopChallenge topChallenge;
  final ChallengeData challengeData;
  final String total_point_all;
  final GetChallenge challenge;
  final List<String> questionList;
  final List<CheckAllChallenge> isQuestion;
  @override
  _MyChallengeState createState() => _MyChallengeState();
}

class _MyChallengeState extends State<MyChallenge> {
  TopChallenge? topChallenge;
  ChallengeData? challengeData;
  String total_point = '0';
  String time_used = '0';

  @override
  void initState() {
    super.initState();
    topChallenge = widget.topChallenge;
    challengeData = widget.challengeData;
    total_point = widget.total_point;
    time_used = widget.time_used;
    totalMinu();
  }

  double convertTimeToMinutes(String timeUsed) {
    List<String> parts = timeUsed.split(":"); // แยกเป็น ["23", "11", "31"]
    double hours = double.parse(parts[0]);
    double minutes = double.parse(parts[1]);
    double seconds = double.parse(parts[2]);

    return (hours * 60) + minutes + (seconds / 60); // รวมวินาทีเป็นทศนิยม
  }

  double totalMinutes = 0;
  void totalMinu() {
    String timeUsed = time_used;
    double totalMinutes = convertTimeToMinutes(timeUsed);
    print("Total Minutes: $totalMinutes"); // 1391.51666 นาที
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(child: _summary()),
              SizedBox(height: 24),
              Column(
                children: [
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amberAccent),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          Top_Challenge ?? '',
                          style: const TextStyle(
                            fontFamily: 'Arial',
                            fontSize: 16,
                            color: Color(0xFF555555),
                            fontWeight: FontWeight.w500,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: EdgeInsets.only(top: 4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Colors.grey.shade300,
                        width: 1,
                      ),
                    ),
                    child: SizedBox(
                      height:
                          (topChallenge?.topUsers.length ?? 0) > 4 ? 200 : null,
                      child: SingleChildScrollView(
                        child: ListView.builder(
                          shrinkWrap: true, // ป้องกัน overflow
                          physics:
                              const NeverScrollableScrollPhysics(), // ปิดการ scroll ซ้อนกับ main ListView
                          itemCount: topChallenge?.topUsers.length ?? 0,
                          itemBuilder: (context, index) {
                            final topUsers = topChallenge?.topUsers[index];

                            return Container(
                              margin: const EdgeInsets.symmetric(
                                  vertical: 4, horizontal: 8),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF1F7F0),
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(
                                    color: const Color(0xFF555555), width: 1),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: DataTable(
                                    columnSpacing: 24,
                                    horizontalMargin: 0,
                                    headingRowHeight: 40,
                                    dataRowHeight: 40,
                                    columns: <DataColumn>[
                                      _buildDataColumn('#'),
                                      DataColumn(
                                        label: SizedBox(
                                          width: 150,
                                          child: Text(
                                            examiner,
                                            style: const TextStyle(
                                              fontFamily: 'Arial',
                                              fontSize: 16,
                                              color: Color(0xFF555555),
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ),
                                      ),
                                      _buildDataColumn(correctAnswer),
                                      _buildDataColumn(timeUsed),
                                    ],
                                    rows: [
                                      DataRow(
                                        cells: [
                                          DataCell(
                                              Text((index + 1).toString())),
                                          DataCell(ConstrainedBox(
                                            constraints: const BoxConstraints(
                                                maxWidth: 150),
                                            child: SingleChildScrollView(
                                              scrollDirection: Axis.horizontal,
                                              child: Row(
                                                children: [
                                                  (topUsers?.avatar == "")
                                                      ? Image.network(
                                                          'https://dev.origami.life/uploads/employee/20140715173028man20key.png?v=1738820588',
                                                          height: 24,
                                                          fit: BoxFit.contain,
                                                        )
                                                      : Image.network(
                                                          topUsers?.avatar ??
                                                              '',
                                                          height: 24,
                                                          fit: BoxFit.contain,
                                                          errorBuilder:
                                                              (context, error,
                                                                  stackTrace) {
                                                            return Icon(null);
                                                          },
                                                        ),
                                                  const SizedBox(width: 4),
                                                  Text(
                                                    '${topUsers?.firstname ?? ''} ${topUsers?.lastname ?? ''}',
                                                    style: const TextStyle(
                                                      fontFamily: 'Arial',
                                                      fontSize: 16,
                                                      color: Color(0xFF555555),
                                                      fontWeight:
                                                          FontWeight.w300,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )),
                                          DataCell(Center(
                                            child: Text(
                                              topUsers?.point?.toString() ??
                                                  '0',
                                              style: const TextStyle(
                                                fontFamily: 'Arial',
                                                fontSize: 16,
                                                color: Color(0xFF555555),
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          )),
                                          DataCell(Center(
                                            child: Text(
                                              topUsers?.time_used ?? '0s',
                                              style: const TextStyle(
                                                fontFamily: 'Arial',
                                                fontSize: 16,
                                                color: Color(0xFF555555),
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          )),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              _timeStatus(),
              // SizedBox(height: 16),
              // SizedBox(
              //   width: double.infinity,
              //   child: ElevatedButton(
              //     style: ElevatedButton.styleFrom(
              //       padding: const EdgeInsets.all(1),
              //       foregroundColor: Colors.red,
              //       backgroundColor: Colors.red,
              //       shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(10),
              //       ),
              //     ),
              //     onPressed: () {
              //       Navigator.pop(context);
              //     },
              //     child: Padding(
              //       padding: const EdgeInsets.only(
              //           left: 60, right: 60, bottom: 12, top: 12),
              //       child: Text(
              //         RequestCA,
              //         style: TextStyle(
              //           fontFamily: 'Arial',
              //           color: Colors.white,
              //           fontSize: 18,
              //           fontWeight: FontWeight.w700,
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
              SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  DataColumn _buildDataColumn(String label) {
    return DataColumn(
      label: Text(
        label,
        style: const TextStyle(
          fontFamily: 'Arial',
          fontSize: 16,
          color: Color(0xFF555555),
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _summary() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 0,
            blurRadius: 2,
            offset: Offset(0, 3), // x, y
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _myChallenge(),
          ],
        ),
      ),
    );
  }

  Widget _myChallenge() {
    return FutureBuilder<List<HistoryChallenge>>(
      future: fetchHistoryChallenge(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(color: Color(0xFFFF9900)),
                SizedBox(height: 12),
                Text(
                  'Loading...',
                  style: TextStyle(
                    fontFamily: 'Arial',
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF555555),
                  ),
                ),
              ],
            ),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error, color: Colors.red, size: 24),
                const SizedBox(height: 12),
                Text(
                  'Error: ${snapshot.error}',
                  style: const TextStyle(
                    fontFamily: 'Arial',
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          );
        } else if (snapshot.hasData) {
          final data = snapshot.data!;
          return Column(
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _question('$correctAnswer :'),
                            _question('$score :'),
                            _question('$timeUsed :'),
                            _question('$startChallenge :'),
                            _question('$finishedChallenge :'),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _question('${data.first.correct}'),
                        _question('${data.first.used_point}'),
                        _question('${data.first.challenge_duration}'),
                        _question('${data.first.challenge_start}'),
                        _question('${data.first.challenge_end}'),
                      ],
                    ),
                  ),
                ],
              ),
              Divider(),
              Container(
                height: (isAndroid || isIPhone) ? (40 * 2) + 16 : (80 * 2) + 16, // สูงพอสำหรับ 2 แถว + ระยะห่าง
                child: SingleChildScrollView(
                  child: Wrap(
                    spacing: (isAndroid || isIPhone) ? 8 : 16,
                    runSpacing: (isAndroid || isIPhone) ? 8 : 16,
                    children: List.generate(widget.isQuestion.length, (index) {
                      final dataQ = widget.isQuestion[index];
                      Color cardColor;
                      if (dataQ.question_status == 'Y') {
                        cardColor = Color(0xFF00C789);
                      } else if (dataQ.question_status == 'N') {
                        cardColor = Color(0xFFEE546C);
                      } else {
                        cardColor = Color(0xFFC0C4CC);
                      }
                      return InkWell(
                        onTap: () {
                          _showDialog(widget.isQuestion);
                        },
                        child: Container(
                          height: (isAndroid || isIPhone) ? 40 : 80,
                          width: (isAndroid || isIPhone) ? 40 : 80,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: cardColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '${index + 1}',
                            style: TextStyle(
                              fontFamily: 'Arial',
                              fontSize: (isAndroid || isIPhone) ? 16 : 20,
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ),
            ],
          );
        } else {
          return const Center(
            child: Text(
              'No data available.',
              style: TextStyle(
                fontFamily: 'Arial',
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Color(0xFF555555),
              ),
            ),
          );
        }
      },
    );
  }

  void _showDialog(List<CheckAllChallenge> isQuestion) {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext dialogContext) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.black54,
            ),
            child: AlertDialog(
              contentPadding: EdgeInsets.zero, // ลบ Padding ด้านใน
              content: Stack(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 16, right: 16, top: 8, bottom: 16),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "YOU ARE VIEWING CHALLENGE SECTION",
                              style: TextStyle(
                                fontFamily: 'Arial',
                                fontSize: (isAndroid || isIPhone) ? 20 : 30,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF555555),
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 16),
                            Text(
                              "$question: ${isQuestion.length}",
                              style: TextStyle(
                                fontFamily: 'Arial',
                                fontSize: (isAndroid || isIPhone) ? 16 : 24,
                                color: Color(0xFF555555),
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 22),
                            ConstrainedBox(
                              constraints: BoxConstraints(
                                maxWidth:
                                    MediaQuery.of(context).size.width * 0.8,
                              ),
                              child: Wrap(
                                  spacing: (isAndroid || isIPhone) ? 8 : 16,
                                  runSpacing: (isAndroid || isIPhone) ? 8 : 16,
                                  children:
                                      List.generate(isQuestion.length, (index) {
                                    final dataQ = isQuestion[index];
                                    Color cardColor;
                                    if (dataQ.question_status == 'Y') {
                                      cardColor = Color(0xFF00C789);
                                    } else if (dataQ.question_status == 'N') {
                                      cardColor = Color(0xFFEE546C);
                                    } else {
                                      cardColor = Color(0xFFC0C4CC);
                                    }
                                    return InkWell(
                                      onTap: () {
                                        String question_no =
                                            widget.questionList[index];
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                FinishedChoiceChallenge(
                                              employee: widget.employee,
                                              Authorization:
                                                  widget.Authorization,
                                              duration: widget.duration,
                                              total_point: widget.total_point,
                                              time_used: widget.time_used,
                                              topChallenge: widget.topChallenge,
                                              challengeData:
                                                  widget.challengeData,
                                              total_point_all:
                                                  widget.total_point_all,
                                              challenge: widget.challenge,
                                              questionList: widget.questionList,
                                              isQuestion: widget.isQuestion,
                                              question_no: question_no,
                                              Qno: (index + 1).toString(),
                                            ),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        height:
                                            (isAndroid || isIPhone) ? 40 : 80,
                                        width:
                                            (isAndroid || isIPhone) ? 40 : 80,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          color: cardColor,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Text(
                                          '${index + 1}',
                                          style: TextStyle(
                                            fontFamily: 'Arial',
                                            fontSize: (isAndroid || isIPhone)
                                                ? 16
                                                : 20,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w700,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                        ),
                                      ),
                                    );
                                  })),
                            ),
                            SizedBox(height: 22),
                            // about => status
                            Divider(),
                            Row(
                              children: [
                                Expanded(
                                  child: Row(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(8),
                                        color: Color(0xFF00C789),
                                      ),
                                      SizedBox(width: 8),
                                      Flexible(
                                        child: Text(
                                          '$correct',
                                          style: TextStyle(
                                            fontFamily: 'Arial',
                                            fontSize: (isAndroid || isIPhone)
                                                ? 14
                                                : 20,
                                            color: Color(0xFF555555),
                                            fontWeight: FontWeight.w700,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Row(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(8),
                                        color: Color(0xFFEE546C),
                                      ),
                                      SizedBox(width: 8),
                                      Flexible(
                                        child: Text(
                                          '$incorrect',
                                          style: TextStyle(
                                            fontFamily: 'Arial',
                                            fontSize: (isAndroid || isIPhone)
                                                ? 14
                                                : 20,
                                            color: Color(0xFF555555),
                                            fontWeight: FontWeight.w700,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Row(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(8),
                                        color: Color(0xFFC0C4CC),
                                      ),
                                      SizedBox(width: 8),
                                      Flexible(
                                        child: Text(
                                          'No Result',
                                          style: TextStyle(
                                            fontFamily: 'Arial',
                                            fontSize: (isAndroid || isIPhone)
                                                ? 14
                                                : 20,
                                            color: Color(0xFF555555),
                                            fontWeight: FontWeight.w700,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: InkWell(
                        onTap: () {
                          Navigator.pop(dialogContext);
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(right: 4, top: 4),
                          child: Icon(
                            Icons.clear,
                            size: (isAndroid || isIPhone) ? 22 : 45,
                            color: Colors.red,
                          ),
                        )),
                  ),
                ],
              ),
            ),
          );
        });
  }

  Widget _question(String text) {
    return Column(
      children: [
        Text(
          text,
          style: TextStyle(
            fontFamily: 'Arial',
            fontSize: 16,
            color: Color(0xFF555555),
            fontWeight: FontWeight.w500,
          ),
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
        ),
        SizedBox(height: 8),
      ],
    );
  }

  Widget _timeStatus() {
    // String timeString = "00:02:39"; // time_used
    List<String> timeParts = time_used.split(":");
    int hours = int.parse(timeParts[0]);
    int minutes = int.parse(timeParts[1]);
    int seconds = int.parse(timeParts[2]);

    double duration = double.parse(challengeData?.challenge_duration ?? '');

    double totalSeconds = hours * 3600 + minutes * 60 + seconds.toDouble();
    print(totalSeconds);
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 0,
            blurRadius: 2,
            offset: Offset(0, 3), // x, y
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              timeStatus,
              style: TextStyle(
                fontFamily: 'Arial',
                fontSize: 16,
                color: Color(0xFF555555),
                fontWeight: FontWeight.w500,
              ),
            ),
            Divider(),
            SizedBox(height: 12),
            Text(
              time_used,
              style: TextStyle(
                fontFamily: 'Arial',
                fontSize: 32,
                color: Colors.green,
                fontWeight: FontWeight.w500,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Stack(
                  children: [
                    // Background LinearProgressIndicator (สีเทา)
                    LinearProgressIndicator(
                      value: duration * 60, // ใช้เพื่อแสดงพื้นหลังสีเทาเต็ม
                      backgroundColor: Colors.grey.shade300,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Colors.grey.shade300),
                      minHeight: 10,
                    ),
                    // Foreground LinearProgressIndicator (ใช้ ShaderMask สำหรับไล่ระดับสี)
                    ShaderMask(
                      shaderCallback: (bounds) => LinearGradient(
                        colors: [Colors.red, Colors.amber, Colors.green],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ).createShader(bounds),
                      child: LinearProgressIndicator(
                        value: ((duration * 60) - totalSeconds) /
                            (duration * 60), // ค่าความคืบหน้า
                        backgroundColor: Colors.transparent,
                        valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white), // สีไม่เกี่ยวเพราะใช้ ShaderMask
                        minHeight: 10,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 12),
            Text(
              '$examDuration: ${widget.duration}',
              style: TextStyle(
                fontFamily: 'Arial',
                fontSize: 16,
                color: Color(0xFF555555),
                fontWeight: FontWeight.w300,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<List<HistoryChallenge>> fetchHistoryChallenge() async {
    final uri = Uri.parse("$host/api/origami/challenge/history-challenge.php");
    try {
      final response = await http.post(
        uri,
        headers: {'Authorization': 'Bearer ${widget.Authorization}'},
        body: {
          'comp_id': widget.employee.comp_id,
          'emp_id': widget.employee.emp_id,
          'challenge_id': widget.challenge.challenge_id,
        },
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        final List<dynamic> challengeJson = jsonResponse['challenge_data'];
        return challengeJson
            .map((json) => HistoryChallenge.fromJson(json))
            .toList();
      } else {
        throw Exception(
            'Failed to load question data, status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching question data: $e');
      throw Exception('Error fetching question data: $e');
    }
  }
}

// Column(
//     children: List.generate(
//         topChallenge?.topUsers.length ?? 0, (index) {
//   final topUsers = topChallenge!.topUsers[index];
//   return SingleChildScrollView(
//     scrollDirection: Axis.horizontal,
//     child: Padding(
//       padding: const EdgeInsets.all(16),
//       child: Row(
//         children: [
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 '',
//                 style: GoogleFonts.sansita(
//                   fontSize: 16,
//                   color: Color(0xFF555555),
//                   fontWeight: FontWeight.w500,
//                 ),
//                 overflow: TextOverflow.ellipsis,
//                 maxLines: 2,
//               ),
//               Divider(),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 children: [
//                   Text(
//                     (index + 1).toString(),
//                     style: TextStyle(
//                       fontFamily: 'Arial',
//                       fontSize: 16,
//                       color: Color(0xFF555555),
//                       fontWeight: FontWeight.w300,
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//           SizedBox(width: 24),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 examiner,
//                 style: TextStyle(
//                   fontFamily: 'Arial',
//                   fontSize: 16,
//                   color: Color(0xFF555555),
//                   fontWeight: FontWeight.w500,
//                 ),
//                 overflow: TextOverflow.ellipsis,
//                 maxLines: 2,
//               ),
//               Divider(),
//               Row(
//                 children: [
//                   Image.network(
//                     // topUsers.avatar,
//                     'https://dev.origami.life/uploads/employee/20140715173028man20key.png?v=1738646244',
//                     height: 24,
//                     fit: BoxFit.contain,
//                   ),
//                   SizedBox(width: 4),
//                   Text(
//                     '${topUsers.firstname} ${topUsers.lastname}',
//                     style: TextStyle(
//                       fontFamily: 'Arial',
//                       fontSize: 16,
//                       color: Color(0xFF555555),
//                       fontWeight: FontWeight.w300,
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//           SizedBox(width: 16),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Text(
//                 correctAnswer,
//                 style: TextStyle(
//                   fontFamily: 'Arial',
//                   fontSize: 16,
//                   color: Color(0xFF555555),
//                   fontWeight: FontWeight.w500,
//                 ),
//                 overflow: TextOverflow.ellipsis,
//                 maxLines: 2,
//               ),
//               Divider(),
//               Text(
//                 topUsers.point,
//                 style: TextStyle(
//                   fontFamily: 'Arial',
//                   fontSize: 16,
//                   color: Color(0xFF555555),
//                   fontWeight: FontWeight.w300,
//                 ),
//               ),
//             ],
//           ),
//           SizedBox(width: 16),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Text(
//                 timeUsed,
//                 style: TextStyle(
//                   fontFamily: 'Arial',
//                   fontSize: 16,
//                   color: Color(0xFF555555),
//                   fontWeight: FontWeight.w500,
//                 ),
//                 overflow: TextOverflow.ellipsis,
//                 maxLines: 2,
//               ),
//               Divider(),
//               Text(
//                 topUsers.time_used,
//                 style: TextStyle(
//                   fontFamily: 'Arial',
//                   fontSize: 16,
//                   color: Color(0xFF555555),
//                   fontWeight: FontWeight.w300,
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     ),
//   );
// })),
