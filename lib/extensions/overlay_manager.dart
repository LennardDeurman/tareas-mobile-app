import 'package:flutter/material.dart';
import 'package:tareas/extensions/brand_colors.dart';

typedef OverlayBuilder = Widget Function(BuildContext context);

class OverlayManager {


  final GlobalKey headingBoxContainerKey;

  OverlayEntry _currentOverlayEntry;

  Function _onDismiss;

  OverlayManager ({
    this.headingBoxContainerKey
  });

  double get offset {
    RenderBox box = headingBoxContainerKey.currentContext.findRenderObject();
    final position = box.localToGlobal(Offset.zero);
    return box.size.height + position.dy;
  }

  OverlayEntry _createOverlayEntry({ OverlayBuilder builder }) {
    return OverlayEntry(
        builder: (BuildContext context) {
          return GestureDetector(
            child: Container(
              color: BrandColors.overlayColor,
              margin: EdgeInsets.only(
                  top: offset
              ),
              child: builder(context),
            ),
            onTap: dismissOverlay,
          );
        }
    );
  }

  void dismissOverlay() {
    if (_currentOverlayEntry != null) {
      _currentOverlayEntry.remove();
    }

    if (_onDismiss != null) {
      _onDismiss();
    }

    _onDismiss = null;
    _currentOverlayEntry = null;
  }

  void presentOverlay(BuildContext context, { OverlayBuilder builder, Function onDismiss }) {
    dismissOverlay();
    _onDismiss = onDismiss;
    _currentOverlayEntry = _createOverlayEntry(
      builder: builder,
    );
    Overlay.of(context).insert(_currentOverlayEntry);
  }

}