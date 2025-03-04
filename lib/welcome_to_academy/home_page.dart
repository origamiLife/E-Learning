import 'package:academy/welcome_to_academy/tesseract_ocr/tesseract_ocr.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;
import 'package:carousel_slider/carousel_slider.dart';
import 'academy/challeng/challenge_menu.dart';
import 'academy/evaluate/evaluate_module.dart';
import 'export.dart';

class AcademyHomePage extends StatefulWidget {
  const AcademyHomePage(
      {Key? key,
      required this.employee,
      required this.Authorization,
      required this.page})
      : super(key: key);
  final Employee employee;
  final String Authorization;
  final String page;
  @override
  State<AcademyHomePage> createState() => _AcademyHomePageState();
}

class _AcademyHomePageState extends State<AcademyHomePage> {
  final TextEditingController _searchController = TextEditingController();
  bool _showBanner = true; // Control the banner visibility
  bool _isMenu = false;
  bool _change = false;
  String page = "course";
  String search = '';

  @override
  void initState() {
    super.initState();
    page = widget.page;
    // Listener สำหรับการกรอง
    allTranslate();
    _loadSelectedRadio();
    _searchController.addListener(() {
      setState(() {
        search = _searchController.text;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // โหลดค่าที่บันทึกไว้
  _loadSelectedRadio() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedRadio = prefs.getInt('selectedRadio') ?? 2;
      allTranslate();
    });
  }

  // บันทึกค่าเมื่อมีการเปลี่ยนแปลง
  _handleRadioValueChange(int? value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedRadio = value!;
      prefs.setInt('selectedRadio', selectedRadio);
      allTranslate();
      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => LoginPage(
      //       num: 0,
      //       popPage: 0,
      //     ),
      //   ),
      // );
    });
  }

  Future<void> _launchUrl(Uri url) async {
    if (!await launchUrl(url)) {
      throw Exception('Could not launch ${url}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              _buildNavigationBar(),
              // _buildAdBanner(),
              SizedBox(height: 8),
              (page == 'challenge')
                  ? Expanded(
                      child: ChallengeStartTime(
                        employee: widget.employee,
                        Authorization: widget.Authorization,
                      ),
                    )
                  : Expanded(child: _buildPopularEvents()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMobileAppBanner() {
    return Container(
      color: Colors.white, // Or a suitable background color
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              setState(() {
                _showBanner = false;
              });
            },
            icon: const Icon(Icons.close),
          ),
          Image.asset(
            "assets/images/learning/img_2.png",
            height: 40,
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text("Origami Academy"),
              Text("Open on the Origami Life website",
                  style: TextStyle(fontSize: 12)),
            ],
          ),
          const Spacer(),
          TextButton(
            onPressed: () {
              final Uri _url = Uri.parse("https://www.origami.life/edsd");
              setState(() {
                _launchUrl(_url);
              });
            },
            child: Text(openTS),
          ),
        ],
      ),
    );
  }

