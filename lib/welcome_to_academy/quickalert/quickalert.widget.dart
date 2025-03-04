// import 'package:flutter/material.dart';
// import 'package:quickalert/quickalert.dart';
//
// class QuickalertPage extends StatefulWidget {
//   const QuickalertPage({Key? key}) : super(key: key);
//
//   @override
//   State<QuickalertPage> createState() => _QuickalertPageState();
// }
//
// class _QuickalertPageState extends State<QuickalertPage> {
//   @override
//   Widget build(BuildContext context) {
//     final successAlert = buildButton(
//       onTap: () {
//         QuickAlert.show(
//           context: context,
//           type: QuickAlertType.success,
//           text: 'Transaction Completed Successfully!',
//           autoCloseDuration: const Duration(seconds: 2),
//           showConfirmBtn: false,
//         );
//       },
//       title: 'Success',
//       text: 'Transaction Completed Successfully!',
//       leadingImage: 'assets/success.gif',
//     );
//
//     final errorAlert = buildButton(
//       onTap: () {
//         QuickAlert.show(
//           context: context,
//           type: QuickAlertType.error,
//           title: 'Oops...',
//           text: 'Sorry, something went wrong',
//           backgroundColor: Colors.black,
//           titleColor: Colors.white,
//           textColor: Colors.white,
//         );
//       },
//       title: 'Error',
//       text: 'Sorry, something went wrong',
//       leadingImage: 'assets/error.gif',
//     );
//
//     final warningAlert = buildButton(
//       onTap: () {
//         QuickAlert.show(
//           context: context,
//           type: QuickAlertType.warning,
//           text: 'You just broke protocol',
//         );
//       },
//       title: 'Warning',
//       text: 'You just broke protocol',
//       leadingImage: 'assets/warning.gif',
//     );
//
//     final infoAlert = buildButton(
//       onTap: () {
//         QuickAlert.show(
//           context: context,
//           type: QuickAlertType.info,
//           text: 'Buy two, get one free',
//         );
//       },
//       title: 'Info',
//       text: 'Buy two, get one free',
//       leadingImage: 'assets/info.gif',
//     );
//
//     final confirmAlert = buildButton(
//       onTap: () {
//         QuickAlert.show(
//           onCancelBtnTap: () {
//             Navigator.pop(context);
//           },
//           context: context,
//           type: QuickAlertType.confirm,
//           text: 'Do you want to logout',
//           titleAlignment: TextAlign.right,
//           textAlignment: TextAlign.right,
//           confirmBtnText: 'Yes',
//           cancelBtnText: 'No',
//           confirmBtnColor: Colors.white,
//           backgroundColor: Colors.black,
//           headerBackgroundColor: Colors.grey,
//           confirmBtnTextStyle: const TextStyle(
//             color: Colors.black,
//             fontWeight: FontWeight.w700,
//           ),
//           barrierColor: Colors.white,
//           titleColor: Colors.white,
//           textColor: Colors.white,
//         );
//       },
//       title: 'Confirm',
//       text: 'Do you want to logout',
//       leadingImage: 'assets/confirm.gif',
//     );
//
//     final loadingAlert = buildButton(
//       onTap: () {
//         QuickAlert.show(
//           context: context,
//           type: QuickAlertType.loading,
//           title: 'Loading',
//           text: 'Fetching your data',
//         );
//       },
//       title: 'Loading',
//       text: 'Fetching your data',
//       leadingImage: 'assets/loading.gif',
//     );
//
//     final customAlert = buildButton(
//       onTap: () {
//         var message = '';
//         QuickAlert.show(
//           context: context,
//           type: QuickAlertType.custom,
//           barrierDismissible: true,
//           confirmBtnText: 'Save',
//           customAsset: 'assets/custom.gif',
//           widget: TextFormField(
//             decoration: const InputDecoration(
//               alignLabelWithHint: true,
//               hintText: 'Enter Phone Number',
//               prefixIcon: Icon(
//                 Icons.phone_outlined,
//               ),
//             ),
//             textInputAction: TextInputAction.next,
//             keyboardType: TextInputType.phone,
//             onChanged: (value) => message = value,
//           ),
//           onConfirmBtnTap: () async {
//             if (message.length < 5) {
//               await QuickAlert.show(
//                 context: context,
//                 type: QuickAlertType.error,
//                 text: 'Please input something',
//               );
//               return;
//             }
//             Navigator.pop(context);
//             if (mounted) {
//               QuickAlert.show(
//                 context: context,
//                 type: QuickAlertType.success,
//                 text: "Phone number '$message' has been saved!.",
//               );
//             }
//           },
//         );
//       },
//       title: 'Custom',
//       text: 'Custom Widget Alert',
//       leadingImage: 'assets/custom.gif',
//     );
//
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         elevation: 1,
//         centerTitle: true,
//         backgroundColor: Colors.white,
//         title: Text(
//           "QuickAlert Demo",
//           style: Theme.of(context).textTheme.titleMedium,
//         ),
//       ),
//       body: ListView(
//         children: [
//           const SizedBox(height: 20),
//           successAlert,
//           const SizedBox(height: 20),
//           errorAlert,
//           const SizedBox(height: 20),
//           warningAlert,
//           const SizedBox(height: 20),
//           infoAlert,
//           const SizedBox(height: 20),
//           confirmAlert,
//           const SizedBox(height: 20),
//           loadingAlert,
//           const SizedBox(height: 20),
//           customAlert,
//           const SizedBox(height: 20),
//         ],
//       ),
//     );
//   }
// }
// Card buildButton({
//   required onTap,
//   required title,
//   required text,
//   required leadingImage,
// }) {
//   return Card(
//     shape: const StadiumBorder(),
//     margin: const EdgeInsets.symmetric(
//       horizontal: 20,
//     ),
//     clipBehavior: Clip.antiAlias,
//     elevation: 1,
//     child: ListTile(
//       onTap: onTap,
//       leading: CircleAvatar(
//         backgroundImage: AssetImage(
//           leadingImage,
//         ),
//       ),
//       title: Text(title ?? ""),
//       subtitle: Text(text ?? ""),
//       trailing: const Icon(
//         Icons.keyboard_arrow_right_rounded,
//       ),
//     ),
//   );
// }

