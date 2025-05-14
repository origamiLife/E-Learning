import 'package:academy/welcome_to_academy/export.dart';
import '../../academy.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class Instructors extends StatefulWidget {
  Instructors({
    super.key,
    required this.employee,
    required this.academy,
    required this.Authorization,
  });
  final Employee employee;
  final AcademyModel academy;
  final String Authorization;
  @override
  _InstructorsState createState() => _InstructorsState();
}

class _InstructorsState extends State<Instructors> {
  bool isSwitch = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<InstructorModel>>(
      future: fetchInstructors(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                color: Color(0xFFFF9900),
              ),
              SizedBox(
                width: 12,
              ),
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
              color: const Color(0xFF555555),
              fontWeight: FontWeight.w700,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ));
        } else {
          return _getContentWidget(snapshot.data!);
        }
      },
    );
  }

  Widget _getContentWidget(List<InstructorModel> instructors) {
    return SafeArea(
      child: Container(
        color: Colors.grey.shade50,
        child: Padding(
          padding: const EdgeInsets.only(left: 8, right: 8),
          child: SingleChildScrollView(
            child: Column(
              children: List.generate(instructors.length, (index) {
                final instructor = instructors[index];
                return Column(
                  children: [
                    InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: () {
                        setState(() {
                          (isSwitch == false)
                              ? isSwitch = true
                              : isSwitch = false;
                        });
                      },
                      child: (isSwitch == true)
                          ? Container(
                              padding: EdgeInsets.all(8),
                              // color: Colors.transparent,
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      instructor.course_name,
                                      style: TextStyle(
                                        fontFamily: 'Arial',
                                        fontSize: 16,
                                        color: Color(0xFF555555),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 4,
                                  ),
                                  Icon(
                                    Icons.keyboard_arrow_down,
                                    color: Color(0xFF555555),
                                    // size: 30,
                                  )
                                ],
                              ),
                            )
                          : Container(
                              padding: EdgeInsets.all(8),
                              // color: Colors.transparent,
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                // crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Text(
                                      instructor.course_name,
                                      style: TextStyle(
                                        fontFamily: 'Arial',
                                        fontSize: 16,
                                        color: Color(0xFF555555),
                                        fontWeight: FontWeight.w500,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 4,
                                  ),
                                  Icon(
                                    Icons.keyboard_arrow_down,
                                    color: Color(0xFF555555),
                                    // size: 30,
                                  )
                                ],
                              ),
                            ),
                    ),
                    Column(
                      children:
                          List.generate(instructor.coach_data.length, (indexI) {
                        final coach_data = instructor.coach_data[indexI];
                        return (isSwitch == false)
                            ? Card(
                                color: Color(0xFFF5F5F5),
                                child: InkWell(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
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
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            flex: isMobile ? 2 : 1,
                                            child: Image.network(
                                              coach_data.coach_image,
                                              height: (isMobile) ? 120 : 180,
                                              width: double.infinity,
                                              fit: BoxFit.contain,
                                              errorBuilder:
                                                  (context, error, stackTrace) {
                                                return Image.network(
                                                  coach_data.coach_image_error,
                                                  height:
                                                      (isMobile) ? 120 : 180,
                                                  width: double.infinity,
                                                  fit: BoxFit.contain,
                                                );
                                              },
                                            ),
                                          ),
                                          SizedBox(
                                            width: 8,
                                          ),
                                          Expanded(
                                            flex: (isMobile) ? 3 : 5,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  coach_data.coach_name,
                                                  style: TextStyle(
                                                    fontFamily: 'Arial',
                                                    fontSize: 16.0,
                                                    color: Color(0xFF555555),
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                  maxLines: 2,
                                                ),
                                                SizedBox(height: 8),
                                                Row(
                                                  children: [
                                                    Icon(
                                                      Icons.work_outline,
                                                      color: Colors.amber,
                                                      size: 20,
                                                    ),
                                                    SizedBox(
                                                      width: 8,
                                                    ),
                                                    Flexible(
                                                      child: Text(
                                                        coach_data
                                                            .coach_position,
                                                        style: TextStyle(
                                                          fontFamily: 'Arial',
                                                          fontSize: 14.0,
                                                          color:
                                                              Color(0xFF555555),
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                        maxLines: 2,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(height: 8),
                                                Row(
                                                  children: [
                                                    FaIcon(
                                                      FontAwesomeIcons.building,
                                                      color: Colors.amber,
                                                      size: 20,
                                                    ),
                                                    SizedBox(
                                                      width: 8,
                                                    ),
                                                    Flexible(
                                                      child: Text(
                                                        coach_data
                                                            .coach_academy,
                                                        style: TextStyle(
                                                          fontFamily: 'Arial',
                                                          color:
                                                              Color(0xFF555555),
                                                        ),
                                                        maxLines: 2,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(height: 8),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child:
                                                          SingleChildScrollView(
                                                        scrollDirection:
                                                            Axis.horizontal,
                                                        child: Row(
                                                          children: [
                                                            Icon(
                                                              Icons
                                                                  .people_alt_outlined,
                                                              color:
                                                                  Colors.amber,
                                                            ),
                                                            SizedBox(
                                                              width: 4,
                                                            ),
                                                            Text(
                                                              '${coach_data.coach_student} Students',
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    'Arial',
                                                                color: Color(
                                                                    0xFF555555),
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child:
                                                          SingleChildScrollView(
                                                        scrollDirection:
                                                            Axis.horizontal,
                                                        child: Row(
                                                          children: [
                                                            Icon(
                                                              Icons
                                                                  .bookmark_border,
                                                              color:
                                                                  Colors.amber,
                                                            ),
                                                            SizedBox(
                                                              width: 4,
                                                            ),
                                                            Text(
                                                              '${coach_data.coach_course} Courses',
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    'Arial',
                                                                color: Color(
                                                                    0xFF555555),
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : Container();
                      }),
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Divider(),
                  ],
                );
              }),
            ),
          ),
        ),
      ),
    );
  }

  Future<List<InstructorModel>> fetchInstructors() async {
    final uri =
        Uri.parse("$host/api/origami/e-learning/academy/study/instructors.php");
    final response = await http.post(
      uri,
      headers: {'Authorization': 'Bearer $authorization'},
      body: {
        'auth_password': authorization,
        'academy_id': widget.academy.academy_id,
        'academy_type': widget.academy.academy_type,
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      // เข้าถึงข้อมูลในคีย์ 'instructors'
      final List<dynamic> instructorsJson = jsonResponse['instructors_data'];
      // แปลงข้อมูลจาก JSON เป็น List<Instructor>
      return instructorsJson
          .map((json) => InstructorModel.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to load instructors');
    }
  }
}

class InstructorModel {
  final String course_name;
  final List<InstructorsData> coach_data;

  InstructorModel({required this.course_name, required this.coach_data});

  factory InstructorModel.fromJson(Map<String, dynamic> json) {
    return InstructorModel(
      course_name: json['course_name'] ?? '',
      coach_data: (json['coach_data'] as List)
          .map((statusJson) => InstructorsData.fromJson(statusJson))
          .toList(),
    );
  }
}

class InstructorsData {
  final String coach_name;
  final String coach_image;
  final String coach_image_error;
  final String coach_academy;
  final String coach_position;
  final String coach_student;
  final String coach_course;

  InstructorsData({
    required this.coach_name,
    required this.coach_image,
    required this.coach_image_error,
    required this.coach_academy,
    required this.coach_position,
    required this.coach_student,
    required this.coach_course,
  });

  factory InstructorsData.fromJson(Map<String, dynamic> json) {
    return InstructorsData(
      coach_name: json['coach_name'] ?? '',
      coach_image: json['coach_image'] ?? '',
      coach_image_error: json['coach_image_error'] ?? '',
      coach_academy: json['coach_academy'] ?? '',
      coach_position: json['coach_position'] ?? '',
      coach_student: json['coach_student'] ?? '',
      coach_course: json['coach_course'] ?? '',
    );
  }
}
