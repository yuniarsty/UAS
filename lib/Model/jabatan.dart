class Jabatan{

  Jabatan({
      required this.idJabatanPgw,
      required this.namaJabatan,
  });
  int idJabatanPgw;
  String namaJabatan;
  factory Jabatan.fromJson(Map<String,dynamic> json) => Jabatan(
    idJabatanPgw: json["id_jabatan_pgw"],
    namaJabatan: json["nama_jabatan"]==null?'':json["nama_kelompok"].toString()
    );
  Map<String,dynamic> toJson() => {
    "id_jabatan_pgw": idJabatanPgw,
    "nama_jabatan": namaJabatan,
  };
}