import 'package:academy/welcome_to_academy/export.dart';
import 'package:http/http.dart' as http;

class Announcements extends StatefulWidget {
  Announcements({super.key, required this.employee, required this.academy});
  final Employee employee;
  final AcademyModel academy;
  @override
  _AnnouncementsState createState() => _AnnouncementsState();
}

class _AnnouncementsState extends State<Announcements> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<AnnouncementModel>>(
      future: fetchAnnouncement(),
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
          return Center(
              child: Text(
            'Error: ${snapshot.error}',
            style: TextStyle(
              fontFamily: 'Arial',
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Color(0xFF555555),
            ),
          ));
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

  Future<void> _launchUrl(String url) async {
    final Uri launchUri = Uri.parse(url);
    if (!await launchUrl(launchUri)) {
      throw Exception('Could not launch $url');
    }
  }

  Widget _getContentWidget(List<AnnouncementModel> announcements) {
    return Container(
      color: Colors.grey.shade50,
      child: Padding(
        padding: const EdgeInsets.only(left: 8, right: 8),
        child: SingleChildScrollView(
            child: Column(
          children: [
            Column(
              children: List.generate(announcements.length, (index) {
                final announce = announcements[index];
                return Card(
                  color: Color(0xFFF5F5F5),
                  child: InkWell(
                    onTap: () {},
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
                              flex: 2,
                              child: Image.network(
                                _getCertificateImage(announce.creator_img),
                                width: double.infinity,
                                height: 120,
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) {
                                  return Image.network(
                                    'https://webcodeft.com/wp-content/uploads/2021/11/dummy-user.png',
                                    height: 120,
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
                              flex: 3,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    announce.creator_name,
                                    style: TextStyle(
                                      fontFamily: 'Arial',
                                      fontSize: 16.0,
                                      color: Color(0xFF555555),
                                      fontWeight: FontWeight.w700,
                                    ),
                                    maxLines: 2,
                                  ),
                                  SizedBox(height: 12),
                                  Row(
                                    children: [
                                      FaIcon(
                                        FontAwesomeIcons.tags,
                                        color: Colors.amber,
                                        size: 20,
                                      ),
                                      SizedBox(
                                        width: 8,
                                      ),
                                      Flexible(
                                        child: Text(
                                          '${announce.announce_subject}\n${announce.announce_description}',
                                          style: TextStyle(
                                            fontFamily: 'Arial',
                                            fontSize: 14.0,
                                            color: Color(0xFF555555),
                                            fontWeight: FontWeight.w500,
                                          ),
                                          maxLines: 2,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.calendar_month,
                                        color: Colors.amber,
                                      ),
                                      SizedBox(
                                        width: 8,
                                      ),
                                      Flexible(
                                        child: Text(
                                          announce.announce_date,
                                          style: TextStyle(
                                            fontFamily: 'Arial',
                                            color: Color(0xFF555555),
                                          ),
                                          maxLines: 2,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8),
                                  // Row(
                                  //   children: [
                                  //     Expanded(
                                  //       child: SingleChildScrollView(
                                  //         scrollDirection: Axis.horizontal,
                                  //         child: Row(
                                  //           children: [
                                  //             Icon(
                                  //               Icons.remove_red_eye_outlined,
                                  //               color: Colors.amber,
                                  //             ),
                                  //             SizedBox(
                                  //               width: 4,
                                  //             ),
                                  //             Text(
                                  //               '${attach.count_down}',
                                  //               style: TextStyle(
                                  //                 fontFamily: 'Arial',
                                  //                 color: Color(0xFF555555),
                                  //               ),
                                  //             )
                                  //           ],
                                  //         ),
                                  //       ),
                                  //     ),
                                  //     Expanded(
                                  //       child: SingleChildScrollView(
                                  //         scrollDirection: Axis.horizontal,
                                  //         child: Row(
                                  //           children: [
                                  //             Icon(
                                  //               Icons.cloud_download,
                                  //               color: Colors.amber,
                                  //             ),
                                  //             SizedBox(
                                  //               width: 4,
                                  //             ),
                                  //             Text(
                                  //               '${attach.count_view}',
                                  //               style: TextStyle(
                                  //                 fontFamily: 'Arial',
                                  //                 color: Color(0xFF555555),
                                  //               ),
                                  //             )
                                  //           ],
                                  //         ),
                                  //       ),
                                  //     ),
                                  //   ],
                                  // ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
            SizedBox(
              height: 8,
            ),
            Divider(),
            SizedBox(
              height: 8,
            ),
          ],
        )),
      ),
    );
  }

  String _getCertificateImage(String certificationName) {
    switch (certificationName) {
      case 'png':
        return 'https://icons.veryicon.com/png/o/file-type/system-icon/png-37.png';
      case 'pdf':
        return 'http://icons.veryicon.com/png/o/file-type/system-icon/pdf-45.png';
      case 'jpg':
        return 'https://icons.veryicon.com/png/o/file-type/system-icon/jpg-27.png';
      default:
        return 'https://icons.veryicon.com/png/o/file-type/system-icon/jpg-27.png';
    }
  }

  Future<List<AnnouncementModel>> fetchAnnouncement() async {
    final uri = Uri.parse(
        "$host/api/origami/e-learning/academy/study/announcement.php");
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
      final List<dynamic> dataJson = jsonResponse['announement_data'];
      // แปลงข้อมูลจาก JSON เป็น List<Instructor>
      return dataJson.map((json) => AnnouncementModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load instructors');
    }
  }

  // @override
  // void initState() {
  //   super.initState();
  // }
  //
  // @override
  // Widget build(BuildContext context) {
  //   return Padding(
  //     padding: const EdgeInsets.all(16),
  //     child: SingleChildScrollView(
  //       child: Column(
  //         children: List.generate(1, (index) {
  //           return Column(
  //             children: [
  //               Card(
  //                 color: Colors.white,
  //                 elevation: 0,
  //                 child: InkWell(
  //                   child: Container(
  //                     padding: EdgeInsets.all(20),
  //                     decoration: BoxDecoration(
  //                       color: Colors.white,
  //                       borderRadius: BorderRadius.circular(20),
  //                     ),
  //                     child: Row(
  //                       children: [
  //                         Image.network(
  //                           'https://webcodeft.com/wp-content/uploads/2021/11/dummy-user.png',
  //                           width: 90,
  //                           height: 100,
  //                           fit: BoxFit.fill,
  //                         ),
  //                         SizedBox(
  //                           width: 8,
  //                         ),
  //                         Expanded(
  //                           child: Column(
  //                             crossAxisAlignment: CrossAxisAlignment.start,
  //                             children: [
  //                               SingleChildScrollView(
  //                                 scrollDirection: Axis.horizontal,
  //                                 child: Row(
  //                                   children: [
  //                                     Icon(Icons.note_alt,color: Colors.amber,),
  //                                     SizedBox(width: 4,),
  //                                     Text(
  //                                       'รบกวนแสดงความคิดเห็น',
  //                                       style: TextStyle(fontFamily: 'Arial',
  //                                         fontSize: 20.0,
  //                                         color: Colors.amber,
  //                                         fontWeight: FontWeight.w700,
  //                                       ),
  //                                       overflow: TextOverflow.ellipsis,
  //                                       maxLines: 1,
  //                                     ),
  //                                   ],
  //                                 ),
  //                               ),
  //                               SizedBox(height: 8,),
  //                               Text(
  //                                 'รบกวนแสดงความคิดเห็น ที่มีต่อคอร์สหลังเรียนจบ',
  //                                 style: TextStyle(fontFamily: 'Arial',
  //                                   color: Color(0xFF555555),
  //                                 ),
  //                                 overflow: TextOverflow.ellipsis,
  //                                 maxLines: 3,
  //                               ),
  //                             ],
  //                           ),
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //               SizedBox(
  //                 height: 8,
  //               ),
  //             ],
  //           );
  //         }),
  //       ),
  //     ),
  //   );
  // }
}

class AnnouncementModel {
  final String announce_subject;
  final String announce_description;
  final String announce_date;
  final String creator_name;
  final String creator_img;

  AnnouncementModel({
    required this.announce_subject,
    required this.announce_description,
    required this.announce_date,
    required this.creator_name,
    required this.creator_img,
  });

  factory AnnouncementModel.fromJson(Map<String, dynamic> json) {
    return AnnouncementModel(
      announce_subject: json['announce_subject'],
      announce_description: json['announce_description'],
      announce_date: json['announce_date'],
      creator_name: json['creator_name'],
      creator_img: json['creator_img'],
    );
  }
}