  String? selectedValue;
  Widget _buildNavigationBar() {
    return AppBar(
      backgroundColor: Colors.white, // Example background color
      automaticallyImplyLeading: false, // Remove default back button
      actions: [
        SizedBox(width: 20),
        Expanded(
          flex: 2,
          child: DropdownButton(
            items: [
              DropdownMenuItem(
                  value: 'course',
                  child: Text(
                    '$MyLearningTS',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  )),
              DropdownMenuItem(
                  value: 'challenge',
                  child: Text(
                    '$MyChallengeTS',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  )),
              DropdownMenuItem(
                  value: 'catalog',
                  child: Text(
                    '$CatalogTS',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  )),
              DropdownMenuItem(
                  value: 'favorite',
                  child: Text(
                    '$FavoriteTS',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  )),
              // Add other menu items
            ],
            onChanged: (value) {
              setState(() {
                selectedValue = value;
                page = value!;
              });
            },
            value: selectedValue,
            hint: Text(
              page == 'challenge' ? '$MyChallengeTS' : '$MyLearningTS',
              style: TextStyle(
                fontFamily: 'Arial',
                fontSize: 16,
                color: Colors.orange,
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
              style:TextStyle(
                fontFamily: 'Arial',
                fontSize: 16,
                color: Colors.orange,
                fontWeight: FontWeight.w500,
              ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Row(
            children: [
              Expanded(
                child: TextButton(
                    onPressed: () {
                      _handleRadioValueChange(1);
                    },
                    child: Text('TH')),
              ),
              Text(
                '|',
                style: TextStyle(
                  fontFamily: 'Arial',
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF555555),
                ),
              ),
              Expanded(
                child: TextButton(
                    onPressed: () {
                      _handleRadioValueChange(2);
                    },
                    child: Text('EN')),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 1,
          child: TextButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => LoginPage(
                    num: 1,
                    popPage: 0,
                  ),
                ),
                (route) => false,
              );
            },
            child: Text('$IntOutTS'),
          ),
        ),
        // SizedBox(width: 16),
      ],
    );
  }

  Widget _buildHeroImageSlider() {
    final heroImages = [];
    return CarouselSlider(
      options: CarouselOptions(height: 400.0), // Adjust height as needed
      items: heroImages.map((image) {
        return Builder(
          builder: (BuildContext context) {
            return Expanded(
                child: Image.network(image['desktop_image_url'],
                    fit: BoxFit.cover));
          },
        );
      }).toList(),
    );
  }

  Widget _buildAdBanner() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Image.network(
        "https://p-u.popcdn.net/attachments/images/000/094/017/original/Ad_Banner_Desktop___1140_x_190_pixels_.png?1738435340",
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildPopularEvents() {
    return Column(
      children: [
        ElevatedButton.icon(onPressed: (){
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ImagePickerScreen(empName: widget.employee.emp_name, empAvatar: widget.employee.emp_avatar,

              ),
            ),
          );
        }, label: Icon(Icons.camera)),
        _buildSearchField(),
        // SizedBox(height: 8),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 8, right: 8),
            child: FutureBuilder<List<AcademyRespond>>(
              future: fetchAcademies(),
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
                      color: const Color(0xFF555555),
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
                  return _Learning(snapshot.data!);
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _Learning(List<AcademyRespond> filteredAcademy) {
    return filteredAcademy.isNotEmpty
        ? SingleChildScrollView(
            child: _buildAcademyListView(filteredAcademy),
          )
        : _buildNotFoundText();
  }

  Widget _buildAcademyListView(List<AcademyRespond> filteredAcademy) {
    if (isAndroid || isIPhone) {
      return _buildAcademyList(filteredAcademy);
    } else {
      return _buildAcademyList2(filteredAcademy);
    }
  }

  Widget _buildNotFoundText() {
    return Container(
      alignment: Alignment.center,
      child: Text(
        NotFoundDataTS, // You can replace this with a constant if needed.
        style: TextStyle(
          fontFamily: 'Arial',
          fontSize: 16.0,
          color: const Color(0xFF555555),
          fontWeight: FontWeight.w700,
        ),
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      ),
    );
  }

  Widget _buildSearchField() {
    return Padding(
        padding: const EdgeInsets.only(left: 8, right: 8),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(100),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2), // สีเงา
                blurRadius: 8, // ความฟุ้งของเงา
                offset: Offset(0, 4), // การเยื้องของเงา (แนวแกน X, Y)
              ),
            ],
          ),
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
                  EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              hintText: '$SearchTS...',
              hintStyle: TextStyle(
                  fontFamily: 'Arial', fontSize: 14, color: Color(0xFF555555)),
              border: InputBorder.none, // เอาขอบปกติออก
              suffixIcon: Padding(
                padding: EdgeInsets.only(right: 8.0),
                child: Icon(
                  Icons.search,
                  size: 24,
                ),
              ),
              // border: OutlineInputBorder(
              //   borderRadius: BorderRadius.circular(100),
              // ),
              // suffixIcon: Padding(
              //   padding: const EdgeInsets.only(right: 8.0),
              //   child: Icon(
              //     Icons.search,
              //     // color: Colors.red, // สีไอคอน
              //     size: 24, // ขนาดไอคอน
              //   ),
              // ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.black38,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(50),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.black38,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(50),
              ),
            ),
          ),
        ));
  }

  //android,iphone
  Widget _buildAcademyList(List<AcademyRespond> filteredAcademy) {
    return ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: filteredAcademy.length,
        separatorBuilder: (_, __) => const Divider(),
        itemBuilder: (context, index) {
          final academyItem = filteredAcademy[index];
          return Card(
            color: Color(0xFFF5F5F5),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EvaluateModule(
                      employee: widget.employee,
                      academy: academyItem,
                      Authorization: widget.Authorization,
                      callback: () {
                        setState(() {
                          academyId = academyItem.academy_id;
                          academyType = academyItem.academy_type;
                          favorite();
                        });
                      },
                    ),
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
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
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(width: 8),
                      Expanded(
                        flex: 2,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Image.network(
                            academyItem.academy_image,
                            width: double.infinity, // ความกว้างเต็มจอ
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              return Image.asset(
                                'assets/images/default_image.png', // A default placeholder image in case of an error
                                width: double.infinity, // ความกว้างเต็มจอ
                                fit: BoxFit.contain,
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              academyItem.academy_subject,
                              style: TextStyle(
                                fontFamily: 'Arial',
                                color: const Color(0xFF555555),
                                fontWeight: FontWeight.w700,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                            SizedBox(height: 8),
                            Column(
                              children: academyItem.academy_coach_data.isEmpty
                                  ? [Text("")]
                                  : List.generate(
                                      academyItem.academy_coach_data.length,
                                      (index) {
                                      return _buildCoachList(academyItem
                                          .academy_coach_data[index]);
                                    }),
                            ),
                            SizedBox(height: 8),
                            Text(
                              academyItem.academy_date == "Time Out"
                                  ? '$timeoutTS'
                                  : '$startTS : ${academyItem.academy_date}',
                              style: TextStyle(
                                fontFamily: 'Arial',
                                color: academyItem.academy_date == "Time Out"
                                    ? Colors.red
                                    : const Color(0xFF555555),
                                fontWeight: FontWeight.w500,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  //tablet, ipad
  Widget _buildAcademyList2(List<AcademyRespond> filteredAcademy) {
    return Column(
      children: List.generate(filteredAcademy.length, (index) {
        final academyItem = filteredAcademy[
            index]; // Store the academy item in a variable to avoid repetition.
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EvaluateModule(
                    employee: widget.employee,
                    academy: academyItem,
                    Authorization: widget.Authorization,
                    callback: () {
                      setState(() {
                        academyId = academyItem.academy_id;
                        academyType = academyItem.academy_type;
                        favorite();
                      });
                    },
                  ),
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
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: const Color(0xFF555555),
                          width: 0.2,
                        ),
                      ),
                      child: Image.network(
                        academyItem.academy_image,
                        width: 200,
                        height: 200,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return Image.asset(
                            'assets/images/default_image.png', // Default image in case of an error.
                            width: 200,
                            height: 200,
                            fit: BoxFit.contain,
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            academyItem.academy_subject,
                            style: TextStyle(
                              fontFamily: 'Arial',
                              color: const Color(0xFF555555),
                              fontSize: 28,
                              fontWeight: FontWeight.w700,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                          const SizedBox(height: 16),
                          Column(
                            children: List.generate(
                              academyItem.academy_coach_data.length,
                              (indexII) {
                                final coachData =
                                    academyItem.academy_coach_data[indexII];
                                return Padding(
                                  padding: const EdgeInsets.all(4),
                                  child: Row(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(50),
                                        child: Image.network(
                                          coachData.avatar ?? '',
                                          height: 50,
                                          width: 50,
                                          fit: BoxFit.contain,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                            return Icon(Icons.error);
                                          },
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Flexible(
                                        child: Text(
                                          coachData.name ?? '',
                                          style: TextStyle(
                                            fontFamily: 'Arial',
                                            fontSize: 24,
                                            fontWeight: FontWeight.w500,
                                            color: const Color(0xFF555555),
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            academyItem.academy_date == "Time Out"
                                ? '$timeoutTS'
                                : '$startTS : ${academyItem.academy_date}',
                            style: TextStyle(
                              fontFamily: 'Arial',
                              fontSize: 20,
                              color: academyItem.academy_date == "Time Out"
                                  ? Colors.red
                                  : const Color(0xFF555555),
                              fontWeight: FontWeight.w500,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ],
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
    );
  }

  Widget _buildCoachList(AcademyCoachData coach) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Coach Avatar
          ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: Image.network(
              coach.avatar ?? '',
              height: 32,
              width: 32,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => Icon(Icons.error),
            ),
          ),
          const SizedBox(width: 8),
          // Coach Name
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Text(
                  coach.name ?? '',
                  style: TextStyle(
                    fontFamily: 'Arial',
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF555555),
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<List<AcademyRespond>> fetchAcademies() async {
    final uri = Uri.parse("$host/api/origami/academy/course.php");
    try {
      final response = await http.post(
        uri,
        headers: {'Authorization': 'Bearer ${widget.Authorization}'},
        body: {
          'comp_id': widget.employee.comp_id,
          'emp_id': widget.employee.emp_id,
          'Authorization': widget.Authorization,
          'pages': page,
          'search': search,
        },
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        // เข้าถึงข้อมูลในคีย์ 'instructors'
        final List<dynamic> academiesJson = jsonResponse['academy_data'];
        // แปลงข้อมูลจาก JSON เป็น List<Instructor>
        return academiesJson
            .map((json) => AcademyRespond.fromJson(json))
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

  String academyId = "";
  String academyType = "";
  Future<void> favorite() async {
    try {
      final response = await http.post(
        Uri.parse('$host/api/origami/academy/favorite.php'),
        body: {
          'comp_id': widget.employee.comp_id,
          'emp_id': widget.employee.emp_id,
          'Authorization': widget.Authorization,
          'academy_id': academyId,
          'academy_type': academyType,
        },
      );
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse['status'] == true) {
          print("message: true");
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
