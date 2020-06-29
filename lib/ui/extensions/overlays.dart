import 'package:flutter/material.dart';
import 'package:tareas/constants/brand_colors.dart';

typedef OverlayBuilder = Widget Function(BuildContext context);

class OverlayCreator {


  final GlobalKey headingBoxContainerKey;

  OverlayEntry _currentOverlayEntry;

  int _currentOverlayCode;

  Function _onDismiss;

  OverlayCreator ({
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

  bool isActiveOverlay(int code) {
    return _currentOverlayCode == code;
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
    _currentOverlayCode = null;
  }

  void presentOverlay(BuildContext context, { OverlayBuilder builder, int overlayCode, Function onDismiss }) {
    dismissOverlay();
    _onDismiss = onDismiss;
    _currentOverlayCode = overlayCode;
    _currentOverlayEntry = _createOverlayEntry(
      builder: builder,
    );
    Overlay.of(context).insert(_currentOverlayEntry);
  }

}