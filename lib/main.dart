import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(MaterialApp(
      home:  MyApp()
  )
  );
}


class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  getPermission() async {
    var status = await Permission.contacts.status;
    if(status.isGranted) {
      print('허람됨');
    }else if(status.isDenied){
      print('거절됨');
      Permission.contacts.request();
      openAppSettings();
    }
  }



  var name = [['홍길동', '010-0000-0000'], ['신성범', '010-1111-1111'], ['피자집', '010-2222-2222']];
  var like = [0, 0, 0];
  //부모위젯에서 수정함수를 만들어야함 아니면

  remName(i){
    setState(() {
      name.removeAt(i);
    });
  }
  addName(value, number){
    setState(() {
      List<String> list = [value, number];
      name.add(list);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          onPressed: (){
            showDialog(context: context, builder: (context){
              return DialogUI(addName : addName);//보낼때는 중괄호 쓰면 안됨 무한루프?에 빠지는것같음
            });
          }
      ),

      appBar: AppBar( title: Text(name.length.toString()), actions: [
        IconButton(onPressed: (){getPermission();}, icon: Icon(Icons.contacts))
      ], ),
      body: ListView.builder(
        itemCount: name.length,
        itemBuilder: (c, i){
          return ListTile(
            leading: Image.asset('assets/bibim.png'),
            title: Text(name[i][0] +'     '+ name[i][1]),

            trailing: TextButton(onPressed: (){remName(i);}, child: Text('삭제'),),
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          height: 80,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Icon(Icons.call),
              Icon(Icons.message),
              Icon(Icons.book),
            ],
          ),
        ),
      ),
    );
  }
}


class DialogUI extends StatelessWidget {
  DialogUI({Key? key, this.addName}) : super(key: key);
  final addName;
  var inputData = TextEditingController();
  var inputData2 = '';
  var inputData3 = '';
  @override
  Widget build(BuildContext context) {
    return Dialog(
        child: Container(
          width: 500, height: 300, padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Contact', style: TextStyle(fontSize: 50)),
              TextField( onChanged: (text){ inputData2 = text; } ),
              TextField( onChanged: (text){ inputData3 = text; } ),
              Container(
                child: Row(
                  children: [
                    TextButton(
                        onPressed: (){Navigator.pop(context); },
                        child: Text('Cancel', style: TextStyle(fontSize: 20),)
                    ),
                    TextButton(
                        onPressed: (){
                          if(inputData2.isNotEmpty){
                            addName(inputData2, inputData3);
                            Navigator.pop(context);
                          }
                        },
                        child: Text('OK', style: TextStyle(fontSize: 20),)
                    )
                  ],
                ),
              )
            ],
          ),
        )
    );;
  }
}

/*클래스로 만듬
클래스는 변수, 함수 보관함
재사용이 많은 ui들 또는 큰페이지들 만들면 좋음*/
/*class ShopItem extends StatelessWidget {
  const ShopItem({Key? key}) : super(key: key);

  @override//내꺼 먼저 적용하라는 뜻
  build(context) {
    return SizedBox(
      child: Text("안녕"),
    );
  }
}*/
