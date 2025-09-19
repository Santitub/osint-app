// lib/main.dart
import 'dart:ui';
import 'package:flutter_windowmanager_plus/flutter_windowmanager_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:math' as math;
import 'ips/ips_module.dart';
import 'domains/domain_menu.dart';

/* ---------------- APP ROOT ---------------- */
void main() => runApp(
      ProviderScope(
        child: MyApp(),
      ),
    );

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(themeProvider);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorScheme: const ColorScheme.light(
          primary: Color(0xFF0052D4),
          secondary: Color(0xFF4364F7),
          tertiary: Color(0xFF6FB1FC),
          surface: Color(0xFFFFFFFF),
          background: Color(0xFFE3EDFF),
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF00E5FF),
          secondary: Color(0xFF18FFFF),
          tertiary: Color(0xFF64FFDA),
          surface: Color(0xFF121212),
          background: Color(0xFF1A1A2E),
        ),
      ),
      themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
      home: const HomeLauncher(),
    );
  }
}

final themeProvider = StateProvider<bool>((ref) => false);

/* --------------- LAUNCHER (FULL-SCREEN) --------------- */
class HomeLauncher extends ConsumerStatefulWidget {
  const HomeLauncher({super.key});

  @override
  ConsumerState<HomeLauncher> createState() => _HomeLauncherState();
}

class _HomeLauncherState extends ConsumerState<HomeLauncher>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    // 1) Pantalla completa inmediata (Android)
    FlutterWindowManagerPlus.addFlags(
      FlutterWindowManagerPlus.FLAG_FULLSCREEN |
      FlutterWindowManagerPlus.FLAG_LAYOUT_NO_LIMITS,
    );
    // 2) Restaurar al volver a primer plano
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      FlutterWindowManagerPlus.addFlags(
        FlutterWindowManagerPlus.FLAG_FULLSCREEN |
        FlutterWindowManagerPlus.FLAG_LAYOUT_NO_LIMITS,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final modules = [
    _Module(
      label: 'Analizar IPs',
      icon: Icons.location_on,
      color: Theme.of(context).colorScheme.primary,
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const IpsMenu()),
      ),
    ),
    _Module(
      label: 'Analizar Dominios',
      icon: Icons.language,
      color: Theme.of(context).colorScheme.tertiary,
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => DomainMenu()),
      ),
    ),
  ];

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          AnimatedGradient(isDark: isDark),
          const FloatingParticles(),
          SafeArea(
            child: Column(
              children: [
                // TÍTULO Y BOTÓN DE TEMA (misma línea)
                Padding(
                  padding: const EdgeInsets.only(top: 12, left: 16, right: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Spacer(),
                      AppTitle(isDark: isDark),
                      const Spacer(),
                      GestureDetector(
                        onTap: () => ref.read(themeProvider.notifier).state =
                            !ref.read(themeProvider),
                        child: Icon(
                          ref.watch(themeProvider)
                              ? Icons.dark_mode
                              : Icons.light_mode,
                          size: 72,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                const Spacer(),
                GlassCard(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 32,
                      horizontal: 20,
                    ),
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 20,
                      runSpacing: 20,
                      children: modules
                          .map((m) => ModuleButton(module: m, isDark: isDark))
                          .toList(),
                    ),
                  ),
                ),
                const Spacer(flex: 2),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Footer(isDark: isDark),
          ),
        ],
      ),
    );
  }
}

/* ---------------- WIDGETS AUXILIARES ---------------- */
class AppTitle extends StatelessWidget {
  const AppTitle({super.key, required this.isDark});
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => LinearGradient(
        colors: isDark
            ? [const Color(0xFF00E5FF), const Color(0xFF64FFDA)]
            : [const Color(0xFF0052D4), const Color(0xFF6FB1FC)],
      ).createShader(bounds),
      child: Text(
        'OSINT APP',
        style: TextStyle(
          fontSize: 48,
          fontWeight: FontWeight.w900,
          letterSpacing: -1.2,
          color: isDark ? Colors.white : Colors.black,
          shadows: [
            Shadow(
              blurRadius: 28,
              color: isDark
                  ? const Color(0xFF00E5FF).withOpacity(0.6)
                  : const Color(0xFF0052D4).withOpacity(0.4),
              offset: const Offset(0, 4),
            ),
          ],
        ),
      ),
    );
  }
}

