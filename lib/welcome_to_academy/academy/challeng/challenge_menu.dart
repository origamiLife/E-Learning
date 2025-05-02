import 'package:academy/welcome_to_academy/export.dart';
import 'package:http/http.dart' as http;
import 'challenge_test.dart';
import 'package:intl/intl.dart';

class ChallengeStartTime extends StatefulWidget {
  const ChallengeStartTime({
    super.key,
    required this.employee,
    required this.Authorization,
  });
  final Employee employee;
  final String Authorization;

  @override
  _ChallengeStartTimeState createState() => _ChallengeStartTimeState();
}

class _ChallengeStartTimeState extends State<ChallengeStartTime>
    with WidgetsBindingObserver {
  late Future<List<GetChallenge>> futureChallenges;
  List<GetChallenge> getChallenges = [];
  List<GetChallenge> allChallenges = [];
  List<GetChallenge> filteredChallenges = [];
  final TextEditingController _searchController = TextEditingController();

  bool _isMenu = false;
  String formattedDate = '';
  @override
  void initState() {
    super.initState();
    DateTime now = DateTime.now();
    formattedDate = DateFormat('yyyy-MM-dd').format(now);
    WidgetsBinding.instance.addObserver(this);
    futureChallenges = fetchGetChallenge();
    futureChallenges.then((challenges) {
      setState(() {
        allChallenges = challenges;
        filteredChallenges = challenges;
      });
    });

    // Listener สำหรับการกรอง
    _searchController.addListener(() {
      filterChallenges();
    });
  }

  void filterChallenges() {
    final query = _searchController.text.toLowerCase();

    setState(() {
      filteredChallenges = allChallenges.where((challenge) {
        final name = challenge.challenge_name.toLowerCase();
        final start = challenge.challenge_start.toLowerCase();
        final end = challenge.challenge_end.toLowerCase();
        return name.contains(query) ||
            start.contains(query) ||
            end.contains(query);
      }).toList();
    });
  }

  // ✅ ปิด Controller ใน dispose()
  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _searchController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      setState(() {
        futureChallenges = fetchGetChallenge();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 8,top: 4,bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(flex:3,child: _buildSearchField()),
                Expanded(flex:1,child: _DropdownStatus('Please select')),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 8, right: 8),
              child: FutureBuilder<List<GetChallenge>>(
                future: futureChallenges,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(
                            color: Color(0xFFFF9900),
                          ),
                          SizedBox(width: 12),
                          Text(
                            '$loadingTS...',
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
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(
                      child: Text(
                        NotFoundDataTS,
                        style: TextStyle(
                          fontFamily: 'Arial',
                          fontSize: 16.0,
                          color: Color(0xFF555555),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    );
                  } else {
                    // ✅ ใช้ snapshot.data โดยตรง
                    List<GetChallenge> challengeList = snapshot.data!;
                    return SingleChildScrollView(
                      child: isMobile
                          ? _challengeListSlim(challengeList)
                          : _challengeListBig(challengeList),
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchField() {
    return Padding(
        padding: const EdgeInsets.only(left: 8, right: 8),
        child: Container(
          height: 40,
          // decoration: BoxDecoration(
          //   color: Colors.white,
          //   borderRadius: BorderRadius.circular(100),
          //   boxShadow: [
          //     BoxShadow(
          //       color: Colors.black.withOpacity(0.2), // สีเงา
          //       blurRadius: 1, // ความฟุ้งของเงา
          //       offset: Offset(0, 4), // การเยื้องของเงา (แนวแกน X, Y)
          //     ),
          //   ],
          // ),
          child: TextFormField(
            controller: _searchController,
            keyboardType: TextInputType.text,
            style: const TextStyle(
              fontFamily: 'Arial',
              color: Color(0xFF555555),
              fontSize: 14,
            ),
            decoration: InputDecoration(
              isDense: true,
              filled: true,
              fillColor: Colors.white,
              contentPadding:
              const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              hintText: '$SearchTS...',
              hintStyle: const TextStyle(
                  fontFamily: 'Arial', fontSize: 14, color: Color(0xFF555555)),
              border: InputBorder.none, // เอาขอบปกติออก
              suffixIcon: const Padding(
                padding: EdgeInsets.only(right: 8.0),
                child: Icon(
                  Icons.search,
                  size: 24,
                  color: Colors.grey,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.grey.shade300,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.grey.shade300,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ));
  }

  Widget _textWidget(String title, String subject) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.text_snippet_outlined, color: Colors.black38),
          SizedBox(width: 6),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontFamily: 'Arial',
                    fontSize: (!isMobile) ? 20 : 14,
                    color: Colors.black54,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: (!isMobile) ? 8 : 2),
                Text(
                  subject,
                  style: TextStyle(
                    fontFamily: 'Arial',
                    fontSize: (!isMobile) ? 20 : 14,
                    color: Colors.black45,
                  ),
                  maxLines: 6,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  //android,iphone
  Widget _challengeListSlim(List<GetChallenge> filteredChallenges) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: filteredChallenges.length,
      separatorBuilder: (_, __) => Container(padding: EdgeInsets.all(4)),
      itemBuilder: (context, index) {
        final challenge = filteredChallenges[index];
        return InkWell(
          onTap: () => btnGetchalleng(challenge),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 3,
                  blurRadius: 1,
                  offset: Offset(1, 2),
                ),
              ],
            ),
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const SizedBox(width: 8),
                    Expanded(
                      child: Container(
                        // padding: EdgeInsets.all(4),
                        height: 120,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                            color: const Color(0xFF555555),
                            width: 0.1,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            challenge.challenge_logo,
                            height: 100,
                            width: 100,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(Icons.error, size: 80, color: Colors.red);
                            },
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            challenge.challenge_name,
                            style: const TextStyle(
                              fontFamily: 'Arial',
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF555555),
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '$startTS: ${challenge.challenge_start}',
                            style: const TextStyle(
                              fontFamily: 'Arial',
                              fontSize: 12,
                              color: Color(0xFF555555),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '$endTS: ${challenge.challenge_end}',
                            style: const TextStyle(
                              fontFamily: 'Arial',
                              fontSize: 12,
                              color: Color(0xFF555555),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            (challenge.challenge_status == 'success')
                                ? successTS
                                : (challenge.challenge_status == 'time_out')
                                    ? timeoutTS
                                    : (challenge.challenge_status == 'not_start')
                                        ? notStartTS
                                        : doingTS,
                            style: TextStyle(
                              fontFamily: 'Arial',
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: (challenge.challenge_status == 'doing' ||
                                      challenge.challenge_status == 'not_start')
                                  ? Color(0xFF00C789)
                                  : Color(0xFFEE546C),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                const Divider(),
              ],
            ),
          ),
        );
      },
    );
  }

  //tablet, ipad
  Widget _challengeListBig(List<GetChallenge> filteredChallenges) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: filteredChallenges.length,
      separatorBuilder: (_, __) => Container(padding: EdgeInsets.all(4)),
      itemBuilder: (context, index) {
        final challenge = filteredChallenges[index];
        return InkWell(
          onTap: () => btnGetchalleng(challenge),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 3,
                  blurRadius: 1,
                  offset: Offset(1, 2),
                ),
              ],
            ),
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                            color: const Color(0xFF555555),
                            width: 0.1,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            challenge.challenge_logo,
                            width: double.infinity,
                            height: 180,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Icon(Icons.error, size: 50),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          Text(
                            challenge.challenge_name,
                            style: TextStyle(
                              fontFamily: 'Arial',
                              color: const Color(0xFF555555),
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 3,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '$startTS: ${challenge.challenge_start}',
                            style: const TextStyle(
                              fontFamily: 'Arial',
                              fontSize: 18,
                              color: Color(0xFF555555),
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '$endTS: ${challenge.challenge_end}',
                            style: const TextStyle(
                              fontFamily: 'Arial',
                              fontSize: 18,
                              color: Color(0xFF555555),
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                          SizedBox(height: 8),
                          Text(
                            (challenge.challenge_status == 'success')
                                ? '$successTS'
                                : (challenge.challenge_status == 'time_out')
                                    ? '$timeoutTS'
                                    : (challenge.challenge_status == 'not_start')
                                        ? '$notStartTS'
                                        : '$doingTS',
                            style: TextStyle(
                              fontFamily: 'Arial',
                              fontSize: 18,
                              color: (challenge.challenge_status == 'doing' ||
                                      challenge.challenge_status == 'not_start')
                                  ? Color(0xFF00C789)
                                  : Color(0xFFEE546C),
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // const Divider(),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showChallengeDialog(
      BuildContext context, GetChallenge challenge, GetChallenge challeng2) {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.confirm,
      // customAsset: 'assets/images/learning/img.png',
      width: MediaQuery.of(context).size.width > 600 ? 590 : 400,
      title: '$AreYouReadyTS',
      confirmBtnText: '$startTS',
      confirmBtnColor: Colors.blue,
      customAsset: 'assets/images/learning/student.png',
      confirmBtnTextStyle: const TextStyle(
        fontSize: 18,
        color: Colors.white,
        fontWeight: FontWeight.w700,
      ),
      cancelBtnText: '$CancelTS',
      cancelBtnTextStyle: const TextStyle(
        fontSize: 18,
        color: Colors.grey,
        fontWeight: FontWeight.w700,
      ),
      widget: Column(
        children: [
          const SizedBox(height: 8),
          _textWidget('$challengeTS:', challenge.challenge_name),
          _textWidget('$DescriptionTS:', challenge.challenge_description),
          _textWidget('$RuleTS:', challenge.challenge_rule),
          _textWidget('$DurationTS ($MinTS):', challenge.challenge_duration),
          _textWidget('$PartTS:', challenge.challenge_question_part),
          _textWidget('$NumberQuestionsTS:',
              '${challenge.specific_question} $questionTS'),
        ],
      ),
      onCancelBtnTap: () => Navigator.pop(context),
      onConfirmBtnTap: () => btnGetchalleng(challenge),
    );
  }

  void btnGetchalleng(GetChallenge challenge) {
    String? challengeStartStr = challenge.challenge_start;
    String? challengeEndStr = challenge.challenge_end;

    if (challengeStartStr != null &&
        challengeStartStr.isNotEmpty &&
        challengeEndStr != null &&
        challengeEndStr.isNotEmpty) {
      DateTime dateStartChallenge =
          DateFormat('yyyy-MM-dd').parse(challengeStartStr);
      DateTime dateEndChallenge =
          DateFormat('yyyy-MM-dd').parse(challengeEndStr);
      DateTime currentDate =
          DateFormat('yyyy-MM-dd').parse(formattedDate); // Convert to DateTime

      print(currentDate.isAfter(dateStartChallenge));
      print(currentDate.isAtSameMomentAs(dateStartChallenge));

      if (mounted) {
        // ตรวจสอบว่ามี context อยู่หรือไม่
        if (currentDate.isAfter(dateStartChallenge) ||
            currentDate.isAtSameMomentAs(dateStartChallenge)) {
          if (challenge.challenge_status != 'doing' ||
              challenge.challenge_status != 'not_start') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChallengePage(
                  employee: widget.employee,
                  Authorization: widget.Authorization,
                  initialMinutes:
                      double.tryParse(challenge.challenge_duration) ?? 0,
                  getchallenge: challenge,
                ),
              ),
            );
          } else {
            showCustomDialog(context, challenge);
            // QuickAlert.show(
            //   context: context,
            //   type: QuickAlertType.confirm,
            //   title: '$AreYouReadyTS',
            //   width: MediaQuery.of(context).size.width > 600 ? 590 : 400,
            //   confirmBtnText: '$startTS',
            //   confirmBtnColor: Colors.blue,
            //   confirmBtnTextStyle: const TextStyle(
            //     fontSize: 18,
            //     color: Colors.white,
            //     fontWeight: FontWeight.w700,
            //   ),
            //   cancelBtnText: '$CancelTS',
            //   cancelBtnTextStyle: const TextStyle(
            //     fontSize: 18,
            //     color: Colors.grey,
            //     fontWeight: FontWeight.w700,
            //   ),
            //   customAsset: 'assets/images/learning/student.png',
            //   onConfirmBtnTap: () {
            //     if (mounted) {
            //       Navigator.pop(context); // ปิด QuickAlert ก่อน
            //       // ใช้ Navigator.push แทน pushReplacement
            //       Navigator.push(
            //         context,
            //         MaterialPageRoute(
            //           builder: (context) => ChallengePage(
            //             employee: widget.employee,
            //             Authorization: widget.Authorization,
            //             initialMinutes:
            //                 double.tryParse(challenge.challenge_duration) ?? 0,
            //             getchallenge: challenge,
            //           ),
            //         ),
            //       );
            //     }
            //   },
            //   widget: Column(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       SizedBox(height: 8),
            //       _textWidget('$challengeTS:', challenge.challenge_name),
            //       _textWidget(
            //           '$DescriptionTS:', challenge.challenge_description),
            //       _textWidget('$RuleTS:', challenge.challenge_rule),
            //       _textWidget(
            //           '$DurationTS ($MinTS):', challenge.challenge_duration),
            //       _textWidget('$PartTS:', challenge.challenge_question_part),
            //       _textWidget('$NumberQuestionsTS:',
            //           '${challenge.specific_question} $questionTS'),
            //     ],
            //   ),
            // );
          }
        } else {
          // Handle different cases
          final snackBarMessage = currentDate.isAfter(dateEndChallenge)
              ? "$SorryChallengeTS, $BeforeTS : ${dateStartChallenge}"
              : "$SorryChallengeTS, $AfterTS : ${dateStartChallenge}";

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                duration: const Duration(seconds: 2),
                content: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      snackBarMessage,
                      style: TextStyle(
                        fontFamily: 'Arial',
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        }
      }
    } else {
      print("challenge_start หรือ challenge_end เป็นค่า null หรือว่าง");
    }
  }

  void showCustomDialog(BuildContext context, GetChallenge challenge) {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissing by tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          title: Column(
            children: [
              Text(
                '$AreYouReadyTS', // Title of the dialog
                style: TextStyle(
                    fontFamily: 'Arial',
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              // SizedBox(height: ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  width: isMobile ? 400 : 580,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Image (similar to customAsset)
                      Image.asset(
                        'assets/images/learning/student.png',
                        height: 180,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                      SizedBox(height: 16),
                      _textWidget2('$challengeTS:', challenge.challenge_name),
                      _textWidget2(
                          '$DescriptionTS:', challenge.challenge_description),
                      _textWidget2('$RuleTS:', challenge.challenge_rule),
                      _textWidget2('$DurationTS ($MinTS):',
                          challenge.challenge_duration),
                      _textWidget2(
                          '$PartTS:', challenge.challenge_question_part),
                      _textWidget2('$NumberQuestionsTS:',
                          '${challenge.specific_question} $questionTS'),
                    ],
                  ),
                ),
              ),
            ],
          ),
          actions: [
            // Cancel Button
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: Text(
                '$CancelTS',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            // Confirm Button
            TextButton(
              onPressed: () {
                // Navigator.pop(context); // Close the dialog
                // Navigate to the next screen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChallengePage(
                      employee: widget.employee,
                      Authorization: widget.Authorization,
                      initialMinutes:
                          double.tryParse(challenge.challenge_duration) ?? 0,
                      getchallenge: challenge,
                    ),
                  ),
                );
              },
              child: Text(
                '$startTS',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.orange,
                  // fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

// Custom widget to display the text
  Widget _textWidget2(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontFamily: 'Arial',
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFF555555),
            ),
          ),
          SizedBox(width: 10),
          Expanded(
              child: Text(
            value,
            style: TextStyle(
              fontFamily: 'Arial',
              fontSize: 12,
              // fontWeight: FontWeight.w500,
              color: Color(0xFF555555),
            ),
          )),
        ],
      ),
    );
  }

  Widget _DropdownStatus(String value) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        border: Border.all(
          color: Colors.grey.shade300,
          width: 1.0,
        ),
      ),
      child: DropdownButton2<ModelDropdownAcademy>(
        isExpanded: true,
        hint: Text(
          value,
          style: TextStyle(
            fontFamily: 'Arial',
            color: Colors.grey,
            fontSize: 14,
          ),
        ),
        style: TextStyle(
          fontFamily: 'Arial',
          color: Colors.grey,
          fontSize: 14,
        ),
        items: _modelStatus
            .map((ModelDropdownAcademy status) =>
            DropdownMenuItem<ModelDropdownAcademy>(
              value: status,
              child: Text(
                status.name,
                style: TextStyle(
                  fontFamily: 'Arial',
                  fontSize: 14,
                ),
              ),
            ))
            .toList(),
        value: selectedStatus,
        onChanged: (value) {
          setState(() {
            selectedStatus = value;
          });
        },
        underline: SizedBox.shrink(),
        iconStyleData: IconStyleData(
          icon: Icon(Icons.arrow_drop_down,
              color: Color(0xFF555555), size: 30),
          iconSize: 30,
        ),
        buttonStyleData: ButtonStyleData(
          padding: const EdgeInsets.symmetric(vertical: 2),
        ),
        dropdownStyleData: DropdownStyleData(
          maxHeight: 200,
        ),
        menuItemStyleData: MenuItemStyleData(
          height: 33,
        ),
      ),
    );
  }

  ModelDropdownAcademy? selectedStatus;
  List<ModelDropdownAcademy> _modelStatus = [
    ModelDropdownAcademy(id: '001', name: 'All'),
    ModelDropdownAcademy(id: '001', name: 'Success'),
    ModelDropdownAcademy(id: '001', name: 'Doing'),
    ModelDropdownAcademy(id: '001', name: 'Timed Out'),
    ModelDropdownAcademy(id: '001', name: 'Not Start'),
  ];

  Future<List<GetChallenge>> fetchGetChallenge() async {
    final uri = Uri.parse("$host/api/origami/challenge/get-challenge.php");
    final response = await http.post(
      uri,
      headers: {'Authorization': 'Bearer ${widget.Authorization}'},
      body: {
        'comp_id': widget.employee.comp_id,
        'emp_id': widget.employee.emp_id,
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      // ตรวจสอบว่ามีคีย์ 'academy_data' และไม่เป็น null
      if (jsonResponse['code'] == 200) {
        final List<dynamic> challengeJson = jsonResponse['challenge_data'];
        return getChallenges =
            challengeJson.map((json) => GetChallenge.fromJson(json)).toList();
      } else {
        // หากไม่มีข้อมูลใน 'academy_data' ให้คืนค่าเป็นลิสต์ว่าง
        print('No challenge data available.');
        return [];
      }
    } else {
      throw Exception('Failed to load academies');
    }
  }
}

