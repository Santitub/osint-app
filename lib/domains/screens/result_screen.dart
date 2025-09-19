import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/domain_providers.dart';

class ResultScreen extends ConsumerWidget {
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dnsAsync = ref.watch(dnsResultProvider);
    final whoisAsync = ref.watch(whoisResultProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Resultado del dominio')),
      body: Column(
        children: [
          /* WHOIS */
          whoisAsync.when(
            loading: () => const Padding(
              padding: EdgeInsets.all(16),
              child: LinearProgressIndicator(),
            ),
            error: (e, _) => ListTile(title: Text('Whois error: $e')),
            data: (whois) {
              if (whois == null) return const SizedBox();
              return Card(
                margin: const EdgeInsets.all(16),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Dominio: ${whois.domain}',
                          style: Theme.of(context).textTheme.titleMedium),
                      Text('Registrar: ${whois.registrar}'),
                      Text(
                          'Creación: ${whois.creationDate?.toLocal() ?? '-'}'),
                      Text(
                          'Expira: ${whois.expirationDate?.toLocal() ?? '-'}'),
                      Text('Name-servers: ${whois.nameServers.join(', ')}'),
                    ],
                  ),
                ),
              );
            },
          ),
          const Divider(),

          /* REGISTROS DNS */
          Expanded(
            child: dnsAsync.when(
              loading: () =>
                  const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('DNS error: $e')),
              data: (records) {
                if (records.isEmpty) {
                  return const Center(child: Text('Sin registros'));
                }
                return ListView.builder(
                  itemCount: records.length,
                  itemBuilder: (_, i) {
                    final r = records[i];
                    return Card(
                      child: ListTile(
                        leading: CircleAvatar(child: Text(r.type)),
                        title: Text(r.value),
                        subtitle: Text('TTL: ${r.ttl} s'),
                        trailing: r.priority != null
                            ? Chip(label: Text('prio ${r.priority}'))
                            : null,
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}