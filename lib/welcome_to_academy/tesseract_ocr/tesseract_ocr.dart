import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';

class ImagePickerScreen extends StatefulWidget {
  final String empName;
  final String empAvatar; // Path หรือ URL ของ avatar

  const ImagePickerScreen({
    Key? key,
    required this.empName,
    required this.empAvatar,
  }) : super(key: key);

  @override
  _ImagePickerScreenState createState() => _ImagePickerScreenState();
}

class _ImagePickerScreenState extends State<ImagePickerScreen> {
  final ImagePicker _picker = ImagePicker();
  bool _isMatch = false;
  late File _pickedImage;

  @override
  void initState() {
    super.initState();
    _loadModel();
  }

  // โหลดโมเดล TFLite
  Future<void> _loadModel() async {
    await Tflite.loadModel(model: "assets/your_model.tflite");
  }

  // ฟังก์ชันถ่ายภาพจากกล้อง
  Future<void> _pickAndCompareImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        _pickedImage = File(image.path);
      });

      // เรียกใช้โมเดล TFLite สำหรับการประมวลผล
      var recognitions = await Tflite.runModelOnImage(
        path: image.path,
        numResults: 1,
        threshold: 0.5,
        asynch: true,
      );

      // ตรวจสอบผลลัพธ์จาก TFLite
      if (recognitions!.isNotEmpty) {
        String label = recognitions[0]["label"];
        setState(() {
          _isMatch = (label == widget.empName);
        });
      }
    }
  }

  // ฟังก์ชันแสดงผลลัพธ์
  void _showResultDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(_isMatch ? 'พบการจับคู่!' : 'ไม่พบการจับคู่'),
        content: Text(
          _isMatch
              ? 'ภาพที่ถ่ายตรงกับ avatar ของ ${widget.empName}'
              : 'ภาพที่ถ่ายไม่ตรงกับ avatar ของ ${widget.empName}',
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('ตกลง'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('เปรียบเทียบภาพจากกล้อง'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () async {
                await _pickAndCompareImage();
                _showResultDialog(); // แสดงผลการเปรียบเทียบ
              },
              child: Text('ถ่ายภาพเพื่อเปรียบเทียบ'),
            ),
            SizedBox(height: 20),
            if (_pickedImage != null)
              Column(
                children: [
                  Image.file(
                    _pickedImage,
                    height: 200,
                    width: 200,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(height: 10),
                  Text('ภาพที่ถ่ายจากกล้อง'),
                ],
              ),
            if (_isMatch)
              Text('ภาพตรงกันกับ ${widget.empName}'),
            if (!_isMatch && _pickedImage != null)
              Text('ภาพไม่ตรงกันกับ ${widget.empName}'),
          ],
        ),
      ),
    );
  }
}
