import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatefulWidget {
  final String label;
  final bool isTime;
  final TextEditingController controller;
  final int maxLines; // 추가된 maxLines 속성

  const CustomTextField({
    required this.label,
    required this.isTime,
    required this.controller,
    this.maxLines = 1, // 기본 maxLines 설정
    Key? key,
  }) : super(key: key);

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  TimeOfDay? _selectedTime;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: TextStyle(
            fontFamily: 'Omyu',
            fontSize: 16,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 5.0),
        Container(
          child: widget.isTime
              ? GestureDetector(
            onTap: _selectTime,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6.0),
                border: Border.all(
                  color: Colors.black,
                  width: 1.0,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _selectedTime != null
                        ? _selectedTime!.format(context)
                        : '시간 선택',
                    style: TextStyle(
                      fontFamily: 'Omyu',
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                  Icon(
                    Icons.access_time,
                    color: Colors.black,
                  ),
                ],
              ),
            ),
          )
              : TextFormField(
            controller: widget.controller,
            cursorColor: Colors.black,
            maxLines: widget.maxLines,
            keyboardType: widget.isTime
                ? TextInputType.number
                : TextInputType.multiline,
            inputFormatters: widget.isTime
                ? [
              FilteringTextInputFormatter.digitsOnly,
            ]
                : [],
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6.0),
                borderSide: BorderSide(
                  color: Colors.black,
                  width: 1.0,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6.0),
                borderSide: BorderSide(
                  color: Colors.black,
                  width: 1.0,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6.0),
                borderSide: BorderSide(
                  color: Colors.black,
                  width: 1.0,
                ),
              ),
              filled: true,
              fillColor: Colors.white,
              suffixText: widget.isTime ? '시' : null,
            ),
            style: TextStyle(
              fontFamily: 'Omyu',
              fontSize: 16,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }

  void _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
      widget.controller.text = _selectedTime!.format(context);
    }
  }
}
