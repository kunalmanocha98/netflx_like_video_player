import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {
  final void Function()? callback;
  final IconData iconData;
  final String title;

  const ActionButton(
      {super.key, this.callback, required this.iconData, required this.title});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: callback,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            iconData,
            color: Colors.white,
            size: 24,
          ),
          const SizedBox(
            width: 4,
          ),
          Text(
            title,
            style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.normal,
                color: Colors.white),
          )
        ],
      ),
    );
  }
}
