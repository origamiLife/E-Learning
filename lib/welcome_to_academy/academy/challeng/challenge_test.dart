import 'package:academy/welcome_to_academy/academy/challeng/summary_scores.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:academy/welcome_to_academy/export.dart';
import 'package:academy/main.dart';

class ChallengePage extends StatefulWidget {
  ChallengePage({
    super.key,
    required this.employee,
    required this.Authorization,
    required this.initialMinutes,
  });
  final Employee employee;
  final String Authorization;
  final double initialMinutes;
  @override
  _ChallengePageState createState() => _ChallengePageState();
}

class _ChallengePageState extends State<ChallengePage> {
  final CarouselSliderController _controller = CarouselSliderController();
  int _currentIndex = 0;
  String? _oneChoice;

  // กำหนดค่าตัวเลือกเริ่มต้นให้ติ๊กไว้ 2 ข้อ
  // Set<String> _manyChoiceSet = {'1', '2'}; // ระบุ choice_id ที่ต้องการเลือกไว้ก่อน
  Set<String> _manyChoiceSet = {};
  Timer? timer;
  double _progress = 1.0; // เริ่มต้นที่ 100%
  double _progressValue = 0.8; // ค่าความคืบหน้า

  @override
  void initState() {
    super.initState();
    _progress = widget.initialMinutes * 60; // แปลงเป็นวินาที
    startTimer();
  }

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_progress > 0) {
          _progress--;
        } else {
          timer.cancel();
          navigateToNextPage(); // เรียกฟังก์ชันเปลี่ยนหน้า
        }
      });
    });
  }

  void navigateToNextPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SummaryScores(
          employee: widget.employee,
          Authorization: widget.Authorization,
        ),
      ),
    ).then((_) {
      Navigator.pop(context);
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  String formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  void _showFullScreenImage(String imageUrl) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: GestureDetector(
            onTap: () {
              Navigator.pop(context); // ปิด Dialog เมื่อแตะที่รูป
            },
            child: Image.network(
              imageUrl,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return Icon(Icons.error);
              },
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    _progressValue = _progress / (widget.initialMinutes * 60);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        // elevation: 1,
        foregroundColor: Colors.white,
        backgroundColor: Color(0xFFFF9900),
        title: RichText(
          text: TextSpan(
            text: 'Time: ', // ข้อความที่ต้องการให้เป็นสีส้ม
            style: TextStyle(
              fontFamily: 'Arial',
              fontSize: (isIPad || isTablet) ? 38 : 28,
              color: Colors.white, // สีส้มสำหรับ 'Time:'
              fontWeight: FontWeight.w500,
            ),
            children: [
              TextSpan(
                text: '${formatTime(_progress.toInt())}', // ส่วนข้อความที่เหลือ
                style: TextStyle(
                  fontFamily: 'Arial',
                  fontSize: (isIPad || isTablet) ? 38 : 28,
                  color: Colors.white, // สีแดงสำหรับเวลา
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
      body: _getContentWidget(),
    );
  }

  Widget _getContentWidget() {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.all(isIPad || isTablet ? 24 : 16),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Stack(
                children: [
                  // Background LinearProgressIndicator (สีเทา)
                  LinearProgressIndicator(
                    value: widget.initialMinutes *
                        60, // ใช้เพื่อแสดงพื้นหลังสีเทาเต็ม
                    backgroundColor: Colors.grey.shade300,
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Colors.grey.shade300),
                    minHeight: 10,
                  ),
                  // Foreground LinearProgressIndicator (ใช้ ShaderMask สำหรับไล่ระดับสี)
                  ShaderMask(
                    shaderCallback: (bounds) => LinearGradient(
                      colors: [Colors.lightBlueAccent,Colors.lightBlue, Colors.blueAccent],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ).createShader(bounds),
                    child: LinearProgressIndicator(
                      value: _progressValue, // ค่าความคืบหน้า
                      backgroundColor: Colors.transparent,
                      valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.white), // สีไม่เกี่ยวเพราะใช้ ShaderMask
                      minHeight: 10,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Q${challengeData.challenge_id}. ',
                          style: TextStyle(
                            fontFamily: 'Arial',
                            fontSize: (isIPad || isTablet) ? 32 : 18,
                            color: Color(0xFF555555),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Flexible(
                          child: Text(
                            challengeData.challenge_hearder,
                            style: TextStyle(
                              fontFamily: 'Arial',
                              fontSize: (isIPad || isTablet) ? 24 : 16,
                              color: Color(0xFF555555),
                              fontWeight: FontWeight.w700,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 10,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    if (isIPad || isTablet) SizedBox(height: 28),
                    if (challengeData.challenge_image.isNotEmpty)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: Icon(Icons.arrow_back_ios,
                                color: Colors.grey, size: 24),
                            onPressed: () {
                              _controller.previousPage();
                            },
                          ),
                          Expanded(
                            child: CarouselSlider.builder(
                              itemCount: challengeData.challenge_image.length,
                              carouselController: _controller,
                              options: CarouselOptions(
                                viewportFraction: 1, // ขนาดภาพใน Carousel
                                autoPlay: false, // เลื่อนอัตโนมัติ
                                autoPlayInterval: Duration(seconds: 5),
                                enlargeCenterPage: true, // ขยายภาพตรงกลาง
                                enableInfiniteScroll:
                                    false, // เลื่อนไม่มีสิ้นสุด
                                onPageChanged: (index, reason) {
                                  setState(() {
                                    _currentIndex = index;
                                  });
                                },
                              ),
                              itemBuilder: (context, index, realIndex) {
                                return Padding(
                                  padding: (isIPad || isTablet)
                                      ? EdgeInsets.only(top: 24, bottom: 24)
                                      : EdgeInsets.only(top: 12, bottom: 12),
                                  child: GestureDetector(
                                    onTap: () {
                                      _showFullScreenImage(challengeData
                                              .challenge_image[
                                          index]); // เรียกฟังก์ชันเพื่อขยายภาพ
                                    },
                                    child: Image.network(
                                      challengeData.challenge_image[index],
                                      fit: BoxFit.contain,
                                      // width: double.infinity,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return Icon(Icons.error);
                                      },
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.arrow_forward_ios,
                                color: Colors.grey, size: 24),
                            onPressed: () {
                              _controller.nextPage();
                            },
                          ),
                        ],
                      ),
                    if (isIPad || isTablet) SizedBox(height: 20),
                    SizedBox(height: 8),
                    _choice(challengeData.challenge_testData),
                    SizedBox(height: 8),
                  ],
                ),
              ),
            ),
            Container(
              // color: Colors.orange.shade50,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      TextButton(
                          onPressed: () {},
                          child: Text(
                            'Skip',
                            style: TextStyle(
                              fontFamily: 'Arial',
                              fontSize: (isIPad || isTablet) ? 24 : 16,
                              color: Color(0xFF555555),
                              fontWeight: FontWeight.w700,
                            ),
                          )),
                      IconButton(
                          onPressed: _showDialog,
                          icon: Icon(Icons.window_sharp)),
                      TextButton(
                          onPressed: () {
                            if (_oneChoice != null ||
                                _manyChoiceSet.isNotEmpty) {
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //     builder: (context) => SummaryScores(
                              //       employee: widget.employee,
                              //       Authorization: widget.Authorization,
                              //     ),
                              //   ),
                              // ).then((_) {
                              //   Navigator.pop(context);
                              // });
                              QuickAlert.show(
                                context: context,
                                type: QuickAlertType.error,
                                // customAsset: 'assets/images/ic_calen.png',
                                text: 'Transaction Completed Successfully!',
                                autoCloseDuration: const Duration(seconds: 2),
                                showConfirmBtn: false,
                              );
                              Future.delayed(const Duration(seconds: 2), () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SummaryScores(
                                      employee: widget.employee,
                                      Authorization: widget.Authorization,
                                    ),
                                  ),
                                ).then((_) {
                                  Navigator.pop(context);
                                });
                              });
                            }
                          },
                          child: Text(
                            'Next',
                            style: TextStyle(
                              fontFamily: 'Arial',
                              fontSize: (isIPad || isTablet) ? 24 : 16,
                              color: Color(0xFF555555),
                              fontWeight: FontWeight.w700,
                            ),
                          )),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _choice(List<MultipleChoice> choiceList) {
    return Card(
      elevation: 0,
      child: Column(
        children: List.generate(choiceList.length, (index) {
          final choice = challengeData.challenge_testData[index];
          final isSelected = _manyChoiceSet.contains(choice.choice_id);
          return Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xFFF1F7F0),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      color: Colors.white, // สีขอบ
                      width: 4, // ความหนาของขอบ
                    ),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color(0xFFF1F7F0),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: (_oneChoice == choice.choice_id || isSelected)
                            ? Color(0xFF00C789)
                            : Colors.white, // สีขอบ
                        width: 2, // ความหนาของขอบ
                      ),
                    ),
                    child: ListTile(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                      title: Text(
                        choice.choice_name,
                        style: TextStyle(
                          fontFamily: 'Arial',
                          fontSize: (isIPad || isTablet) ? 24 : 16,
                          color: Color(0xFF555555),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      leading: (choiceNo > 1)
                          ? manyChoice(choice, isSelected)
                          : Radio<String>(
                              value: choice.choice_id,
                              groupValue: _oneChoice,
                              hoverColor: Color(0xFF555555),
                              activeColor: Color(0xFF00C789),
                              onChanged: (String? value) {
                                setState(() {
                                  _oneChoice = value;
                                });
                              },
                            ),
                    ),
                  ),
                ),
              )
            ],
          );
        }),
      ),
    );
  }

  int choiceNo = 2;

  Widget manyChoice(MultipleChoice choice, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            // ลบตัวเลือกออกเมื่อยกเลิกการเลือก
            _manyChoiceSet.remove(choice.choice_id);
          } else {
            // เพิ่มตัวเลือกเมื่อเลือกไม่เกิน 3
            if (_manyChoiceSet.length < choiceNo) {
              _manyChoiceSet.add(choice.choice_id);
            }
          }
          print(choice.choice_id);
          print(_manyChoiceSet);
          print(_manyChoiceSet.isNotEmpty);
        });
      },
      child: Icon(
        isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
        color: isSelected ? Color(0xFF00C789) : Color(0xFF555555),
      ),
    );
  }

  void _showDialog() {
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
                              "QUESTION: 5",
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
                                  children: List.generate(
                                      int.parse(challengeData.challenge_max),
                                      (index) {
                                    Color cardColor;
                                    if (index == 3 ||
                                        index == 6 ||
                                        index == 7 ||
                                        index == 19 ||
                                        index == 27 ||
                                        index == 38 ||
                                        index == 40 ||
                                        index == 41 ||index == 48 ||index == 49) {
                                      cardColor = Color(0xFFC0C4CC); // สีเทา
                                    } else if (index % 2 == 0) {
                                      cardColor =
                                          Color(0xFFEE546C); // เลขคู่สีแดง
                                    } else {
                                      cardColor =
                                          Color(0xFF00C789); // เลขคี่สีเขียว
                                    }
                                    return InkWell(
                                      onTap: () {
                                        Navigator.pop(dialogContext);
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
                                          'Correct',
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
                                          'Incorrect',
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

  final ChallengeData challengeData = ChallengeData(
    challenge_id: '3',
    challenge_hearder:
        'ในถุงมีลูกแก้วสีแดง 5 ลูก สีเขียว 3 ลูก และสีเหลือง 2 ลูก สุ่มหยิบลูกแก้วจากถุงใบนี้มา 3 ลูก ความน่าจะเป็นที่หยิบได้ลูกแก้วสีแดง 2 ลูกและสีเขียว 1 ลูกเท่ากับเท่าใด',
    challenge_image: [
      'https://www.shutterstock.com/image-vector/camera-photography-photo-picture-check-260nw-1168514233.jpg'
    ],
    challenge_only: '3',
    challenge_max: '50',
    challenge_subjective: '',
    challenge_testData: [
      MultipleChoice(
        choice_id: '0',
        choice_name: '0.25',
        choice_image: '',
      ),
      MultipleChoice(
        choice_id: '1',
        choice_name: '0.5',
        choice_image: '',
      ),
      MultipleChoice(
        choice_id: '2',
        choice_name: '0.3',
        choice_image: '',
      ),
      MultipleChoice(
        choice_id: '3',
        choice_name: '0.06',
        choice_image: '',
      ),
      MultipleChoice(
        choice_id: '4',
        choice_name: '0.13',
        choice_image: '',
      ),
    ],
  );
}

class ChallengeData {
  final String challenge_id; // ข้อ
  final String challenge_hearder; // โจทย์
  final List<String> challenge_image; // บางโจทย์มีรูปภาพประกอบ
  final String challenge_only; // ข้อปัจจุบัน
  final String challenge_max; // ข้อทั้งหมด
  final String challenge_subjective; // อัตนัย
  final List<MultipleChoice> challenge_testData; // ปรนัย

  ChallengeData({
    required this.challenge_id,
    required this.challenge_hearder,
    required this.challenge_image,
    required this.challenge_only,
    required this.challenge_max,
    required this.challenge_subjective,
    required this.challenge_testData,
  });
}

class MultipleChoice {
  final String choice_id;
  final String choice_name;
  final String choice_image;

  MultipleChoice({
    required this.choice_id,
    required this.choice_name,
    required this.choice_image,
  });
}
