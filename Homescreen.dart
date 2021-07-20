import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List courses = [];
  bool isLoading = false;

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();

    this.fetchcourse();
  }

  Future fetchcourse() async {
    setState(() {
      isLoading = true;
    });
      String url = "http://ec2-65-1-253-147.ap-south-1.compute.amazonaws.com/course/";
    // var response = await http.get(url);
    http.Response response;
    response=await http.get(url);
    // print(response.body);
    if(response.statusCode == 200){
      setState(() {
        courses = json.decode(response.body);
      });
    }
    else{
      courses = [];
      isLoading = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Screen"),
      ),
      body: getBody(),
    );
  }
  Widget getBody(){
    if(courses.contains(null) || courses.length < 0 || isLoading){
      return Center(child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(textGrey),));
    }
    return ListView.builder(
      itemCount: courses.length,
      itemBuilder: (context,index){
      return getCard(courses[index]);
    });
  }
  Widget getCard(item){
    var fullName = item['name'];
    var durations = item['video_duration'];
    var images = item['image'];
    return Card(
      elevation: 1.5,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListTile(
          title: Row(
            children: <Widget>[
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(60/2),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(images)
                  )
                ),
              ),
              SizedBox(width: 20,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    width: MediaQuery.of(context).size.width-140,
                    child: Text(fullName,style: TextStyle(fontSize: 17),)),
                  SizedBox(height: 10,),
                  Text(durations.toString(),style: TextStyle(color: Colors.grey),)
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
