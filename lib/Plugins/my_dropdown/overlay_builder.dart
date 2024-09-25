part of 'custom_dropdown.dart';

class _OverlayBuilder extends StatefulWidget {
  final Widget Function(Size, VoidCallback) overlay;
  final Widget Function(VoidCallback) child;

  final DropdownController controller;

  const _OverlayBuilder({
    Key? key,
    required this.overlay,
    required this.child, required this.controller,
  }) : super(key: key);

  @override
  _OverlayBuilderState createState() => _OverlayBuilderState();
}

class _OverlayBuilderState extends State<_OverlayBuilder> {
  OverlayEntry? overlayEntry;

  bool get isShowingOverlay => overlayEntry != null;

  void showOverlay() {
    overlayEntry = OverlayEntry(
      builder: (_) {
        if (mounted) {
          try {
            final renderBox = context.findRenderObject() as RenderBox;
            final size = renderBox.size;
            return widget.overlay(size, hideOverlay);
          } catch (e){
            return const SizedBox();
          }
        }
        return const SizedBox();
      },
    );
    widget.controller.isOverlayShown.value = true;

    addToOverlay(overlayEntry!);
  }

  void addToOverlay(OverlayEntry entry) => Overlay.of(context)?.insert(entry);

  void hideOverlay() {
    overlayEntry!.remove();
    overlayEntry = null;
    widget.controller.isOverlayShown.value = false;
  }

  @override
  void dispose() {
    widget.controller.isOverlayShown.value = false;
    overlayEntry?.remove();
    overlayEntry?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child(showOverlay);
}
