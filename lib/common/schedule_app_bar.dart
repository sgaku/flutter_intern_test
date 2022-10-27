import 'package:flutter/material.dart';

class ScheduleAppBar extends StatelessWidget with PreferredSizeWidget {
  const ScheduleAppBar(
      {Key? key, required this.onPressedIcon, this.onPressedElevated, required this.title})
      : super(key: key);
  final void Function()? onPressedIcon;
  final void Function()? onPressedElevated;
  final Widget title;

  @override
  Size get preferredSize => const Size.fromHeight(60);


  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: title,
      leading:
          IconButton(icon: const Icon(Icons.close), onPressed: onPressedIcon),
      actions: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed: onPressedElevated,
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.resolveWith<Color>(
                (Set<MaterialState> states) {
                  if (states.contains(MaterialState.disabled)) {
                    return Colors.white;
                  }
                  return Colors.white;
                },
              ),
              foregroundColor: MaterialStateProperty.resolveWith<Color>(
                (Set<MaterialState> states) {
                  if (states.contains(MaterialState.disabled)) {
                    return const Color(0xFFAEAEAE);
                  }
                  return Colors.black;
                },
              ),
            ),
            child: const Text("保存"),
          ),
        )
      ],
    );
  }


}
