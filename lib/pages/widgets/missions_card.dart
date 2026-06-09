import 'package:flutter/material.dart';
import '../../models/misi_progress_model.dart';

class MissionCard extends StatelessWidget {
  final MisiProgress progress;

  const MissionCard({super.key, required this.progress});

  // Label parameter sensor yang ramah user
  static const Map<String, String> _labelParameter = {
    'temperature':   'Suhu',
    'humidity':      'Kelembapan Udara',
    'light':         'Cahaya',
    'soil_moisture': 'Kelembapan Tanah',
    'tds':           'Nutrisi TDS',
    'ph':            'pH Air',
    'semua':         'Semua Parameter',
  };

  // Warna berdasarkan status
  Color get _warnaStatus {
    if (progress.isSelesai) return Colors.green;
    if (progress.persentase >= 50) return Colors.orange;
    return Colors.blue;
  }

  @override
  Widget build(BuildContext context) {
    final String paramLabel =
        _labelParameter[progress.kondisiParameter] ?? '-';

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ── Baris atas: nama + badge status ──────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    progress.namaMisi,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ),
                _BadgeStatus(
                  label: progress.isSelesai ? 'Selesai' : 'Aktif',
                  warna: _warnaStatus,
                ),
              ],
            ),

            const SizedBox(height: 6),
            Text(
              progress.deskripsiMisi,
              style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
            ),

            const SizedBox(height: 12),

            // ── Info sensor ───────────────────────────────
            if (progress.kondisiParameter != null) ...[
              Row(
                children: [
                  Icon(Icons.sensors, size: 14, color: Colors.grey.shade500),
                  const SizedBox(width: 4),
                  Text(
                    '$paramLabel: ${progress.nilaiMin} – ${progress.nilaiMax}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
              if (progress.nilaiTerakhir != null) ...[
                const SizedBox(height: 2),
                Text(
                  'Nilai terakhir: ${progress.nilaiTerakhir}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.blueGrey,
                  ),
                ),
              ],
              const SizedBox(height: 10),
            ],

            // ── Progress bar ──────────────────────────────
            Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: progress.persentase / 100,
                      minHeight: 10,
                      backgroundColor: Colors.grey.shade200,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(_warnaStatus),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '${progress.persentase}%',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: _warnaStatus,
                    fontSize: 13,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 4),
            Text(
              '${progress.hariTerpenuhi} / ${progress.durasiHari} hari',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
            ),

            const SizedBox(height: 10),

            // ── Poin reward ───────────────────────────────
            Row(
              children: [
                const Icon(Icons.stars_rounded, size: 16, color: Colors.amber),
                const SizedBox(width: 4),
                Text(
                  '${progress.poin} poin',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.amber,
                    fontSize: 13,
                  ),
                ),
                const Spacer(),
                Text(
                  progress.tipeMisi.toUpperCase(),
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade400,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Widget kecil badge status
class _BadgeStatus extends StatelessWidget {
  final String label;
  final Color warna;

  const _BadgeStatus({required this.label, required this.warna});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: warna.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: warna),
      ),
      child: Text(
        label,
        style: TextStyle(color: warna, fontSize: 11),
      ),
    );
  }
}