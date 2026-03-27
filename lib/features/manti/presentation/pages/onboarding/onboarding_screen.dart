import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isar/isar.dart';
import 'package:manti/features/manti/data/local/app_config_isar.dart';
import 'package:manti/features/manti/presentation/pages/home/home_screen.dart';

// ── Accent colors (iOS system palette) ───────────────────────────────────────
const _c0 = Color(0xFF0A84FF); // Welcome  — blue
const _c1 = Color(0xFF30B0C7); // Items    — teal
const _c2 = Color(0xFFBF5AF2); // History  — purple
const _c3 = Color(0xFF34C759); // Alerts   — green
const _slideColors = [_c0, _c1, _c2, _c3];

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  final _pageCtrl = PageController();
  int _page = 0;

  // Continuous animations shared across all illustrations
  late final AnimationController _floatCtrl; // orbital float loop
  late final AnimationController _pulseCtrl; // main-circle pulse loop
  // Per-page entrance: restarted on every page change
  late final AnimationController _entrCtrl;

  static const _count = 4;

  @override
  void initState() {
    super.initState();
    _floatCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);
    _entrCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 560),
    )..forward();
  }

  @override
  void dispose() {
    _pageCtrl.dispose();
    _floatCtrl.dispose();
    _pulseCtrl.dispose();
    _entrCtrl.dispose();
    super.dispose();
  }

  void _next() {
    if (_page < _count - 1) {
      _pageCtrl.nextPage(
        duration: const Duration(milliseconds: 420),
        curve: Curves.easeInOutCubic,
      );
    } else {
      _complete();
    }
  }

  Future<void> _complete() async {
    final isar = context.read<Isar>();
    await isar.writeTxn(() async {
      await isar.appConfigIsars.put(
        AppConfigIsar()
          ..id = 1
          ..hasSeededMantiItems = true,
      );
    });
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (_, animation, __) => const HomeScreen(),
        transitionsBuilder: (_, animation, __, child) => FadeTransition(
          opacity: animation,
          child: child,
        ),
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }

  void _onPageChanged(int page) {
    setState(() => _page = page);
    _entrCtrl.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    final accent = _slideColors[_page];

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // ── Animated background glow — interpolates between slide colors ──
          TweenAnimationBuilder<Color?>(
            tween: ColorTween(begin: _c0, end: accent),
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
            builder: (_, color, __) => Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: const Alignment(0, -0.55),
                  radius: 0.95,
                  colors: [
                    (color ?? accent).withValues(alpha: 0.11),
                    Colors.white,
                  ],
                ),
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                // ── Skip ──────────────────────────────────────────────────
                SizedBox(
                  height: 52,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: AnimatedOpacity(
                      opacity: _page < _count - 1 ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 200),
                      child: Padding(
                        padding: const EdgeInsets.only(right: 24),
                        child: GestureDetector(
                          onTap: _page < _count - 1 ? _complete : null,
                          child: Text(
                            'Omitir',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Colors.black.withValues(alpha: 0.3),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // ── Slides ────────────────────────────────────────────────
                Expanded(
                  child: PageView(
                    controller: _pageCtrl,
                    onPageChanged: _onPageChanged,
                    children: [
                      _Slide(
                        illustration: _Illus1(
                          floatCtrl: _floatCtrl,
                          pulseCtrl: _pulseCtrl,
                        ),
                        tag: null,
                        title: 'Bienvenido a Manti',
                        subtitle:
                            'El asistente que recuerda por ti.\nTodo lo que cuidas, en un solo lugar.',
                        accentColor: _c0,
                        entrCtrl: _entrCtrl,
                        isActive: _page == 0,
                      ),
                      _Slide(
                        illustration: _Illus2(floatCtrl: _floatCtrl),
                        tag: 'Artículos',
                        title: 'Agrega lo que cuidas',
                        subtitle:
                            'Auto, laptop, bici, cafetera —\nlo que uses y necesite atención regular.',
                        accentColor: _c1,
                        entrCtrl: _entrCtrl,
                        isActive: _page == 1,
                      ),
                      _Slide(
                        illustration: _Illus3(floatCtrl: _floatCtrl),
                        tag: 'Historial',
                        title: 'Registra cada servicio',
                        subtitle:
                            'Costo, notas y frecuencia.\nHistorial completo siempre contigo.',
                        accentColor: _c2,
                        entrCtrl: _entrCtrl,
                        isActive: _page == 2,
                      ),
                      _Slide(
                        illustration: _Illus4(
                          floatCtrl: _floatCtrl,
                          pulseCtrl: _pulseCtrl,
                        ),
                        tag: 'Recordatorios',
                        title: 'Nunca llegues tarde',
                        subtitle:
                            'Manti calcula cuándo toca\ny te avisa antes de que venza.',
                        accentColor: _c3,
                        entrCtrl: _entrCtrl,
                        isActive: _page == 3,
                      ),
                    ],
                  ),
                ),

                // ── Dot indicators with glow ──────────────────────────────
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(_count, (i) {
                    final active = i == _page;
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: active ? 24 : 7,
                      height: 7,
                      decoration: BoxDecoration(
                        color: active
                            ? accent
                            : Colors.black.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(999),
                        boxShadow: active
                            ? [
                                BoxShadow(
                                  color: accent.withValues(alpha: 0.4),
                                  blurRadius: 8,
                                  offset: Offset.zero,
                                ),
                              ]
                            : null,
                      ),
                    );
                  }),
                ),

                const SizedBox(height: 32),

                // ── CTA button — color follows slide ──────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  child: SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: _next,
                      style: FilledButton.styleFrom(
                        backgroundColor: accent,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 17),
                        shape: const StadiumBorder(),
                        textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        child: Text(
                          _page == _count - 1 ? 'Empezar' : 'Siguiente',
                          key: ValueKey(_page == _count - 1),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 44),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Slide wrapper ──────────────────────────────────────────────────────────────

class _Slide extends StatelessWidget {
  final Widget illustration;
  final String? tag;
  final String title;
  final String subtitle;
  final Color accentColor;
  final AnimationController entrCtrl;
  final bool isActive;

  const _Slide({
    required this.illustration,
    required this.tag,
    required this.title,
    required this.subtitle,
    required this.accentColor,
    required this.entrCtrl,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Column(
        children: [
          // Illustration: scale + fade entrance
          Expanded(
            child: Center(
              child: AnimatedBuilder(
                animation: entrCtrl,
                builder: (context, child) {
                  if (!isActive) return child!;
                  final scale = CurvedAnimation(
                    parent: entrCtrl,
                    curve: Curves.easeOutBack,
                  ).value.clamp(0.0, 1.0);
                  final opacity = CurvedAnimation(
                    parent: entrCtrl,
                    curve: Curves.easeOut,
                  ).value.clamp(0.0, 1.0);
                  return Transform.scale(
                    scale: 0.88 + 0.12 * scale,
                    child: Opacity(opacity: opacity, child: child),
                  );
                },
                child: illustration,
              ),
            ),
          ),

          // Text block: slide-up + fade entrance
          AnimatedBuilder(
            animation: entrCtrl,
            builder: (context, child) {
              if (!isActive) return child!;
              final t = CurvedAnimation(
                parent: entrCtrl,
                curve: const Interval(0.15, 1.0, curve: Curves.easeOutCubic),
              ).value.clamp(0.0, 1.0);
              return Transform.translate(
                offset: Offset(0, 20 * (1 - t)),
                child: Opacity(opacity: t, child: child),
              );
            },
            child: Column(
              children: [
                // Category tag pill
                if (tag != null) ...[
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                    decoration: BoxDecoration(
                      color: accentColor.withValues(alpha: 0.10),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      tag!,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: accentColor,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: Colors.black87,
                    height: 1.15,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    height: 1.65,
                    color: Colors.black.withValues(alpha: 0.45),
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 48),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Shared: white circle with colored icon ─────────────────────────────────────

class _OrbitalIcon extends StatelessWidget {
  final IconData icon;
  final Color color;

  const _OrbitalIcon({required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 46,
      height: 46,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.09),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Icon(icon, size: 22, color: color),
    );
  }
}

// ── Illustration 1 — Welcome (blue) ───────────────────────────────────────────
// Concentric rings + pulsing central circle + 3 floating orbital icons

class _Illus1 extends StatelessWidget {
  final AnimationController floatCtrl;
  final AnimationController pulseCtrl;

  const _Illus1({required this.floatCtrl, required this.pulseCtrl});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([floatCtrl, pulseCtrl]),
      builder: (context, _) {
        final pulse = 1.0 + pulseCtrl.value * 0.045;
        final glowBlur = 28.0 + pulseCtrl.value * 14;
        final glowAlpha = 0.30 + pulseCtrl.value * 0.10;

        double fy(double phase) =>
            sin((floatCtrl.value + phase) * 2 * pi) * 9;
        double fx(double phase) =>
            cos((floatCtrl.value + phase) * 2 * pi) * 3;

        return SizedBox(
          width: 280,
          height: 280,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Outer ring
              Container(
                width: 260,
                height: 260,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: _c0.withValues(alpha: 0.08),
                    width: 1.5,
                  ),
                ),
              ),
              // Mid fill
              Container(
                width: 192,
                height: 192,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _c0.withValues(alpha: 0.06),
                ),
              ),
              // Pulsing main circle
              Transform.scale(
                scale: pulse,
                child: Container(
                  width: 118,
                  height: 118,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _c0,
                    boxShadow: [
                      BoxShadow(
                        color: _c0.withValues(alpha: glowAlpha),
                        blurRadius: glowBlur,
                        offset: const Offset(0, 12),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.handyman_rounded,
                      size: 50, color: Colors.white),
                ),
              ),
              // Floating orbitals (phase-offset for organic motion)
              Transform.translate(
                offset: Offset(85 + fx(0.0), -62 + fy(0.0)),
                child: const _OrbitalIcon(
                    icon: Icons.directions_car_rounded, color: _c0),
              ),
              Transform.translate(
                offset: Offset(-90 + fx(0.33), -48 + fy(0.33)),
                child: const _OrbitalIcon(
                    icon: Icons.laptop_rounded, color: _c0),
              ),
              Transform.translate(
                offset: Offset(8 + fx(0.67), 96 + fy(0.67)),
                child: const _OrbitalIcon(
                    icon: Icons.home_repair_service_rounded, color: _c0),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ── Illustration 2 — Items (teal) ─────────────────────────────────────────────
// Three category mini-cards stacked; front card floats

class _Illus2 extends StatelessWidget {
  final AnimationController floatCtrl;

  const _Illus2({required this.floatCtrl});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: floatCtrl,
      builder: (context, _) {
        final float = sin(floatCtrl.value * 2 * pi) * 7;

        return SizedBox(
          width: 280,
          height: 280,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Outer ring
              Container(
                width: 260,
                height: 260,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: _c1.withValues(alpha: 0.08),
                    width: 1.5,
                  ),
                ),
              ),
              // Mid fill
              Container(
                width: 192,
                height: 192,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _c1.withValues(alpha: 0.06),
                ),
              ),
              // Back card — tool, tilted left
              Transform.translate(
                offset: Offset(-52, 24 + float * 0.35),
                child: Transform.rotate(
                  angle: -0.18,
                  child: _MiniCard(
                    icon: Icons.home_repair_service_rounded,
                    label: 'Herramienta',
                    color: const Color(0xFFBA68C8),
                  ),
                ),
              ),
              // Back card — car, tilted right
              Transform.translate(
                offset: Offset(48, 24 + float * 0.55),
                child: Transform.rotate(
                  angle: 0.18,
                  child: _MiniCard(
                    icon: Icons.directions_car_rounded,
                    label: 'Auto',
                    color: const Color(0xFFFF8A65),
                  ),
                ),
              ),
              // Front card — laptop, main float
              Transform.translate(
                offset: Offset(0, float),
                child: _MiniCard(
                  icon: Icons.laptop_rounded,
                  label: 'Laptop',
                  color: _c1,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _MiniCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _MiniCard({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 88,
      height: 100,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.10),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 24, color: color),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Colors.black.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Illustration 3 — History/Log (purple) ─────────────────────────────────────
// Realistic log-entry card floating above a ghost card

class _Illus3 extends StatelessWidget {
  final AnimationController floatCtrl;

  const _Illus3({required this.floatCtrl});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: floatCtrl,
      builder: (context, _) {
        final float = sin(floatCtrl.value * 2 * pi) * 7;

        return SizedBox(
          width: 280,
          height: 280,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Outer ring
              Container(
                width: 260,
                height: 260,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: _c2.withValues(alpha: 0.08),
                    width: 1.5,
                  ),
                ),
              ),
              // Mid fill
              Container(
                width: 192,
                height: 192,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _c2.withValues(alpha: 0.06),
                ),
              ),
              // Ghost card behind (rotated, faded)
              Transform.translate(
                offset: Offset(14, float * 0.45 + 14),
                child: Transform.rotate(
                  angle: 0.10,
                  child: Opacity(
                    opacity: 0.40,
                    child: Container(
                      width: 195,
                      height: 118,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(22),
                      ),
                    ),
                  ),
                ),
              ),
              // Main log card (floating)
              Transform.translate(
                offset: Offset(0, float),
                child: const _LogCard(),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _LogCard extends StatelessWidget {
  const _LogCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 195,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.11),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon + title + date
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: _c2.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.build_rounded, size: 17, color: _c2),
              ),
              const SizedBox(width: 9),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Cambio de aceite',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '15 Mar 2025',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.black.withValues(alpha: 0.35),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 11),
          // Cost pill + status chip
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                decoration: BoxDecoration(
                  color: _c2.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: const Text(
                  '\$450',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: _c2,
                  ),
                ),
              ),
              const Spacer(),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _c3.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.check_circle_rounded,
                        size: 11, color: _c3),
                    const SizedBox(width: 3),
                    Text(
                      'Listo',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: _c3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Frequency chip
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.repeat_rounded,
                    size: 11, color: Colors.black.withValues(alpha: 0.4)),
                const SizedBox(width: 4),
                Text(
                  'Cada 3 meses',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: Colors.black.withValues(alpha: 0.45),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Illustration 4 — Reminders (green) ────────────────────────────────────────
// Pulsing notification bell + 3 floating status chips (the 3 app states)

class _Illus4 extends StatelessWidget {
  final AnimationController floatCtrl;
  final AnimationController pulseCtrl;

  const _Illus4({required this.floatCtrl, required this.pulseCtrl});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([floatCtrl, pulseCtrl]),
      builder: (context, _) {
        final pulse = 1.0 + pulseCtrl.value * 0.045;
        final glowBlur = 28.0 + pulseCtrl.value * 14;
        final glowAlpha = 0.30 + pulseCtrl.value * 0.10;

        double fy(double phase) =>
            sin((floatCtrl.value + phase) * 2 * pi) * 8;
        double fx(double phase) =>
            cos((floatCtrl.value + phase) * 2 * pi) * 3;

        return SizedBox(
          width: 280,
          height: 280,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Outer ring
              Container(
                width: 260,
                height: 260,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: _c3.withValues(alpha: 0.08),
                    width: 1.5,
                  ),
                ),
              ),
              // Mid fill
              Container(
                width: 192,
                height: 192,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _c3.withValues(alpha: 0.06),
                ),
              ),
              // Pulsing main circle
              Transform.scale(
                scale: pulse,
                child: Container(
                  width: 118,
                  height: 118,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _c3,
                    boxShadow: [
                      BoxShadow(
                        color: _c3.withValues(alpha: glowAlpha),
                        blurRadius: glowBlur,
                        offset: const Offset(0, 12),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.notifications_rounded,
                      size: 50, color: Colors.white),
                ),
              ),
              // Status chips — the 3 maintenance states in the app
              Transform.translate(
                offset: Offset(-80 + fx(0.0), -66 + fy(0.0)),
                child: const _StatusChip(
                  label: 'A tiempo',
                  color: _c3, // green
                ),
              ),
              Transform.translate(
                offset: Offset(66 + fx(0.33), -72 + fy(0.33)),
                child: const _StatusChip(
                  label: 'Próximo',
                  color: Color(0xFFFF9500), // iOS orange
                ),
              ),
              Transform.translate(
                offset: Offset(2 + fx(0.67), 100 + fy(0.67)),
                child: const _StatusChip(
                  label: 'Vencido',
                  color: Color(0xFFFF3B30), // iOS red
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// Compact colored pill representing a maintenance status
class _StatusChip extends StatelessWidget {
  final String label;
  final Color color;

  const _StatusChip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(999),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 7,
            height: 7,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
