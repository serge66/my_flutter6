import 'package:flutter/material.dart';

class Toast {
  static void show(BuildContext context, String message, {int duration}) {
    OverlayEntry entry = OverlayEntry(builder: (context) {
      return Container(
        color: Colors.transparent,
        margin: EdgeInsets.only(
          top: MediaQuery.of(context).size.height * 0.7,
        ),
        alignment: Alignment.center,
        child: Center(
          child: Container(
            color: Colors.grey,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Material(
                child: Text(
                  message,
                  style: TextStyle(
                    color: Colors.white,
                    backgroundColor: Colors.grey,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    });
    Overlay.of(context).insert(entry);
    Future.delayed(Duration(seconds: duration ?? 2)).then((value) {
      // 移除层可以通过调用OverlayEntry的remove方法。
      entry.remove();
    });
  }
}
