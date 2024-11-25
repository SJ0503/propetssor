import 'package:flutter/material.dart';
import 'package:propetsor/calendar/customTextField.dart';

class ScheduleBottomSheet extends StatefulWidget {
  final Function(Map<String, dynamic>) onSave;

  const ScheduleBottomSheet({Key? key, required this.onSave}) : super(key: key);

  @override
  State<ScheduleBottomSheet> createState() => _ScheduleBottomSheetState();
}

class _ScheduleBottomSheetState extends State<ScheduleBottomSheet> {
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _startTimeController = TextEditingController();
  final TextEditingController _endTimeController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus(); // 화면의 다른 부분을 터치하면 키보드가 내려감
      },
      child: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height / 2 + 60,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            border: Border.all(
              color: Colors.black,
              width: 1,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 16,
              bottom: bottomInset + 16,
            ),
            child: SingleChildScrollView( // 내용이 스크롤 가능하도록 함
              child: Column(
                children: [
                  GestureDetector(
                    onTap: _selectDate,
                    child: AbsorbPointer(
                      child: CustomTextField(
                        label: '날짜',
                        isTime: false,
                        controller: _dateController,
                        maxLines: 1, // 날짜 칸의 maxLines 설정
                      ),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextField(
                          label: '시작 시간',
                          isTime: true,
                          controller: _startTimeController,
                          maxLines: 1, // 시간 칸의 maxLines 설정
                        ),
                      ),
                      const SizedBox(width: 16.0),
                      Expanded(
                        child: CustomTextField(
                          label: '종료 시간',
                          isTime: true,
                          controller: _endTimeController,
                          maxLines: 1, // 시간 칸의 maxLines 설정
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.0),
                  CustomTextField(
                    label: '내용',
                    isTime: false,
                    controller: _contentController,
                    maxLines: 5, // 내용 칸의 maxLines 설정
                  ),
                  SizedBox(height: 30.0),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _onSavePressed,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey,
                        padding: EdgeInsets.symmetric(vertical: 16.0), // 버튼 높이 조정
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        '저장하기',
                        style: TextStyle(
                          fontSize: 20,
                          fontFamily: 'Geekble',
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _selectDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      setState(() {
        _dateController.text = "${pickedDate.toLocal()}".split(' ')[0];
      });
    }
  }

  void _onSavePressed() {
    final schedule = {
      'ndate': _dateController.text,
      'startTime': _startTimeController.text,
      'endTime': _endTimeController.text,
      'content': _contentController.text,
    };
    widget.onSave(schedule);
    Navigator.pop(context);
  }
}