import 'package:flutter/material.dart';



class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // พื้นหลังรูปภาพ
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/logoOrigami/default_bg.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // กล่อง Login
          LayoutBuilder(
              builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                  ),
                  child: Center(
                    child: Container(
                      width: constraints.maxWidth * 0.85,
                      padding: EdgeInsets.all(30),
                      decoration: BoxDecoration(
                        // color: Colors.black12,
                        borderRadius: BorderRadius.circular(20),
                        // boxShadow: [
                        //   BoxShadow(
                        //     color: Colors.black12,
                        //     blurRadius: 10,
                        //     offset: Offset(0, 4),
                        //   )
                        // ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            "assets/images/learning/img_2.png", // ใส่โลโก้
                            fit: BoxFit.contain,
                          ),
                          Column(
                            children: [
                              Text(
                                'Origami',
                                style: TextStyle(
                                  fontFamily: 'Arial',
                                  color: Colors.white70,
                                  fontWeight: FontWeight.w500,
                                  fontSize: constraints.maxWidth * 0.08,
                                ),
                              ),
                              Text(
                                'Academy',
                                style: TextStyle(
                                  fontFamily: 'Arial',
                                  color: Colors.white70,
                                  fontWeight: FontWeight.w700,
                                  fontSize: constraints.maxWidth * 0.1,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          CustomTextField(
                            hintText: "E-mail",
                            icon: Icons.email_outlined,
                          ),
                          SizedBox(height: 10),
                          CustomTextField(
                            hintText: "Password",
                            icon: Icons.lock_outline,
                            isPassword: true,
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              "Forgot password?",
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          SizedBox(height: 15),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              minimumSize: Size(double.infinity, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                            onPressed: () {},
                            child: Text(
                              "LOG IN",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          Text("or login with"),
                          SizedBox(height: 10),
                          RichText(
                            text: TextSpan(
                              style: TextStyle(color: Colors.black),
                              children: [
                                TextSpan(text: "Don't have an account yet? "),
                                TextSpan(
                                  text: "SIGN UP",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue,
                                  ),
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
            }
          ),
        ],
      ),
    );
  }
}

// Custom TextField
class CustomTextField extends StatelessWidget {
  final String hintText;
  final IconData icon;
  final bool isPassword;

  const CustomTextField({
    required this.hintText,
    required this.icon,
    this.isPassword = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: isPassword,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: Icon(icon, color: Colors.grey),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
      ),
    );
  }
}

// Social Media Button
class SocialButton extends StatelessWidget {
  final String image;

  const SocialButton({required this.image});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.grey),
        ),
        child: Image.asset(
          image,
          width: 30,
          height: 30,
        ),
      ),
    );
  }
}
