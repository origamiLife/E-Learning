
import 'package:academy/welcome_to_academy/export.dart';
import 'package:http/http.dart' as http;
import '../language/translate_page.dart';
import 'challeng/challenge_test.dart';
import 'challeng/challenge_start.dart';
import 'evaluate/evaluate_module.dart';

class AcademyPage extends StatefulWidget {
  AcademyPage({
    super.key,
    required this.employee,
    required this.Authorization,
  });
  final Employee employee;
  final String Authorization;
  @override
  _AcademyPageState createState() => _AcademyPageState();
}

class _AcademyPageState extends State<AcademyPage> {
  final _controller = SideMenuController();
  int _currentIndex = 0;
  late Future<List<AcademyRespond>> fetchAcademy;
  List<AcademyRespond> allAcademy = [];
  List<AcademyRespond> filteredAcademy = [];
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();
  DateTime? lastPressed;
  String _searchA = '';
  bool _isMenu = false;
  bool _change = false;
  String _comment = '';
  final List<String> itemsLogo = ['Language', 'Logout'];
  String? selectedValue;

  @override
  void initState() {
    super.initState();
    if ((page != "challenge")) fetchAcademy = fetchAcademies();
    fetchAcademy.then((challenges) {
      setState(() {
        allAcademy = challenges;
        filteredAcademy = challenges;
      });
    });

    // Listener สำหรับการกรอง
    _searchController.addListener(() {
      _change = false;
      if (page != "challenge") fetchAcademies();
      filterAcademy();
    });
    _commentController.addListener(() {
      _comment = _commentController.text;
      print("Current text: ${_commentController.text}");
    });
  }

  void filterAcademy() {
    final query = _searchController.text.toLowerCase();

    setState(() {
      filteredAcademy = allAcademy.where((academy) {
        final name = academy.academy_subject.toLowerCase();
        final start = academy.academy_date.toLowerCase();
        return name.contains(query) || start.contains(query);
      }).toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  int _selectedIndex = 0;
  String page = "course";
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      switch (index) {
        case 0:
          page = "course";
          break;
        case 1:
          page = "challenge";
          break;
        case 2:
          page = "catalog";
          break;
        case 3:
          page = "favorite";
          break;
        case 4:
          page = "enroll";
          break;
        default:
          page = "course";
      }
      if (page == "challenge") {
      } else {
        _change = true;
        fetchAcademies();
      }
    });
  }

