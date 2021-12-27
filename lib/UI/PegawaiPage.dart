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
  int _pageSize=2;

  void deletePegawai(id) async{
    response=await ApiStatic.deletePegawai(id);
    final snackBar =SnackBar(content: Text(response.message),);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);  
}

Future<void> _fetchPage(int pageKey, _s,_publish) async{
  try{
    final newItems = await ApiStatic.getPegawaiFilter(pageKey, _s,_publish);
    final isLastPage =newItems.length < _pageSize;
    if(isLastPage){
      _pagingController.appendLastPage(newItems);
    }else{
      final nextPageKey = pageKey + 1;
      _pagingController.appendPage(newItems, nextPageKey);
    }
  }catch(error){
    _pagingController.error = error;
  }
}
@override
  void initState() {
    _s=TextEditingController();
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey, _s.text,_publish);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      // appBar: AppBar(
      //   title:  Text("Daftar Pegawai Loka POM"),
      // ),
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
      body: SingleChildScrollView(
        child:  Stack(
          children: [
        Container(
         padding: EdgeInsets.only(top: 100),
         margin:EdgeInsets.fromLTRB(20, 10, 20, 10),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: RefreshIndicator(
          onRefresh: ()=>Future.sync(() => _pagingController.refresh()
          ),
          child: PagedListView<int, Pegawai>(
            pagingController: _pagingController,
            builderDelegate: PagedChildBuilderDelegate<Pegawai>(
            itemBuilder: (context, item, index)=>Container(
              child: InkWell(
                onTap: (){
                  Navigator.of(context).push(new MaterialPageRoute(
                    builder: (BuildContext context)=>DetailPegawaiPage(pegawai: item)
                    ));
                },
                child: Container(
                  height: 100,
                            padding: EdgeInsets.all(5),
                            margin: EdgeInsets.only(top: 10),
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(3),
                              color: Colors.white,
                              border: Border.all(width: 1, color: item.status=='Y'?Colors.blue:Colors.orange)
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children:[
                                Image.network( ApiStatic.host +'/'+ item.foto,width: 40,),
                              Padding(
                                padding: const EdgeInsets.only(left: 5,right:5),
                                child: Column(
                                children:[
                                  Text(item.nama),
                                  Text(item.namaJabatan, style: TextStyle(fontSize:10),),
                                ],
                              )
                              ),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  GestureDetector(
                                    onTap: (){
                                      Navigator.of(context).push(new MaterialPageRoute(
                                        builder: (BuildContext context)=> InputPegawai(pegawai: item,)
                                        ));
                                    },
                                    child: Icon(Icons.edit)),
                                    GestureDetector(
                                      onTap: (){
                                          deletePegawai(item.idPegawai);
                                      },
                                      child: Icon(Icons.delete)),
                                 ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

      // untuk filter
      Container(
        height: 100,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.blueAccent,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30))),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0),
            child:Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconButton(
                  onPressed: () => _scaffoldKey.currentState!.openDrawer(),
                  icon: Icon(
                    Icons.menu,
                    color: Colors.white,
                  ),
                ),
                  Text(
                    "pegawai",
                    style: TextStyle(color: Colors.white, fontSize:20),
                  ), 
              ],
            )
          ),
          ),

          // Untuk filterrrrrr
          Container(
            height: 100,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.blueAccent,
              borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30))),
              child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0),
               child:Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                        IconButton(
                          onPressed: () => _scaffoldKey.currentState!.openDrawer(),
                          icon: Icon(
                            Icons.menu,
                            color: Colors.white,
                  ),
                ),
                Text(
                    "pegawai",
                    style: TextStyle(color: Colors.white, fontSize:20),
                  ), 
                PopupMenuButton(
                  icon: Icon(
                    Icons.filter_list,
                    color: Colors.white,
                  ),
                  initialValue: _publish,
                  onSelected: (String result){
                    setState(() {
                      _publish =result;
                      _pagingController.refresh();
                    });
                  },

                itemBuilder: (BuildContext context) =><PopupMenuItem<String>>[
                      new PopupMenuItem<String>(
                          child: const Text('Aktif'), value: 'Y'),
                      new PopupMenuItem<String>(
                          child: const Text('Non Aktif'), value: 'N'),
                      new PopupMenuItem<String>(
                          child: const Text('Semua'), value: 'All'),
                      new PopupMenuItem<String>(
                          child: const Text('Deleted'), value: 'del'),
                    ],
                  )
                ],
              ),

            ),
          ), 

          Container(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 70,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Material(
                    elevation: 5.0,
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                    child: TextField(
                      controller: _s,
                      onSubmitted: (_s){
                        _pagingController.refresh();
                      },
                      cursorColor: Theme.of(context).primaryColor,
                      style: TextStyle(color: Colors.black,fontSize: 18),
                      decoration: InputDecoration(
                        hintText: "Masukkan nama pegawai",
                        hintStyle: TextStyle(
                        color: Colors.black38, fontSize: 16),
                          prefixIcon: Material(
                            elevation: 0.0,
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                            child: Icon(Icons.search),
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 25, vertical: 13)),
 
                        ),
                        ),
                  ),
              ],
            ),
          )
        ]),
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