// ignore_for_file: public_member_api_docs, sort_constructors_first
class Makanan {
  String id_makanan;
  String nama_makanan;
  String jenis_makanan;
  String harga_makanan;
  String stok;
  String deskripsi;
  Makanan({
    required this.id_makanan,
    required this.nama_makanan,
    required this.jenis_makanan,
    required this.harga_makanan,
    required this.stok,
    required this.deskripsi,
  });

  String get idmakanan => this.id_makanan;
  set idmakanan(String value) => this.id_makanan = value;

  String get namamakanan => this.nama_makanan;
  set namamakanan(String value) => this.nama_makanan = value;

  String get jenismakanan => this.jenis_makanan;
  set jenismakanan(String value) => this.jenis_makanan = value;

  String get hargamakanan => this.harga_makanan;
  set hargamakanan(String value) => this.harga_makanan = value;

  String get getStok => this.stok;
  set setStok(String stok) => this.stok = stok;

  String get getDeskripsi => this.deskripsi;
  set setDeskripsi(String deskripsi) => this.deskripsi = deskripsi;
}
