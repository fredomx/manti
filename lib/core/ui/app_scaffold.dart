// lib/core/ui/app_scaffold.dart
import 'package:flutter/material.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';

class AppScaffold extends StatelessWidget {
  final Widget body;
  final PreferredSizeWidget? appBar;
  final Widget? bottomBar;      // content (no glass inside)
  final Widget? floatingButton; // content (no glass inside)
  final bool extendBody;

  const AppScaffold({
    super.key,
    required this.body,
    this.appBar,
    this.bottomBar,
    this.floatingButton,
    this.extendBody = true,
  });

  @override
  Widget build(BuildContext context) {
    final hasBottomRow = bottomBar != null || floatingButton != null;

    return Scaffold(
      appBar: appBar,
      backgroundColor: Colors.transparent,
      extendBody: extendBody,
      body: Stack(
        children: [
          // Background gradient
          const Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFFEFF3FF),
                    Color(0xFFFDF2FF),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
          ),

          // Main content
          Positioned.fill(child: body),

          if (hasBottomRow)
            SafeArea(
              minimum: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: LiquidGlassLayer(
                  settings: const LiquidGlassSettings(
                    thickness: 18,
                    blur: 0.8,
                    glassColor: Color(0x44FFFFFF),
                    lightIntensity: 1.4,
                    ambientStrength: 0.9,
                    saturation: 1.1,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (bottomBar != null)
                        Expanded(
                          child: LiquidGlass(
                            shape: LiquidRoundedSuperellipse(
                              borderRadius: 999,
                            ),
                            child: bottomBar!,
                          ),
                        ),

                      if (bottomBar != null && floatingButton != null)
                        const SizedBox(width: 12),

                      if (floatingButton != null)
                        LiquidStretch(
                          stretch: 0.8,
                          interactionScale: 1.15,
                          child: LiquidGlass(
                            shape: LiquidRoundedSuperellipse(
                              borderRadius: 999,
                            ),
                            child: floatingButton!,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
