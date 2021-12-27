import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:latihan_mvvm/Model/Pegawai.dart';
import 'package:latihan_mvvm/Model/errMsg.dart';
import 'package:latihan_mvvm/Services/apiStatic.dart';
import 'package:latihan_mvvm/UI/PegawaiPage.dart';
import 'package:latihan_mvvm/UI/detailPegawaiPage.dart';
import 'package:latihan_mvvm/UI/widget/buttomBar.dart';

class HomePage extends StatefulWidget {
  const HomePage({ Key? key }) : super(key: key);
  

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
   late ErrorMSG response;

  final PagingController<int, Pegawai> _pagingController=PagingController(firstPageKey: 0);
  late TextEditingController _s;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  late String _publish="Y";
  int _pageSize=5;



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
      appBar: AppBar(
        title: Text("List Pegawai"),
      ),    
      
      body: SingleChildScrollView(
        child:  Container(
          margin:EdgeInsets.fromLTRB(30, 10, 30, 10),
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
                                Image.network( ApiStatic.host +'/'+ item.foto,width: 90,),
                              Padding(
                                padding: const EdgeInsets.only(top: 25, left: 25,right:15),
                                child: Column(
                                children:[
                                  Text(item.nama, style: TextStyle(fontSize:15),),
                                  Text(item.nip, style: TextStyle(fontSize:12),),
                                  Text(item.namaJabatan, style: TextStyle(fontSize:10),),
                               ],
                            )
                              ),
                          ],
          
                        ),
                      )),
                      ),
                    ),
                  ),
                )),
          ),
        
      
        
       
        
   bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: 0,
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