class Pegawai{
  Pegawai({
      required this.idPegawai,
      required this.nama,
      required this.nip,
      required this.alamat,
      required this.telp,
      required this.foto,
      required this.idJabatanPgw,
      required this.status,
      required this.namaJabatan,
      required this.createdAt,
      required this.updateAt,
  });
  int idPegawai;
  String nama;
  String nip;
  String alamat;
  String telp;
  String foto;
  int idJabatanPgw;
  String status;
  String namaJabatan;
  String createdAt;
  String updateAt;

  factory Pegawai.fromJson(Map<String, dynamic> json) => Pegawai(
    idPegawai: json["id_pegawai"],
    nama: (json["nama"]==null || json["nama"]=='')?'':json["nama"].toString(),
    nip: (json["nip"]==null || json["nip"]=='')?'':json["nip"].toString(),
    alamat:json["alamat"].toString(),
    telp:json["telp"].toString(),
    foto: json["foto"].toString(),
    idJabatanPgw: json["id_jabatan_pgw"] as int,
    status: json["status"].toString(),
    namaJabatan:json["nama_jabatan"].toString(),
    createdAt: json["createdAt"].toString(),
    updateAt: json["updateAt"].toString(),
  );
}