class AnimatedGradient extends StatefulWidget {
  const AnimatedGradient({super.key, required this.isDark});
  final bool isDark;

  @override
  State<AnimatedGradient> createState() => _AnimatedGradientState();
}

class _AnimatedGradientState extends State<AnimatedGradient>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Color?> _color1, _color2;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat(reverse: true);
    final light = [
      const Color(0xFF5C9DF0),
      const Color(0xFF7DD3FC),
    ];
    final dark = [
      const Color(0xFF1A1A2E),
      const Color(0xFF2A2A3C),
    ];
    _color1 = ColorTween(begin: widget.isDark ? dark[0] : light[0],
                         end: widget.isDark ? dark[1] : light[1])
        .animate(_controller);
    _color2 = ColorTween(begin: widget.isDark ? dark[1] : light[1],
                         end: widget.isDark ? dark[0] : light[0])
        .animate(_controller);
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
      builder: (_, __) => Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [_color1.value!, _color2.value!],
          ),
        ),
      ),
    );
  }
}

class FloatingParticles extends StatefulWidget {
  const FloatingParticles({super.key});
  @override
  State<FloatingParticles> createState() => _FloatingParticlesState();
}

class _FloatingParticlesState extends State<FloatingParticles>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) {
        return Stack(
          children: List.generate(15, (i) {
            final rand = math.Random(i);
            final size = 4 + rand.nextDouble() * 6;
            final left = rand.nextDouble();
            final top = (rand.nextDouble() + _controller.value) % 1.0;
            return Positioned(
              left: left * MediaQuery.of(context).size.width,
              top: top * MediaQuery.of(context).size.height,
              child: Opacity(
                opacity: 0.2 + rand.nextDouble() * 0.3,
                child: Container(
                  width: size,
                  height: size,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}

class GlassCard extends StatelessWidget {
  const GlassCard({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return ClipRRect(
      borderRadius: BorderRadius.circular(32),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          decoration: BoxDecoration(
            color: (isDark ? Colors.grey[900] : Colors.white)
                ?.withOpacity(0.15),
            borderRadius: BorderRadius.circular(32),
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
              width: 1.5,
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}

class ModuleButton extends StatefulWidget {
  const ModuleButton({super.key, required this.module, required this.isDark});
  final _Module module;
  final bool isDark;

  @override
  State<ModuleButton> createState() => _ModuleButtonState();
}

class _ModuleButtonState extends State<ModuleButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 120),
      vsync: this,
    );
    _scale = Tween<double>(begin: 1, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      onTap: widget.module.onTap,
      child: ScaleTransition(
        scale: _scale,
        child: Container(
          width: 160,
          height: 160,
          decoration: BoxDecoration(
            color: widget.isDark
                ? const Color(0xFF1E1E2C).withOpacity(0.9)
                : const Color(0xFFFFFFFF).withOpacity(0.9),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: widget.isDark
                  ? const Color(0xFF00E5FF).withOpacity(0.6)
                  : const Color(0xFF0052D4).withOpacity(0.6),
              width: 1.5,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(widget.module.icon, size: 52, color: widget.module.color),
              const SizedBox(height: 12),
              Text(
                widget.module.label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: widget.isDark ? Colors.white : Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onTapDown(TapDownDetails _) => _controller.forward();
  void _onTapUp(TapUpDetails _) => _controller.reverse();
  void _onTapCancel() => _controller.reverse();
}

class Footer extends StatelessWidget {
  const Footer({super.key, required this.isDark});
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        'Made with ❤️ By Santitub',
        style: TextStyle(
          fontSize: 14,
          color: isDark ? Colors.white70 : Colors.black54,
        ),
      ),
    );
  }
}

class _Module {
  const _Module({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
}