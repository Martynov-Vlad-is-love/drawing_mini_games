import 'package:flutter/material.dart';

class MainButton extends StatefulWidget {
  final String text;

  const MainButton({
    required this.text,
    super.key,
  });

  @override
  State<MainButton> createState() => _MainButtonState();
}

class _MainButtonState extends State<MainButton> {
  bool isTapped = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
        height: 70,
        width: 200,
        duration: const Duration(milliseconds: 600),
        color: isTapped ? Colors.black87 : Colors.brown,
        curve: Curves.fastOutSlowIn,
        child: ElevatedButton(
          onPressed: () async {
            setState(() {
              isTapped = !isTapped;
            });
            await Future.delayed(const Duration(milliseconds: 600));
            Navigator.pushNamed(context, '/draw');
          },
          style: ButtonStyle(
              backgroundColor: MaterialStateColor.resolveWith(
                  (states) => Colors.transparent)),
          child: Text(
            widget.text,
            style: const TextStyle(fontSize: 30),
          ),
        )
    );
  }
}
