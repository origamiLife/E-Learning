import 'package:academy/welcome_to_academy/test/chat_telegram.dart';
import 'package:academy/welcome_to_academy/test/telegram.dart';
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
      required this.page,
      this.company_id})
      : super(key: key);
  final Employee employee;
  final String Authorization;
  final String page;
  final int? company_id;

  @override
  State<AcademyHomePage> createState() => _AcademyHomePageState();
}

class _AcademyHomePageState extends State<AcademyHomePage> {
  final TextEditingController _searchController = TextEditingController();
  String page = "course";
  String search = '';
  // bool _isClick = false;

  @override
  void initState() {
    super.initState();
    page = widget.page;
    print('isAndroid : $isAndroid');
    print('isIPhone : $isIPhone');
    print('object : $isMobile');
    if (page == 'challenge') {
      _selectedIndex = 1;
    }
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

  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    _selectedIndex = index;
    setState(() {
      if (index == 0) {
        page = "course";
      } else if (index == 1) {
        page = "challenge";
      } else if (index == 2) {
        page = "catalog";
      } else if (index == 3) {
        page = "favorite";
      } else {
        page = "course";
      }
    });
  }

  List<TabItem> items = [
    TabItem(
      icon: FontAwesomeIcons.university,
      title: '$MyLearningTS',
    ),
    TabItem(
      icon: FontAwesomeIcons.trophy,
      title: '$MyChallengeTS',
    ),
    TabItem(
      icon: FontAwesomeIcons.thList,
      title: '$CatalogTS',
    ),
    TabItem(
      icon: FontAwesomeIcons.heart,
      title: '$FavoriteTS',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white,
      body: SafeArea(
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
      bottomNavigationBar: BottomBarDefault(
        items: items,
        iconSize: 16,
        animated: true,
        titleStyle: const TextStyle(
          fontFamily: 'Arial',
          fontSize: 8,
          fontWeight: FontWeight.w500,
        ),
        backgroundColor: Colors.white,
        color: Colors.grey.shade400,
        colorSelected: Color(0xFFFF9900),
        indexSelected: _selectedIndex,
        // paddingVertical: 25,
        onTap: _onItemTapped,
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
                // _showBanner = false;
              });
            },
            icon: const Icon(Icons.close),
          ),
          Image.asset(
            "assets/images/learning/img_2.png",
            height: 40,
          ),
          const SizedBox(width: 8),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Origami Academy",
                style: TextStyle(
                  fontFamily: 'Arial',
                ),
              ),
              Text(
                "Open on the Origami Life website",
                style: TextStyle(
                  fontFamily: 'Arial',
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
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

  Widget _buildNavigationBar() {
    return AppBar(
      backgroundColor: Colors.white, // Example background color
      automaticallyImplyLeading: false, // Remove default back button
      actions: [
        SizedBox(width: 8),
        Expanded(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Icon(Icons.menu_book, color: Color(0xFFFF9900), size: 30),
                SizedBox(width: 14),
                Text(
                  'Academy',
                  style: TextStyle(
                    fontFamily: 'Arial',
                    fontSize: isMobile ? 24 : 28,
                    color: Color(0xFFFF9900),
                    fontWeight: FontWeight.w700,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ],
            ),
          ),
        ),
        // Expanded(
        //   flex: 2,
        //   child: DropdownButton(
        //     items: [
        //       DropdownMenuItem(
        //           value: 'course',
        //           child: Text(
        //             '$MyLearningTS',
        //             overflow: TextOverflow.ellipsis,
        //             maxLines: 1,
        //           )),
        //       DropdownMenuItem(
        //           value: 'challenge',
        //           child: Text(
        //             '$MyChallengeTS',
        //             overflow: TextOverflow.ellipsis,
        //             maxLines: 1,
        //           )),
        //       DropdownMenuItem(
        //           value: 'catalog',
        //           child: Text(
        //             '$CatalogTS',
        //             overflow: TextOverflow.ellipsis,
        //             maxLines: 1,
        //           )),
        //       DropdownMenuItem(
        //           value: 'favorite',
        //           child: Text(
        //             '$FavoriteTS',
        //             overflow: TextOverflow.ellipsis,
        //             maxLines: 1,
        //           )),
        //       // Add other menu items
        //     ],
        //     onChanged: (value) {
        //       setState(() {
        //         selectedValue = value;
        //         page = value!;
        //       });
        //     },
        //     value: selectedValue,
        //     hint: Text(
        //       page == 'challenge' ? '$MyChallengeTS' : '$MyLearningTS',
        //       style: TextStyle(
        //         fontFamily: 'Arial',
        //         fontSize: 16,
        //         color: Colors.orange,
        //         fontWeight: FontWeight.w500,
        //       ),
        //       overflow: TextOverflow.ellipsis,
        //       maxLines: 1,
        //     ),
        //     style: TextStyle(
        //       fontFamily: 'Arial',
        //       fontSize: 16,
        //       color: Colors.orange,
        //       fontWeight: FontWeight.w500,
        //     ),
        //   ),
        // ),
        Expanded(
          flex: 1,
          child: Row(
            children: [
              Expanded(
                child: TextButton(
                    onPressed: () {
                      _handleRadioValueChange(1);
                    },
                    child: Text('TH', style: TextStyle(fontFamily: 'Arial'))),
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
                    child: Text('EN', style: TextStyle(fontFamily: 'Arial'))),
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
                  builder: (context) => const LoginPage(
                    num: 1,
                    popPage: 0,
                    company_id: 0,
                  ),
                ),
                (route) => false,
              );
            },
            child: Text('$IntOutTS', style: TextStyle(fontFamily: 'Arial')),
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

  Widget _buildPopularEvents() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Column(
            children: [
              _buildSearchField(),
              Padding(
                padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
                child: Column(
                  children: [
                    _DropdownLevel('All Select Level'),
                    _DropdownCategory('All Category'),
                    _DropdownType('All Type'),
                  ],
                ),
              ),
            ],
          ),
        ),
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
    if (isMobile) {
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

  //android,iphone
  Widget _buildAcademyList(List<AcademyRespond> filteredAcademy) {
    final widthArea = WidgetsBinding.instance.window.physicalSize.width /
        WidgetsBinding.instance.window.devicePixelRatio;
    return ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: filteredAcademy.length,
        separatorBuilder: (_, __) => Container(padding: EdgeInsets.all(4)),
        itemBuilder: (context, index) {
          final academyItem = filteredAcademy[index];
          return InkWell(
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
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(width: 8),
                        Expanded(
                          child: Container(
                            height: 120,
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
                              borderRadius: BorderRadius.circular(2),
                              child: Image.network(
                                academyItem.academy_image,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Image.asset(
                                    'assets/images/default_image.png',
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  );
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
                                academyItem.academy_subject,
                                style: TextStyle(
                                  fontFamily: 'Arial',
                                  color: const Color(0xFF555555),
                                  fontWeight: FontWeight.w700,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                              SizedBox(height: 4),
                              Column(
                                children: academyItem.academy_coach_data.isEmpty
                                    ? [Text("")]
                                    : List.generate(1, (index) {
                                        return _buildCoachList(
                                            academyItem.academy_coach_data,
                                            index);
                                      }),
                              ),
                              SizedBox(height: 4),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      academyItem.academy_date == "Time Out"
                                          ? '$timeoutTS'
                                          : '$startTS : \n${academyItem.academy_date}',
                                      style: TextStyle(
                                        fontFamily: 'Arial',
                                        color: academyItem.academy_date ==
                                                "Time Out"
                                            ? Colors.red
                                            : const Color(0xFF555555),
                                        fontWeight: FontWeight.w500,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 3,
                                    ),
                                  ),
                                  Expanded(
                                    child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          academyId = academyItem.academy_id;
                                          academyType =
                                              academyItem.academy_type;
                                          favorite();
                                        });
                                      },
                                      child: Container(
                                        width: widthArea * 0.12,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: Border.all(
                                            color: (academyItem.favorite == '1')
                                                ? Colors.red
                                                : Colors.orange, // สีขอบ
                                            width: 2.0, // ความหนาของขอบ
                                          ),
                                          // border: Border(
                                          //   bottom: BorderSide(color: Colors.orange, width: 2),
                                          // )
                                        ),
                                        padding: EdgeInsets.only(
                                            top: 8,
                                            bottom: 8,
                                            right: 6,
                                            left: 6),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Favorite',
                                              style: TextStyle(
                                                fontFamily: 'Arial',
                                                fontSize: 14,
                                                color: (academyItem.favorite ==
                                                        '1')
                                                    ? Colors.red
                                                    : Colors.orange,
                                              ),
                                            ),
                                            SizedBox(width: 4),
                                            Icon(Icons.favorite,
                                                color: (academyItem.favorite ==
                                                        '1')
                                                    ? Colors.red
                                                    : Colors.orange,
                                                size: 20),
                                          ],
                                        ),
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
                    const SizedBox(height: 4),
                  ],
                ),
              ),
            ),
          );
        });
  }

  //tablet, ipad
  Widget _buildAcademyList2(List<AcademyRespond> filteredAcademy) {
    final widthArea = WidgetsBinding.instance.window.physicalSize.width /
        WidgetsBinding.instance.window.devicePixelRatio;
    return ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: filteredAcademy.length,
        separatorBuilder: (_, __) => Container(padding: EdgeInsets.all(4)),
        itemBuilder: (context, index) {
          final academyItem = filteredAcademy[index];
          return GestureDetector(
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
                            borderRadius: BorderRadius.circular(2),
                            child: Image.network(
                              academyItem.academy_image,
                              height: 180,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Image.asset(
                                  'assets/images/default_image.png', // Default image in case of an error.
                                  width: double.infinity,
                                  height: 180,
                                  fit: BoxFit.contain,
                                );
                              },
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
                              academyItem.academy_subject,
                              style: const TextStyle(
                                fontFamily: 'Arial',
                                color: Color(0xFF555555),
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8, bottom: 8),
                              child: Column(
                                children: academyItem.academy_coach_data.isEmpty
                                    ? [Text("")]
                                    : List.generate(1, (index) {
                                        return _buildCoachList(
                                            academyItem.academy_coach_data,
                                            index);
                                      }),
                              ),
                            ),
                            Text(
                              academyItem.academy_date == "Time Out"
                                  ? '$timeoutTS'
                                  : '$startTS : ${academyItem.academy_date}',
                              style: TextStyle(
                                fontFamily: 'Arial',
                                fontSize: 18,
                                color: academyItem.academy_date == "Time Out"
                                    ? Colors.red
                                    : const Color(0xFF555555),
                                fontWeight: FontWeight.w500,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                            const SizedBox(height: 16),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  academyId = academyItem.academy_id;
                                  academyType = academyItem.academy_type;
                                  favorite();
                                });
                              },
                              child: Container(
                                width: widthArea * 0.12,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: (academyItem.favorite == '1')
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
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Favorite',
                                      style: TextStyle(
                                        fontFamily: 'Arial',
                                        fontSize: 16,
                                        color: (academyItem.favorite == '1')
                                            ? Colors.red
                                            : Colors.orange,
                                      ),
                                    ),
                                    SizedBox(width: 4),
                                    Icon(Icons.favorite,
                                        color: (academyItem.favorite == '1')
                                            ? Colors.red
                                            : Colors.orange,
                                        size: 22),
                                  ],
                                ),
                              ),
                            ),
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
        });
  }

  Widget _buildCoachList(List<AcademyCoachData> academyCoachData, int index) {
    final coach = academyCoachData[index];
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Coach Avatar
            ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: Image.network(
                coach.avatar ?? '',
                height: isMobile ? 32 : 36,
                width: isMobile ? 32 : 36,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => Icon(Icons.error),
              ),
            ),
            // Coach Name
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Text(
                  coach.name ?? '',
                  style: TextStyle(
                    fontFamily: 'Arial',
                    fontSize: isMobile ? 14 : 18,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF555555),
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ),
            ),
          ],
        ),
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
          print("print message: ${jsonResponse['status']}");
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

  Widget _DropdownCategory(String value) {
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
            items: _modelCategory
                .map((ModelDropdownAcademy category) =>
                    DropdownMenuItem<ModelDropdownAcademy>(
                      value: category,
                      child: Text(
                        category.name,
                        style: TextStyle(
                          fontFamily: 'Arial',
                          fontSize: 14,
                        ),
                      ),
                    ))
                .toList(),
            value: selectedCategory,
            onChanged: (value) {
              setState(() {
                selectedCategory = value;
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
        ),
        SizedBox(height: 8),
      ],
    );
  }

  Widget _DropdownType(String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Text(
        //   value,
        //   style: TextStyle(
        //     fontFamily: 'Arial',
        //     fontSize: 14,
        //     color: Color(0xFF555555),
        //     fontWeight: FontWeight.w500,
        //   ),
        // ),
        // SizedBox(height: 8),
        Container(
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
            items: _modelType
                .map((ModelDropdownAcademy type) =>
                    DropdownMenuItem<ModelDropdownAcademy>(
                      value: type,
                      child: Text(
                        type.name,
                        style: TextStyle(
                          fontFamily: 'Arial',
                          fontSize: 14,
                        ),
                      ),
                    ))
                .toList(),
            value: selectedType,
            onChanged: (value) {
              setState(() {
                selectedType = value;
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
        ),
        SizedBox(height: 8),
      ],
    );
  }

  Widget _DropdownLevel(String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Text(
        //   value,
        //   style: TextStyle(
        //     fontFamily: 'Arial',
        //     fontSize: 14,
        //     color: Color(0xFF555555),
        //     fontWeight: FontWeight.w500,
        //   ),
        // ),
        // SizedBox(height: 8),
        Container(
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
            items: _modelLevel
                .map((ModelDropdownAcademy level) =>
                    DropdownMenuItem<ModelDropdownAcademy>(
                      value: level,
                      child: Text(
                        level.name,
                        style: TextStyle(
                          fontFamily: 'Arial',
                          fontSize: 14,
                        ),
                      ),
                    ))
                .toList(),
            value: selectedLevel,
            onChanged: (value) {
              setState(() {
                selectedLevel = value;
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
        ),
        SizedBox(height: 8),
      ],
    );
  }

  ModelDropdownAcademy? selectedCategory;
  ModelDropdownAcademy? selectedType;
  ModelDropdownAcademy? selectedLevel;
  List<ModelDropdownAcademy> _modelCategory = [
    ModelDropdownAcademy(id: '001', name: 'Searching...'),
  ];

  List<ModelDropdownAcademy> _modelType = [
    ModelDropdownAcademy(id: '001', name: 'All Type'),
    ModelDropdownAcademy(id: '002', name: 'Course'),
    ModelDropdownAcademy(id: '003', name: 'Learning Map'),
    ModelDropdownAcademy(id: '004', name: 'OA Courese'),
  ];

  List<ModelDropdownAcademy> _modelLevel = [
    ModelDropdownAcademy(id: '001', name: 'Searching...'),
  ];
}
