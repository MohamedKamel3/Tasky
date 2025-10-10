import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:to_do_app/core/constants/colors.dart';
import 'package:to_do_app/core/utils/show_date.dart';
import 'package:to_do_app/features/home/data/models/task_model.dart';
import 'package:to_do_app/features/home/presentation/widgets/priority_widget.dart';

class TaskItemWidget extends StatefulWidget {
  TaskItemWidget({
    super.key,
    this.withBorder = true,
    required this.taskModel,
    required this.callBack,
    this.onTap,
  });

  TaskModel taskModel;
  bool withBorder;
  Function(bool) callBack;
  void Function()? onTap;

  @override
  State<TaskItemWidget> createState() => _TaskItemWidgetState();
}

class _TaskItemWidgetState extends State<TaskItemWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        decoration: widget.withBorder
            ? BoxDecoration(
                border: Border.all(width: 2, color: Colors.black),
                borderRadius: BorderRadius.circular(12),
              )
            : null,
        child: Row(
          spacing: 10,
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  widget.taskModel.isDone = !widget.taskModel.isDone;
                  widget.callBack(widget.taskModel.isDone);
                });
              },
              child: Radio(
                side: BorderSide(width: 2, color: Colors.black),
                value: true,
                groupValue: widget.taskModel.isDone ? true : null,
                fillColor: WidgetStateProperty.all(primaryColor1),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.taskModel.title!,
                    maxLines: 1,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    showDate(widget.taskModel.date!),
                    maxLines: 2,
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
            PriorityWidget(priority: widget.taskModel.priority!),
          ],
        ),
      ),
    );
  }
}
