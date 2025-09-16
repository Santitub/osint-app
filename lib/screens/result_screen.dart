import 'package:android_intent_plus/android_intent.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../providers/ip_providers.dart';

class ResultScreen extends ConsumerWidget {
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(ipResultProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Resultado')),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (info) {
          if (info == null) return const Center(child: Text('Sin datos'));

          final lat = info.lat;
          final lon = info.lon;
          final hasCoords = lat != 0.0 || lon != 0.0;

          return Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(24),
                  children: [
                    _row('IP', info.ip),
                    _row('País', info.country),
                    _row('Ciudad', info.city),
                    _row('ISP', info.isp),
                    _row('Organización', info.org),
                    _row('Latitud', lat.toString()),
                    _row('Longitud', lon.toString()),
                  ],
                ),
              ),
              if (hasCoords)
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
                    child: FilledButton.icon(
                      onPressed: () => _openMapsOrStore(lat, lon),
                      icon: const Icon(Icons.map),
                      label: const Text('Ver en Google Maps'),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _row(String label, String value) => Card(
        child: ListTile(title: Text(label), subtitle: Text(value)),
      );

  Future<void> _openMapsOrStore(double lat, double lon) async {
    // 1. Intent nativo geo:
    final intent = AndroidIntent(
      action: 'action_view',
      data: 'geo:$lat,$lon?q=$lat,$lon',
    );

    final canResolve = await intent.canResolveActivity() ?? false;
    if (canResolve) {
      await intent.launch();
      return;
    }

    // 2. No hay app que atienda geo: → Play Store
    const storeIntent = AndroidIntent(
      action: 'action_view',
      data: 'market://details?id=com.google.android.apps.maps',
    );
    if (await storeIntent.canResolveActivity() ?? false) {
      await storeIntent.launch();
      return;
    }

    // 3. Último fallback: web
    final webUri = Uri.https('maps.google.com', '/', {'q': '$lat,$lon'});
    await launchUrl(webUri, mode: LaunchMode.externalApplication);
  }
}