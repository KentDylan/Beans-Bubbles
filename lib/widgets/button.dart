import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final String text;
  final void Function()? onTap;
  final void Function()? showSnackbar;
  const MyButton(
      {super.key, required this.text, this.onTap, this.showSnackbar});

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    var textStyle = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: () {
        onTap?.call();
        showSnackbar?.call();
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
            color: colorScheme.onPrimary,
            borderRadius: BorderRadius.circular(40)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(text,
                style: textStyle.headlineMedium!.copyWith(
                  color: colorScheme.secondary,
                )),
            const SizedBox(
              width: 10,
            ),
            Icon(
              Icons.arrow_forward,
              color: colorScheme.secondary,
            ),
          ],
        ),
      ),
    );
  }
}
