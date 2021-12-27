import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:latihan_mvvm/Model/errMsg.dart';
import 'package:latihan_mvvm/Model/jabatan.dart';
import 'package:latihan_mvvm/Model/Pegawai.dart';


class ApiStatic{
  static final host='http://192.168.1.3/webmobile/public';
  static final _token="19|CeTxcuN3woIYhrMOJjpjS7pgvbW7WrVdK8yoyxOf";
  static getHost(){
    return host;
  }
  // static Future<List<Pegawai>> getPegawai2() async{
  //   List<Pegawai> pegawai=[];
  //   for(var i = 0; i < 8; i++){
  //     pegawai.add(
  //       Pegawai(
  //         idPegawai: i, nama: "Pegawai"+i.toString(), nip: "NIP Pegawai: 000000000"+i.toString(), alamat: "Alamat ", telp: "No Telp: 08596590042", foto: "", idJabatanPgw: 1, nama_jabatan: 'ahli madya', status: 'y',createdAt:"", updateAt: ""
  //         )
  //     );
  //   }
  //   return pegawai;
  // }

  static Future<List<Pegawai>> getPegawai() async{
  //  String response='[{"id_pegawai":1,"nama":"made","nip":1905021010,"alamat":"jln.sangket","telp":"087546354975","foto":"uploads\/pegawais\/1632972981foto1.jpeg","id_jabatan_pgw":1,"status":"y","created_at":null,"updated_at":"2021-09-30T03:36:21.000000Z"},{"id_pegawai":2,"nama":"ngurah","nip":1905021098,"alamat":"jalan bukit lempuyang","telp":"087698567436","foto":"uploads\/pegawais\/1632913456Untitled-24.jpg","id_jabatan_pgw":1,"status":"y","created_at":"2021-09-29T11:04:16.000000Z","updated_at":"2021-09-30T11:51:13.000000Z"}]';
     try {
      final response= await http.get(Uri.parse("$host/api/pegawai"),
      headers: {
        'Authorization' :'Bearer'+_token,
      });
      if (response.statusCode==200){
         var json=jsonDecode(response.body);
        //  print(json);
       final parsed= json['data'].cast<Map<String, dynamic>>(); 
       return parsed.map<Pegawai>((json)=>Pegawai.fromJson(json)).toList();
        
      } else {
         return[];
       }
     } catch (e) {
       return[];
     }
  }

  static Future<List<Jabatan>> getJabatanPgw() async{
     try {
      final response= await http.get(Uri.parse("$host/api/jabatan_pgw"),
      headers: {
        'Authorization' :'Bearer'+_token,
      });
      if (response.statusCode==200){
         var json=jsonDecode(response.body);
       final parsed=json.cast<Map<String, dynamic>>(); 
       return parsed.map<Jabatan>((json)=>Jabatan.fromJson(json)).toList();
      } else {
      return[];
       }
     } catch (e) {
       return[];
     }
  }

 static Future<List<Pegawai>> getPegawaiFilter(int pageKey, String _s,String _selectedChoice) async{
    try {
      final response= await http.get(Uri.parse("$host/api/pegawai?page="+pageKey.toString()+"&s="+_s+"&publish="+_selectedChoice),
      headers: {
        'Authorization' :'Bearer'+_token,
      });
      if (response.statusCode==200){
         var json=jsonDecode(response.body);
        //  print(json);
       final parsed= json['data'].cast<Map<String, dynamic>>(); 
       return parsed.map<Pegawai>((json)=>Pegawai.fromJson(json)).toList();
        
      } else {
         return[];
       }
     } catch (e) {
       return[];
     }
  }




  static Future<ErrorMSG> savePegawai(id,pegawai, filepath) async {
    try {
      var url=Uri.parse('$host/api/pegawai');
      if(id !=0){
        url=Uri.parse('$host/api/pegawai/'+id.toString());
      }
      
      var request = http.MultipartRequest('POST', url);
      request.fields['nama']=pegawai['nama'];
      request.fields['nip']=pegawai['nip'];
      request.fields['alamat']=pegawai['alamat'];
      request.fields['telp']=pegawai['telp'];
      request.fields['status']=pegawai['status'];
      request.fields['id_jabatan_pgw']=pegawai['id_jabatan_pgw'].toString();
      if(filepath!=''){
        request.files.add(await http.MultipartFile.fromPath('foto', filepath));
      }
      request.headers.addAll(
        {
          'Authorization' : 'Bearer' +_token,
        }
      );
      var response = await request.send();
      if (response.statusCode==200){
       final respStr= await response.stream.bytesToString(); 
       return ErrorMSG.fromJson(jsonDecode(respStr));
      } else {
         return ErrorMSG(success: false, message: 'err Request');
       }
     } catch (e) {
       ErrorMSG responseRequest = ErrorMSG(success: false, message: 'error caught: $e');
       return responseRequest;
     }
  }

  static Future<ErrorMSG> deletePegawai(id)async{
    try{
      final response = await http.delete(Uri.parse('$host/api/pegawai/'+id.toString()),
      headers:{
        'Authorization' : 'Bearer' +_token,
      });
      if (response.statusCode==200){
       return ErrorMSG.fromJson(jsonDecode(response.body));
      } else {
         return ErrorMSG(success: false, message: 'err Periksa Kembali Inputan anda');
       }
     } catch (e) {
       ErrorMSG responseRequest = ErrorMSG(success: false, message: 'error caught: $e');
       return responseRequest;
     }
    }
  }