class GetChallenge {
  final String challenge_id;
  final String challenge_status;
  final String challenge_name;
  final String challenge_description;
  final String challenge_start;
  final String challenge_end;
  final String challenge_duration;
  final String specific_question;
  final String challenge_point_value;
  final String timer_start;
  final String timer_finish;
  final String challenge_rank;
  final String challenge_logo;
  final String request_id;
  final String status;
  final String start_date;
  final String end_date;
  final String challenge_rule;
  final String challenge_question_part;
  final String correct_answer;

  GetChallenge({
    required this.challenge_id,
    required this.challenge_status,
    required this.challenge_name,
    required this.challenge_description,
    required this.challenge_start,
    required this.challenge_end,
    required this.challenge_duration,
    required this.specific_question,
    required this.challenge_point_value,
    required this.timer_start,
    required this.timer_finish,
    required this.challenge_rank,
    required this.challenge_logo,
    required this.request_id,
    required this.status,
    required this.start_date,
    required this.end_date,
    required this.challenge_rule,
    required this.challenge_question_part,
    required this.correct_answer,
  });

  factory GetChallenge.fromJson(Map<String, dynamic> json) {
    return GetChallenge(
      challenge_id: json['challenge_id'] ?? '',
      challenge_status: json['challenge_status'] ?? '',
      challenge_name: json['challenge_name'] ?? '',
      challenge_description: json['challenge_description'] ?? '',
      challenge_start: json['challenge_start'] ?? '',
      challenge_end: json['challenge_end'] ?? '',
      challenge_duration: json['challenge_duration'] ?? '',
      specific_question: json['specific_question'] ?? '',
      challenge_point_value: json['challenge_point_value'] ?? '',
      timer_start: json['timer_start'] ?? '',
      timer_finish: json['timer_finish'] ?? '',
      challenge_rank: json['challenge_rank'] ?? '',
      challenge_logo: json['challenge_logo'] ?? '',
      request_id: json['request_id'] ?? '',
      status: json['status'] ?? '',
      start_date: json['start_date'] ?? '',
      end_date: json['end_date'] ?? '',
      challenge_rule: json['challenge_rule'] ?? '',
      challenge_question_part: json['challenge_question_part'] ?? '',
      correct_answer: json['correct_answer'] ?? '',
    );
  }
}
