import 'package:flutter/material.dart';

class FloatingBackToTop extends StatefulWidget {
  const FloatingBackToTop({required this.scrollController, super.key});

  final ScrollController scrollController;

  @override
  State<FloatingBackToTop> createState() => _FloatingBackToTopState();
}

class _FloatingBackToTopState extends State<FloatingBackToTop> {
  bool _isVisible = false;
  final ValueNotifier<Offset> _mouseOffset = ValueNotifier(Offset.zero);
  final ValueNotifier<bool> _isHovered = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_scrollListener);
    _mouseOffset.dispose();
    _isHovered.dispose();
    super.dispose();
  }

  void _scrollListener() {
    final show = widget.scrollController.offset > 500;
    if (show != _isVisible) {
      setState(() => _isVisible = show);
    }
  }

  void _scrollToTop() {
    widget.scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 1500),
      curve: Curves.fastOutSlowIn,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // On small screens, bottom nav bar is ~80px — keep FAB above it
    final isSmallScreen = MediaQuery.sizeOf(context).width <= 800;
    final bottomInset = _isVisible ? (isSmallScreen ? 100.0 : 40.0) : -100.0;

    return AnimatedPositioned(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOutBack,
      right: 40,
      bottom: bottomInset,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 300),
        opacity: _isVisible ? 1.0 : 0.0,
        child: MouseRegion(
          onEnter: (_) => _isHovered.value = true,
          onExit: (_) {
            _isHovered.value = false;
            _mouseOffset.value = Offset.zero;
          },
          onHover: (event) {
            final renderBox = context.findRenderObject() as RenderBox?;
            if (renderBox == null) return;
            final size = renderBox.size;
            final center = Offset(size.width / 2, size.height / 2);
            _mouseOffset.value = Offset(
              (event.localPosition.dx - center.dx) * 0.2,
              (event.localPosition.dy - center.dy) * 0.2,
            );
          },
          child: GestureDetector(
            onTap: _scrollToTop,
            child: ListenableBuilder(
              listenable: Listenable.merge([_mouseOffset, _isHovered]),
              builder: (context, _) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeOutCubic,
                  transform: Matrix4.identity()
                    ..translateByDouble(
                        _mouseOffset.value.dx, _mouseOffset.value.dy, 0, 1)
                    ..scaleByDouble(
                        _isHovered.value ? 1.1 : 1.0,
                        _isHovered.value ? 1.1 : 1.0,
                        1,
                        1),
                  transformAlignment: Alignment.center,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        theme.colorScheme.primary,
                        theme.colorScheme.tertiary,
                      ],
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: theme.colorScheme.primary.withValues(alpha: 0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                      if (_isHovered.value)
                        BoxShadow(
                          color: theme.colorScheme.primary.withValues(
                            alpha: 0.2,
                          ),
                          blurRadius: 30,
                          spreadRadius: 5,
                        ),
                    ],
                  ),
                  child: Icon(
                    Icons.keyboard_arrow_up_rounded,
                    color: theme.colorScheme.onPrimary,
                    size: 28,
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
