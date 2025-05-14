import 'package:academy/welcome_to_academy/export.dart';
import 'package:http/http.dart' as http;

class Certification extends StatefulWidget {
  Certification({
    super.key,
    required this.employee,
    required this.academy,
    required this.Authorization,
  });
  final Employee employee;
  final AcademyModel academy;
  final String Authorization;
  @override
  _CertificationState createState() => _CertificationState();
}

class _CertificationState extends State<Certification> {
  bool isSwitch = false;

  TextStyle _getTextStyle(double fontSize, FontWeight fontWeight, Color color) {
    return TextStyle(
      fontFamily: 'Arial',
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
    );
  }

  @override
  void initState() {
    super.initState();
  }

  Future<void> _launchURL(Uri url) async {
    if (!await launchUrl(url)) {
      throw Exception('Could not launch ${url}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<CertificationModel>>(
      future: fetchCertification(),
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
          return (snapshot.data!.isEmpty)
              ? Center(
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
              ))
              : _getContentWidget(snapshot.data!);
        }
      },
    );
  }

  Widget _getContentWidget(List<CertificationModel> Certifications) {
    return Container(
      color: Colors.grey.shade50,
      child: Padding(
        padding: const EdgeInsets.only(left: 8,right: 8),
        child: SingleChildScrollView(
          child: Column(
            children: List.generate(Certifications.length, (index) {
              final certification = Certifications[index];
              return Column(
                children: [
                  InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: () {
                      setState(() {
                        isSwitch = !isSwitch;
                      });
                    },
                    child: (isSwitch == true)
                        ? Card(
                      color: Colors.white,
                      child: Container(
                        padding: EdgeInsets.only(
                            left: 6, right: 6, top: 10, bottom: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                certification.course_name,
                                style: TextStyle(
                                  fontFamily: 'Arial',
                                  fontSize: 18.0,
                                  color: Color(0xFF555555),
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            Icon(
                              Icons.keyboard_arrow_down,
                              color: Color(0xFF555555),
                              size: 30,
                            )
                          ],
                        ),
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
                        children: [
                          Expanded(
                            child: Text(
                              certification.course_name,
                              style: TextStyle(
                                fontFamily: 'Arial',
                                fontSize: 16,
                                color: Color(0xFF555555),
                                fontWeight: FontWeight.w700,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                          Icon(
                            Icons.keyboard_arrow_down,
                            color: Color(0xFF555555),
                            size: 30,
                          )
                        ],
                      ),
                    ),
                  ),
                  if (!isSwitch) _buildCertificationList(certification),
                  SizedBox(height: 8),
                ],
              );
            }).toList(), // เพิ่ม .toList()
          ),
        ),
      ),
    );
  }

  // Widget _buildCertificationCard(CertificationData certification) {
  //   return Card(
  //     color: Colors.white,
  //     child: Container(
  //       padding: EdgeInsets.symmetric(vertical: 10, horizontal: 6),
  //       decoration: BoxDecoration(
  //         color: Colors.white,
  //         borderRadius: BorderRadius.circular(10),
  //       ),
  //       child: Row(
  //         children: [
  //           Expanded(
  //             child: Text(
  //               certification.courseName,
  //               style: _getTextStyle(18.0, FontWeight.w700, Color(0xFF555555)),
  //             ),
  //           ),
  //           Icon(
  //             Icons.keyboard_arrow_down,
  //             color: Color(0xFF555555),
  //             size: 30,
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget _buildCertificationList(CertificationModel certification) {
    return Column(
      children: List.generate(certification.certificate_data.length, (index) {
        final certificate = certification.certificate_data[index];
        return Card(
          color: Color(0xFFF5F5F5),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 0,
                  blurRadius: 2,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: isMobile ? 2 : 1, child: _buildCertificateImage(certificate)),
                  SizedBox(width: 8),
                  Expanded(
                      flex: isMobile ? 3 : 5, child: _buildCertificateDetails(certificate)),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCertificateImage(CertificateData certificate) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Image.network(
              certificate.certification_background,
              width: double.infinity,
              fit: BoxFit.fill,
              errorBuilder: (context, error, stackTrace) {
                return Icon(
                  Icons.error,
                );
              },
            ),
            Center(
              child: Text(
                certificate.certification_name,
                style: _getTextStyle(14.0, FontWeight.w600, Color(0xFF555555)),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        _buildDownloadButton(certificate),
      ],
    );
  }

  Widget _buildCertificateDetails(CertificateData certificate) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Text(
            certificate.certification_name,
            style: _getTextStyle(18.0, FontWeight.w700, Color(0xFF555555)),
            maxLines: 1,
          ),
        ),
        SizedBox(height: 4),
        Text(
          certificate.certification_description,
          style: _getTextStyle(14.0, FontWeight.w600, Color(0xFF555555)),
        ),
        SizedBox(height: 8),
        if(certificate.content_pass != '')
        _buildCertificationConditions(certificate.content_pass),
        if(certificate.video_quality != '')
          _buildCertificationConditions(certificate.video_quality),
        if(certificate.challenge_pass != '')
          _buildCertificationConditions(certificate.challenge_pass),
        if(certificate.event_pass != '')
          _buildCertificationConditions(certificate.event_pass),
      ],
    );
  }

  Widget _buildCertificationConditions(String persen) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          // SizedBox(width: 8),
          Icon(Icons.lens_sharp, color: Colors.green, size: 8),
          SizedBox(width: 4),
          Flexible(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Text(
                persen,
                style:
                _getTextStyle(14.0, FontWeight.w400, Color(0xFF555555)),
                // overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDownloadButton(CertificateData certificate) {
    return InkWell(
      onTap: () {
        if (certificate.certification_no != "") {
          course_id = certificate.course_id;
          certification_id = certificate.certification_id;
          ViewCertification();
        }
      },
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: certificate.certification_no != ""
              ? Colors.amber.shade200
              : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.cloud_download, color: Colors.white),
            SizedBox(width: 4),
            Text(
              '$DownloadTS',
              style: _getTextStyle(14.0, FontWeight.w600, Color(0xFF555555)),
            ),
          ],
        ),
      ),
    );
  }

  String _getCertificateImage(String certificationName) {
    switch (certificationName) {
      case 'Certificate Bronze':
        return '$host/images/certification/1.png?v=2';
      case 'Certificate Platinum':
        return '$host/images/certification/3.png?v=2';
      case 'Certificate Gold':
        return '$host/images/certification/2.png?v=2';
      default:
        return '$host/images/certification/4.png?v=2';
    }
  }

  Future<List<CertificationModel>> fetchCertification() async {
    final uri = Uri.parse("$host/api/origami/e-learning/academy/study/get.certificate.php");
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
      final List<dynamic> dataJson = jsonResponse['certification_data'];
      return dataJson.map((json) => CertificationModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load academies');
    }
  }

  String course_id = "";
  String certification_id = "";
  String certification_file = "";

  Future<void> ViewCertification() async {
    try {
      final response = await http.post(
        Uri.parse('$host/api/origami/e-learning/academy/study/view.certificate.php'),
        body: {
          'auth_password': authorization,
          'emp_id': widget.employee.emp_id,
          'comp_id': widget.employee.comp_id,
          'course_id': course_id,
          'certification_id': certification_id,
        },
      );
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse['status'] == 200) {
          print("$jsonResponse");
          certification_file = jsonResponse['certification_file'];
          print("message: $certification_file");
          final Uri _url = Uri.parse(certification_file);
          setState(() {
            _launchURL(_url);
          });
        } else {
          throw Exception(
              'Failed to load personal data: ${jsonResponse['message']}');
        }
      } else {
        throw Exception(
            'Failed to load personal data: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Failed to load personal data: $e');
    }
  }
}

