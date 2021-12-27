import 'package:flutter/material.dart';
import 'package:latihan_mvvm/Model/Pegawai.dart';
import 'package:latihan_mvvm/Services/apiStatic.dart';

class DetailPegawaiPage extends StatefulWidget {
  DetailPegawaiPage({required this.pegawai});
  final Pegawai pegawai; 
 
  @override
  _DetailPegawaiPageState createState() => _DetailPegawaiPageState();
}

class _DetailPegawaiPageState extends State<DetailPegawaiPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.pegawai.nama),
      ),
      body: Container(
        width: double.infinity,
        child: ListView(
          children: [
            Image.network(ApiStatic.host +'/'+ widget.pegawai.foto),
            Container(
              padding: EdgeInsets.all(5),
              decoration: new BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.bottomCenter,
                  colors: [const Color(0xff3164bd), const Color(0xff295cb5)],
                ),
              ),
              child:  Text(widget.pegawai.nama, style: TextStyle(color: Colors.white),),
              ),
              Container(
                padding: EdgeInsets.all(10),
                width: double.infinity,
                child: Text(widget.pegawai.nip),
              ),
              Container(
                padding: EdgeInsets.all(10),
                width: double.infinity,
                child: Text(widget.pegawai.namaJabatan),
              ),
              Container(
                padding: EdgeInsets.all(10),
                width: double.infinity,
                child: Text(widget.pegawai.alamat),
              ),
               Container(
                padding: EdgeInsets.all(10),
                width: double.infinity,
                child: Text(widget.pegawai.telp),
              ),
                  ],
                ),
              ),
               
    );
  }
}