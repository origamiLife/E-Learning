import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../main.dart';
import '../language/translate.dart';
import 'chat_list.dart';
// import 'line/chat_list.dart';
// import 'login_lineoa.dart';

class ChatTelegram extends StatefulWidget {
  const ChatTelegram({
    Key? key,
    required this.employee,
    required this.pageInput,
    required this.Authorization,
  }) : super(key: key);
  final Employee employee;
  final String pageInput;
  final String Authorization;
  @override
  _ChatTelegramState createState() => _ChatTelegramState();
}

class _ChatTelegramState extends State<ChatTelegram> {
  @override
  void initState() {
    super.initState();
  }

  // void line_oa() {
  //   // LineSDK.instance.setup('YOUR_CHANNEL_ID');
  //   runApp(LineOA());
  // }

  int _selectedIndex = 0;
  Widget _bodySwitch() {
    switch (_selectedIndex) {
      case 0:
        return ChatList(
          selectedIndex: _selectedIndex,
        );
      case 1:
        return ChatList(
          selectedIndex: _selectedIndex,
        );
      case 2:
        return ChatList(
          selectedIndex: _selectedIndex,
        );
      default:
        return Container(
          alignment: Alignment.center,
          child: Text(
            'ERROR!',
            style: GoogleFonts.openSans(
              fontSize: 18.0,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Scaffold(
            body: Column(
          children: [
            _buildNavigationBar(),
            Row(
              children: [
                // InkWell(
                //   onTap: () {
                //     Navigator.pop(context);
                //   },
                //   child: Padding(
                //     padding: const EdgeInsets.all(8.0),
                //     child: Icon(Icons.arrow_back_ios_new),
                //   ),
                // ),
                InkWell(
                  onTap: () {
                    setState(() {
                      _selectedIndex = 0;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      radius: 20,
                      backgroundImage: NetworkImage(
                          'https://www.rocket.in.th/wp-content/uploads/2023/03/%E0%B8%AA%E0%B8%A3%E0%B8%B8%E0%B8%9B-Line-Official-Account.png'),
                      backgroundColor: Colors.transparent,
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      _selectedIndex = 1;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      radius: 20,
                      backgroundImage: NetworkImage(
                          'https://www.computerhope.com/jargon/f/facebook-messenger.png'),
                      backgroundColor: Colors.transparent,
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      _selectedIndex = 2;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      radius: 20,
                      backgroundImage: NetworkImage(
                          'https://upload.wikimedia.org/wikipedia/commons/thumb/6/6b/WhatsApp.svg/640px-WhatsApp.svg.png'),
                      backgroundColor: Colors.green,
                    ),
                  ),
                ),
              ],
            ),
            Expanded(child: _bodySwitch()),
          ],
        )),
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
          child: InkWell(
            onTap: (){Navigator.pop(context);},
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
        ),
        Expanded(
          flex: 1,
          child: Row(
            children: [
              Expanded(
                child: TextButton(
                    onPressed: () {
                      // _handleRadioValueChange(1);
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
                      // _handleRadioValueChange(2);
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
                    popPage: 0, company_id: 0,
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
}
