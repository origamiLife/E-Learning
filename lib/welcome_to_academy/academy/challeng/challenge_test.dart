import 'package:academy/welcome_to_academy/academy/challeng/challenge_start.dart';
import 'package:academy/welcome_to_academy/academy/challeng/summary_scores.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:academy/welcome_to_academy/export.dart';
import 'package:academy/main.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

import '../evaluate/curriculum/curriculum.dart';

class ChallengePage extends StatefulWidget {
  const ChallengePage({
    super.key,
    required this.employee,
    required this.Authorization,
    required this.initialMinutes,
    required this.challenge,
    required this.timer_end,
  });
  final Employee employee;
  final String Authorization;
  final double initialMinutes;
  final GetChallenge challenge;
  final Function(String) timer_end;
  @override
  _ChallengePageState createState() => _ChallengePageState();
}

class _ChallengePageState extends State<ChallengePage> {
  final CarouselSliderController _controller = CarouselSliderController();
  String _oneChoice = '';
  String timer_start = '';
  String timer_end = '';
  bool oneShot = true;

  // กำหนดค่าตัวเลือกเริ่มต้นให้ติ๊กไว้ 2 ข้อ
  // Set<String> _manyChoiceSet = {'1', '2'}; // ระบุ choice_id ที่ต้องการเลือกไว้ก่อน
  Set<String> _manyChoiceSet = {};
  Timer? timer;
  double _progress = 0.0; // เริ่มต้นที่ 100%
  double _progressValue = 0.8; // ค่าความคืบหน้า

  @override
  void initState() {
    super.initState();
    fetchNextChallenge();
    if ((widget.challenge.challenge_status != 'doing' ||
        widget.challenge.challenge_status != 'not_start')) {
      _progress = 0;
    }
    fetchResult();
  }

