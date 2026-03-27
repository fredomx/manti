import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isar/isar.dart';
import 'package:manti/features/manti/data/local/app_config_isar.dart';
import 'package:manti/features/manti/presentation/pages/home/home_screen.dart';

const _blue = Color(0xFF0A84FF);
const _teal = Color(0xFF30B0C7);
const _green = Color(0xFF34C759);

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _controller = PageController();
  int _page = 0;

  static const _count = 3;

  void _next() {
    if (_page < _count - 1) {
      _controller.nextPage(
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
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // ── Skip button ──────────────────────────────────────────
            SizedBox(
              height: 52,
              child: Align(
                alignment: Alignment.centerRight,
                child: AnimatedOpacity(
                  opacity: _page < _count - 1 ? 1 : 0,
                  duration: const Duration(milliseconds: 200),
                  child: Padding(
                    padding: const EdgeInsets.only(right: 20),
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

            // ── Slides ───────────────────────────────────────────────
            Expanded(
              child: PageView(
                controller: _controller,
                onPageChanged: (p) => setState(() => _page = p),
                children: const [
                  _Slide(
                    illustration: _Illus1(),
                    title: 'Bienvenido a Manti',
                    subtitle:
                        'Cuida lo que tienes.\nNunca olvides un mantenimiento.',
                  ),
                  _Slide(
                    illustration: _Illus2(),
                    title: 'Agrega lo que cuidas',
                    subtitle:
                        'Tu auto, laptop, bici — lo que necesite\natención regular.',
                  ),
                  _Slide(
                    illustration: _Illus3(),
                    title: 'Manti te avisa a tiempo',
                    subtitle:
                        'Asigna una frecuencia a cada servicio\ny recibe recordatorios antes de que toque.',
                  ),
                ],
              ),
            ),

            // ── Dots ─────────────────────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_count, (i) {
                final active = i == _page;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 260),
                  curve: Curves.easeInOut,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: active ? 22 : 7,
                  height: 7,
                  decoration: BoxDecoration(
                    color: active
                        ? _blue
                        : Colors.black.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(999),
                  ),
                );
              }),
            ),

            const SizedBox(height: 36),

            // ── CTA Button ───────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _next,
                  style: FilledButton.styleFrom(
                    backgroundColor: _blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 17),
                    shape: const StadiumBorder(),
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  child: Text(_page == _count - 1 ? 'Empezar' : 'Siguiente'),
                ),
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

// ── Slide wrapper ─────────────────────────────────────────────────────────────

class _Slide extends StatelessWidget {
  final Widget illustration;
  final String title;
  final String subtitle;

  const _Slide({
    required this.illustration,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Column(
        children: [
          Expanded(child: Center(child: illustration)),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w800,
              color: Colors.black87,
              height: 1.15,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              height: 1.55,
              color: Colors.black.withValues(alpha: 0.45),
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 48),
        ],
      ),
    );
  }
}

// ── Shared illustration helpers ───────────────────────────────────────────────

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

// ── Illustration 1: Welcome ───────────────────────────────────────────────────

class _Illus1 extends StatelessWidget {
  const _Illus1();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 260,
      height: 260,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer faint ring
          Container(
            width: 250,
            height: 250,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: _blue.withValues(alpha: 0.08),
                width: 1.5,
              ),
            ),
          ),
          // Mid fill
          Container(
            width: 186,
            height: 186,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _blue.withValues(alpha: 0.07),
            ),
          ),
          // Main circle
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _blue,
              boxShadow: [
                BoxShadow(
                  color: _blue.withValues(alpha: 0.35),
                  blurRadius: 40,
                  offset: const Offset(0, 14),
                ),
              ],
            ),
            child: const Icon(Icons.handyman_rounded,
                size: 52, color: Colors.white),
          ),
          // Orbitals
          Transform.translate(
            offset: const Offset(88, -68),
            child: const _OrbitalIcon(
                icon: Icons.directions_car_rounded, color: _blue),
          ),
          Transform.translate(
            offset: const Offset(-92, -52),
            child: const _OrbitalIcon(
                icon: Icons.laptop_rounded, color: _blue),
          ),
          Transform.translate(
            offset: const Offset(8, 98),
            child: const _OrbitalIcon(
                icon: Icons.home_repair_service_rounded, color: _blue),
          ),
        ],
      ),
    );
  }
}

// ── Illustration 2: Items ─────────────────────────────────────────────────────

class _Illus2 extends StatelessWidget {
  const _Illus2();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 260,
      height: 260,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer faint ring
          Container(
            width: 250,
            height: 250,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: _teal.withValues(alpha: 0.08),
                width: 1.5,
              ),
            ),
          ),
          // Mid fill
          Container(
            width: 186,
            height: 186,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _teal.withValues(alpha: 0.07),
            ),
          ),
          // Back card (tool)
          Transform.translate(
            offset: const Offset(-50, 22),
            child: Transform.rotate(
              angle: -0.18,
              child: _MiniCard(
                icon: Icons.home_repair_service_rounded,
                label: 'Herramienta',
                color: const Color(0xFFBA68C8),
              ),
            ),
          ),
          // Back card (car)
          Transform.translate(
            offset: const Offset(46, 22),
            child: Transform.rotate(
              angle: 0.18,
              child: _MiniCard(
                icon: Icons.directions_car_rounded,
                label: 'Auto',
                color: const Color(0xFFFF8A65),
              ),
            ),
          ),
          // Front card (laptop) — on top, no rotation
          _MiniCard(
            icon: Icons.laptop_rounded,
            label: 'Laptop',
            color: _teal,
          ),
        ],
      ),
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

// ── Illustration 3: Reminders ─────────────────────────────────────────────────

class _Illus3 extends StatelessWidget {
  const _Illus3();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 260,
      height: 260,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer faint ring
          Container(
            width: 250,
            height: 250,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: _green.withValues(alpha: 0.08),
                width: 1.5,
              ),
            ),
          ),
          // Mid fill
          Container(
            width: 186,
            height: 186,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _green.withValues(alpha: 0.07),
            ),
          ),
          // Main circle
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _green,
              boxShadow: [
                BoxShadow(
                  color: _green.withValues(alpha: 0.35),
                  blurRadius: 40,
                  offset: const Offset(0, 14),
                ),
              ],
            ),
            child: const Icon(Icons.notifications_rounded,
                size: 52, color: Colors.white),
          ),
          // Orbitals
          Transform.translate(
            offset: const Offset(-90, -56),
            child: const _OrbitalIcon(
                icon: Icons.calendar_today_rounded, color: _green),
          ),
          Transform.translate(
            offset: const Offset(88, -60),
            child: const _OrbitalIcon(
                icon: Icons.check_circle_rounded, color: _green),
          ),
          Transform.translate(
            offset: const Offset(-6, 98),
            child: const _OrbitalIcon(
                icon: Icons.schedule_rounded, color: _green),
          ),
        ],
      ),
    );
  }
}
