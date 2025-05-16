import 'package:academy/welcome_to_academy/export.dart';
import 'package:http/http.dart' as http;

class Description extends StatefulWidget {
  Description({
    super.key,
    required this.employee,
    required this.academy,
    required this.Authorization,
  });
  final Employee employee;
  final AcademyModel academy;
  final String Authorization;

  @override
  _DescriptionState createState() => _DescriptionState();
}

class _DescriptionState extends State<Description> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return loading();
  }

  Widget loading() {
    return FutureBuilder<List<DescriptionModel>>(
      future: fetchDescription(),
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

  bool isSwitch = false;
  Widget _getContentWidget(List<DescriptionModel> descriptions) {
    return Container(
      color: Colors.grey.shade50,
      child: Padding(
        padding: const EdgeInsets.only(left: 8, right: 8),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(descriptions.length, (index) {
              final description = descriptions[index];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8, top: 16, bottom: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Description",
                          style: TextStyle(
                            fontFamily: 'Arial',
                            fontSize: 18,
                            color: Color(0xFF555555),
                            fontWeight: FontWeight.w700,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        SizedBox(height: 8),
                        Text(
                          description.course_description,
                          style: TextStyle(
                            fontFamily: 'Arial',
                            fontSize: 14,
                            color: Color(0xFF555555),
                            fontWeight: FontWeight.w500,
                          ),
                          strutStyle: StrutStyle(fontSize: 16, height: 1.5),
                        ),
                      ],
                    ),
                  ),
                  Card(
                    color: Color(0xFFF5F5F5),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 0,
                            blurRadius: 0,
                            offset: Offset(0, 3), // x, y
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Container(
                              alignment: Alignment.centerLeft,
                              // color: Colors.transparent,
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                "$WYLTS",
                                style: TextStyle(
                                  fontFamily: 'Arial',
                                  fontSize: 14,
                                  color: Color(0xFF555555),
                                  fontWeight: FontWeight.w700,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                            SizedBox(height: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  children: List.generate(
                                      description.content_data.length,
                                      (indexI) {
                                    final content =
                                        description.content_data[indexI];
                                    return Container(
                                      alignment: Alignment.centerLeft,
                                      child: Padding(
                                        padding: EdgeInsets.only(bottom: 4),
                                        child: Text(
                                          "${content.class_no}  ${content.content_name}",
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontFamily: 'Arial',
                                            color: Color(0xFF555555),
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                      ),
                                    );
                                  }),
                                ),
                                SizedBox(height: 16),
                                Inclu(description),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }

  Widget Inclu(DescriptionModel description) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            courseIncludesTS,
            style: TextStyle(
              fontFamily: 'Arial',
              fontSize: 16.0,
              color: Color(0xFF555555),
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(
            height: 8,
          ),
          Column(
            children: [
              if (description.video_counter != "0")
                Padding(
                  padding: EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    children: [
                      Icon(
                        Icons.video_collection_outlined,
                        color: Color(0xFF555555),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        "${description.video_counter} $videoTS",
                        style: TextStyle(
                          fontFamily: 'Arial',
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              if (description.document_counter != "0")
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    children: [
                      Icon(
                        Icons.file_copy_outlined,
                        color: Color(0xFF555555),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        "${description.document_counter} File",
                        style: TextStyle(
                          fontFamily: 'Arial',
                          color: Colors.grey,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              if (description.youtube_counter != "0")
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    children: [
                      Icon(
                        Icons.ondemand_video_outlined,
                        color: Color(0xFF555555),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        "${description.youtube_counter} Video",
                        style: TextStyle(
                          fontFamily: 'Arial',
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              if (description.challenge_counter != "0")
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    children: [
                      Icon(
                        Icons.emoji_events_outlined,
                        color: Color(0xFF555555),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        "${description.challenge_counter} Challenge",
                        style: TextStyle(
                          fontFamily: 'Arial',
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              if (description.link_counter != "0")
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    children: [
                      Icon(
                        Icons.link_outlined,
                        color: Color(0xFF555555),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        "${description.link_counter} Link",
                        style: TextStyle(
                          fontFamily: 'Arial',
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              if (description.course_certificate == "Y")
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    children: [
                      Icon(
                        Icons.school_outlined,
                        color: Color(0xFF555555),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Flexible(
                        child: Text(
                          'Certificate of completion',
                          style: TextStyle(
                            fontFamily: 'Arial',
                            color: Colors.grey,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Future<List<DescriptionModel>> fetchDescription() async {
    final uri =
        Uri.parse("$host/api/origami/e-learning/academy/study/description.php");
    final response = await http.post(
      uri,
      headers: {'Authorization': 'Bearer ${widget.Authorization}'},
      body: {
        'auth_password': authorization,
        'academy_id': widget.academy.academy_id,
        'academy_type': widget.academy.academy_type,
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      // เข้าถึงข้อมูลในคีย์ 'academy_data'
      final List<dynamic> academiesJson = jsonResponse['course_data'];
      // แปลงข้อมูลจาก JSON เป็น List<AcademyModel>
      return academiesJson
          .map((json) => DescriptionModel.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to load academies');
    }
  }
}

class DescriptionModel {
  final String course_name;
  final String course_description;
  final String video_counter;
  final String challenge_counter;
  final String document_counter;
  final String youtube_counter;
  final String link_counter;
  final String course_certificate;
  final List<ContentData> content_data;

  DescriptionModel({
    required this.course_name,
    required this.course_description,
    required this.video_counter,
    required this.challenge_counter,
    required this.document_counter,
    required this.youtube_counter,
    required this.link_counter,
    required this.course_certificate,
    required this.content_data,
  });

  factory DescriptionModel.fromJson(Map<String, dynamic> json) {
    return DescriptionModel(
      course_name: json['course_name'] ?? '',
      course_description: json['course_description'] ?? '',
      video_counter: json['video_counter'] ?? '',
      challenge_counter: json['challenge_counter'] ?? '',
      document_counter: json['document_counter'] ?? '',
      youtube_counter: json['youtube_counter'] ?? '',
      link_counter: json['link_counter'] ?? '',
      course_certificate: json['course_certificate'] ?? '',
      content_data: (json['content_data'] as List?)
              ?.map((e) => ContentData.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class ContentData {
  final String content_name;
  final String content_type;
  final String class_no;

  ContentData({
    required this.content_name,
    required this.content_type,
    required this.class_no,
  });

  factory ContentData.fromJson(Map<String, dynamic> json) {
    return ContentData(
      content_name: json['content_name'] ?? '',
      content_type: json['content_type'] ?? '',
      class_no: json['class_no'] ?? '',
    );
  }
}
