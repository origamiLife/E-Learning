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
      required this.learnin_page,
      required this.logo,
      this.company_id})
      : super(key: key);
  final Employee employee;
  final String Authorization;
  final String learnin_page;
  final String logo;
  final int? company_id;

  @override
  State<AcademyHomePage> createState() => _AcademyHomePageState();
}

class _AcademyHomePageState extends State<AcademyHomePage> {
  TextEditingController _searchController = TextEditingController();
  TextEditingController _searchCategoryController = TextEditingController();
  TextEditingController _createEnrollController = TextEditingController();
  late PaginationModel pagination;
  String learnin_page = "course";
  String search = '';
  String searchCategory = '';
  String? filter_date;
  String? filter_type;
  String? filter_level;
  String? filter_category;
  String pages = '';
  bool isfilter = false;
  Map<String, String> levelOptions = {};
  Map<String, String> typeOptions = {};
  List<CategoryData> categories = [];
  CategoryData? selectedCategories;
  List<int> selectIndex = [];

  @override
  void initState() {
    super.initState();
    learnin_page = widget.learnin_page;
    print('isAndroid : $isAndroid');
    print('isIPhone : $isIPhone');
    print('object : $isMobile');
    if (learnin_page == 'challenge') {
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
    loadLevels();
    loadCategories();
  }

  Future<void> loadLevels() async {
    final leveldata = await fetchLevelData();
    final typedata = await fetchTypeData();
    if (leveldata != null) {
      setState(() {
        levelOptions = leveldata.level_data;
      });
    }
    if (typedata != null) {
      setState(() {
        typeOptions = typedata.level_data;
      });
    }
  }

  Future<void> loadCategories() async {
    try {
      final result = await fetchCategoryData();
      setState(() {
        categories = result;
      });
    } catch (e) {
      print('Error loading categories: $e');
    }
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
    });
  }

  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    _selectedIndex = index;
    setState(() {
      if (index == 0) {
        learnin_page = "course";
      } else if (index == 1) {
        learnin_page = "challenge";
      } else if (index == 2) {
        learnin_page = "catalog";
      } else if (index == 3) {
        learnin_page = "favorite";
      } else {
        learnin_page = "course";
      }
    });
  }

  List<TabItem> items = [
    TabItem(
      icon: FontAwesomeIcons.university,
      title: MyLearningTS,
    ),
    TabItem(
      icon: FontAwesomeIcons.trophy,
      title: MyChallengeTS,
    ),
    TabItem(
      icon: FontAwesomeIcons.thList,
      title: CatalogTS,
    ),
    TabItem(
      icon: FontAwesomeIcons.heart,
      title: FavoriteTS,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildNavigationBar(),
            const SizedBox(height: 8),
            (learnin_page == 'challenge')
                ? Expanded(
                    child: ChallengeStartTime(
                      employee: widget.employee,
                      Authorization: widget.Authorization,
                      logo: widget.logo,
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

  Widget _buildNavigationBar() {
    return AppBar(
      backgroundColor: Colors.white, // Example background color
      automaticallyImplyLeading: false, // Remove default back button
      actions: [
        SizedBox(width: 8),
        Expanded(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Image.network(
                  widget.logo,
                  width: 35,
                  height: 35,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset(
                      widget.employee.comp_logo,
                      width: 35,
                      height: 35,
                      fit: BoxFit.contain,
                    );
                  },
                ),
                SizedBox(width: 14),
                Text(
                  'E-Learning',
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
            onPressed: () => fetchLogout(),
            child: Text('$IntOutTS', style: TextStyle(fontFamily: 'Arial')),
          ),
        ),
        // SizedBox(width: 16),
      ],
    );
  }

  Widget _buildPopularEvents() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(child: _buildSearchField()),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8),
                    child: InkWell(
                        onTap: () {
                          setState(() {
                            (isfilter == false)
                                ? isfilter = true
                                : isfilter = false;
                          });
                        },
                        child: Icon(
                          Icons.filter_list,
                          color: Colors.grey,
                          size: 22,
                        )),
                  ),
                ],
              ),
              SizedBox(height: 8),
              const Padding(
                padding: EdgeInsets.only(left: 4, right: 4),
              ),
              if (isfilter == true)
                Padding(
                  padding: const EdgeInsets.only(left: 8, right: 8),
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
            child: FutureBuilder<List<AcademyModel>>(
              future: fetchAcademies(),
              builder: (context, snapshot) {
                // if (snapshot.connectionState == ConnectionState.waiting) {
                //   return Container();
                // } else
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData) {
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

  Widget _Learning(List<AcademyModel> myLearning) {
    return myLearning.isNotEmpty
        ? SingleChildScrollView(
            child: Column(
              children: [
                _buildAcademyListView(myLearning),
                if (pagination.page != pagination.total_pages)
                  Column(
                    children: [
                      Divider(),
                      Row(
                        children: [
                          InkWell(
                            onTap: () {
                              if (pagination.page > 1) {
                                setState(() {
                                  pages = (pagination.page - 1).toString();
                                });
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 8, right: 8, top: 8, bottom: 12),
                              child: Text(
                                'ก่อนหน้า',
                                style: TextStyle(
                                  fontFamily: 'Arial',
                                  fontSize: 16.0,
                                  color: (pagination.page <= 1)
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
                              if (pagination.page >= pagination.total_pages) {
                                setState(() {
                                  pages = (pagination.page + 1).toString();
                                });
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 8, right: 8, top: 8, bottom: 12),
                              child: Text(
                                'ถัดไป',
                                style: TextStyle(
                                  fontFamily: 'Arial',
                                  fontSize: 16.0,
                                  color: (pagination.page <=
                                          pagination.total_pages)
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
          )
        : _buildNotFoundText();
  }

  Widget _buildAcademyListView(List<AcademyModel> myLearning) {
    if (isMobile) {
      return _buildAcademyList(myLearning);
    } else {
      return _buildAcademyList2(myLearning);
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
  Widget _buildAcademyList(List<AcademyModel> myLearning) {
    final widthArea = WidgetsBinding.instance.window.physicalSize.width /
        WidgetsBinding.instance.window.devicePixelRatio;
    return ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: myLearning.length,
        separatorBuilder: (_, __) => Container(padding: EdgeInsets.all(4)),
        itemBuilder: (context, index) {
          final academylist = myLearning[index];
          return InkWell(
            onTap: () {
              fetchNextPlan(academylist);
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
                                academylist.academy_cover,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Image.asset(
                                    academylist.academy_cover_error,
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
                                (academylist.academy_name == '')
                                    ? 'Topic not found'
                                    : academylist.academy_name,
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
                                children: academylist.academy_coach.isEmpty
                                    ? [Text("")]
                                    : List.generate(1, (index) {
                                        return _buildCoachList(
                                            academylist.academy_coach, index);
                                      }),
                              ),
                              SizedBox(height: 4),
                              Row(
                                children: [
                                  if (academylist.academy_flag == 'learn')
                                    Expanded(
                                      child: Text(
                                        academylist.academy_text,
                                        style: TextStyle(
                                          fontFamily: 'Arial',
                                          color: const Color(0xFF555555),
                                          fontWeight: FontWeight.w500,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                      ),
                                    )
                                  else
                                    Expanded(
                                        child: _enrollWidget(
                                      academylist,
                                      widthArea,
                                    )),
                                  Container(
                                      padding: const EdgeInsets.only(
                                          left: 4, right: 4)),
                                  Expanded(
                                      child: _favoriteWidget(
                                    academylist,
                                    widthArea,
                                    index,
                                  )),
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

  // bool isFavorite = false;
  Widget _favoriteWidget(
      AcademyModel academylist, double widthArea, int index) {
    // bool isSelected = selectIndex.contains(index);
    // (academylist.academy_favorite == 'Y') ? isSelected : !isSelected;
    return InkWell(
      onTap: () {
        setState(() {
          // (isSelected) ? selectIndex.remove(index) : selectIndex.add(index);

          sendFavorite(academylist.academy_id, academylist.academy_type);
          // print('isSelected: ${isSelected}');
        });
      },
      child: Container(
        width: widthArea * 0.12,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: (academylist.academy_favorite == 'Y')
                ? Colors.red
                : Colors.grey, // สีขอบ
            width: 2.0, // ความหนาของขอบ
          ),
        ),
        padding: EdgeInsets.only(top: 8, bottom: 8, right: 6, left: 6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Favorite',
              style: TextStyle(
                fontFamily: 'Arial',
                fontSize: 14,
                color: (academylist.academy_favorite == 'Y')
                    ? Colors.red
                    : Colors.grey,
              ),
            ),
            SizedBox(width: 4),
            Icon(Icons.favorite,
                color: (academylist.academy_favorite == 'Y')
                    ? Colors.red
                    : Colors.grey,
                size: 20),
          ],
        ),
      ),
    );
  }

  Widget _enrollWidget(AcademyModel academylist, double widthArea) {
    return InkWell(
      onTap: () {
        enroll_academy_id = academylist.academy_id;
        enroll_academy_type = academylist.academy_type;
        enroll_academy_pages = '';

        ////////////////////////// isCheck ////////////////////////////////
        print('enroll_academy_type:$enroll_academy_type\n'
            'enroll_academy_id:$enroll_academy_id\n'
            'academy_flag: ${academylist.academy_flag}');
        if (enroll_academy_type != '' &&
            enroll_academy_id != '' &&
            academylist.academy_flag == 'enroll') {
          if (academylist.academy_text == 'Enroll') {
            // fetchCreateEnroll(enroll_academy_id, enroll_academy_type);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                duration: Duration(seconds: 3),
                content: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                        child: Icon(Icons.check_circle, color: Colors.green)),
                    Flexible(
                      child: Padding(
                        padding: EdgeInsets.only(left: 14),
                        child: Text(
                          'Your enrollment has been successfully recorded and is pending administrator approval before proceeding',
                          style: TextStyle(
                            fontFamily: 'Arial',
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else if (academylist.academy_text == 'Pending') {
            // fetchDeleteEnroll(enroll_academy_id);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                duration: Duration(seconds: 3),
                content: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                        child: Icon(Icons.delete, color: Colors.red)),
                    Flexible(
                      child: Padding(
                        padding: EdgeInsets.only(left: 14),
                        child: Text(
                          'Your enrollment has been successfully recorded and is pending administrator approval before proceeding',
                          style: TextStyle(
                            fontFamily: 'Arial',
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        }
      },
      child: Container(
        width: widthArea * 0.12,
        decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Colors.green, // สีขอบ
            width: 2, // ความหนาของขอบ
          ),
        ),
        padding: EdgeInsets.only(top: 8, bottom: 8, right: 6, left: 6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(null, color: Colors.orange, size: 20),
            Text(
              academylist.academy_text,
              style: TextStyle(
                fontFamily: 'Arial',
                fontSize: 14,
                color: Colors.white,
              ),
            ),
            Icon(null, color: Colors.orange, size: 20),
          ],
        ),
      ),
    );
  }

  //tablet, ipad
  Widget _buildAcademyList2(List<AcademyModel> myLearning) {
    final widthArea = WidgetsBinding.instance.window.physicalSize.width /
        WidgetsBinding.instance.window.devicePixelRatio;
    return ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: myLearning.length,
        separatorBuilder: (_, __) => Container(padding: EdgeInsets.all(4)),
        itemBuilder: (context, index) {
          final academylist = myLearning[index];
          return GestureDetector(
            onTap: () {
              fetchNextPlan(academylist);
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
                              academylist.academy_cover,
                              height: 180,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Image.asset(
                                  academylist.academy_cover_error,
                                  width: double.infinity,
                                  height: 180,
                                  fit: BoxFit.cover,
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
                              (academylist.academy_name == '')
                                  ? 'Topic not found'
                                  : academylist.academy_name,
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
                                children: academylist.academy_coach.isEmpty
                                    ? [Text("")]
                                    : List.generate(1, (index) {
                                        return _buildCoachList(
                                            academylist.academy_coach, index);
                                      }),
                              ),
                            ),
                            Text(
                              '${academylist.academy_text}',
                              style: TextStyle(
                                fontFamily: 'Arial',
                                fontSize: 18,
                                color: Colors.red,
                                fontWeight: FontWeight.w500,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                            const SizedBox(height: 16),
                            InkWell(
                              onTap: () {
                                sendFavorite(academylist.academy_id,
                                    academylist.academy_type);
                              },
                              child: Container(
                                width: widthArea * 0.12,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: (academylist.academy_favorite == 'Y')
                                        ? Colors.red
                                        : Colors.grey, // สีขอบ
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
                                        color: (academylist.academy_favorite ==
                                                'Y')
                                            ? Colors.red
                                            : Colors.grey,
                                      ),
                                    ),
                                    SizedBox(width: 4),
                                    Icon(Icons.favorite,
                                        color: (academylist.academy_favorite ==
                                                'Y')
                                            ? Colors.red
                                            : Colors.grey,
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

  Widget _buildCoachList(List<AcademyCoachModel> academyCoachData, int index) {
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
                coach.coach_image,
                height: isMobile ? 32 : 36,
                width: isMobile ? 32 : 36,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => Image.network(
                  coach.coach_image_error,
                  height: isMobile ? 32 : 36,
                  width: isMobile ? 32 : 36,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            // Coach Name
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Text(
                  coach.coach_name,
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
          child: DropdownButton2<CategoryData>(
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
            items: categories
                .map((item) => DropdownMenuItem<CategoryData>(
                      value: item,
                      child: Text(
                        item.category_name,
                        style: TextStyle(
                          fontFamily: 'Arial',
                          fontSize: 14,
                        ),
                      ),
                    ))
                .toList(),
            value: selectedCategories,
            onChanged: (value) {
              setState(() {
                selectedCategories = value;
                filter_category = value?.category_id ?? '';
              });
            },
            underline: SizedBox.shrink(),
            iconStyleData: IconStyleData(
              icon: InkWell(
                onTap: () {
                  setState(() {
                    filter_category = null;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(Icons.close, color: Colors.red, size: 18),
                ),
              ),
              iconSize: 30,
            ),
            buttonStyleData: ButtonStyleData(
                padding: const EdgeInsets.symmetric(vertical: 2)),
            dropdownStyleData: DropdownStyleData(maxHeight: 200),
            menuItemStyleData: MenuItemStyleData(height: 33),
            dropdownSearchData: DropdownSearchData(
              searchController: _searchCategoryController,
              searchInnerWidgetHeight: 50,
              searchInnerWidget: Padding(
                padding: const EdgeInsets.all(8),
                child: TextFormField(
                  controller: _searchCategoryController,
                  keyboardType: TextInputType.text,
                  style: TextStyle(
                      fontFamily: 'Arial',
                      color: Color(0xFF555555),
                      fontSize: 14),
                  decoration: InputDecoration(
                    isDense: true,
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),
                    hintText: 'search...',
                    hintStyle: TextStyle(
                        fontFamily: 'Arial',
                        fontSize: 14,
                        color: Color(0xFF555555)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
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
              ),
              searchMatchFn: (item, searchValue) {
                return item.value!.category_name
                    .toLowerCase()
                    .contains(searchValue.toLowerCase());
              },
            ),
            onMenuStateChange: (isOpen) {
              if (!isOpen) {
                _searchCategoryController
                    .clear(); // Clear the search field when the menu closes
              }
            },
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
              value: filter_type,
              items: typeOptions.entries.map((entry) {
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
                  filter_type = value;
                });
              },
              underline: SizedBox.shrink(),
              iconStyleData: IconStyleData(
                icon: InkWell(
                  onTap: () {
                    setState(() {
                      filter_type = null;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(Icons.close, color: Colors.red, size: 18),
                  ),
                ),
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

  Widget _DropdownLevel(String value) {
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
              value: filter_level,
              items: levelOptions.entries.map((entry) {
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
                  filter_level = value;
                });
              },
              underline: SizedBox.shrink(),
              iconStyleData: IconStyleData(
                icon: InkWell(
                  onTap: () {
                    setState(() {
                      filter_level = null;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(Icons.close, color: Colors.red, size: 18),
                  ),
                ),
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

  String urlS = '';
  bool isStartLearning = false;
  Future<List<AcademyModel>> fetchAcademies() async {
    print('$filter_date:\n$filter_type:\n$filter_level:\n'
        '$filter_category:\n$search:\n$pages');
    if (_selectedIndex == 0) {
      urlS = "$host/api/origami/e-learning/academy/my-learning.php";
    } else if (_selectedIndex == 2) {
      urlS = "$host/api/origami/e-learning/academy/catalog.php";
    } else if (_selectedIndex == 3) {
      urlS = "$host/api/origami/e-learning/academy/my-favorite.php";
    }
    final uri = Uri.parse(urlS);
    try {
      final response = await http.post(
        uri,
        headers: {'Authorization': 'Bearer ${widget.Authorization}'},
        body: {
          'auth_password': authorization,
          'emp_id': widget.employee.emp_id,
          'comp_id': widget.employee.comp_id,
          'filter_date': filter_date ?? '',
          'filter_type': filter_type ?? '',
          'filter_level': filter_level ?? '',
          'filter_category': filter_category ?? '',
          'search': (search != '') ? '1' : search,
          'pages': pages,
        },
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        final List<dynamic> academiesJson = jsonResponse['academy_data'];
        pagination = PaginationModel.fromJson(jsonResponse['pagination']);
        return academiesJson
            .map((json) => AcademyModel.fromJson(json))
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

  Future<LevelData?> fetchLevelData() async {
    final uri = Uri.parse("$host/api/origami/e-learning/academy/level.php");
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

  Future<LevelData?> fetchTypeData() async {
    final uri = Uri.parse("$host/api/origami/e-learning/academy/type.php");
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

  String pageCategory = '';
  Future<List<CategoryData>> fetchCategoryData() async {
    try {
      final response = await http.post(
        Uri.parse('$host/api/origami/e-learning/academy/category.php'),
        body: {
          'auth_password': authorization,
          'comp_id': widget.employee.comp_id,
          'search': (searchCategory != '') ? '1' : searchCategory,
          'pages': pageCategory,
        },
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse['status'] == 200) {
          final List<dynamic> data = jsonResponse['category_data'];
          return data.map((e) => CategoryData.fromJson(e)).toList();
        } else {
          throw Exception('API error: ${jsonResponse['message']}');
        }
      } else {
        throw Exception('Server error: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Fetch error: $e');
    }
  }

  Future<void> sendFavorite(String academy_id, String academy_type) async {
    try {
      final response = await http.post(
        Uri.parse('$host/api/origami/e-learning/academy/favorite.php'),
        body: {
          'comp_id': widget.employee.comp_id,
          'emp_id': widget.employee.emp_id,
          'auth_password': authorization,
          'academy_id': academy_id,
          'academy_type': academy_type,
        },
      );
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse['status'] == 200) {
          setState(() {
            _selectedIndex = 3;
            _selectedIndex = 0;
          });
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

  Future<void> fetchLogout() async {
    try {
      final response = await http.post(
        Uri.parse('$host/api/origami/signout.php'),
        body: {
          'comp_id': widget.employee.comp_id,
          'emp_id': widget.employee.emp_id,
          'auth_password': authorization,
        },
      );
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse['status'] == 200) {
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
          print("logout message: ${jsonResponse['status']}");
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

  Future<void> fetchNextPlan(AcademyModel academylist) async {
    try {
      final response = await http.post(
        Uri.parse('$host/api/origami/e-learning/academy/study/plan.php'),
        body: {
          'auth_password': authorization,
          'emp_id': widget.employee.emp_id,
          'comp_id': widget.employee.comp_id,
          'academy_id': academylist.academy_id,
          'academy_type': academylist.academy_type,
        },
      );
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse['status'] == 200) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EvaluateModule(
                employee: widget.employee,
                Authorization: widget.Authorization,
                academy: academylist,
                callback: () {
                  sendFavorite(
                      academylist.academy_id, academylist.academy_type);
                },
              ),
            ),
          );
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

  String enroll_academy_id = '';
  String enroll_academy_type = '';
  String enroll_academy_pages = '';
  Future<List<GetEnrollModel>> fetchGetEnroll() async {
    final uri =
        Uri.parse("$host/api/origami/e-learning/academy/enroll/get.enroll.php");
    try {
      final response = await http.post(
        uri,
        headers: {'Authorization': 'Bearer ${widget.Authorization}'},
        body: {
          'auth_password': authorization,
          'emp_id': widget.employee.emp_id,
          'comp_id': widget.employee.comp_id,
          'academy_id': enroll_academy_id,
          'academy_type': enroll_academy_type,
          'page': enroll_academy_pages,
        },
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        final List<dynamic> dataJson = jsonResponse['enroll_data'];
        return dataJson.map((json) => GetEnrollModel.fromJson(json)).toList();
      } else {
        throw Exception(
            'Failed to load question data, status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching question data: $e');
      throw Exception('Error fetching question data: $e');
    }
  }

  String enrollDescription = '';
  Future<void> fetchCreateEnroll(String academy_id, String academy_type) async {
    try {
      final response = await http.post(
        Uri.parse(
            '$host/api/origami/e-learning/academy/enroll/create.enroll.php'),
        body: {
          'comp_id': widget.employee.comp_id,
          'emp_id': widget.employee.emp_id,
          'auth_password': authorization,
          'academy_id': academy_id,
          'academy_type': academy_type,
          'description': enrollDescription,
        },
      );
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse['status'] == 200) {
          // Navigator.pop(context);
          enrollDescription = '';
          _createEnrollController.clear();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              duration: Duration(seconds: 3),
              content: Row(
                children: [
                  Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: Icon(Icons.check_circle,
                          color: Colors.green, size: 20)),
                  Padding(
                    padding: EdgeInsets.only(left: 14),
                    child: Text(
                      jsonResponse['message'],
                      style: TextStyle(
                        fontFamily: 'Arial',
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
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

  // Future<void> fetchUpdateEnroll(String enroll_id, String description,
  //     AcademyModel academylist, double widthArea, isUpdateEnroll) async {
  //   try {
  //     final response = await http.post(
  //       Uri.parse(
  //           '$host/api/origami/e-learning/academy/enroll/update.enroll.php'),
  //       body: {
  //         'comp_id': widget.employee.comp_id,
  //         'emp_id': widget.employee.emp_id,
  //         'auth_password': authorization,
  //         'enroll_id': enroll_id,
  //         'description': description,
  //       },
  //     );
  //     if (response.statusCode == 200) {
  //       final jsonResponse = jsonDecode(response.body);
  //       if (jsonResponse['status'] == 200) {
  //         enrollDescription = '';
  //         _createEnrollController.clear();
  //         isUpdateEnroll = false;
  //         Navigator.pop(context);
  //         _getEnrollShowModal(academylist, widthArea, isUpdateEnroll);
  //         print("logout message: ${jsonResponse['status']}");
  //       } else {
  //         throw Exception(
  //             'Failed to load personal data: ${jsonResponse['message']}');
  //       }
  //     } else {
  //       throw Exception(
  //           'Failed to load personal data: ${response.reasonPhrase}');
  //     }
  //   } catch (e) {
  //     throw Exception('Failed to load personal data: $e');
  //   }
  // }

  Future<void> fetchDeleteEnroll(String enroll_id) async {
    try {
      final response = await http.post(
        Uri.parse(
            '$host/api/origami/e-learning/academy/enroll/delete.enroll.php'),
        body: {
          'comp_id': widget.employee.comp_id,
          'emp_id': widget.employee.emp_id,
          'auth_password': authorization,
          'enroll_id': enroll_id,
        },
      );
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse['status'] == 200) {
          enrollDescription = '';
          _createEnrollController.clear();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              duration: Duration(seconds: 3),
              content: Row(
                children: [
                  Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: Icon(Icons.delete, color: Colors.red, size: 20)),
                  Padding(
                    padding: EdgeInsets.only(left: 14),
                    child: Text(
                      jsonResponse['message'],
                      style: TextStyle(
                        fontFamily: 'Arial',
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
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
