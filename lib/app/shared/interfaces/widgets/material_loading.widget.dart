import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class MaterialLoadingWidget extends StatefulWidget {
  final int itemCount;

  const MaterialLoadingWidget({super.key, this.itemCount = 3});

  @override
  State<MaterialLoadingWidget> createState() => _MaterialLoadingWidgetState();
}

class _MaterialLoadingWidgetState extends State<MaterialLoadingWidget> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final opacity = 0.45 + (_controller.value * 0.35);

        return ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: widget.itemCount,
          separatorBuilder: (_, _) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            return Opacity(
              opacity: opacity,
              child: child,
            );
          },
        );
      },
      child: const _MaterialLoadingCard(),
    );
  }
}

class _MaterialLoadingCard extends StatelessWidget {
  const _MaterialLoadingCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.borderWarm),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            _block(width: 70, height: 70, radius: 16),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _block(width: 150, height: 16, radius: 8),
                  const SizedBox(height: 10),
                  _block(width: 110, height: 12, radius: 8),
                  const SizedBox(height: 10),
                  _block(width: double.infinity, height: 10, radius: 8),
                  const SizedBox(height: 8),
                  _block(width: 120, height: 10, radius: 8),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _block({required double width, required double height, required double radius}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.borderWarm,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}
