import 'package:e_quizzmath/presentation/providers/unit_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyUnitsScreen extends StatelessWidget {
  const MyUnitsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final unitProvider = context.watch<UnitProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Unidades'),
      ),
      body: unitProvider.isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : unitProvider.units.isEmpty
              ? const Center(
                  child: Text('No hay unidades asignadas'),
                )
              : const _MyUnitsView(),
    );
  }
}

class _MyUnitsView extends StatelessWidget {
  const _MyUnitsView();

  @override
  Widget build(BuildContext context) {
    final unitProvider = context.watch<UnitProvider>();

    return ListView.builder(
      itemCount: unitProvider.units.length,
      itemBuilder: (context, index) {
        final unit = unitProvider.units[index];
        return Card(
          child: ExpansionTile(
            childrenPadding: const EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 20,
            ),
            expandedCrossAxisAlignment: CrossAxisAlignment.start,
            expandedAlignment: Alignment.topLeft,
            leading: const Icon(Icons.numbers_rounded),
            title: Text(
              unit.title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            children: [
              Text(unit.description),
              const SizedBox(height: 10),
              Text('Videos: ${unit.playlist.length}'),
            ],
          ),
        );
      },
    );
  }
}
