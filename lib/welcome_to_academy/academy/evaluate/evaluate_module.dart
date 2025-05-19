import 'package:academy/welcome_to_academy/export.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;

import 'announcements/announcements.dart';
import 'attach_file/attach_file.dart';
import 'certification/certification.dart';
import 'curriculum/curriculum.dart';
import 'description/description.dart';
import 'discussion/discussion.dart';
import 'instructors/instructors.dart';

class EvaluateModule extends StatefulWidget {
  EvaluateModule({
    super.key,
    required this.employee,
    required this.academy,
    this.callback,
    this.selectedPage,
    required this.Authorization,
  });
  final Employee employee;
  final AcademyModel academy;
  final VoidCallback? callback;
  final int? selectedPage;
  final String Authorization;

  @override
  _EvaluateModuleState createState() => _EvaluateModuleState();
}

class _EvaluateModuleState extends State<EvaluateModule>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _commentControllerA = TextEditingController();
  final TextEditingController _commentControllerB = TextEditingController();

  bool isScrollable = true;
  bool showNextIcon = false;
  bool showBackIcon = false;
  bool _isClick = false;
  String _commentA = "";
  String _commentB = "";

  // Future<Map<String, dynamic>> getAllAcademyData() async {
  //   try {
  //     final uri = Uri.parse("$host/api/origami/academy/academy.php");
  //     final response = await http.post(
  //       uri,
  //       headers: {'Authorization': 'Bearer ${widget.Authorization}'},
  //       body: {
  //         'comp_id': widget.employee.comp_id,
  //         'emp_id': widget.employee.emp_id,
  //         'Authorization': widget.Authorization,
  //         'academy_id': widget.academy.academy_id,
  //         'academy_type': widget.academy.academy_type,
  //       },
  //     );
  //
  //     if (response.statusCode == 200) {
  //       // แปลงข้อมูล JSON เป็น Map
  //       final Map<String, dynamic> jsonResponse = json.decode(response.body);
  //
  //       // ดึงข้อมูลจาก JSON
  //       HeaderData headerData =
  //           HeaderData.fromJson(jsonResponse['header_data']);
  //       FastView fastView = FastView.fromJson(jsonResponse['fastview_data']);
  //
  //       // ส่งข้อมูลกลับเป็น Map
  //       return {
  //         'headerData': headerData,
  //         'fastView': fastView,
  //       };
  //     } else {
  //       print('Failed to load academy data');
  //       throw Exception('Failed to load academies');
  //     }
  //   } catch (e) {
  //     print('Error: $e');
  //     throw Exception('Error: $e');
  //   }
  // }

  String URL = '';
  String imageUrl = '';

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.selectedPage ?? 0;
    _tabController = TabController(
        length: _tabs.length, vsync: this, initialIndex: _selectedIndex);
    if (widget.academy.academy_favorite == 'Y') {
      _isClick = true;
    } else {
      _isClick = false;
    }
    _commentControllerA.addListener(() {
      _commentA = _commentControllerA.text;
      print("Current text: ${_commentControllerA.text}");
    });
    _commentControllerB.addListener(() {
      _commentB = _commentControllerB.text;
      print("Current text: ${_commentControllerB.text}");
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        // elevation: 1,
        foregroundColor: Colors.white,
        backgroundColor: Color(0xFFFF9900),
        title: Text(
          '$academyTS',
          style: TextStyle(
            fontFamily: 'Arial',
            fontSize: 24,
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
            size: 24,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: FutureBuilder<HeaderData>(
        future: fetchHeader(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final headerData = snapshot.data!;
            return _Head(headerData);
          } else {
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
          }
        },
      ),
    );
  }

  Widget _Head(HeaderData headerData) {
    return Center(
      child: FutureBuilder<FastView>(
        future: fetchFastView(), // เรียกใช้ฟังก์ชัน API
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
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
          } else {
            final fastView = snapshot.data!;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _headerMobile(headerData, fastView),
                Expanded(child: _bodyAcademy()),
              ],
            );
          }
        },
      ),
    );
  }

  Widget _headerMobile(HeaderData headerData, FastView fastView) {
    return Column(
      children: [
        Container(
          color: Colors.white,
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16, right: 4, top: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              headerData.topic_name,
                              style: TextStyle(
                                fontFamily: 'Arial',
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF555555),
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                          ),
                          CircleAvatar(
                            radius: 16,
                            backgroundColor: _isClick
                                ? Colors.red.shade100
                                : Colors.grey.shade100,
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  widget.callback!();
                                  _isClick = !_isClick;
                                });
                              },
                              child: Icon(Icons.favorite,
                                  color: _isClick
                                      ? Colors.red
                                      : Colors.grey.shade500,
                                  size: 22),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        headerData.topic_description,
                        style: TextStyle(
                          fontFamily: 'Arial',
                          fontSize: 14,
                          color: Color(0xFF555555),
                          fontWeight: FontWeight.w500,
                        ),
                        strutStyle: StrutStyle(fontSize: 16, height: 1.5),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 8),
                Card(
                  color: Colors.white,
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: InkWell(
                    child: Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade50,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 2,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(
                                    fastView.fastview_cover,
                                    width: double.infinity,
                                    height: 120,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Image.network(
                                        widget.employee.comp_logo,
                                        width: double.infinity,
                                        height: 120,
                                        fit: BoxFit.cover,
                                      );
                                    },
                                  ),
                                ),
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                flex: 3,
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        fastView.fastview_text,
                                        style: TextStyle(
                                          fontFamily: 'Arial',
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xFF555555),
                                        ),
                                        strutStyle: StrutStyle(
                                            fontSize: 14, height: 1.5),
                                      ),
                                      SizedBox(height: 6),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 8),
                                        child: InkWell(
                                          onTap: () {},
                                          child: Container(
                                            alignment: Alignment.center,
                                            width: double.infinity,
                                            padding: const EdgeInsets.only(
                                                left: 24,
                                                right: 24,
                                                top: 10,
                                                bottom: 10),
                                            decoration: BoxDecoration(
                                              color: Colors.orange,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Text(
                                              fastView.fastview_button_text,
                                              style: TextStyle(
                                                fontFamily: 'Arial',
                                                fontSize: 14,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    children: [
                      _infoRow(Icons.video_collection_outlined,
                          '${headerData.video_count} Video'),
                      Text(
                        '|',
                        style: TextStyle(
                          fontFamily: 'Arial',
                          fontSize: 16,
                          color: Color(0xFF555555),
                        ),
                      ),
                      _infoRow(
                          Icons.access_time, '${headerData.video_duration}'),
                      Text(
                        '|',
                        style: TextStyle(
                          fontFamily: 'Arial',
                          fontSize: 16,
                          color: Color(0xFF555555),
                        ),
                      ),
                      _infoRow(Icons.bookmark_border, headerData.category_name),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Divider(),
        TabBar(
          indicatorColor: Colors.orange,
          labelColor: Colors.orange,
          labelStyle: const TextStyle(
            fontFamily: 'Arial',
            fontSize: 14,
            color: Colors.grey,
            fontWeight: FontWeight.w500,
          ),
          unselectedLabelColor: Colors.grey,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          controller: _tabController,
          isScrollable: true,
          tabs: _tabs.map((tab) => Tab(text: tab)).toList(),
        ),
      ],
    );
  }

  Widget _headerMobileN(HeaderData headerData, FastView fastView) {
    final widthArea = WidgetsBinding.instance.window.physicalSize.width /
        WidgetsBinding.instance.window.devicePixelRatio;
    return Column(
      children: [
        Container(
          color: Colors.white,
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Stack(
              children: [
                SizedBox(
                  height: 400,
                  child: Padding(
                    padding: EdgeInsets.only(left: 8, right: 4, top: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.orange.shade100,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.4),
                                spreadRadius: 0,
                                blurRadius: 0.5,
                                offset: Offset(0, 1), // x, y
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 16, top: 16, bottom: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(width: widthArea * 1),
                                SizedBox(
                                  width: widthArea * 0.65,
                                  child: Text(
                                    widget.academy.academy_name,
                                    style: TextStyle(
                                      fontFamily: 'Arial',
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF555555),
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                  ),
                                ),
                                SizedBox(height: 16),
                                SizedBox(
                                  width: widthArea * 0.3,
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: 140),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          widget.academy.academy_name,
                                          style: TextStyle(
                                            fontFamily: 'Arial',
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            color: Color(0xFF555555),
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                TextButton(
                                    onPressed: () {
                                      setState(() {
                                        widget.callback!();
                                        _isClick = !_isClick;
                                      });
                                    },
                                    child: Container(
                                      width: widthArea * 0.12,
                                      decoration: BoxDecoration(
                                        color: _isClick
                                            ? Colors.white
                                            : Colors.grey.shade200,
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                          color: _isClick
                                              ? Colors.red
                                              : Colors.orange, // สีขอบ
                                          width: 2.0, // ความหนาของขอบ
                                        ),
                                        // border: Border(
                                        //   bottom: BorderSide(color: Colors.orange, width: 2),
                                        // )
                                      ),
                                      padding: EdgeInsets.all(8),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Favorite',
                                            style: TextStyle(
                                              fontFamily: 'Arial',
                                              fontSize: 16,
                                              color: _isClick
                                                  ? Colors.red
                                                  : Colors.orange,
                                            ),
                                          ),
                                          SizedBox(width: 4),
                                          Icon(Icons.favorite,
                                              color: _isClick
                                                  ? Colors.red
                                                  : Colors.orange,
                                              size: 22),
                                        ],
                                      ),
                                    )),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            top: 16,
                            bottom: 8,
                            left: 8,
                            right: widthArea * 0.3,
                          ),
                          child: Row(
                            children: [
                              _infoRow(Icons.video_collection_outlined,
                                  '${headerData.video_count} Video'),
                              Text(
                                '|',
                                style: TextStyle(
                                  fontFamily: 'Arial',
                                  fontSize: 16,
                                  color: Color(0xFF555555),
                                ),
                              ),
                              _infoRow(Icons.access_time,
                                  '${headerData.video_duration}'),
                              Text(
                                '|',
                                style: TextStyle(
                                  fontFamily: 'Arial',
                                  fontSize: 16,
                                  color: Color(0xFF555555),
                                ),
                              ),
                              _infoRow(Icons.bookmark_border,
                                  headerData.category_name),
                            ],
                          ),
                        ),
                        Divider()
                      ],
                    ),
                  ),
                ),
                Positioned(
                  right: 8,
                  top: 16,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.3,
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color:
                                _isClick ? Colors.red : Colors.orange, // สีขอบ
                            width: 2.0, // ความหนาของขอบ
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(
                                  fastView.fastview_cover,
                                  width: double.infinity,
                                  height: 170,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              SizedBox(height: 4),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    fastView.fastview_text,
                                    style: TextStyle(
                                      fontFamily: 'Arial',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFF555555),
                                    ),
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: 6),
                                  // Row(
                                  //   children: [
                                  //     Text(
                                  //       "$startTS: ",
                                  //       style: TextStyle(
                                  //         fontFamily: 'Arial',
                                  //         fontSize: (isMobile) ? 12 : 16,
                                  //         fontWeight: FontWeight.w500,
                                  //         color: Color(0xFF555555),
                                  //       ),
                                  //     ),
                                  //     Flexible(
                                  //       child: Text(
                                  //         fastView.fastview_exp,
                                  //         style: TextStyle(
                                  //           fontFamily: 'Arial',
                                  //           fontSize: (isMobile) ? 12 : 16,
                                  //           fontWeight: FontWeight.w500,
                                  //           color: Colors.orange,
                                  //         ),
                                  //       ),
                                  //     ),
                                  //   ],
                                  // ),
                                  // SizedBox(height: 10),
                                  // Row(
                                  //   children: [
                                  //     Text(
                                  //       "$statusTS: ",
                                  //       style: TextStyle(
                                  //         fontFamily: 'Arial',
                                  //         fontSize: (isMobile) ? 12 : 16,
                                  //         fontWeight: FontWeight.w500,
                                  //         color: Color(0xFF555555),
                                  //       ),
                                  //     ),
                                  //     Flexible(
                                  //       child: Text(
                                  //         fastView.fastview_button,
                                  //         style: TextStyle(
                                  //           fontFamily: 'Arial',
                                  //           fontSize: (isMobile) ? 12 : 16,
                                  //           fontWeight: FontWeight.w500,
                                  //           color: Colors.orange,
                                  //         ),
                                  //       ),
                                  //     ),
                                  //   ],
                                  // ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(top: 8),
                                          child: InkWell(
                                            onTap: () {},
                                            child: Container(
                                              alignment: Alignment.center,
                                              width: double.infinity,
                                              padding: const EdgeInsets.only(
                                                  left: 24,
                                                  right: 24,
                                                  top: 8,
                                                  bottom: 8),
                                              decoration: BoxDecoration(
                                                color: Colors.orange,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: Text(
                                                "$EnrollTS",
                                                style: TextStyle(
                                                  fontFamily: 'Arial',
                                                  fontSize: 12,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 8,
                  bottom: 8,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: TabBar(
                      indicatorColor: Colors.orange,
                      labelColor: Colors.orange,
                      labelStyle: const TextStyle(
                          fontFamily: 'Arial',
                          fontSize: 14,
                          color: Colors.grey,
                          fontWeight: FontWeight.w500),
                      unselectedLabelColor: Colors.grey,
                      onTap: (index) {
                        setState(() {
                          _selectedIndex = index;
                        });
                      },
                      controller: _tabController,
                      isScrollable: true,
                      tabs: _tabs.map((tab) => Tab(text: tab)).toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _infoRow(IconData icon, String text) {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.amber, size: 16),
          SizedBox(width: 8),
          Flexible(
            child: Text(
              text == '' ? '-' : text,
              style: TextStyle(
                fontFamily: 'Arial',
                fontSize: 12,
                color: Color(0xFF555555),
              ),
            ),
          ),
        ],
      ),
    );
  }

  int _selectedIndex = 0;

  final List<String> _tabs = [
    '$CurriculumTS',
    '$DescriptionTS',
    '$InstructorsTS',
    '$DiscussionTS',
    'Announcements',
    '$AttachFileTS',
    '$CertificationTS',
  ];

  Widget _bodyAcademy() {
    switch (_selectedIndex) {
      case 0:
        return Curriculum(
          employee: widget.employee,
          academy: widget.academy,
          Authorization: widget.Authorization,
          callback: () {
            _selectedIndex = 0;
          },
        );
      case 1:
        return Description(
          employee: widget.employee,
          academy: widget.academy,
          Authorization: widget.Authorization,
        );
      case 2:
        return Instructors(
          employee: widget.employee,
          academy: widget.academy,
          Authorization: widget.Authorization,
        );
      case 3:
        return Discussion(
          employee: widget.employee,
          academy: widget.academy,
          Authorization: widget.Authorization,
        );
      case 4:
        return Announcements(
          employee: widget.employee,
          academy: widget.academy,
        );
      case 5:
        return AttachFile(
          employee: widget.employee,
          academy: widget.academy,
          Authorization: widget.Authorization,
        );
      case 6:
        return Certification(
          employee: widget.employee,
          academy: widget.academy,
          Authorization: widget.Authorization,
        );
      default:
        return Container(
          alignment: Alignment.center,
          child: Text(
            'ERROR!',
            style: TextStyle(
              fontFamily: 'Arial',
              fontSize: 18.0,
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        );
    }
  }

  Future<HeaderData> fetchHeader() async {
    final uri =
        Uri.parse("$host/api/origami/e-learning/academy/study/header.php");
    final response = await http.post(
      uri,
      headers: {'Authorization': 'Bearer ${authorization}'},
      body: {
        'auth_password': authorization,
        'academy_id': widget.academy.academy_id,
        'academy_type': widget.academy.academy_type,
      },
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      return HeaderData.fromJson(jsonResponse['header_data']);
    } else {
      throw Exception('Failed to load academies');
    }
  }

  Future<FastView> fetchFastView() async {
    final uri =
        Uri.parse("$host/api/origami/e-learning/academy/study/fastview.php");
    final response = await http.post(
      uri,
      headers: {'Authorization': 'Bearer $authorization'},
      body: {
        'auth_password': authorization,
        'emp_id': widget.employee.emp_id,
        'comp_id': widget.employee.comp_id,
        'academy_id': widget.academy.academy_id,
        'academy_type': widget.academy.academy_type,
      },
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      return FastView.fromJson(jsonResponse['fastview_data']);
    } else {
      throw Exception('Failed to load academies');
    }
  }
}

class IDPlan {
  final bool plan_update;

  IDPlan({
    required this.plan_update,
  });

  // สร้างฟังก์ชันเพื่อแปลง JSON ไปเป็น Object ของ Academy
  factory IDPlan.fromJson(Map<String, dynamic> json) {
    return IDPlan(
      plan_update: json['plan_update'],
    );
  }
}

class HeaderData {
  final String topic_name;
  final String topic_description;
  final String category_name;
  final String video_count;
  final String video_duration;

  HeaderData({
    required this.topic_name,
    required this.topic_description,
    required this.category_name,
    required this.video_count,
    required this.video_duration,
  });

  // สร้างฟังก์ชันเพื่อแปลง JSON ไปเป็น Object ของ Academy
  factory HeaderData.fromJson(Map<String, dynamic> json) {
    return HeaderData(
      topic_name: json['topic_name'] ?? '',
      topic_description: json['topic_description'] ?? '',
      category_name: json['category_name'] ?? '',
      video_count: json['video_count'] ?? '',
      video_duration: json['video_duration'] ?? '',
    );
  }
}

class FastView {
  final String fastview_cover;
  final String fastview_text;
  final String fastview_date;
  final String fastview_button_text;
  final String fastview_button_class;
  final String course_id;
  final String topic_option;
  final String topic_item;
  final String topic_no;
  final String topic_id;

  FastView({
    required this.fastview_cover,
    required this.fastview_text,
    required this.fastview_date,
    required this.fastview_button_text,
    required this.fastview_button_class,
    required this.course_id,
    required this.topic_option,
    required this.topic_item,
    required this.topic_no,
    required this.topic_id,
  });

  // สร้างฟังก์ชันเพื่อแปลง JSON ไปเป็น Object ของ Academy
  factory FastView.fromJson(Map<String, dynamic> json) {
    return FastView(
      fastview_cover: json['fastview_cover'] ?? '',
      fastview_text: json['fastview_text'] ?? '',
      fastview_date: json['fastview_date'] ?? '',
      fastview_button_text: json['fastview_button_text'] ?? '',
      fastview_button_class: json['fastview_button_class'] ?? '',
      course_id: json['course_id'] ?? '',
      topic_option: json['topic_option'] ?? '',
      topic_item: json['topic_item'] ?? '',
      topic_no: json['topic_no'] ?? '',
      topic_id: json['topic_id'] ?? '',
    );
  }
}

class CourseData {
  final String fastview_cover;
  final String count;
  final String course;
  final String fastview_exp;
  final String id;
  final String item;
  final String no;
  final String option;
  final String text;

  CourseData({
    required this.fastview_cover,
    required this.count,
    required this.course,
    required this.fastview_exp,
    required this.id,
    required this.item,
    required this.no,
    required this.option,
    required this.text,
  });

  factory CourseData.fromJson(Map<String, dynamic> json) {
    return CourseData(
      fastview_cover: json['fastview_cover'] ?? '',
      count: json['count'] ?? '',
      course: json['course'] ?? '',
      fastview_exp: json['fastview_exp'] ?? '',
      id: json['id'] ?? '',
      item: json['item'] ?? '',
      no: json['no'] ?? '',
      option: json['option'] ?? '',
      text: json['text'] ?? '',
    );
  }
}
