import 'package:academy/welcome_to_academy/export.dart';
import 'package:http/http.dart' as http;
import 'challenge_test.dart';

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

class _ChallengeStartTimeState extends State<ChallengeStartTime> {
  late Future<List<GetChallenge>> futureChallenges;
  List<GetChallenge> allChallenges = [];
  List<GetChallenge> filteredChallenges = [];
  final TextEditingController _searchController = TextEditingController();

  bool _isMenu = false;

  @override
  void initState() {
    super.initState();
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

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      color: Colors.white,
      child: Column(
        children: [
          _buildSearchField(),
          Expanded(
            child: FutureBuilder<List<GetChallenge>>(
              future: futureChallenges,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                      child: Text(
                    'NOT FOUND DATA',
                    style: TextStyle(
                      fontFamily: 'Arial',
                      fontSize: 16.0,
                      color: const Color(0xFF555555),
                      fontWeight: FontWeight.w700,
                    ),
                  ));
                } else {
                  return SingleChildScrollView(
                      child: (_isMenu)
                          ? Container(
                              child: _challengeTable(filteredChallenges))
                          : (isAndroid || isIPhone)
                              ? Container(
                                  child: _challengeListSlim(filteredChallenges))
                              : Container(
                                  child:
                                      _challengeListBig(filteredChallenges)));
                }
              },
            ),
          ),
        ],
      ),
    ));
  }

  Widget _buildSearchField() {
    return Padding(
      padding: const EdgeInsets.only(left: 8, top: 8),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: _searchController,
              keyboardType: TextInputType.text,
              style: TextStyle(
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
                hintText: 'Search...',
                hintStyle: TextStyle(
                    fontFamily: 'Arial',
                    fontSize: 14,
                    color: Color(0xFF555555)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
                suffixIcon: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Icon(
                    Icons.search,
                    size: 24, // ขนาดไอคอน
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(100),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                _isMenu = !_isMenu;
              });
            },
            icon: Container(
              alignment: Alignment.centerRight,
              child: Icon(
                (_isMenu) ? Icons.list_alt_sharp : Icons.border_all_rounded,
                size: 36,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _challengeTable(List<GetChallenge> filteredChallenges) {
    return SingleChildScrollView(
      child: GridView.builder(
        padding: EdgeInsets.all(10),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: (isAndroid == true || isIPhone == true) ? 2 : 4,
          childAspectRatio: 0.75,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: filteredChallenges.length,
        itemBuilder: (BuildContext context, int index) {
          final challenge = filteredChallenges[index];
          return InkWell(
            onTap: () {
              QuickAlert.show(
                onCancelBtnTap: () {
                  Navigator.pop(context);
                },
                onConfirmBtnTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChallengePage(
                          employee: widget.employee,
                          Authorization: widget.Authorization,
                          initialMinutes:
                              double.parse(challenge.challenge_duration)),
                    ),
                  ).then((_) {
                    Navigator.pop(context);
                  });
                },
                context: context,
                type: QuickAlertType.confirm,
                title: 'Are you ready?', // ไม่ใช้ title ดั้งเดิม
                widget: Column(
                  children: [
                    SizedBox(height: 8),
                    _textWidget('Challenge:', challenge.challenge_name),
                    _textWidget(
                        'Description:', challenge.challenge_description),
                    _textWidget('Rule:', challenge.challenge_rule),
                    // Row(
                    //   children: [
                    //     Expanded(
                    //         child: _textWidget('Duration (Min):',
                    //             challenge.challenge_duration)),
                    //     Expanded(
                    //         child: _textWidget(
                    //             'Part:', challenge.challenge_question_part)),
                    //   ],
                    // ),
                    _textWidget(
                        'Duration (Min):', challenge.challenge_duration),
                    _textWidget('Part:', challenge.challenge_question_part),
                    _textWidget('Part:', challenge.challenge_question_part),
                    _textWidget('Number of questions:',
                        '${challenge.challenge_point_value} questions'),
                  ],
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: Card(
                      elevation: 0,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.network(
                          challenge.challenge_logo,
                          width: double.infinity,
                          fit: BoxFit.fitWidth,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(Icons.error);
                          },
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 4, right: 4),
                        child: Text(
                          challenge.challenge_name,
                          style: TextStyle(
                            fontFamily: 'Arial',
                            fontSize: 16.0,
                            color: Color(0xFF555555),
                            fontWeight: FontWeight.w700,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(4),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.check_box_outlined,
                                  color: Colors.amber,
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Expanded(
                                  child: Text(
                                    '0/0',
                                    style: TextStyle(
                                      fontFamily: 'Arial',
                                      color: Color(0xFF555555),
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                  ),
                                ),
                                Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Expanded(
                                  child: Text(
                                    '0/0',
                                    style: TextStyle(
                                      fontFamily: 'Arial',
                                      color: Color(0xFF555555),
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                FaIcon(
                                  FontAwesomeIcons.trophy,
                                  size: 20.0,
                                  color: Colors.amber,
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Expanded(
                                  child: Text(
                                    challenge.challenge_point_value,
                                    style: TextStyle(
                                      fontFamily: 'Arial',
                                      color: Color(0xFF555555),
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                  ),
                                ),
                                Icon(
                                  Icons.access_time,
                                  color: Colors.amber,
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Expanded(
                                  child: Text(
                                    challenge.challenge_duration,
                                    style: TextStyle(
                                      fontFamily: 'Arial',
                                      color: Color(0xFF555555),
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: Colors.white),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(4),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          '${challenge.challenge_start} - ${challenge.challenge_end}',
                                          style: TextStyle(
                                            fontFamily: 'Arial',
                                            color: Color(0xFF555555),
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                ],
              ),
            ),
          );
        },
        // Set the grid view to shrink wrap its contents.
        shrinkWrap: true,
        // Disable scrolling in the grid view.
        physics: NeverScrollableScrollPhysics(),
      ),
    );
  }

  Widget _textWidget0(String title, String subject) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontFamily: 'Arial',
                  fontSize: 14,
                  color: Colors.black54,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Expanded(
              child: Text(
                subject,
                style: TextStyle(
                  fontFamily: 'Arial',
                  fontSize: 14,
                  color: Colors.black45,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 2),
      ],
    );
  }

  Widget _textWidget(String title, String subject) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.text_snippet_outlined, color: Colors.black38),
            SizedBox(width: 4),
            Expanded(
              child: Column(
                children: [
                  Row(
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
                    ],
                  ),
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          subject,
                          style: TextStyle(
                            fontFamily: 'Arial',
                            fontSize: 14,
                            color: Colors.black45,
                          ),
                          maxLines: 6,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
      ],
    );
  }

  //android,iphone
  Widget _challengeListSlim(List<GetChallenge> filteredChallenges) {
    return Column(
      children: [
        const SizedBox(height: 8),
        Column(
          children: List.generate(filteredChallenges.length, (index) {
            final challenge = filteredChallenges[index];
            return Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
              child: InkWell(
                onTap: () {
                  QuickAlert.show(
                    onCancelBtnTap: () {
                      Navigator.pop(context);
                    },
                    onConfirmBtnTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChallengePage(
                              employee: widget.employee,
                              Authorization: widget.Authorization,
                              initialMinutes:
                                  double.parse(challenge.challenge_duration)),
                        ),
                      ).then((_) {
                        Navigator.pop(context);
                      });
                    },
                    context: context,
                    type: QuickAlertType.confirm,
                    title: 'Are you ready?', // ไม่ใช้ title ดั้งเดิม
                    widget: Column(
                      children: [
                        SizedBox(height: 8),
                        _textWidget('Challenge:', challenge.challenge_name),
                        _textWidget(
                            'Description:', challenge.challenge_description),
                        _textWidget('Rule:', challenge.challenge_rule),
                        _textWidget(
                            'Duration (Min):', challenge.challenge_duration),
                        _textWidget('Part:', challenge.challenge_question_part),
                        _textWidget('Number of questions:',
                            '${challenge.challenge_point_value} questions'),
                      ],
                    ),
                  );
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const SizedBox(width: 8),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Image.network(
                            challenge.challenge_logo,
                            width: 80,
                            height: 80,
                            fit: BoxFit.fitWidth,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(Icons.error);
                            },
                          ),
                        ),
                        Expanded(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                const SizedBox(width: 14),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      challenge.challenge_name,
                                      style: TextStyle(
                                        fontFamily: 'Arial',
                                        color: const Color(0xFF555555),
                                        // fontSize: 64,
                                        fontWeight: FontWeight.w700,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      'Start : ${challenge.challenge_start}',
                                      style: TextStyle(
                                        fontFamily: 'Arial',
                                        color: const Color(0xFF555555),
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      'End : ${challenge.challenge_end}',
                                      style: TextStyle(
                                        fontFamily: 'Arial',
                                        color: const Color(0xFF555555),
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Divider(),
                  ],
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  //tablet, ipad
  Widget _challengeListBig(List<GetChallenge> filteredChallenges) {
    return Column(
      children: [
        const SizedBox(height: 8),
        Column(
          children: List.generate(filteredChallenges.length, (index) {
            final challenge = filteredChallenges[index];
            return Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
              child: InkWell(
                onTap: () {
                  QuickAlert.show(
                    onCancelBtnTap: () {
                      Navigator.pop(context);
                    },
                    onConfirmBtnTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChallengePage(
                              employee: widget.employee,
                              Authorization: widget.Authorization,
                              initialMinutes:
                                  double.parse(challenge.challenge_duration)),
                        ),
                      ).then((_) {
                        Navigator.pop(context);
                      });
                    },
                    context: context,
                    type: QuickAlertType.confirm,
                    title: 'Are you ready?', // ไม่ใช้ title ดั้งเดิม
                    widget: Column(
                      children: [
                        SizedBox(height: 8),
                        _textWidget('Challenge:', challenge.challenge_name),
                        _textWidget(
                            'Description:', challenge.challenge_description),
                        _textWidget('Rule:', challenge.challenge_rule),
                        _textWidget(
                            'Duration (Min):', challenge.challenge_duration),
                        _textWidget('Part:', challenge.challenge_question_part),
                        _textWidget('Number of questions:',
                            '${challenge.challenge_point_value} questions'),
                      ],
                    ),
                  );
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Row(
                        children: [
                          const SizedBox(width: 8),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: Color(0xFF555555), // สีขอบ
                                width: 0.2, // ความหนาของขอบ
                              ),
                            ),
                            child: Image.network(
                              challenge.challenge_logo,
                              width: 200,
                              height: 200,
                              // fit: BoxFit.fitWidth
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(Icons.error);
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  challenge.challenge_name,
                                  style: TextStyle(
                                    fontFamily: 'Arial',
                                    color: const Color(0xFF555555),
                                    fontSize: 28,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                ),
                                Text(
                                  'Start : ${challenge.challenge_start}',
                                  style: TextStyle(
                                    fontFamily: 'Arial',
                                    fontSize: 18,
                                    color: const Color(0xFF555555),
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                                SizedBox(height: 8),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Divider(),
                  ],
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

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
        return challengeJson
            .map((json) => GetChallenge.fromJson(json))
            .toList();
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
  final String start_date;
  final String end_date;
  final String challenge_rule;
  final String challenge_question_part;

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
    required this.start_date,
    required this.end_date,
    required this.challenge_rule,
    required this.challenge_question_part,
  });

  factory GetChallenge.fromJson(Map<String, dynamic> json) {
    return GetChallenge(
      challenge_id: json['challenge_id'],
      challenge_status: json['challenge_status'],
      challenge_name: json['challenge_name'],
      challenge_description: json['challenge_description'],
      challenge_start: json['challenge_start'],
      challenge_end: json['challenge_end'],
      challenge_duration: json['challenge_duration'],
      specific_question: json['specific_question'],
      challenge_point_value: json['challenge_point_value'],
      timer_start: json['timer_start'],
      timer_finish: json['timer_finish'],
      challenge_rank: json['challenge_rank'],
      challenge_logo: json['challenge_logo'],
      request_id: json['request_id'],
      start_date: json['start_date'],
      end_date: json['end_date'],
      challenge_rule: json['challenge_rule'],
      challenge_question_part: json['challenge_question_part'],
    );
  }
}
