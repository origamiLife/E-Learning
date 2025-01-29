import 'package:academy/welcome_to_academy/academy/challeng/challenge_test.dart';
import 'package:academy/welcome_to_academy/academy/challeng/summary_scores.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:academy/welcome_to_academy/export.dart';
import 'package:academy/main.dart';

class FinishedChoiceChallenge extends StatefulWidget {
  FinishedChoiceChallenge({
    super.key,
    required this.employee,
    required this.Authorization,
  });
  final Employee employee;
  final String Authorization;
  @override
  _FinishedChoiceChallengeState createState() =>
      _FinishedChoiceChallengeState();
}

class _FinishedChoiceChallengeState extends State<FinishedChoiceChallenge> {
  final CarouselSliderController _controller = CarouselSliderController();
  int _currentIndex = 0;
  String? _oneChoice;

  // กำหนดค่าตัวเลือกเริ่มต้นให้ติ๊กไว้ 2 ข้อ
  // Set<String> _manyChoiceSet = {'1', '2'}; // ระบุ choice_id ที่ต้องการเลือกไว้ก่อน
  // Set<String> _manyChoiceSet = {};
  Timer? timer;

  @override
  void initState() {
    super.initState();
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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        // elevation: 1,
        foregroundColor: Colors.white,
        backgroundColor: Color(0xFFFF9900),
        title: Row(
          children: [
            Flexible(
              child: Text(
                'Q${'3'}.',
                style: TextStyle(
                  fontFamily: 'Arial',
                  fontSize: 24,
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
      body: _getContentWidget(),
    );
  }

  Widget _getContentWidget() {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.all(isIPad || isTablet ? 24 : 16),
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
                          enableInfiniteScroll: false, // เลื่อนไม่มีสิ้นสุด
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
                                _showFullScreenImage(
                                    challengeData.challenge_image[
                                        index]); // เรียกฟังก์ชันเพื่อขยายภาพ
                              },
                              child: Image.network(
                                challengeData.challenge_image[index],
                                fit: BoxFit.contain,
                                // width: double.infinity,
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
    );
  }

  Widget _choice(List<MultipleChoice> choiceList) {
    return Card(
      elevation: 0,
      child: Column(
        children: List.generate(choiceList.length, (index) {
          final choice = challengeData.challenge_testData[index];
          // กำหนดค่าตัวเลือกเริ่มต้นให้ติ๊กไว้ 2 ข้อ
          final Set<String> _manyChoiceSet = {'1', '2'};
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
    return Icon(
      isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
      color: isSelected ? Color(0xFF00C789) : Color(0xFF555555),
    );
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
