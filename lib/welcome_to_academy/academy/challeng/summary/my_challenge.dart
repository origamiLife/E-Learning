import 'package:academy/welcome_to_academy/export.dart';

import 'finished_choice_challenge.dart';

class MyChallenge extends StatefulWidget {
  MyChallenge({
    super.key,
    required this.employee,
    required this.Authorization,
  });
  final Employee employee;
  final String Authorization;

  @override
  _MyChallengeState createState() => _MyChallengeState();
}

class _MyChallengeState extends State<MyChallenge> {
  @override
  void initState() {
    super.initState();
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
              // Icon(FontAwesomeIcons.trophy, color: Colors.orange, size: 60),
              // Text(
              //   'Question',
              //   style: TextStyle(
              //     fontFamily: 'Arial',
              //     fontSize: 32,
              //     color: Color(0xFF555555),
              //     fontWeight: FontWeight.w700,
              //   ),
              // ),
              Container(child: _summary()),
              SizedBox(height: 24),
              Column(
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.star,
                        color: Colors.amberAccent,
                      ),
                      Text(
                        'Top Challenge',
                        style: TextStyle(
                          fontFamily: 'Arial',
                          fontSize: 16,
                          color: Color(0xFF555555),
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Colors.grey.shade300, // สีขอบ
                        width: 1, // ความหนาของขอบ
                      ),
                    ),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '',
                                  style: GoogleFonts.sansita(
                                    fontSize: 16,
                                    color: Color(0xFF555555),
                                    fontWeight: FontWeight.w500,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                ),
                                Divider(),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      '1',
                                      style: TextStyle(
                                        fontFamily: 'Arial',
                                        fontSize: 16,
                                        color: Color(0xFF555555),
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(width: 24),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Examiner',
                                  style: TextStyle(
                                    fontFamily: 'Arial',
                                    fontSize: 16,
                                    color: Color(0xFF555555),
                                    fontWeight: FontWeight.w500,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                ),
                                Divider(),
                                Row(
                                  children: [
                                    Icon(Icons.person, size: 16),
                                    SizedBox(width: 4),
                                    Text(
                                      'Admin Trandar',
                                      style: TextStyle(
                                        fontFamily: 'Arial',
                                        fontSize: 16,
                                        color: Color(0xFF555555),
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(width: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'Correct answer',
                                  style: TextStyle(
                                    fontFamily: 'Arial',
                                    fontSize: 16,
                                    color: Color(0xFF555555),
                                    fontWeight: FontWeight.w500,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                ),
                                Divider(),
                                Text(
                                  '3',
                                  style: TextStyle(
                                    fontFamily: 'Arial',
                                    fontSize: 16,
                                    color: Color(0xFF555555),
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(width: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'Time used',
                                  style: TextStyle(
                                    fontFamily: 'Arial',
                                    fontSize: 16,
                                    color: Color(0xFF555555),
                                    fontWeight: FontWeight.w500,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                ),
                                Divider(),
                                Text(
                                  '00:01:10',
                                  style: TextStyle(
                                    fontFamily: 'Arial',
                                    fontSize: 16,
                                    color: Color(0xFF555555),
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              _timeStatus(),
              SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(1),
                    foregroundColor: Colors.red,
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 60, right: 60, bottom: 12, top: 12),
                    child: Text(
                      'Request challenge again',
                      style: TextStyle(
                        fontFamily: 'Arial',
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 24),
            ],
          ),
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
                          _question('Correct answer :'),
                          _question('Score :'),
                          _question('Time used :'),
                          _question('Start challenge :'),
                          _question('Finish challenge :'),
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
                      _question('45/50'),
                      _question('45'),
                      _question('00:20:15'),
                      _question('2024-04-26 10:24:35'),
                      _question('2024-04-26 10:44:40'),
                    ],
                  ),
                ),
              ],
            ),
            Divider(),
            Container(
              height: 2*50,
              child: SingleChildScrollView(
                child: Wrap(
                    spacing: 8.0, // ระยะห่างระหว่างไอเท็มแนวนอน
                    runSpacing: 8.0, // ระยะห่างระหว่างไอเท็มแนวตั้ง
                    children: List.generate(50, (index) {
                      Color cardColor;
                      if (index == 3 || index == 6 || index == 7) {
                        cardColor = Color(0xFFC0C4CC); // สีเทา
                      } else if (index % 2 == 0) {
                        cardColor = Color(0xFFEE546C); // เลขคู่สีแดง
                      } else {
                        cardColor = Color(0xFF00C789); // เลขคี่สีเขียว
                      }
                      return InkWell(
                        onTap: (){
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FinishedChoiceChallenge(
                                  employee: widget.employee,
                                  Authorization: widget.Authorization,
                                ),
                            ),
                          );
                        },
                        child: Container(
                          height: 40,
                          width: 40,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: cardColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '${index + 1}',
                            style: TextStyle(
                              fontFamily: 'Arial',
                              fontSize: 16,
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
            ),
          ],
        ),
      ),
    );
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
              'TIME STATUS',
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
              '00:28:50',
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
                      value: 45 * 60, // ใช้เพื่อแสดงพื้นหลังสีเทาเต็ม
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
                        value: (28 * 60) / (45 * 60), // ค่าความคืบหน้า
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
              'Exam Duration: 00:45:00',
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
}
