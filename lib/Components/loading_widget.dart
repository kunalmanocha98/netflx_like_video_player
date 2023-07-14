import 'package:flutter/material.dart';


/// Class defines a loading widget that shows when video loads for the first time
class LoadingWidget extends StatelessWidget {
  final bool isLoading;

  const LoadingWidget({super.key, required this.isLoading});

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Container(
      color: Colors.black,
      child: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            CircularProgressIndicator(),
            SizedBox(width: 16,),
            Text("Loading...",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.normal
              ),)
          ],
        ),
      ),
    )
        : const SizedBox.shrink();
  }
}