class CertificationModel {
  final String course_name;
  final List<CertificateData> certificate_data;

  CertificationModel({
    required this.course_name,
    required this.certificate_data,
  });

  factory CertificationModel.fromJson(Map<String, dynamic> json) {
    return CertificationModel(
      course_name: json['course_name'] ?? '',
      certificate_data: (json['certificate_data'] as List?)
          ?.map((item) => CertificateData.fromJson(item))
          .toList() ??
          [],
    );
  }
}

class CertificateData {
  final String certification_id;
  final String course_id;
  final String certification_level;
  final String certification_name;
  final String certification_description;
  final String certification_background;
  final String content_pass;
  final String content_pass_val;
  final String video_quality;
  final String video_quality_val;
  final String challenge_pass;
  final String challenge_pass_val;
  final String event_pass;
  final String event_pass_val;
  final String certification_date;
  final String certification_no;
  final String certification_dowload;

  CertificateData({
    required this.certification_id,
    required this.course_id,
    required this.certification_level,
    required this.certification_name,
    required this.certification_description,
    required this.certification_background,
    required this.content_pass,
    required this.content_pass_val,
    required this.video_quality,
    required this.video_quality_val,
    required this.challenge_pass,
    required this.challenge_pass_val,
    required this.event_pass,
    required this.event_pass_val,
    required this.certification_date,
    required this.certification_no,
    required this.certification_dowload,
  });

  factory CertificateData.fromJson(Map<String, dynamic> json) {
    return CertificateData(
      certification_id: json['certification_id'] ?? '',
      course_id: json['course_id'] ?? '',
      certification_level: json['certification_level'] ?? '',
      certification_name: json['certification_name'] ?? '',
      certification_description: json['certification_description'] ?? '',
      certification_background: json['certification_background'] ?? '',
      content_pass: json['content_pass'] ?? '',
      content_pass_val: json['content_pass_val'] ?? '',
      video_quality: json['video_quality'] ?? '',
      video_quality_val: json['video_quality_val'] ?? '',
      challenge_pass: json['challenge_pass'] ?? '',
      challenge_pass_val: json['challenge_pass_val'] ?? '',
      event_pass: json['event_pass'] ?? '',
      event_pass_val: json['event_pass_val'] ?? '',
      certification_date: json['certification_date'] ?? '',
      certification_no: json['certification_no'] ?? '',
      certification_dowload: json['certification_dowload'] ?? '',
    );
  }
}
