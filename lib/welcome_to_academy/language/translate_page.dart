import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:academy/welcome_to_academy/export.dart';
import 'package:academy/welcome_to_academy/language/translate.dart';

class TranslatePage extends StatefulWidget {
  const TranslatePage({
    Key? key,
    required this.employee, required this.Authorization,
  }) : super(key: key);
  final Employee employee;
  final String Authorization;
  @override
  _TranslatePageState createState() => _TranslatePageState();
}

class _TranslatePageState extends State<TranslatePage> {
  @override
  void initState() {
    super.initState();
    _loadSelectedRadio();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 1,
        foregroundColor: Color(0xFFFF9900),
        backgroundColor: Colors.white,
        title: Container(
          alignment: (isAndroid || isIPhone)
              ? Alignment.centerLeft
              : Alignment.center,
          child: Text(
            'Translate',
            style: TextStyle(
              fontFamily: 'Arial',
              color: Color(0xFFFF9900),
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        // leading: IconButton(onPressed: (){_controller.toggle();}, icon: Icon(Icons.menu)),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(
                height: 8,
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        children: [
                          Image.network(
                            'https://upload.wikimedia.org/wikipedia/commons/thumb/6/6b/Flag_of_Thailand_%28non-standard_colours%29.svg/180px-Flag_of_Thailand_%28non-standard_colours%29.svg.png',
                            // width: 200,
                            height: 100,
                          ),
                          TextButton(
                            // style:ButtonStyle(shadowColor:Color(colors.)),
                            onPressed: () {
                              _handleRadioValueChange(1);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                (selectedRadio == 1)
                                    ? Icon(
                                  Icons.radio_button_on,
                                  color: Color(0xFFFF9900),
                                )
                                    : Icon(
                                  Icons.radio_button_off,
                                  color: Color(0xFFFF9900),
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Text(
                                  'ภาษาไทย',
                                  style: GoogleFonts.openSans(
                                      fontSize: 16, color: Color(0xFF555555)),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        children: [
                          Image.network(
                            'https://upload.wikimedia.org/wikipedia/commons/thumb/a/a5/Flag_of_the_United_Kingdom_%281-2%29.svg/1200px-Flag_of_the_United_Kingdom_%281-2%29.svg.png',
                            // width: 200,
                            height: 100,
                          ),
                          TextButton(
                            onPressed: () {
                              _handleRadioValueChange(2);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                (selectedRadio == 2)
                                    ? Icon(
                                  Icons.radio_button_on,
                                  color: Color(0xFFFF9900),
                                )
                                    : Icon(
                                  Icons.radio_button_off,
                                  color: Color(0xFFFF9900),
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Text(
                                  'English',
                                  style: GoogleFonts.openSans(
                                      fontSize: 16, color: Color(0xFF555555)),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(4),
                child: Divider(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

