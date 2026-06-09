class MisiProgress {
  final int idProgress;
  final int idMisi;
  final String namaMisi;
  final String deskripsiMisi;
  final int poin;
  final String tipeMisi;
  final String? kondisiParameter;
  final double? nilaiMin;
  final double? nilaiMax;
  final int durasiHari;
  final int hariTerpenuhi;
  final double? nilaiTerakhir;
  final int persentase;
  final String status;
  final String? selesaiAt;
  final String? claimedAt;   
  final bool bisaDiklaim;    

  MisiProgress({
    required this.idProgress,
    required this.idMisi,
    required this.namaMisi,
    required this.deskripsiMisi,
    required this.poin,
    required this.tipeMisi,
    this.kondisiParameter,
    this.nilaiMin,
    this.nilaiMax,
    required this.durasiHari,
    required this.hariTerpenuhi,
    this.nilaiTerakhir,
    required this.persentase,
    required this.status,
    this.selesaiAt,
    this.claimedAt,
    this.bisaDiklaim = false,
  });

  factory MisiProgress.fromJson(Map<String, dynamic> json) {
    return MisiProgress(
      idProgress:       json['id_progress'],
      idMisi:           json['id_misi'],
      namaMisi:         json['nama_misi'],
      deskripsiMisi:    json['deskripsi_misi'],
      poin:             json['poin'],
      tipeMisi:         json['tipe_misi'],
      kondisiParameter: json['kondisi_parameter'],
      nilaiMin:         (json['nilai_min'] as num?)?.toDouble(),
      nilaiMax:         (json['nilai_max'] as num?)?.toDouble(),
      durasiHari:       json['durasi_hari'],
      hariTerpenuhi:    json['hari_terpenuhi'],
      nilaiTerakhir:    (json['nilai_terakhir'] as num?)?.toDouble(),
      persentase:       json['persentase'],
      status:           json['status'],
      selesaiAt:        json['selesai_at'],
      claimedAt:        json['claimed_at'],
      bisaDiklaim:      json['bisa_diklaim'] ?? false,
    );
  }

  bool get isSelesai => status == 'selesai';
  bool get isAktif   => status == 'aktif';
  bool get sudahDiklaim => claimedAt != null;
}