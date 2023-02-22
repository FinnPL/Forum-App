import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:forum/models/comment.dart';
import 'package:forum/palette.dart';

class CommentWidget extends StatelessWidget {
  const CommentWidget({
    Key? key,
    required this.comment,
  }) : super(key: key);

  final Comment comment;

  @override
  Widget build(BuildContext context) {
    String date;
    if (comment.date.isAfter(DateTime.now().subtract(const Duration(days: 1)))) {
      date = '${comment.date.hour}:';
      if (comment.date.hour < 10) {
        date = '0$date';
      }
      if (comment.date.minute < 10) {
        date = '${date}0${comment.date.minute}';
      } else {
        date = '$date${comment.date.minute}';
      }
    } else {
      date = '${comment.date.day}/${comment.date.month}/${comment.date.year}';
    } //💀

    return Container(
      decoration: BoxDecoration(
        color: Palette.BlueToLight[400],
        borderRadius: BorderRadius.circular(8),
      ),
      margin: const EdgeInsets.only(top: 16, bottom: 16, left: 16, right: 16),
      padding: const EdgeInsets.only(top: 16, bottom: 16, left: 16, right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.account_circle,
                size: 15,
                color: Colors.black54,
              ),
              const SizedBox(width: 4),
              Text(
                '${comment.userName}',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(width: 16),
              const Icon(
                Icons.access_time,
                size: 15,
                color: Colors.black54,
              ),
              const SizedBox(width: 4),
              Text(
                date,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            comment.content,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}