import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../services/asistencia_participacion_service.dart';

class AsistenciaParticipacionScreen extends StatefulWidget {
  const AsistenciaParticipacionScreen({super.key});

  @override
  State<AsistenciaParticipacionScreen> createState() =>
      _AsistenciaParticipacionScreenState();
}

class _AsistenciaParticipacionScreenState
    extends State<AsistenciaParticipacionScreen> {
  Map<String, dynamic> asistencias = {};
  Map<String, dynamic> participaciones = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final alumnoId = auth.usuario!.alumnoId!;
    final token = auth.token!;

    final service = AsistenciaParticipacionService();

    asistencias = await service.getAsistencias(alumnoId, token);
    participaciones = await service.getParticipaciones(alumnoId, token);

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            strokeWidth: 2,
          ),
        ),
      );
    }

    final years = (asistencias['asistencias'] ?? {})
        .keys
        .map((e) => e.toString())
        .toList();

    // Solución: Asegurar que la comparación devuelva int explícitamente
    years.sort((a, b) => (b as String).compareTo(a as String));

    if (years.isEmpty) {
      return _buildEmptyState();
    }

    final currentYear = years.first;
    final grades = Map<String, dynamic>.from(
        asistencias['asistencias'][currentYear]['grados'] ?? {});

    final currentGrade = grades.isNotEmpty
        ? grades.keys.firstWhere(
            (k) => (grades[k]['periodos'] ?? {}).isNotEmpty,
            orElse: () => grades.keys.first,
          )
        : null;

    final periods = currentGrade != null
        ? Map<String, dynamic>.from(grades[currentGrade]['periodos'] ?? {})
        : {};

    if (currentGrade == null || periods.isEmpty) {
      return _buildEmptyState();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Asistencia y Participación'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildYearHeader(currentYear, currentGrade),
            const SizedBox(height: 16),
            ...periods.keys.map((period) => _buildPeriodCard(
                  period,
                  periods[period],
                  participaciones['participaciones']?[currentYear]?['grados']
                      [currentGrade]?['periodos']?[period],
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Asistencia y Participación'),
        elevation: 0,
      ),
      body: Center(
        child: Text(
          "No hay registros disponibles",
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.grey[600],
              ),
        ),
      ),
    );
  }

  Widget _buildYearHeader(String year, String grade) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        "$year - $grade",
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }

  Widget _buildPeriodCard(String period, Map<String, dynamic> attendances,
      Map<String, dynamic>? participations) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: Theme.of(context).dividerColor,
          width: 0.5,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              period,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
            ),
            const SizedBox(height: 12),
            if (attendances.isNotEmpty) ...[
              _buildSectionTitle("Asistencias"),
              ..._buildAttendanceList(attendances),
            ],
            if (participations?.isNotEmpty ?? false) ...[
              const SizedBox(height: 12),
              _buildSectionTitle("Participación"),
              ..._buildParticipationList(participations!),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
              color: Theme.of(context).primaryColor,
            ),
      ),
    );
  }

  List<Widget> _buildAttendanceList(Map<String, dynamic> attendances) {
    return attendances.entries.expand((entry) {
      final materia = entry.key;
      final asistList = entry.value as List? ?? [];
      return asistList.map((a) {
        final valor = a['valor'];
        return _buildListItem(
          icon: Icons.check,
          iconColor: Colors.blue,
          title: materia,
          subtitle: "Nota asistencia: ${valor?.toStringAsFixed(1) ?? '-'}",
        );
      });
    }).toList();
  }

  List<Widget> _buildParticipationList(Map<String, dynamic> participations) {
    return participations.entries.expand((entry) {
      final materia = entry.key;
      final partList = entry.value as List? ?? [];
      return partList.map((p) {
        final valor = p['valor'];
        return _buildListItem(
          icon: Icons.record_voice_over,
          iconColor: Colors.indigo,
          title: materia,
          subtitle: "Nota participación: ${valor ?? '-'}",
        );
      });
    }).toList();
  }

  Widget _buildListItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: iconColor),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
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
