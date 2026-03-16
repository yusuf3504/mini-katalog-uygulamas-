import 'dart:async';
import 'package:flutter/material.dart';

class TopBanner {
  static OverlayEntry? _entry;
  static Timer? _timer;

  static void show(
    BuildContext context,
    String message, {
    double extraTopMargin = 8,
    Duration duration = const Duration(milliseconds: 1600),
  }) {
    
    _timer?.cancel();
    _timer = null;
    _entry?.remove();
    _entry = null;

    final overlay = Overlay.of(context);
    if (overlay == null) return;

    final double statusBar = MediaQuery.of(context).padding.top;
    const double appBarHeight = kToolbarHeight;
    final double top = statusBar + appBarHeight + extraTopMargin;

    _entry = OverlayEntry(
      builder: (_) => Positioned(
        left: 0,
        right: 0,
        top: top,
        child: IgnorePointer(
          ignoring: true,
          child: Material(
            color: Colors.transparent,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.green.shade600,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.check_circle, color: Colors.white),
                    const SizedBox(width: 8),
                    Text(
                      message,
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );

    overlay.insert(_entry!);
    _timer = Timer(duration, () {
      _entry?.remove();
      _entry = null;
      _timer = null;
    });
  }

  static void hide() {
    _timer?.cancel();
    _timer = null;
    _entry?.remove();
    _entry = null;
  }
}