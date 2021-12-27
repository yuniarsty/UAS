import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latihan_mvvm/Model/Pegawai.dart';
import 'package:latihan_mvvm/Model/errMsg.dart';
import 'package:latihan_mvvm/Model/jabatan.dart';
import 'package:latihan_mvvm/Services/apiStatic.dart';
import 'package:latihan_mvvm/UI/PegawaiPage.dart';

class InputPegawai extends StatefulWidget {
    final Pegawai pegawai;
  InputPegawai({required this.pegawai});
  @override
  _InputPegawaiState createState() => _InputPegawaiState();
}

class _InputPegawaiState extends State<InputPegawai> {
  final _formkey=GlobalKey<FormState>();
  late TextEditingController nama,nip,alamat,telp;
  late List<Jabatan> _jabatan=[];
  late int idJabatan=0;
  late int idPegawai=0;
  bool _isupdate=false;
  bool _success=false;
  bool _validate=false;
  late ErrorMSG response;
  late String _status='N';
  late String _imagePath="";
  late String _imageURL="";
  final ImagePicker _picker = ImagePicker();

  void getJabatan() async{
    final response =await ApiStatic.getJabatanPgw();
    setState((){
      _jabatan=response.toList();
    });
  }

void submit() async{
  if(_formkey.currentState!.validate()){
    _formkey.currentState!.save();
    var params = {
      'nama' : nama.text.toString(),
      'nip' : nip.text.toString(),
      'alamat' : alamat.text.toString(),
      'telp' : telp.text.toString(),
      'status' :_status,
      'id_jabatan_pgw' :idJabatan,
    };
    response=await ApiStatic.savePegawai(idPegawai, params, _imagePath);
    _success=response.success;
    final snackBar= SnackBar(content: Text(response.message),);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    if(_success){
      Navigator.of(context).pushReplacement(new MaterialPageRoute(
        builder: (BuildContext context)=>PegawaiPage()));
    }
  }else{
    _validate = true;
  }
}

  @override
  void initState() {
    nama =TextEditingController();
    nip=TextEditingController();
    alamat=TextEditingController();
    telp= TextEditingController();

    getJabatan();
     if(widget.pegawai.idPegawai!=0){
       idPegawai=widget.pegawai.idPegawai;
       nama = TextEditingController(text: widget.pegawai.nama);
       nip = TextEditingController(text: widget.pegawai.nip);
       alamat = TextEditingController(text: widget.pegawai.alamat);
       telp = TextEditingController(text: widget.pegawai.telp);
       idJabatan=widget.pegawai.idJabatanPgw;
       _status=widget.pegawai.status;
       _isupdate=true;
      _imageURL=ApiStatic.host+'/'+widget.pegawai.foto;
     }
    super.initState();
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        title: _isupdate ? Text(widget.pegawai.nama) : Text('Input Data'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(10),
       color:  Colors.white,
        child: Form(
           key: _formkey,
          child: Column(
          children: [
            Padding(
             padding: const EdgeInsets.all(5),
                    child: TextFormField(
                      controller: nama,
                      validator: (u) => u == "" ? "Wajib Disis" : null,
                          decoration: const InputDecoration(
                            icon: Icon(Icons.perm_identity),
                           hintText: "Nama Pegawai",
                          labelText: 'Nama Pegawai',
                          ),
                    ),
                  ),

          Padding(
             padding: const EdgeInsets.all(5),
                    child: TextFormField(
                      controller: nip,
                      validator: (u) => u == "" ? "Wajib Disis" : null,
                      keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            icon: Icon(Icons.assignment_ind),
                           hintText: "NIP Pegawai",
                          labelText: 'NIP Pegawai',
                          ),
                    ),
                  ),
          
          Padding(
            padding: EdgeInsets.all(5),
            child: DropdownButtonFormField(
              value: idJabatan == 0?null : idJabatan,
              hint: Text("pilih Jabatan"),
              decoration:  const InputDecoration(
                icon:Icon(Icons.category_rounded),
              ),
              items: _jabatan.map((item) {
                return DropdownMenuItem(
                  child: Text(item.namaJabatan),
                  value: item.idJabatanPgw.toInt(),
                );
              }).toList(),
                onChanged: (value){
                  setState((){
                   idJabatan=value as int;
                  });
                },
                validator: (u) => u == null ? "Wajib Diisi" : null,
          ),
          ),

           Padding(
             padding: const EdgeInsets.all(5),
                    child: TextFormField(
                      controller: telp,
                      keyboardType: TextInputType.phone,
                          decoration: const InputDecoration(
                            icon: Icon(Icons.perm_identity),
                           hintText: "Nomor HP",
                          labelText: 'Nomor HP',
                          ),
                          validator: (u) => u == "" ? "Wajib Disis" : null,
                    ),
                  ),

           Padding(
             padding: const EdgeInsets.all(5),
                    child: TextFormField(
                      controller: alamat,
                      keyboardType: TextInputType.multiline,
                          decoration: const InputDecoration(
                            icon: Icon(Icons.perm_identity),
                           hintText: "Alamat",
                          labelText: 'Alamat Pegawai',
                          ),
                          validator: (u) => u == "" ? "Wajib Disis" : null,
                    ),
                  ),

            Padding(
              padding: EdgeInsets.only(bottom:10, left: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(Icons.image),
                  Flexible(
                    child: _imagePath !='' ? GestureDetector(
                      child: ClipRRect(
                        borderRadius:  BorderRadius.circular(9),
                        child: Image.file(File(_imagePath),
                        fit: BoxFit.fitWidth,
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height / 5,
                        ),
                      ),
                      onTap: (){
                        getImage(ImageSource.camera);
                      }
                    ): _imageURL != ''? GestureDetector(
                       child: ClipRRect(
                        borderRadius:  BorderRadius.circular(9),
                        child: Image.network(_imageURL,
                        fit: BoxFit.fitWidth,
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height / 5,
                        ),
                      ),
                       onTap: (){
                        getImage(ImageSource.camera);
                      }
                  ): GestureDetector(
                     onTap: (){
                        getImage(ImageSource.camera);
                     },
                     child: Container(
                       height: 100,
                       child:  Row(
                         children: <Widget> [
                           Padding(
                             padding: EdgeInsets.only(left: 25),
                           ),
                           Text("Ambil Gambar")
                         ],
                       ),
                      decoration:  BoxDecoration(
                        border: Border(bottom: BorderSide(color: Colors.greenAccent,width:1))
                      ),
                     ),
                       ),
                    )
                ],
              )
            ),


                  Padding(
                    padding: EdgeInsets.only(bottom: 10, left: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Icon(Icons.visibility),
                        Row(
                          children: <Widget>[
                            new Radio(
                              value: "Y", 
                              groupValue: _status, 
                              onChanged: (String? newValue){
                                setState((){
                                  _status = newValue!.toString();
                                });
                              },
                              ),
                              new Text(
                                'Aktif'
                              ),
                              new Radio(
                                value: "N", 
                                groupValue: _status, 
                                onChanged: (String? newValue){
                                  setState((){
                                      _status = newValue!.toString();
                                });
                                },
                              ),
                              new Text(
                                  'Tidak'
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  Divider(),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 50.0,
                      child: RaisedButton(
                      color:Colors.green,
                      child: Text(
                        'SIMPAN',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: (){
                            submit();
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                      ),
                  ),

         ],
      ),
        ),
      ),
      )
    );
}
Future getImage(ImageSource media) async {
  var img = await _picker.pickImage(source: media);

  setState(() {
    _imagePath=img!.path;
    print(_imagePath);
  });
}
}