import 'package:academy/welcome_to_academy/export.dart';
import 'package:http/http.dart' as http;
import 'challenge_test.dart';
import 'package:intl/intl.dart';

class ChallengeStartTime extends StatefulWidget {
  const ChallengeStartTime({
    super.key,
    required this.employee,
    required this.Authorization,
    required this.logo,
  });
  final Employee employee;
  final String Authorization;
  final String logo;

  @override
  _ChallengeStartTimeState createState() => _ChallengeStartTimeState();
}

class _ChallengeStartTimeState extends State<ChallengeStartTime>
    with WidgetsBindingObserver {
  final TextEditingController _searchController = TextEditingController();
  Map<String, String> statusOptions = {};
  String formattedDate = '';
  @override
  void initState() {
    super.initState();
    DateTime now = DateTime.now();
    formattedDate = DateFormat('yyyy-MM-dd').format(now);
    WidgetsBinding.instance.addObserver(this);
    loadLevelsStatus();
  }

  Future<void> loadLevelsStatus() async {
    final statusdata = await fetchStatusData();
    if (statusdata != null) {
      setState(() {
        statusOptions = statusdata.level_data;
      });
    }
  }

  // ✅ ปิด Controller ใน dispose()
  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 8, top: 4, bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(flex: 3, child: _buildSearchField()),
                Expanded(flex: 1, child: _DropdownStatus('Status')),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 8, right: 8),
              child: FutureBuilder<List<GetChallenge>>(
                future: fetchGetChallenge(),
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
                      child: Column(
                        children: [
                          _challengeListSlim(challengeList),
                          (current_page == total_pages)
                              ? Container()
                              : Column(
                                  children: [
                                    Divider(),
                                    Row(
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            if (current_page > 1) {
                                              setState(() {
                                                pages = (current_page - 1)
                                                    .toString();
                                              });
                                            }
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8,
                                                right: 8,
                                                top: 8,
                                                bottom: 12),
                                            child: Text(
                                              'ก่อนหน้า',
                                              style: TextStyle(
                                                fontFamily: 'Arial',
                                                fontSize: 16.0,
                                                color: (current_page <= 1)
                                                    ? Colors.grey
                                                    : Color(0xFF555555),
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Spacer(),
                                        InkWell(
                                          onTap: () {
                                            if (current_page >= total_pages) {
                                              setState(() {
                                                pages = (current_page + 1)
                                                    .toString();
                                              });
                                            }
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8,
                                                right: 8,
                                                top: 8,
                                                bottom: 12),
                                            child: Text(
                                              'ถัดไป',
                                              style: TextStyle(
                                                fontFamily: 'Arial',
                                                fontSize: 16.0,
                                                color: (current_page <=
                                                        total_pages)
                                                    ? Colors.grey
                                                    : Color(0xFF555555),
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                        ],
                      ),
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
                    fontSize: 14,
                    color: Colors.black54,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  subject,
                  style: TextStyle(
                    fontFamily: 'Arial',
                    fontSize: 14,
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
          // onTap: () => btnGetchalleng(challenge),
          onTap: () {
            if (challenge.challenge_status != 'doing' ||
                challenge.challenge_status != 'not_start') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChallengePage(
                    employee: widget.employee,
                    Authorization: widget.Authorization,
                    initialMinutes:
                        double.tryParse(challenge.challenge_minute) ?? 0,
                    getchallenge: challenge,
                    logo: widget.logo,
                  ),
                ),
              );
            }
          },
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
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                            challenge.challenge_cover,
                            height: 100,
                            width: 100,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Image.network(
                                  challenge.challenge_cover_error,
                                  height: 100,
                                  width: 100,
                                  fit: BoxFit.cover);
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
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF555555),
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '$startTS: ${challenge.challenge_start}',
                            style: const TextStyle(
                              fontFamily: 'Arial',
                              fontSize: 14,
                              color: Color(0xFF555555),
                              fontWeight: FontWeight.w500,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '$endTS: ${challenge.challenge_end}',
                            style: const TextStyle(
                              fontFamily: 'Arial',
                              fontSize: 14,
                              color: Color(0xFF555555),
                              fontWeight: FontWeight.w500,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            (challenge.challenge_status == 'success')
                                ? successTS
                                : (challenge.challenge_status == 'time_out')
                                    ? timeoutTS
                                    : (challenge.challenge_status ==
                                            'not_start')
                                        ? notStartTS
                                        : doingTS,
                            style: TextStyle(
                              fontFamily: 'Arial',
                              fontSize: 14,
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
          // onTap: () => btnGetchalleng(challenge),
          onTap: () {
            if (challenge.challenge_status != 'doing' ||
                challenge.challenge_status != 'not_start') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChallengePage(
                    employee: widget.employee,
                    Authorization: widget.Authorization,
                    initialMinutes:
                        double.tryParse(challenge.challenge_minute) ?? 0,
                    getchallenge: challenge,
                    logo: widget.logo,
                  ),
                ),
              );
            }
          },
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
                            challenge.challenge_cover,
                            width: double.infinity,
                            height: 180,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Image.network(challenge.challenge_cover_error,
                                    width: double.infinity,
                                    height: 180,
                                    fit: BoxFit.cover),
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
                                    : (challenge.challenge_status ==
                                            'not_start')
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

  // void _showChallengeDialog(
  //     BuildContext context, GetChallenge challenge, GetChallenge challeng2) {
  //   QuickAlert.show(
  //     context: context,
  //     type: QuickAlertType.confirm,
  //     // customAsset: 'assets/images/learning/img.png',
  //     width: MediaQuery.of(context).size.width > 600 ? 590 : 400,
  //     title: '$AreYouReadyTS',
  //     confirmBtnText: '$startTS',
  //     confirmBtnColor: Colors.blue,
  //     customAsset: 'assets/images/learning/student.png',
  //     confirmBtnTextStyle: const TextStyle(
  //       fontSize: 18,
  //       color: Colors.white,
  //       fontWeight: FontWeight.w700,
  //     ),
  //     cancelBtnText: '$CancelTS',
  //     cancelBtnTextStyle: const TextStyle(
  //       fontSize: 18,
  //       color: Colors.grey,
  //       fontWeight: FontWeight.w700,
  //     ),
  //     widget: Column(
  //       children: [
  //         const SizedBox(height: 8),
  //         _textWidget('$challengeTS:', challenge.challenge_name),
  //         _textWidget('$DescriptionTS:', challenge.challenge_description),
  //         _textWidget('$RuleTS:', challenge.challenge_rule),
  //         _textWidget('$DurationTS ($MinTS):', challenge.challenge_duration),
  //         _textWidget('$PartTS:', challenge.challenge_question_part),
  //         _textWidget('$NumberQuestionsTS:',
  //             '${challenge.specific_question} $questionTS'),
  //       ],
  //     ),
  //     onCancelBtnTap: () => Navigator.pop(context),
  //     onConfirmBtnTap: () => btnGetchalleng(challenge),
  //   );
  // }

  void btnGetchalleng(GetChallenge challenge) {
    String? challengeStartStr = challenge.challenge_start;
    String? challengeEndStr = challenge.challenge_end;

    if (challengeStartStr.isNotEmpty && challengeEndStr.isNotEmpty) {
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
                      double.tryParse(challenge.challenge_minute) ?? 0,
                  getchallenge: challenge,
                  logo: widget.logo,
                ),
              ),
            );
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

  Widget _DropdownStatus(String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
              border: Border.all(
                color: Colors.grey.shade300,
                width: 1.0,
              ),
            ),
            child: DropdownButton2<String>(
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
              value: challenge_status,
              items: statusOptions.entries.map((entry) {
                return DropdownMenuItem<String>(
                  value: entry.key,
                  child: Text(
                    entry.value,
                    style: TextStyle(
                      fontFamily: 'Arial',
                      fontSize: 14,
                    ),
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  challenge_status = value;
                  print('$challenge_status');
                  fetchGetChallenge();
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
            )),
        SizedBox(height: 8),
      ],
    );
  }

  String search = '';
  String pages = '';
  int total_items = 0;
  int total_pages = 0;
  int current_page = 0;
  String? challenge_status;
  Future<List<GetChallenge>> fetchGetChallenge() async {
    print('$challenge_status : $search : $pages');
    final uri =
        Uri.parse("$host/api/origami/e-learning/challenge/my-challenge.php");
    final response = await http.post(
      uri,
      headers: {'Authorization': 'Bearer $authorization'},
      body: {
        'auth_password': authorization,
        'emp_id': widget.employee.emp_id,
        'comp_id': widget.employee.comp_id,
        'challenge_status': challenge_status ?? '',
        'search': search,
        'page': (search != '') ? '1' : pages,
      },
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      // ตรวจสอบว่ามีคีย์ 'academy_data' และไม่เป็น null
      if (jsonResponse['status'] == 200) {
        final List<dynamic> challengeJson = jsonResponse['challenge_data'];
        total_items = jsonResponse['total_items']; // จำนวนทั้งหมด
        total_pages = jsonResponse['total_pages']; // หน้าทั้งหมด
        current_page = jsonResponse['current_page']; // หน้าปัจจุบัน
        return challengeJson
            .map((json) => GetChallenge.fromJson(json))
            .toList();
      } else {
        print('No challenge data available.');
        return [];
      }
    } else {
      throw Exception('Failed to load academies');
    }
  }

  Future<LevelData?> fetchStatusData() async {
    final uri = Uri.parse("$host/api/origami/e-learning/challenge/status.php");
    try {
      final response = await http.post(
        uri,
        headers: {'Authorization': 'Bearer $authorization'},
        body: {'auth_password': authorization},
      );
      if (response.statusCode == 200) {
        return LevelData.fromJson(json.decode(response.body));
      }
      return null;
    } catch (e) {
      print('Error fetching question data: $e');
      throw Exception('Error fetching question data: $e');
    }
  }
}

class GetChallenge {
  final String challenge_id;
  final String request_id;
  final String challenge_name;
  final String challenge_start;
  final String challenge_end;
  final String challenge_question;
  final String challenge_correct;
  final String challenge_point;
  final String challenge_time_used;
  final String challenge_cover;
  final String challenge_cover_error;
  final String challenge_status;
  final String challenge_minute;

  GetChallenge({
    required this.challenge_id,
    required this.request_id,
    required this.challenge_name,
    required this.challenge_start,
    required this.challenge_end,
    required this.challenge_question,
    required this.challenge_correct,
    required this.challenge_point,
    required this.challenge_time_used,
    required this.challenge_cover,
    required this.challenge_cover_error,
    required this.challenge_status,
    required this.challenge_minute,
  });

  factory GetChallenge.fromJson(Map<String, dynamic> json) {
    return GetChallenge(
      challenge_id: json['challenge_id'] ?? '',
      request_id: json['request_id'] ?? '',
      challenge_name: json['challenge_name'] ?? '',
      challenge_start: json['challenge_start'] ?? '',
      challenge_end: json['challenge_end'] ?? '',
      challenge_question: json['challenge_question'] ?? '',
      challenge_correct: json['challenge_correct'] ?? '',
      challenge_point: json['challenge_point'] ?? '',
      challenge_time_used: json['challenge_time_used'] ?? '',
      challenge_cover: json['challenge_cover'] ?? '',
      challenge_cover_error: json['challenge_cover_error'] ?? '',
      challenge_status: json['challenge_status'] ?? '',
      challenge_minute: json['challenge_minute'] ?? '',
    );
  }
}