  // นับเวลาถอยหลัง
  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_progress > 0 &&
            (widget.challenge.challenge_status == 'doing' ||
                widget.challenge.challenge_status == 'not_start')) {
          _progress--;
          print("เวลาคงเหลือ: $_progress วินาที");
        } else {
          print("หมดเวลา");
          _progress = 0;
          timer.cancel();
          if ((widget.challenge.challenge_status == 'doing' ||
              widget.challenge.challenge_status == 'not_start')) {
            timeOutNextPage();
          }else{
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SummaryScores(
                  employee: widget.employee,
                  Authorization: widget.Authorization,
                  initialMinutes: widget.initialMinutes,
                  total_point: total_point,
                  time_used: time_used,
                  topChallenge: topChallenge!,
                  challengeData: challengeData!,
                  total_point_all: total_point_all.toString(),
                  challenge: widget.challenge,
                  questionList: questionList,
                  isQuestion: checkAllChallenge,
                ),
              ),
            ).then((_) {
              Navigator.pop(context);
              // Navigator.pop(context);
            });
          }
        }
      });
      // print("เวลาคงเหลือ: $_progress วินาที");
    });
  }

  // หมดเวลา
  void timeOutNextPage() {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.info,
      width: MediaQuery.of(context).size.width > 600 ? 590 : 400,
      customAsset: 'assets/images/busienss1.jpg',
      widget: SizedBox(
        height: 100, // กำหนดความสูงของรูป
        child: Image.network(
            'https://images.ctfassets.net/unrdeg6se4ke/42cuIBOAntDgaG1GinrKHs/e424890c6ae3ed84021e247011ca949c/summary-1366x446-1.jpg'),
      ),
      title: 'หมดเวลา!',
      text:
          'ระบบจะประมวลผลการทำข้อสอบของผู้เข้าสอบทั้งหมดเข้าสู่ฐานข้อมูลเพื่อการแสดงผล',
      // autoCloseDuration: const Duration(seconds: 2),
      showConfirmBtn: true,
      barrierDismissible: false, // ปิดการแตะออกนอกกรอบ
      onCancelBtnTap: () {
        Navigator.pop(context);
      },
      onConfirmBtnTap: () {
        fetchFinishChallenge();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SummaryScores(
              employee: widget.employee,
              Authorization: widget.Authorization,
              initialMinutes: widget.initialMinutes,
              total_point: total_point,
              time_used: time_used,
              topChallenge: topChallenge!,
              challengeData: challengeData!,
              total_point_all: total_point_all.toString(),
              challenge: widget.challenge,
              questionList: questionList,
              isQuestion: checkAllChallenge,
            ),
          ),
        ).then((_) {
          Navigator.pop(context);
          Navigator.pop(context);
        });
      },
    );
  }

  // สิ้นสุดการทดสอบ
  void finishNextpage(List<CheckAllChallenge> isQuestion) {
    final String successMessage =
        'คุณได้ทำข้อสอบให้ครบทุกข้อแล้วกดปุ่ม Success เพื่อส่งคำตอบ หรือกดปุ่ม Close เพื่อกลับไปทบทวน';
    final String failureMessage =
        'มีข้อที่ยังไม่ได้ตอบ กดปุ่ม Close เพื่อกลับไปทำข้อสอบให้ครบทุกข้อ หรือกดปุ่ม Success เพื่อส่งคำตอบ';

    if (_oneChoice.isNotEmpty || _manyChoiceSet.isNotEmpty) {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.confirm,
        width: MediaQuery.of(context).size.width > 600 ? 590 : 400,
        customAsset: 'assets/images/busienss1.jpg',
        widget: SizedBox(
          height: 100,
          child: Image.network(
            'https://images.ctfassets.net/unrdeg6se4ke/42cuIBOAntDgaG1GinrKHs/e424890c6ae3ed84021e247011ca949c/summary-1366x446-1.jpg',
          ),
        ),
        title: 'แจ้งเตือน!',
        text: successMessage,
        confirmBtnText: 'Success',
        cancelBtnText: 'Close',
        showConfirmBtn: true,
        barrierDismissible: false,
        onCancelBtnTap: () {
          Navigator.pop(context);
          _showDialog(isQuestion);
        },
        onConfirmBtnTap: () {
          // fetchFinishChallenge();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SummaryScores(
                employee: widget.employee,
                Authorization: widget.Authorization,
                initialMinutes: widget.initialMinutes,
                total_point: total_point,
                time_used: time_used,
                topChallenge: topChallenge!,
                challengeData: challengeData!,
                total_point_all: total_point_all.toString(),
                challenge: widget.challenge,
                questionList: questionList,
                isQuestion: checkAllChallenge,
              ),
            ),
          ).then((_) {
            Navigator.pop(context);
            Navigator.pop(context);
          });
        },
      );
    }
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

  void _mainDateTime(GetChallenge challenge, String timerStart) {
    if (timerStart.isEmpty) {
      print("Invalid start time.");
      return;
    }

    try {
      DateFormat format = DateFormat("yyyy/MM/dd HH:mm:ss"); // ใช้ / แทน -
      DateTime startTime = format.parse(timerStart).toUtc(); // แปลงเป็น UTC
      DateTime now = DateTime.now().toUtc();

      int durationMinutes = int.tryParse(challenge.challenge_duration) ?? 0;
      DateTime endTime = startTime.add(Duration(minutes: durationMinutes));

      // คำนวณเวลาคงเหลือ
      double remainingSeconds = endTime.difference(now).inSeconds.toDouble();
      _progress = remainingSeconds > 0 ? remainingSeconds : 0;

      print("เวลาเริ่มต้น: $startTime");
      print("เวลาสิ้นสุด: $endTime");
      print("คงเหลือ: $_progress วินาที");

      startTimer();
    } catch (e) {
      print("Error parsing date: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    // question_no = question_list.first;
    _progressValue = _progress / (widget.initialMinutes * 60);
    // print("เวลาปัจจุบัน: $_progressValue นาที");
    return PopScope(
      canPop: true, // ป้องกันการออกจากหน้าก่อนเรียก fetchStatus()
      onPopInvoked: (didPop) async {
        fetchFinishChallenge();
      },
      child: Scaffold(
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
          // leading: Icon(null),
        ),
        body: _getContentWidget(),
      ),
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
                    value: widget.initialMinutes * 60,
                    backgroundColor: Colors.grey.shade300,
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Colors.grey.shade300),
                    minHeight: 10,
                  ),
                  // Foreground LinearProgressIndicator with ShaderMask
                  ShaderMask(
                    shaderCallback: (bounds) => LinearGradient(
                      colors: [
                        Colors.lightBlueAccent,
                        Colors.lightBlue,
                        Colors.blueAccent
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ).createShader(bounds),
                    child: LinearProgressIndicator(
                      value: _progressValue,
                      backgroundColor: Colors.transparent,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      minHeight: 10,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            FutureBuilder<QuestionData?>(
              future: fetchQuestionData(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return _loadingWidget();
                } else {
                  final questionList = snapshot.data!;
                  return _contentWidget(questionList);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _loadingWidget() {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: Color(0xFFFF9900)),
          SizedBox(width: 12),
          Text(
            'Loading...',
            style: TextStyle(
                fontFamily: 'Arial',
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Color(0xFF555555)),
          ),
        ],
      ),
    );
  }

  Widget _contentWidget(QuestionData questionData) {
    return Expanded(
      child: FutureBuilder<List<CheckAllChallenge>>(
          future: fetchCheckAllChallenge(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return _loadingWidget();
            } else {
              final isQuestion = snapshot.data!;
              checkAllChallenge = isQuestion;
              return Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          _questionRow(questionData),
                          if (isIPad || isTablet) SizedBox(height: 28),
                          _imageCarousel(questionData),
                          SizedBox(height: 8),
                          _choice(questionData.question.choice, isQuestion,
                              questionData.question.choice_choose),
                          SizedBox(height: 8),
                        ],
                      ),
                    ),
                  ),
                  _actionButtons(questionData, isQuestion),
                ],
              );
            }
          }),
    );
  }

  Widget _questionRow(QuestionData questionData) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Q${questionData.question.question_seq}. ',
          style: TextStyle(
              fontFamily: 'Arial',
              fontSize: (isIPad || isTablet) ? 32 : 18,
              color: Color(0xFF555555),
              fontWeight: FontWeight.w700),
        ),
        Flexible(
          child: Text(
            questionData.question.question_text,
            style: TextStyle(
                fontFamily: 'Arial',
                fontSize: (isIPad || isTablet) ? 24 : 16,
                color: Color(0xFF555555),
                fontWeight: FontWeight.w700),
            overflow: TextOverflow.ellipsis,
            maxLines: 10,
          ),
        ),
      ],
    );
  }

  Widget _imageCarousel(QuestionData questionData) {
    if (questionData.question.question_image.isNotEmpty) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.grey, size: 24),
            onPressed: () {
              _controller.previousPage();
            },
          ),
          Expanded(
            child: CarouselSlider.builder(
              itemCount: questionData.question.question_image.length,
              carouselController: _controller,
              options: CarouselOptions(
                viewportFraction: 1,
                autoPlay: false,
                autoPlayInterval: Duration(seconds: 5),
                enlargeCenterPage: true,
                enableInfiniteScroll: false,
                onPageChanged: (index, reason) {
                  int currentIndex = 0;
                  setState(() {
                    currentIndex = index;
                  });
                },
              ),
              itemBuilder: (context, index, realIndex) {
                return Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: isIPad || isTablet ? 24 : 12),
                  child: GestureDetector(
                    onTap: () {
                      _showFullScreenImage(
                          questionData.question.question_image[index]);
                    },
                    child: Image.network(
                      questionData.question.question_image[index],
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(Icons.error);
                      },
                    ),
                  ),
                );
              },
            ),
          ),
          IconButton(
            icon: Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 24),
            onPressed: () {
              _controller.nextPage();
            },
          ),
        ],
      );
    }
    return SizedBox();
  }

  Widget _actionButtons(
      QuestionData questionData, List<CheckAllChallenge> isQuestion) {
    return Container(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _actionButton("${skip}", () {
                if (questionData.question.question_seq !=
                    questionList.length.toString()) {
                  int index = int.parse(questionData.question.question_seq);
                  question_first = questionList[index];
                  fetchNextChallenge();
                }
              }),
              IconButton(
                  onPressed: () {
                    _showDialog(isQuestion);
                  },
                  icon: Icon(Icons.window_sharp)),
              (isYChoice == false)
                  ? _actionButton("${next}", () {
                      if (_oneChoice != '') {
                        if (questionData.question.question_seq ==
                            questionList.length.toString()) {
                          int index =
                              int.parse(questionData.question.question_seq) - 1;
                          question_first = questionList[index];
                          fetchSend(_oneChoice);
                          finishNextpage(isQuestion);
                        } else {
                          int index =
                              int.parse(questionData.question.question_seq);
                          question_first = questionList[index];
                          fetchSend(_oneChoice);
                          showIconDialog(context, choice_correct);
                        }
                      }
                    })
                  : _actionButton((questionData.question.question_seq ==
                  questionList.length.toString())?"finish":"", () {
                if (questionData.question.question_seq ==
                    questionList.length.toString()) {
                  int index =
                      int.parse(questionData.question.question_seq) - 1;
                  question_first = questionList[index];
                  fetchSend(_oneChoice);
                  finishNextpage(isQuestion);
                }

                    }),
            ],
          ),
        ],
      ),
    );
  }

  Widget _actionButton(String label, VoidCallback onPressed) {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        label,
        style: TextStyle(
            fontFamily: 'Arial',
            fontSize: (isIPad || isTablet) ? 24 : 16,
            color: Color(0xFF555555),
            fontWeight: FontWeight.w700),
      ),
    );
  }

  String choice_correct = '';
  Widget _choice(List<Choice> choiceList, List<CheckAllChallenge> isQuestion,
      List<ChoiceChoose> choice_choose) {
    return Card(
      elevation: 0,
      child: Column(
        children: List.generate(choiceList.length, (index1) {
          final isSelected =
              _manyChoiceSet.contains(choiceList[index1].choice_id);
          final choice = choiceList[index1];
          return Row(
            children: [
              Expanded(
                child: (choice_choose.isEmpty ||
                        choice_choose.first.choice_no.isEmpty)
                    ? nChoice(choice, isSelected, isQuestion)
                    : yChoice(choice, isSelected, isQuestion, choice_choose),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  int choiceNo = 1;
  bool isYChoice = false;
  Widget yChoice(Choice choice, bool isSelected,
      List<CheckAllChallenge> isQuestion, List<ChoiceChoose> choice_choose) {
    isYChoice = true;
    Color borderColor = Colors.white;
    if (choice.choice_no == choice_choose.first.choice_no) {
      if (choice_choose.first.choice_correct == "0") {
        borderColor = const Color(0xFFEE546C); // สีแดง
      } else {
        borderColor = const Color(0xFF00C789); // สีเขียว
      }
    }
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFF1F7F0),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
            color: borderColor, width: 2), // ใช้ borderColor ตามเงื่อนไข
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 16),
        title: Row(
          children: [
            Expanded(
              child: Text(
                choice.choice_text,
                style: TextStyle(
                  fontFamily: 'Arial',
                  fontSize: (isIPad || isTablet) ? 24 : 16,
                  color: Color(0xFF555555),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            if (choice.choice_correct == "1")
              Icon(Icons.check_circle, color: Colors.green)
          ],
        ),
        leading: (choiceNo > 1)
            ? manyChoice(choice, isSelected, isQuestion)
            : Radio<String>(
                value: choice.choice_no,
                groupValue: choice_choose.first.choice_no,
                hoverColor: Color(0xFF555555),
                activeColor: Color(0xFF555555),
                onChanged: (String? value) {},
              ),
      ),
    );
  }

  // ยังไม่ทำ
  Widget nChoice(
      Choice choice, bool isSelected, List<CheckAllChallenge> isQuestion) {
    isYChoice = false;
    Color borderColor = (_oneChoice == choice.choice_id || isSelected)
        ? Color(0xFF00C789)
        : Colors.white;
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFF1F7F0),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xFFF1F7F0),
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: borderColor, width: 2),
        ),
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 16),
          title: Text(
            choice.choice_text,
            style: TextStyle(
              fontFamily: 'Arial',
              fontSize: (isIPad || isTablet) ? 24 : 16,
              color: Color(0xFF555555),
              fontWeight: FontWeight.w500,
            ),
          ),
          leading: (choiceNo > 1)
              ? manyChoice(choice, isSelected, isQuestion)
              : Radio<String>(
                  value: choice.choice_id,
                  groupValue: _oneChoice,
                  hoverColor: Color(0xFF555555),
                  activeColor: Color(0xFF555555),
                  onChanged: (String? value) {
                    setState(() {
                      _oneChoice = value!;
                      choice_correct = choice.choice_correct;
                    });
                  },
                ),
        ),
      ),
    );
  }

  // มากกว่า 1 ข้อ
  Widget manyChoice(
      Choice choice, bool isSelected, List<CheckAllChallenge> isQuestion) {
    isYChoice = false;
    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            // Remove the choice from the set when deselected
            _manyChoiceSet.remove(choice.choice_id);
          } else {
            // Add the choice to the set if not selected and under the limit
            if (_manyChoiceSet.length < choiceNo) {
              _manyChoiceSet.add(choice.choice_id);
            } else {
              // Optional: Provide feedback if limit reached
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text('You can select up to $choiceNo choices')),
              );
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
                                        question_first = questionList[index];
                                        fetchNextChallenge();
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

  void showIconDialog(BuildContext context, String choice_correct) {
    final isCheck = (choice_correct == "1") ? true : false;
    showDialog(
      context: context,
      barrierDismissible: false, // ป้องกันการปิดด้วยการแตะด้านนอก
      builder: (BuildContext context) {
        Future.delayed(Duration(milliseconds: 500), () {
          Navigator.of(context).pop(); // ปิด Dialog อัตโนมัติใน 0.5 วินาที
        });

        return Dialog(
          backgroundColor: Colors.transparent, // ให้พื้นหลังโปร่งใส
          elevation: 0, // ไม่มีเงา
          child: TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0.0, end: 1.0),
            duration: Duration(milliseconds: 10), // ใช้เวลา 0.3 วินาที
            builder: (context, value, child) {
              return Transform.scale(
                scale: value, // ค่อย ๆ ขยายขนาด
                child: child,
              );
            },
            child: Icon(
              isCheck
                  ? Icons.check_circle_outline
                  : Icons.highlight_remove_sharp, // ไอคอนที่ต้องการแสดง
              color: isCheck ? Color(0xFF00C789) : Color(0xFFEE546C), // สีไอคอน
              size: 80, // ขนาดไอคอน
            ),
          ),
        );
      },
    );
  }

  //----------------- 2.1 start-challenge------------------------------------------------------------

  List<String> questionList = [];
  bool isLoading = false;
  int total_point_all = 0;
  String question_first = '';

  Future<void> fetchNextChallenge() async {
    final uri = Uri.parse("$host/api/origami/challenge/start-challenge.php");
    try {
      final response = await http.post(
        uri,
        headers: {'Authorization': 'Bearer ${widget.Authorization}'},
        body: {
          'comp_id': widget.employee.comp_id,
          'emp_id': widget.employee.emp_id,
          'challenge_id': widget.challenge.challenge_id,
          'request_id': widget.challenge.request_id,
        },
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);

        setState(() {
          final String timerStart = jsonResponse['timer_start']?.toString() ?? '';
          final String questionFirst = jsonResponse['question_first']?.toString() ?? '';

          print("timer_start: $timerStart");
          print("question_first: $questionFirst");

          // ตรวจสอบว่า question_list เป็น List จริง
          if (jsonResponse['question_list'] is List) {
            questionList = List<String>.from(jsonResponse['question_list']);
          } else {
            questionList = [];
            print("Warning: question_list is not a valid list.");
          }

          total_point_all = questionList.length;
          print('questionList: $questionList');
          print('fetchNextChallenge: ${widget.challenge.challenge_status}');

          if (oneShot && questionList.isNotEmpty) {
            // กำหนดค่า question_first โดยใช้ค่า API หรือ fallback ไปที่ค่าแรกของ questionList
            question_first = questionFirst.isNotEmpty ? questionFirst : questionList.first;
            print("Final question_first: $question_first");

            if (timerStart.isNotEmpty) {
              _mainDateTime(widget.challenge, timerStart);
            }
            oneShot = false;
          }
        });
      } else {
        throw Exception('Failed to load challenge data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching challenge data: $e');
    } finally {
      setState(() {}); // อัปเดต UI หลังจากโหลดเสร็จ
    }
  }


  //-------------- 2.2 result-challenge---------------------------------------------------------------

  TopChallenge? topChallenge;
  ChallengeData? challengeData;
  String total_point = '';
  String time_used = '';
  Future<void> fetchResult() async {
    final uri = Uri.parse("$host/api/origami/challenge/result-challenge.php");
    try {
      final response = await http.post(
        uri,
        headers: {'Authorization': 'Bearer ${widget.Authorization}'},
        body: {
          'comp_id': widget.employee.comp_id,
          'emp_id': widget.employee.emp_id,
          'challenge_id': widget.challenge.challenge_id,
          'request_id': widget.challenge.request_id,
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        if (jsonResponse['code'] == 200) {
          setState(() {
            String total_point0 = jsonResponse['total_point']?.toString() ?? '';
            String time_used0 = jsonResponse['time_used']?.toString() ?? '';
            total_point = total_point0;
            time_used = time_used0;
            challengeData = jsonResponse['challenge_data'] != null
                ? ChallengeData.fromJson(jsonResponse['challenge_data'])
                : null;

            if (jsonResponse['top_challenge'] != null &&
                jsonResponse['top_challenge']['top_challenge'] != null) {
              topChallenge =
                  TopChallenge.fromJson(jsonResponse['top_challenge']);
              print('Result : ${topChallenge}');
            } else {
              topChallenge = null;
              print('Result Null : ${topChallenge}');
            }

            print('fetchResult : ${widget.challenge.challenge_status}');
          });
        } else {
          throw Exception('Empty response data');
        }
      } else {
        throw Exception(
            'Failed to load challenge data, status code: ${response.statusCode}');
      }
    } catch (e) {
      // จับข้อผิดพลาดต่างๆ เช่น การเชื่อมต่อ API หรือการแปลง JSON
      throw Exception('Error fetching challenge data: $e');
    }
  }

  //-----------------2.3 get-question-no------------------------------------------------------------

  List<CheckAllChallenge> checkAllChallenge = [];
  Future<List<CheckAllChallenge>> fetchCheckAllChallenge() async {
    final uri = Uri.parse("$host/api/origami/challenge/get-question-no.php");
    try {
      final response = await http.post(
        uri,
        headers: {'Authorization': 'Bearer ${widget.Authorization}'},
        body: {
          'comp_id': widget.employee.comp_id,
          'emp_id': widget.employee.emp_id,
          'challenge_id': widget.challenge.challenge_id,
          'request_id': widget.challenge.request_id,
          'question_no': question_first,
        },
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        // เข้าถึงข้อมูลในคีย์ 'instructors'
        final List<dynamic> challengeJson = jsonResponse['challenge_data'];
        print('CheckAllChallenge : ${widget.challenge.challenge_status}');
        // แปลงข้อมูลจาก JSON เป็น List<Instructor>
        return challengeJson
            .map((json) => CheckAllChallenge.fromJson(json))
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

  //------------------3.1 get-question-----------------------------------------------------------

  Future<QuestionData?> fetchQuestionData() async {
    final uri = Uri.parse("$host/api/origami/challenge/get-question.php");

    try {
      final response = await http.post(
        uri,
        headers: {'Authorization': 'Bearer ${widget.Authorization}'},
        body: {
          'comp_id': widget.employee.comp_id,
          'emp_id': widget.employee.emp_id,
          'challenge_id': widget.challenge.challenge_id,
          'request_id': widget.challenge.request_id,
          'question_no': question_first,
        },
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        // Debug: ตรวจสอบ response
        print("Response: ${response.body}");

        if (jsonResponse.containsKey('question_data') &&
            jsonResponse['question_data'] != null) {
          print('QuestionData: ${widget.challenge.challenge_status}');
          print('คำถาม: ${jsonResponse['question_data']}');
          return QuestionData.fromJson(jsonResponse['question_data']);
        } else {
          print('No question data found in response.');
          return null; // คืนค่า `null` แทนที่จะ throw error
        }
      } else {
        throw Exception('Failed to load question data, status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching question data: $e');
      return null; // คืนค่า `null` เพื่อป้องกันแอป crash
    }
  }

  //------------------ 3.2 send-answer-----------------------------------------------------------

  String next_question = '';
  Future<void> fetchSend(String choices) async {
    final uri = Uri.parse("$host/api/origami/challenge/send-answer.php");
    try {
      final response = await http.post(
        uri,
        headers: {'Authorization': 'Bearer ${widget.Authorization}'},
        body: {
          'comp_id': widget.employee.comp_id,
          'emp_id': widget.employee.emp_id,
          'challenge_id': widget.challenge.challenge_id,
          'request_id': widget.challenge.request_id,
          'question_no': question_first,
          'choices': choices,
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        if (jsonResponse.isNotEmpty) {
          fetchNextChallenge();
          print('fetchSend : ${widget.challenge.challenge_status}');
        } else {
          throw Exception('Empty response data');
        }
      } else {
        throw Exception(
            'Failed to load challenge data, status code: ${response.statusCode}');
      }
    } catch (e) {
      // จับข้อผิดพลาดต่างๆ เช่น การเชื่อมต่อ API หรือการแปลง JSON
      throw Exception('Error fetching challenge data: $e');
    }
  }

  //----------------- 3.3 finish-challenge------------------------------------------------------------

  Future<void> fetchFinishChallenge() async {
    final uri = Uri.parse("$host/api/origami/challenge/finish-challenge.php");
    try {
      final response = await http.post(
        uri,
        headers: {'Authorization': 'Bearer ${widget.Authorization}'},
        body: {
          'comp_id': widget.employee.comp_id,
          'emp_id': widget.employee.emp_id,
          'challenge_id': widget.challenge.challenge_id,
          'request_id': widget.challenge.request_id,
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        if (jsonResponse.isNotEmpty) {
        } else {
          throw Exception('Empty response data');
        }
      } else {
        throw Exception(
            'Failed to load challenge data, status code: ${response.statusCode}');
      }
    } catch (e) {
      // จับข้อผิดพลาดต่างๆ เช่น การเชื่อมต่อ API หรือการแปลง JSON
      throw Exception('Error fetching challenge data: $e');
    }
  }
}

class QuestionData {
  final Question question;

  QuestionData({required this.question});

  factory QuestionData.fromJson(Map<String, dynamic> json) {
    return QuestionData(
      question: Question.fromJson(json['question']),
    );
  }
}

class Question {
  final String id;
  final String challenge_id;
  final String question_no;
  final String question_text;
  final String question_image;
  final String show_answer;
  final String question_seq;
  final List<ChoiceChoose> choice_choose;
  final List<Choice> choice;
  final String correct;

  Question({
    required this.id,
    required this.challenge_id,
    required this.question_no,
    required this.question_text,
    required this.question_image,
    required this.show_answer,
    required this.question_seq,
    required this.choice_choose,
    required this.choice,
    required this.correct,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'] ?? '',
      challenge_id: json['challenge_id'] ?? '',
      question_no: json['question_no'] ?? '',
      question_text: json['question_text'] ?? '',
      question_image: json['question_image'] ?? '',
      show_answer: json['show_answer'] ?? '',
      question_seq: json['question_seq'] ?? '',
      choice_choose: (json['choice_choose'] as List?)
              ?.map((e) => ChoiceChoose.fromJson(e))
              .toList() ??
          [],
      choice:
          (json['choice'] as List?)?.map((e) => Choice.fromJson(e)).toList() ??
              [],
      correct: json['correct'] ?? '',
    );
  }
}

class Choice {
  final String choice_id;
  final String choice_no;
  final String choice_text;
  final String choice_image;
  final String choice_correct;

  Choice({
    required this.choice_id,
    required this.choice_no,
    required this.choice_text,
    required this.choice_image,
    required this.choice_correct,
  });

  factory Choice.fromJson(Map<String, dynamic> json) {
    return Choice(
      choice_id: json['choice_id'] ?? '',
      choice_no: json['choice_no'] ?? '',
      choice_text: json['choice_text'] ?? '',
      choice_image: json['choice_image'] ?? '',
      choice_correct: json['choice_correct'] ?? '',
    );
  }
}

class ChoiceChoose {
  final String choice_no;
  final String choice_correct;

  ChoiceChoose({
    required this.choice_no,
    required this.choice_correct,
  });

  factory ChoiceChoose.fromJson(Map<String, dynamic> json) {
    return ChoiceChoose(
      choice_no: json['choice_no'],
      choice_correct: json['choice_correct'],
    );
  }
}

class TopChallenge {
  final List<TopUser> topUsers;

  TopChallenge({required this.topUsers});

  factory TopChallenge.fromJson(Map<String, dynamic> json) {
    return TopChallenge(
      topUsers: (json['top_challenge'] as List?)
              ?.map((user) => TopUser.fromJson(user))
              .toList() ??
          [],
    );
  }
}

class TopUser {
  final String avatar;
  final String firstname;
  final String lastname;
  final String point;
  final String time_used;
  final String emp_id;

  TopUser({
    required this.avatar,
    required this.firstname,
    required this.lastname,
    required this.point,
    required this.time_used,
    required this.emp_id,
  });

  factory TopUser.fromJson(Map<String, dynamic> json) {
    return TopUser(
      avatar: json['avatar'] ?? '',
      firstname: json['firstname'] ?? '',
      lastname: json['lastname'] ?? '',
      point: json['point'] ?? '',
      time_used: json['time_used'] ?? '',
      emp_id: json['emp_id'] ?? '',
    );
  }
}

class ChallengeData {
  final String challenge_id;
  final String challenge_name;
  final String specific_question;
  final String question_type;
  final String challenge_duration;
  final String duration_point;
  final String challenge_random_question;
  final String used_point;
  final String cheat_answer;
  final String challenge_start;
  final String challenge_end;
  final String timer_start;
  final String challenge_last_question;
  final String timer_finish;
  final String check_request_status;
  final String challenge_question_part;
  final bool finish;
  final String start_question;
  final List<QuestionAnswer> question_answer;
  final String question_total;

  ChallengeData({
    required this.challenge_id,
    required this.challenge_name,
    required this.specific_question,
    required this.question_type,
    required this.challenge_duration,
    required this.duration_point,
    required this.challenge_random_question,
    required this.used_point,
    required this.cheat_answer,
    required this.challenge_start,
    required this.challenge_end,
    required this.timer_start,
    required this.challenge_last_question,
    required this.timer_finish,
    required this.check_request_status,
    required this.challenge_question_part,
    required this.finish,
    required this.start_question,
    required this.question_answer,
    required this.question_total,
  });

  factory ChallengeData.fromJson(Map<String, dynamic> json) {
    return ChallengeData(
      challenge_id: json['challenge_id'] ?? '',
      challenge_name: json['challenge_name'] ?? '',
      specific_question: json['specific_question'] ?? '',
      question_type: json['question_type'] ?? '',
      challenge_duration: json['challenge_duration'] ?? '',
      duration_point: json['duration_point'] ?? '',
      challenge_random_question: json['challenge_random_question'] ?? '',
      used_point: json['used_point'] ?? '',
      cheat_answer: json['cheat_answer'] ?? '',
      challenge_start: json['challenge_start'] ?? '',
      challenge_end: json['challenge_end'] ?? '',
      timer_start: json['timer_start'] ?? '',
      challenge_last_question: json['challenge_last_question'] ?? '',
      timer_finish: json['timer_finish'] ?? '',
      check_request_status: json['check_request_status'] ?? '',
      challenge_question_part: json['challenge_question_part'] ?? '',
      finish: json['finish'],
      start_question: json['start_question'] ?? '',
      question_answer: (json['question_answer'] as List?)
              ?.map((e) => QuestionAnswer.fromJson(e))
              .toList() ??
          [],
      question_total: json['question_total'] ?? '',
    );
  }
}

class QuestionAnswer {
  final String question_index;
  final String question_no;
  final String question_answer;
  final String correct_value;
  final String correct_pt;
  final CorrectAns? correct_ans;

  QuestionAnswer({
    required this.question_index,
    required this.question_no,
    required this.question_answer,
    required this.correct_value,
    required this.correct_pt,
    this.correct_ans,
  });

  factory QuestionAnswer.fromJson(Map<String, dynamic> json) {
    return QuestionAnswer(
      question_index: json['question_index'] ?? '',
      question_no: json['question_no'] ?? '',
      question_answer: json['question_answer'] ?? '',
      correct_value: json['correct_value'] ?? '',
      correct_pt: json['correct_pt'] ?? '',
      correct_ans: json['correct_ans'] is Map<String, dynamic>
          ? CorrectAns.fromJson(json['correct_ans'])
          : null, // ถ้าเป็น "" ให้กำหนดเป็น null
    );
  }
}

class CorrectAns {
  final String challenge_id;
  final String question_no;
  final String correct_value;
  final String answer_correct;
  final String correct_point;
  final String used_time;
  final String found_answer;
  final String status;

  CorrectAns({
    required this.challenge_id,
    required this.question_no,
    required this.correct_value,
    required this.answer_correct,
    required this.correct_point,
    required this.used_time,
    required this.found_answer,
    required this.status,
  });

  factory CorrectAns.fromJson(Map<String, dynamic> json) {
    return CorrectAns(
      challenge_id: json['challenge_id'] ?? '',
      question_no: json['question_no'] ?? '',
      correct_value: json['correct_value'] ?? '',
      answer_correct: json['answer_correct'] ?? '',
      correct_point: json['correct_point'] ?? '',
      used_time: json['used_time'] ?? '',
      found_answer: json['found_answer'] ?? '',
      status: json['status'] ?? '',
    );
  }
}

class CheckAllChallenge {
  final String question_seq;
  final String question_no;
  final String question_status;

  CheckAllChallenge({
    required this.question_seq,
    required this.question_no,
    required this.question_status,
  });

  factory CheckAllChallenge.fromJson(Map<String, dynamic> json) {
    return CheckAllChallenge(
      question_seq: json['question_seq'] ?? '',
      question_no: json['question_no'] ?? '',
      question_status: json['question_status'] ?? '',
    );
  }
}