  List<TabItem> items = [
    TabItem(
      icon: FontAwesomeIcons.university,
      title: 'Learning',
    ),
    TabItem(
      icon: FontAwesomeIcons.trophy,
      title: 'Challenge',
    ),
    TabItem(
      icon: FontAwesomeIcons.thList,
      title: 'Catalog',
    ),
    TabItem(
      icon: FontAwesomeIcons.heart,
      title: 'Favorite',
    ),
    TabItem(
      icon: FontAwesomeIcons.graduationCap,
      title: 'Coach Course',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // เช็คว่ามีการกดปุ่มย้อนกลับครั้งล่าสุดหรือไม่ และเวลาห่างจากปัจจุบันมากกว่า 2 วินาทีหรือไม่
        final now = DateTime.now();
        final maxDuration = Duration(seconds: 2);
        final isWarning =
            lastPressed == null || now.difference(lastPressed!) > maxDuration;

        if (isWarning) {
          // ถ้ายังไม่ได้กดสองครั้งภายในเวลาที่กำหนด ให้แสดง SnackBar แจ้งเตือน
          lastPressed = DateTime.now();

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Press back again to exit the origami application.',
                style: TextStyle(
                  fontFamily: 'Arial',
                  color: Colors.white,
                ),
              ),
              duration: maxDuration,
            ),
          );
          return false; // ไม่ออกจากแอป
        }

        // ถ้ากดปุ่มย้อนกลับสองครั้งภายในเวลาที่กำหนด ให้ออกจากแอป
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 1,
          foregroundColor: Color(0xFFFF9900),
          backgroundColor: Colors.white,
          title: Container(
            alignment: (isAndroid || isIPhone)
                ? Alignment.centerLeft
                : Alignment.center,
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'ORIGAMI ACADEMY',
                    style: TextStyle(
                      fontFamily: 'Arial',
                      color: Color(0xFFFF9900),
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                DropdownButtonHideUnderline(
                  child: DropdownButton2<String>(
                    customButton: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        image: DecorationImage(
                          image: NetworkImage(
                            '${widget.employee.emp_avatar}',
                          ),
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                    ),
                    items: itemsLogo
                        .map((String item) => DropdownMenuItem<String>(
                              value: item,
                              child: Text(
                                item,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'Arial',
                                  color: const Color(0xFF555555),
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ))
                        .toList(),
                    value: selectedValue,
                    onChanged: (String? value) {
                      setState(() {
                        selectedValue = value;
                        if (value == 'Language') {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => TranslatePage(
                                        employee: widget.employee,
                                        Authorization: widget.Authorization,
                                      )));
                        } else {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginPage(
                                      num: 1,
                                      popPage: 0,
                                    )),
                            (Route<dynamic> route) =>
                                false, // ลบหน้าทั้งหมดใน stack
                          );
                        }
                      });
                    },
                    buttonStyleData: ButtonStyleData(
                      // This is necessary for the ink response to match our customButton radius.
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                      ),
                    ),
                    dropdownStyleData: DropdownStyleData(
                      width: 160,
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: Colors.white,
                      ),
                      offset: const Offset(40, -4),
                    ),
                    menuItemStyleData: const MenuItemStyleData(
                      height: 40,
                      padding: EdgeInsets.only(left: 14, right: 14),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // leading: IconButton(onPressed: (){_controller.toggle();}, icon: Icon(Icons.menu)),
        ),
        bottomNavigationBar: BottomBarDefault(
          items: items,
          iconSize: 18,
          animated: true,
          titleStyle: TextStyle(
            fontFamily: 'Arial',
          ),
          backgroundColor: Colors.white,
          color: Colors.grey.shade400,
          colorSelected: Color(0xFFFF9900),
          indexSelected: _selectedIndex,
          // paddingVertical: 25,
          onTap: _onItemTapped,
        ),
        body: SafeArea(
          child: Row(
            children: [
              Expanded(
                child: (page != "challenge")
                    ? Column(
                        children: [
                          _buildSearchField(),
                          SizedBox(height: 10),
                          Expanded(child: loading()),
                        ],
                      )
                    : ChallengeStartTime(
                        employee: widget.employee,
                        Authorization: widget.Authorization),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget loading() {
    return FutureBuilder<List<AcademyRespond>>(
      future: fetchAcademy,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
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
            'NOT FOUND DATA',
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
          return _Learning(filteredAcademy);
        }
      },
    );
  }

  Widget _Learning(List<AcademyRespond> filteredAcademy) {
    return SafeArea(
      child: (filteredAcademy.isNotEmpty)
          ? SingleChildScrollView(
              child: Column(
                children: [
                  (_isMenu)
                      ? _buildAcademyCard(filteredAcademy)
                      : (isAndroid || isIPhone)
                          ? _buildAcademyList(filteredAcademy)
                          : _buildAcademyList2(filteredAcademy),
                ],
              ),
            )
          : Container(
              alignment: Alignment.center,
              child: Text(
                'NOT FOUND DATA',
                style: TextStyle(
                  fontFamily: 'Arial',
                  fontSize: 16.0,
                  color: const Color(0xFF555555),
                  fontWeight: FontWeight.w700,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
    );
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
                hintText: '${Search}...',
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
                    // color: Colors.red, // สีไอคอน
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

  //android,iphone
  Widget _buildAcademyList(List<AcademyRespond> filteredAcademy) {
    return Column(
      children: List.generate(filteredAcademy.length, (indexI) {
        final academy = filteredAcademy;
        return Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EvaluateModule(
                    employee: widget.employee,
                    academy: academy[indexI],
                    Authorization: widget.Authorization,
                    callback: () {
                      setState(() {
                        academyId = academy[indexI].academy_id;
                        academyType = academy[indexI].academy_type;
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
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      const SizedBox(width: 8),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Image.network(
                          '${academy[indexI].academy_image}',
                          width: 60,
                          height: 60,
                          fit: BoxFit.fitWidth,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(Icons.error);
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            academy[indexI].academy_subject,
                            style: TextStyle(
                              fontFamily: 'Arial',
                              color: const Color(0xFF555555),
                              // fontSize: 64,
                              fontWeight: FontWeight.w700,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                          Text(
                            academy[indexI].academy_date == "Time Out"
                                ? academy[indexI].academy_date
                                : 'Start : ${academy[indexI].academy_date}',
                            style: TextStyle(
                              fontFamily: 'Arial',
                              color: academy[indexI].academy_date == "Time Out"
                                  ? Colors.red
                                  : const Color(0xFF555555),
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ],
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
    );
  }

  //tablet, ipad
  Widget _buildAcademyList2(List<AcademyRespond> filteredAcademy) {
    return Column(
      children: [
        Column(
          children: List.generate(filteredAcademy.length, (index) {
            final academy = filteredAcademy;
            return Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EvaluateModule(
                        employee: widget.employee,
                        academy: academy[index],
                        Authorization: widget.Authorization,
                        callback: () {
                          setState(() {
                            academyId = academy[index].academy_id;
                            academyType = academy[index].academy_type;
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
                              academy[index].academy_image,
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
                                  academy[index].academy_subject,
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
                                  academy[index].academy_date == "Time Out"
                                      ? academy[index].academy_date
                                      : 'Start : ${academy[index].academy_date}',
                                  style: TextStyle(
                                    fontFamily: 'Arial',
                                    fontSize: 18,
                                    color: academy[index].academy_date ==
                                            "Time Out"
                                        ? Colors.red
                                        : const Color(0xFF555555),
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                                SizedBox(height: 8),
                                Column(
                                  children: List.generate(
                                    academy[index].academy_coach_data.length,
                                    (indexII) {
                                      final coachData = academy[index]
                                          .academy_coach_data[indexII];
                                      return Padding(
                                        padding: const EdgeInsets.all(4),
                                        child: Row(
                                          children: [
                                            // Coach Avatar
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                              child: Image.network(
                                                coachData.avatar ?? '',
                                                height: 50,
                                                width: 50,
                                                fit: BoxFit.fitHeight,
                                                errorBuilder: (context, error,
                                                    stackTrace) {
                                                  return Icon(Icons.error);
                                                },
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            // Coach Name
                                            Flexible(
                                              child: Text(
                                                coachData.name ?? '',
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
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),
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

  Widget _buildAcademyCard(List<AcademyRespond> filteredAcademy) {
    return GridView.builder(
      padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: (isAndroid == true || isIPhone == true) ? 2 : 4,
        childAspectRatio: 0.7,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: filteredAcademy.length,
      itemBuilder: (BuildContext context, int index) {
        final _academy = filteredAcademy;
        return InkWell(
          onTap: () {
            setState(() {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => EvaluateModule(
                          employee: widget.employee,
                          academy: _academy[index],
                          Authorization: widget.Authorization,
                          callback: () {
                            academyId = _academy[index].academy_id;
                            academyType = _academy[index].academy_type;
                            setState(() {
                              favorite();
                            });
                          },
                        )),
              );
            });
          },
          child: IntrinsicHeight(
            child: Card(
              // elevation: 0,
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
                      offset: Offset(0, 3), // x, y
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      LayoutBuilder(
                        builder: (context, constraints) {
                          return Stack(
                            children: [
                              // Background Image
                              Card(
                                elevation: 0,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: Image.network(
                                    '${_academy[index].academy_image}',
                                    width: constraints.maxWidth,
                                    height: 120,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Icon(Icons.error);
                                    },
                                  ),
                                ),
                              ),
                              // Category Label
                              Padding(
                                padding: const EdgeInsets.all(4),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.black26,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(4),
                                          child: Text(
                                            _academy[index].academy_category ??
                                                '',
                                            style: TextStyle(
                                              fontFamily: 'Arial',
                                              fontSize: 12.0,
                                              color: Colors.white,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Spacer(),
                                  ],
                                ),
                              ),
                              // Type Label
                              Positioned(
                                bottom: 4,
                                left: 4,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.black26,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(4),
                                    child: Text(
                                      _academy[index].academy_type,
                                      style: TextStyle(
                                        fontFamily: 'Arial',
                                        fontSize: 12.0,
                                        color: Colors.white,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            _academy[index].academy_subject,
                            style: TextStyle(
                              fontFamily: 'Arial',
                              fontSize: 16.0,
                              color: Color(0xFF555555),
                              fontWeight: FontWeight.w700,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: SingleChildScrollView(
                          child: Column(
                            children: List.generate(
                              _academy[index].academy_coach_data.length,
                              (indexII) {
                                final coachData =
                                    _academy[index].academy_coach_data;
                                return Padding(
                                  padding: const EdgeInsets.all(4),
                                  child: Row(
                                    children: [
                                      // Coach Avatar
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(50),
                                        child: Image.network(
                                          coachData[indexII].avatar ?? '',
                                          height: 40,
                                          width: 40,
                                          fit: BoxFit.fitHeight,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                            return Icon(Icons.error);
                                          },
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      // Coach Name
                                      Expanded(
                                        child: Text(
                                          coachData[indexII].name ?? '',
                                          style: TextStyle(
                                            fontFamily: 'Arial',
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: Color(0xFF555555),
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
                        ),
                      ),
                      (_selectedIndex == 0)
                          ? Expanded(
                              flex: 1,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: (_academy[index].academy_date ==
                                            "Time Out")
                                        ? SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: Row(
                                              children: [
                                                Container(
                                                  alignment:
                                                      Alignment.bottomLeft,
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(
                                                    _academy[index]
                                                        .academy_date,
                                                    style: TextStyle(
                                                      fontFamily: 'Arial',
                                                      color: Colors.red,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        : SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: Row(
                                              children: [
                                                Container(
                                                  alignment:
                                                      Alignment.bottomLeft,
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(
                                                    'Start: ${_academy[index].academy_date}',
                                                    style: TextStyle(
                                                      fontFamily: 'Arial',
                                                      color: const Color(
                                                          0xFF555555),
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 1,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                  ),
                                  // Row(
                                  //   mainAxisAlignment: MainAxisAlignment.end,
                                  //   children: [
                                  //     if (_academy[index].academy_date ==
                                  //         "Time Out")
                                  //       Container(
                                  //         alignment: Alignment.bottomRight,
                                  //         padding: EdgeInsets.all(8),
                                  //         child: Container(
                                  //           padding: EdgeInsets.all(4),
                                  //           decoration: BoxDecoration(
                                  //             color: Colors.green,
                                  //             borderRadius:
                                  //                 BorderRadius.circular(10),
                                  //           ),
                                  //           child: Text(
                                  //             Enroll,
                                  //             style: TextStyle(fontFamily: 'Arial',
                                  //               color: Colors.white,
                                  //             ),
                                  //             overflow: TextOverflow.ellipsis,
                                  //             maxLines: 1,
                                  //           ),
                                  //         ),
                                  //       ),
                                  //   ],
                                  // ),
                                ],
                              ),
                            )
                          : Container()
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
    );
  }

  Future<List<AcademyRespond>> fetchAcademies() async {
    final uri = Uri.parse("$host/api/origami/academy/course.php");
    final response = await http.post(
      uri,
      headers: {'Authorization': 'Bearer ${widget.Authorization}'},
      body: {
        'comp_id': widget.employee.comp_id,
        'emp_id': widget.employee.emp_id,
        'Authorization': widget.Authorization,
        'pages': page,
        'search': _searchA,
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      // ตรวจสอบว่ามีคีย์ 'academy_data' และไม่เป็น null
      if (jsonResponse['academy_data'] != null) {
        final List<dynamic> academiesJson = jsonResponse['academy_data'];
        setState(() {
          // แปลงข้อมูลจาก JSON เป็น List<AcademyRespond>
          fetchAcademy = fetchAcademies();
          if (_change == true) {
            fetchAcademy.then((challenges) {
              setState(() {
                allAcademy = challenges;
                filteredAcademy = challenges;
              });
            });
          }
        });
        return academiesJson
            .map((json) => AcademyRespond.fromJson(json))
            .toList();
      } else {
        // หากไม่มีข้อมูลใน 'academy_data' ให้คืนค่าเป็นลิสต์ว่าง
        print('No academy data available.');
        return [];
      }
    } else {
      throw Exception('Failed to load academies');
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

class AcademyRespond {
  final String academy_id;
  final String academy_type;
  final String academy_subject;
  final String academy_image;
  final String? academy_category;
  final String academy_date;
  final List<AcademyCoachData> academy_coach_data;
  final int favorite;

  AcademyRespond({
    required this.academy_id,
    required this.academy_type,
    required this.academy_subject,
    required this.academy_image,
    this.academy_category,
    required this.academy_date,
    required this.academy_coach_data,
    required this.favorite,
  });

  // สร้างฟังก์ชันเพื่อแปลง JSON ไปเป็น Object ของ Academy
  factory AcademyRespond.fromJson(Map<String, dynamic> json) {
    return AcademyRespond(
      academy_id: json['academy_id'],
      academy_type: json['academy_type'],
      academy_subject: json['academy_subject'],
      academy_image: json['academy_image'],
      academy_category: json['academy_category'],
      academy_date: json['academy_date'],
      academy_coach_data: (json['academy_coach_data'] as List)
          .map((statusJson) => AcademyCoachData.fromJson(statusJson))
          .toList(),
      favorite: json['favorite'],
    );
  }

  // การแปลง Object ของ Academy กลับเป็น JSON
  Map<String, dynamic> toJson() {
    return {
      'academy_id': academy_id,
      'academy_type': academy_type,
      'academy_subject': academy_subject,
      'academy_image': academy_image,
      'academy_category': academy_category,
      'academy_date': academy_date,
      'academy_coach_data':
          academy_coach_data.map((item) => item.toJson()).toList(),
      'favorite': favorite,
    };
  }
}

class AcademyCoachData {
  final String? name;
  final String? avatar;

  AcademyCoachData({
    this.name,
    this.avatar,
  });

  // ฟังก์ชันเพื่อแปลง JSON ไปเป็น Object ของ AcademyCoachData
  factory AcademyCoachData.fromJson(Map<String, dynamic> json) {
    return AcademyCoachData(
      name: json['name'],
      avatar: json['avatar'],
    );
  }

  // การแปลง Object ของ AcademyCoachData กลับเป็น JSON
  Map<String, dynamic> toJson() {
    return {
      'avatar': avatar,
      'name': name,
    };
  }
}

class Challenge {
  String challengeDescription;
  String challengeDuration;
  String challengeEnd;
  String challengeId;
  String challengeLogo;
  String challengeName;
  String challengePointValue;
  String challengeQuestionPart;
  String challengeRank;
  String challengeRule;
  String challengeStart;
  String challengeStatus;
  int correctAnswer;
  String endDate;
  String requestId;
  int specificQuestion;
  String startDate;
  String status;
  String? timerFinish;
  String timerStart;

  Challenge({
    required this.challengeDescription,
    required this.challengeDuration,
    required this.challengeEnd,
    required this.challengeId,
    required this.challengeLogo,
    required this.challengeName,
    required this.challengePointValue,
    required this.challengeQuestionPart,
    required this.challengeRank,
    required this.challengeRule,
    required this.challengeStart,
    required this.challengeStatus,
    required this.correctAnswer,
    required this.endDate,
    required this.requestId,
    required this.specificQuestion,
    required this.startDate,
    required this.status,
    this.timerFinish,
    required this.timerStart,
  });

  // การสร้างฟังก์ชันเพื่อแปลง JSON ไปเป็น Object ของ Challenge
  factory Challenge.fromJson(Map<String, dynamic> json) {
    return Challenge(
      challengeDescription: json['challenge_description'],
      challengeDuration: json['challenge_duration'],
      challengeEnd: json['challenge_end'],
      challengeId: json['challenge_id'],
      challengeLogo: json['challenge_logo'],
      challengeName: json['challenge_name'],
      challengePointValue: json['challenge_point_value'],
      challengeQuestionPart: json['challenge_question_part'],
      challengeRank: json['challenge_rank'],
      challengeRule: json['challenge_rule'],
      challengeStart: json['challenge_start'],
      challengeStatus: json['challenge_status'],
      correctAnswer: json['correct_answer'],
      endDate: json['end_date'],
      requestId: json['request_id'],
      specificQuestion: json['specific_question'],
      startDate: json['start_date'],
      status: json['status'],
      timerFinish: json['timer_finish'],
      timerStart: json['timer_start'],
    );
  }

  // การแปลง Object ของ Challenge กลับเป็น JSON
  Map<String, dynamic> toJson() {
    return {
      'challenge_description': challengeDescription,
      'challenge_duration': challengeDuration,
      'challenge_end': challengeEnd,
      'challenge_id': challengeId,
      'challenge_logo': challengeLogo,
      'challenge_name': challengeName,
      'challenge_point_value': challengePointValue,
      'challenge_question_part': challengeQuestionPart,
      'challenge_rank': challengeRank,
      'challenge_rule': challengeRule,
      'challenge_start': challengeStart,
      'challenge_status': challengeStatus,
      'correct_answer': correctAnswer,
      'end_date': endDate,
      'request_id': requestId,
      'specific_question': specificQuestion,
      'start_date': startDate,
      'status': status,
      'timer_finish': timerFinish,
      'timer_start': timerStart,
    };
  }
}

extension on Widget {
  Widget? showOrNull(bool isShow) => isShow ? this : null;
}
