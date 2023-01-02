import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './style.dart' as style;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

void main() {
  runApp(MaterialApp(
    theme: style.theme,
    home: MyApp(),
  ) );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var tab = 0;
  var data = [];
  var userImage;
  var userContent;
  getData() async{
    var result = await http.get(Uri.parse('https://codingapple1.github.io/app/data.json'));
    setState(() {
      data = jsonDecode(result.body);
    });
  }

  addMyData(){
    var myData = {
      'id':data.length,
      'image':userImage,
      'likes':5,
      'date':'July 25',
      'content':userContent,
      'liked':false,
      'user':'John Kim',

    };
    setState(() {
      data.insert(0, myData);
    });
  }

  setUserContent(a){
    setState(() {
      userContent = a;
    });
  }
  
  @override
  initState()  {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Instagram'),
          actions: [
            IconButton(
              icon: Icon(Icons.add_box_outlined),
              onPressed: () async {
                var picker = ImagePicker();
                var image = await picker.pickImage(source: ImageSource.gallery);
                if(image != null){
                  setState(() {
                    userImage = File(image.path);
                  });
                }
                Navigator.push(context,
                MaterialPageRoute(builder: (context) => Upload(
                    userImage: userImage,
                    setUserContent:setUserContent,
                    addMyData:addMyData
                ))
                );
              },
              iconSize: 30,
            )
          ],
      ),
      body: [Home(data : data), Text('샵페이지')][tab],
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: (i){
          setState(() {
            tab = i;
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: '홈'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_bag_outlined), label: '샵'),
        ],
      ),

    );
  }
}

//홈화면
class Home extends StatefulWidget {
  const Home({Key? key, this.data}) : super(key: key);
  final data;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  var scroll = ScrollController();
  final ValueNotifier<bool> visible = ValueNotifier<bool>(true);

  @override
  void initState() {
    super.initState();
    scroll.addListener(() async {
      if(scroll.position.pixels == scroll.position.maxScrollExtent){
        var moredata = await http.get(Uri.parse('https://codingapple1.github.io/app/more1.json'));
        var moredata2 = jsonDecode(moredata.body);
        setState(() {
          widget.data.add(moredata2);
        });
      }

    });
  }

  @override
  Widget build(BuildContext context) {

  if(widget.data.isNotEmpty){
    return ListView.builder(itemCount: widget.data.length, controller: scroll, itemBuilder: (c, i){
      return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                widget.data[i]['image'].runtimeType == String
                  ?Image.network(widget.data[i]['image'])
                  :Image.file(widget.data[i]['image']),

                Text('좋아요${widget.data[i]['likes']}'),
                Text('${widget.data[i]['user']}'),
                Text('${widget.data[i]['content']}'),
              ],
            );
    });
  }else{
    return Text('로딩중임');
  }

  }
}

class Upload extends StatefulWidget {
  Upload({Key? key, this.userImage, this.setUserContent, this.addMyData}) : super(key: key);
  final userImage;
  final addMyData;
  final setUserContent;
  var inputText = '';
  @override
  State<Upload> createState() => _UploadState();
}

class _UploadState extends State<Upload> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions: [TextButton(onPressed: (){
        widget.addMyData();
        Navigator.pop(context);
      }, child: Text('공유'))]),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.file(widget.userImage),
          Text('이미지업로드화면'),
          TextField(onChanged: (text){
           widget.setUserContent(text);
          }),
          IconButton(onPressed: (){
            Navigator.pop(context);
          }, icon: Icon(Icons.close)),
        ],
      ),
    );
  }
}
