import 'package:academy/welcome_to_academy/academy/challeng/summary/finished_challenge.dart';
import 'package:academy/welcome_to_academy/academy/challeng/summary/my_challenge.dart';
import 'package:academy/welcome_to_academy/export.dart';

import 'challenge_test.dart';

class SummaryScores extends StatefulWidget {
  SummaryScores({
    super.key,
    required this.employee,
    required this.Authorization,
  });
  final Employee employee;
  final String Authorization;

  @override
  _SummaryScoresState createState() => _SummaryScoresState();
}

class _SummaryScoresState extends State<SummaryScores> {
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 1,
        foregroundColor: Colors.white,
        backgroundColor: Color(0xFFFF9900),
        title: Text(
          'Summary',
          style: TextStyle(fontFamily: 'Arial',
            fontSize: 28,
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
              color: Colors.grey.shade100, height: 4, width: double.infinity),
          DefaultTabController(
            animationDuration: Duration(milliseconds: 300),
            length: 2,
            initialIndex: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TabBar(
                tabs: [
                  Tab(
                    text: "My Challenge",
                  ),
                  Tab(
                    text: "Finished Challenge",
                  ),
                ],
                labelColor: Color(0xFF555555),
                unselectedLabelColor: Colors.grey.shade400,
                indicator: MaterialIndicator(
                  height: 5,
                  topLeftRadius: 8,
                  topRightRadius: 8,
                  horizontalPadding: 50,
                  tabPosition: TabPosition.bottom,
                  color: Color(0xFF555555),
                ),
                onTap: _onItemTapped,
              ),
            ),
          ),
          // SizedBox(height: 8),
          // Container(color:Colors.grey.shade100,height: 4,width: double.infinity),
          Expanded(
              child: _selectedIndex == 0
                  ? MyChallenge(
                  employee: widget.employee,
                  Authorization: widget.Authorization)
                  : FinishedChallenge(
                  employee: widget.employee,
                  Authorization: widget.Authorization),
          ),
        ],
      ),
    );
  }
}
