// ignore_for_file: public_member_api_docs, sort_constructors_first
class Mahasiswa {
  int id;
  String nama;
  String nim;
  String jurusan;
  String alamat;
  String email;
  String password;
  String foto;
  String noTelp;
 int get getId => this.id;

 set setId(int id) => this.id = id;

  get getNama => this.nama;

 set setNama( nama) => this.nama = nama;

  get getNim => this.nim;

 set setNim( nim) => this.nim = nim;

  get getJurusan => this.jurusan;

 set setJurusan( jurusan) => this.jurusan = jurusan;

  get getAlamat => this.alamat;

 set setAlamat( alamat) => this.alamat = alamat;

  get getEmail => this.email;

 set setEmail( email) => this.email = email;

  get getPassword => this.password;

 set setPassword( password) => this.password = password;

  get getFoto => this.foto;

 set setFoto( foto) => this.foto = foto;

  get getNoTelp => this.noTelp;

 set setNoTelp( noTelp) => this.noTelp = noTelp;
  

  Mahasiswa({
    required this.id,
    required this.nama,
    required this.nim,
    required this.jurusan,
    required this.alamat,
    required this.email,
    required this.password,
    required this.foto,
    required this.noTelp,
  });
}

