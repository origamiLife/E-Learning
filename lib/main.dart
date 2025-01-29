import 'dart:ui';
import 'package:academy/welcome_to_academy/export.dart';
import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

String host = 'https://www.origami.life';
int selectedRadio = 2;
void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // รอการ initialize
  // ป้องกันการจับภาพหน้าจอ (สำหรับ Android)
  await secureScreen();

  // เตรียมข้อมูลสำหรับ Locale ภาษาไทย
  await initializeDateFormatting('th', null);

  // ตั้งค่า Hive
  var appDocumentDirectory = await getApplicationDocumentsDirectory();
  await Hive.initFlutter(appDocumentDirectory.path);
  await Hive.openBox('userBox');

  // บังคับให้แอปทำงานในแนวตั้งก่อนเรียก runApp()
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) => runApp(const MyApp()));
}

Future<void> secureScreen() async {
  if (Platform.isAndroid) {
    // ใช้ MethodChannel สำหรับ FLAG_SECURE (แทน FlutterWindowManager)
    const platform = MethodChannel('com.origami.learning/screen');
    try {
      await platform.invokeMethod('enableSecure');
    } on PlatformException catch (e) {
      debugPrint('Failed to enable secure screen: ${e.message}');
    }
  }
}

bool isAndroid = false;
bool isTablet = false;
bool isIPad = false;
bool isIPhone = false;

