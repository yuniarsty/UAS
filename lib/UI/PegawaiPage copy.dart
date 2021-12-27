import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:latihan_mvvm/Model/Pegawai.dart';
import 'package:latihan_mvvm/Model/errMsg.dart';
import 'package:latihan_mvvm/Services/apiStatic.dart';
import 'package:latihan_mvvm/UI/PPL/inputPegawai.dart';
import 'package:latihan_mvvm/UI/detailPegawaiPage.dart';
import 'package:latihan_mvvm/UI/homePage.dart';

class PegawaiPage extends StatefulWidget {
  const PegawaiPage({ Key? key }) : super(key: key);

  @override
  _PegawaiPageState createState() => _PegawaiPageState();
}

class _PegawaiPageState extends State<PegawaiPage> {
  late ErrorMSG response;

  final PagingController<int, Pegawai> _pagingController=PagingController(firstPageKey: 0);
  late TextEditingController _s;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  late String _publish="Y";

  void deletePegawai(id) async{
    response=await ApiStatic.deletePegawai(id);
    final snackBar =SnackBar(content: Text(response.message),);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text("Daftar Pegawai Loka POM"),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => InputPegawai(pegawai: Pegawai(
            idPegawai: 0,
            idJabatanPgw: 0,
            nama:'',
            namaJabatan: '',
            status: 'N',
            createdAt: '',
            updateAt: '',
            telp: '',
            alamat: '',
            nip: '',
            foto: ''
          ))));
        },
        ),
      body: FutureBuilder<List<Pegawai>>(
        future: ApiStatic.getPegawai(),
        builder: (context, snapshot){
            if (snapshot.connectionState==ConnectionState.waiting){
              return Center(child: CircularProgressIndicator());
            }else{
                List<Pegawai> listPegawai=snapshot.data!;
                return Container(
                  padding: EdgeInsets.all(5),
                  child: ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (BuildContext context, int index)=>Column(
                      children: [
                        InkWell(
                          onTap:  (){
                               Navigator.of(context).push(new MaterialPageRoute(
                                 builder: (BuildContext context)=>DetailPegawaiPage(pegawai: listPegawai[index],)
                                   ));
                          },
                          child: Container(
                            padding: EdgeInsets.all(5),
                            margin: EdgeInsets.only(top: 10),
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(3),
                              color: Colors.white,
                              border: Border.all(width: 1, color: listPegawai[index].status=='Y'?Colors.blue:Colors.orange)
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children:[
                                Image.network( ApiStatic.host +'/'+ listPegawai[index].foto,width: 40,),
                              Padding(
                                padding: const EdgeInsets.only(left: 5,right:5),
                                child: Column(
                                children:[
                                  Text(listPegawai[index].nama),
                                  Text(listPegawai[index].namaJabatan, style: TextStyle(fontSize:10),),
                                ],
                              )
                              ),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  GestureDetector(
                                    onTap: (){
                                      Navigator.of(context).push(new MaterialPageRoute(
                                        builder: (BuildContext context)=> InputPegawai(pegawai: listPegawai[index],)
                                        ));
                                    },
                                    child: Icon(Icons.edit)),
                                    GestureDetector(
                                      onTap: (){
                                          deletePegawai(listPegawai[index].idPegawai);
                                      },
                                      child: Icon(Icons.delete)),
                                ],
                              )
                              ],
                            ),
                          ),
                        )
                      ]
                    ),
                  ),
                );
            }
        },
    ),
   bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: 1,
        onTap:  (i){
          switch (i) {
            case 0:
              Navigator.of(context).pushReplacement(new MaterialPageRoute(
                builder: (BuildContext context)=>HomePage()
              ));
              break;
               case 1:
              Navigator.of(context).pushReplacement(new MaterialPageRoute(
                builder: (BuildContext context)=>PegawaiPage()
              ));
              break;
            default:
          }
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), title: Text("Home")),
          BottomNavigationBarItem(icon: Icon(Icons.supervised_user_circle), title: Text("Pegawai")),
        ],
      ),
    );
  }
}