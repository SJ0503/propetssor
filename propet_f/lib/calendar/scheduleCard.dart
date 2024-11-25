import 'package:flutter/material.dart';

class ScheduleCard extends StatelessWidget {
  final String startTime;
  final String endTime;
  final String content;
  final Function onDelete;

  const ScheduleCard({
    required this.startTime,
    required this.endTime,
    required this.content,
    required this.onDelete,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(left: 5.0, top: 3.0, bottom: 5.0),
            width: MediaQuery.of(context).size.width * 0.85,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                width: 1.0,
                color: Colors.black,
              ),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 3,
                    child: _Time(
                      startTime: startTime,
                      endTime: endTime,
                    ),
                  ),
                  VerticalDivider(
                    width: 16.0,
                    thickness: 1.0,
                    color: Colors.black,
                  ),
                  Expanded(
                    flex: 4,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: _Content(
                        content: content,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () => onDelete(),
                    ),
                  ),
                ],
              ),

            ),
          ),
          SizedBox(height: 5),
        ],
      ),
    );
  }
}

class _Time extends StatelessWidget {
  final String startTime;
  final String endTime;

  const _Time({
    required this.startTime,
    required this.endTime,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(
      fontFamily: 'Omyu',
      color: Colors.black,
      fontSize: 16.0,
    );

    return Flexible(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$startTime ~ $endTime',
            style: textStyle,
          ),
        ],
      ),
    );
  }
}

class _Content extends StatelessWidget {
  final String content;

  const _Content({
    required this.content,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Center(
        child: Text(
          content,
          style: TextStyle(
            fontFamily: 'Omyu',
            fontWeight: FontWeight.w600,
            fontSize: 18.0,
          ),
        ),
      ),
    );
  }
}