Future<void> checkDeviceType(BuildContext context) async {
  if (Platform.isAndroid) {
    // เช็คว่าหน้าจอเป็น Tablet หรือไม่
    isAndroid = true;
    isTablet = MediaQuery.of(context).size.shortestSide >= 600;
    print(isTablet ? "This Android device is a Tablet" : "This Android device is a Phone");
  } else if (Platform.isIOS) {
    // ใช้ DeviceInfoPlugin เช็คชื่อรุ่น iOS
    final deviceInfo = DeviceInfoPlugin();
    final iosInfo = await deviceInfo.iosInfo;
    final model = iosInfo.model?.toLowerCase() ?? '';

    isIPad = model.contains("ipad");
    isIPhone = model.contains("iphone");
    print(isIPad ? "This is an iPad" : isIPhone ? "This is an iPhone" : "Unknown iOS Device");
  }
  print('isAndroid: $isAndroid, isIPhone: $isIPhone, isTablet: $isTablet, isIPad: $isIPad');
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    checkDeviceType(context);
    return MaterialApp(
      title: 'Origami Academy',
      theme: ThemeData(
        useMaterial3: false,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Theme.of(context).colorScheme.inversePrimary,
          brightness: Brightness.light,
        ),
        textTheme: TextTheme(
          displayLarge: TextStyle(
            fontFamily: 'Arial',
            fontSize: 72,
            fontWeight: FontWeight.w700,
          ),
          titleLarge: TextStyle(
            fontFamily: 'Arial',
            fontSize: 28,
          ),
        ),
      ),
      home: const LoginPage(
        num: 0,
        popPage: 0,
      ),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({
    super.key,
    required this.num,
    required this.popPage,
  });
  final int num;
  final int popPage;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _forgotController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  DateTime? lastPressed;
  bool isPass = true;
  bool _forgot = false;

  @override
  void initState() {
    super.initState();
    checkDeviceType(context);
    allTranslate();
    loadCredentials();
    _forgotController.addListener(() {
      forgot_mail = _forgotController.text;
      print("Current text: ${_forgotController.text}");
    });
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _forgotController.dispose();
    super.dispose();
  }

  // ฟังก์ชันในการบันทึกข้อมูล
  Future<void> saveCredentials(username, password) async {
    var box = await Hive.openBox('userBox');
    // บันทึกข้อมูลลงใน Box
    await box.put('username', username);
    await box.put('password', password);
  }

  Future<void> loadCredentials() async {
    var box = await Hive.openBox('userBox');
    if (widget.num == 1) {
      box.clear();
      _usernameController.clear();
      _passwordController.clear();
    }
    String? username = box.get('username') ?? '';
    String? password = box.get('password') ?? '';
    setState(() {
      _usernameController.text = username ?? '';
      _passwordController.text = password ?? '';
    });
    if (username!.isNotEmpty && password!.isNotEmpty) {
      if (widget.num == 0) {
        _login();
      } else {
        box.clear();
        _usernameController.clear();
        _passwordController.clear();
      }
    }
    print('Username: $username');
    print('Password: $password');
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (disposition) {
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
                'Press back again to exit',
                style: TextStyle(
                  fontFamily: 'Arial',
                  color: Colors.white,
                ),
              ),
              duration: maxDuration,
            ),
          );
          // ไม่ออกจากแอปในครั้งแรก
        } else {
          // ถ้ากดปุ่มย้อนกลับสองครั้งภายในเวลาที่กำหนด ให้ออกจากแอป
          SystemNavigator.pop(); // หรือ exit(0) หากต้องการออกจากแอป
        }
      },
      child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/logoOrigami/default_bg.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Padding(
              padding: (isAndroid || isIPhone)
                  ? EdgeInsets.only(left: 24, right: 24)
                  : EdgeInsets.only(left: 240, right: 240),
              child: (_forgot == false) ? _loginWidget() : _forgotWidget(),
            ),
          )),
    );
  }

  Widget _loginWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 400,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: SizedBox(
              width: 400,
              child: Image.asset(
                'assets/images/learning/img_2.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        _isLoading
            ? Center(
          child: LoadingAnimationWidget.horizontalRotatingDots(
            size: 75,
            color: Colors.white,
          ),
        )
            : Text(
          'E-Learning',
          style: TextStyle(
              fontFamily: 'Arial',
              color: Colors.white70,
              fontWeight: FontWeight.w500,
              fontSize: 64),
        ),
        SizedBox(height: 24),
        Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(
                      r'[a-zA-Z0-9@#%&*_!$^(),.?":;{}|<>-]')), // เฉพาะตัวอักษรภาษาอังกฤษและช่องว่าง
                ],
                controller: _usernameController,
                style: TextStyle(
                  fontFamily: 'Arial',
                  color: Color(0xFF555555),
                ),
                decoration: InputDecoration(
                  filled: true, // เปิดใช้งานการตั้งค่าพื้นหลัง
                  fillColor: Colors.white, // กำหนดสีพื้นหลังเป็นสีขาว
                  hintText: 'Username',
                  labelStyle:
                  TextStyle(fontFamily: 'Arial', color: Color(0xFF555555)),
                  hintStyle:
                  TextStyle(fontFamily: 'Arial', color: Color(0xFF555555)),
                  prefixIcon: Icon(Icons.person, color: Color(0xFF555555)),
                ),
              ),
              SizedBox(height: 18),
              TextFormField(
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(
                      r'[a-zA-Z0-9@#%&*_!$^(),.?":;{}|<>-]')), // เฉพาะตัวอักษรภาษาอังกฤษและช่องว่าง
                ],
                controller: _passwordController,
                style: TextStyle(
                  fontFamily: 'Arial',
                  color: Color(0xFF555555),
                ),
                obscureText: isPass,
                decoration: InputDecoration(
                  filled: true, // เปิดใช้งานการตั้งค่าพื้นหลัง
                  fillColor: Colors.white, // กำหนดสีพื้นหลังเป็นสีขาว
                  hintText: 'Password',
                  labelStyle:
                  TextStyle(fontFamily: 'Arial', color: Color(0xFF555555)),
                  hintStyle:
                  TextStyle(fontFamily: 'Arial', color: Color(0xFF555555)),
                  prefixIcon: Icon(Icons.lock, color: Color(0xFF555555)),
                  suffixIcon: Container(
                    alignment: Alignment.centerRight,
                    width: 10,
                    child: Center(
                      child: IconButton(
                          onPressed: () {
                            setState(() {
                              (isPass == true) ? isPass = false : isPass = true;
                            });
                          },
                          icon: Icon(isPass
                              ? Icons.remove_red_eye
                              : Icons.remove_red_eye_outlined),
                          color: Color(0xFF555555),
                          iconSize: 18),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Spacer(),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _forgot = true;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Icon(Icons.lock_open, color: Colors.white, size: 20),
                          SizedBox(width: 8),
                          Text(
                            'Forgot Pwd?',
                            style: TextStyle(
                              fontFamily: 'Arial',
                              color: Colors.white,
                              fontSize: (isIPad || isTablet) ? 18 : 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              Container(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(1),
                    foregroundColor: Colors.red,
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: _login,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 60, right: 60, bottom: 12, top: 12),
                    child: Text(
                      'LOGIN',
                      style: TextStyle(
                        fontFamily: 'Arial',
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _forgotWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 400,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Container(
              width: 400,
              child: Image.asset(
                'assets/images/learning/img_2.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(height: 16),
              Text(
                'Forgot your password?',
                style: TextStyle(
                  fontFamily: 'Arial',
                  color: Colors.white,
                  fontSize: (isIPad || isTablet) ? 40 : 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  '    Please enter your email address to request a password reset.',
                  style: TextStyle(
                    fontFamily: 'Arial',
                    color: Colors.orange.shade50,
                    fontSize: (isIPad || isTablet) ? 24 : 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _forgotController,
                  style: TextStyle(
                    fontFamily: 'Arial',
                    color: Color(0xFF555555),
                  ),
                  decoration: InputDecoration(
                    filled: true, // เปิดใช้งานการตั้งค่าพื้นหลัง
                    fillColor: Colors.white, // กำหนดสีพื้นหลังเป็นสีขาว
                    labelText: 'Email',
                    labelStyle: TextStyle(
                      fontFamily: 'Arial',
                      color: Color(0xFF555555),
                    ),
                    hintStyle: TextStyle(
                      fontFamily: 'Arial',
                      color: Color(0xFF555555),
                    ),
                    prefixIcon: Icon(
                      Icons.person,
                      color: Color(0xFF555555),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              Container(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(1),
                    foregroundColor: Colors.red,
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () => _fetchForgetMail(),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 60, right: 60, bottom: 12, top: 12),
                    child: Text(
                      'SEND',
                      style: TextStyle(
                        fontFamily: 'Arial',
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _forgot = false;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(Icons.chevron_left,
                              color: Colors.white, size: 20),
                          SizedBox(width: 8),
                          Text(
                            'Return to login.',
                            style: TextStyle(
                              fontFamily: 'Arial',
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Spacer(),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _login() async {
    // _loadSelectedRadio();
    String username = _usernameController.text;
    String password = _passwordController.text;
    // _saveCredentials(username, password);
    saveCredentials(username, password);
    if (username.isEmpty && password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter both email and password.',
              style: TextStyle(
                fontFamily: 'Arial',
                color: Colors.white,
              )),
        ),
      );
      return;
    } else if (username.isNotEmpty && password.isNotEmpty) {
      _fetchLogin(username, password);
    }
  }

  Future<void> _fetchLogin(String username, String password) async {
    final uri = Uri.parse('$host/api/origami/signin.php');
    final response = await http.post(
      uri,
      body: {
        'username': username, //chakrit@trandar.com
        'password': password, //@HengL!ke08
      },
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      if (jsonResponse['status'] == true) {
        final String Authorization = jsonResponse['Authorization'];
        final List<dynamic> employeeJson = jsonResponse['employee_data'];
        List<Employee> employee = [];
        setState(() {
          employee =
              employeeJson.map((json) => Employee.fromJson(json)).toList();
        });
        setState(() {
          _isLoading = true;
        });
        await Future.delayed(Duration(seconds: 1));
        final Employee employee1 = employee[0];
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => AcademyPage(
              employee: employee1,
              Authorization: Authorization,
            ),
          ),
        );
      } else {
        final String error_message = jsonResponse['message'];
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              error_message, // 'Email or Password is incorrect, please try again',
              style: TextStyle(
                fontFamily: 'Arial',
                color: Colors.white,
              ),
            ),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Status Code Error!',
              style: TextStyle(
                fontFamily: 'Arial',
                color: Colors.white,
              )),
        ),
      );
    }
  }

  String forgot_mail = '';
  Future<void> _fetchForgetMail() async {
    final uri = Uri.parse("$host/api/origami/forgot_password.php");
    final response = await http.post(
      uri,
      body: {
        'email': forgot_mail,
      },
    );
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      if (jsonResponse['status'] == false) {
        final message = jsonResponse['message'];
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              message,
              style: TextStyle(
                fontFamily: 'Arial',
                color: Colors.white,
              ),
            ),
          ),
        );
      }
    } else {
      throw Exception('Failed to load projects');
    }
  }
}

class Employee {
  final String? emp_id;
  final String? emp_code;
  final String? emp_name;
  final String? emp_avatar;
  final String? comp_id;
  final String? comp_description;
  final String? comp_logo;
  final String? dept_id;
  final String? dept_description;
  final String? dna_id;
  final String? dna_name;
  final String? dna_color;
  final String? dna_logo;
  final String? password_verify;

  const Employee({
    this.emp_id,
    this.emp_code,
    this.emp_name,
    this.emp_avatar,
    this.comp_id,
    this.comp_description,
    this.comp_logo,
    this.dept_id,
    this.dept_description,
    this.dna_id,
    this.dna_name,
    this.dna_color,
    this.dna_logo,
    this.password_verify,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      emp_id: json['emp_id'] ?? '',
      emp_code: json['emp_code'] ?? '',
      emp_name: json['emp_name'] ?? '',
      emp_avatar: json['emp_avatar'] ?? '',
      comp_id: json['comp_id'] ?? '',
      comp_description: json['comp_description'] ?? '',
      comp_logo: json['comp_logo'] ?? '',
      dept_id: json['dept_id'] ?? '',
      dept_description: json['dept_description'] ?? '',
      dna_id: json['dna_id'] ?? '',
      dna_name: json['dna_name'] ?? '',
      dna_color: json['dna_color'] ?? '',
      dna_logo: json['dna_logo'] ?? '',
      password_verify: json['password_verify'] ?? '',
    );
  }
}
