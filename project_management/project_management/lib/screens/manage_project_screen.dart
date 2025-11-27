import 'package:flutter/material.dart';
import '../core/api_service.dart';

class ManageProjectsScreen extends StatefulWidget{
  @override State<ManageProjectsScreen> createState()=>_ManageProjectsScreen();
}

class _ManageProjectsScreen extends State<ManageProjectsScreen>{
  List projects=[];
  bool loading=false;

  @override void initState(){ super.initState(); fetch(); }

  fetch() async {
    setState(()=>loading=true);
    final res = await ApiService.viewProjects();
    setState(()=>loading=false);

    if(res["body"]?["projects"]!=null){
      projects = res["body"]["projects"];
    }
  }

  updateStatus(i){
    var flow = ["designer","developer","tester","completed"];
    String current = projects[i]["status"];
    int index = flow.indexOf(current);

    if(index < flow.length-1){
      projects[i]["status"] = flow[index+1];
      setState((){});
    }
  }

  @override Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: Text("Manage Projects")),
      body: loading?Center(child: CircularProgressIndicator()) :
      ListView.builder(
        itemCount: projects.length,
        itemBuilder: (_,i){
          var p = projects[i];
          return Card(
            child: ListTile(
              title: Text(p["title"]),
              subtitle: Text("Status: ${p["status"]}"),
              trailing: ElevatedButton(
                onPressed: p["status"]=="completed" ? null : ()=>updateStatus(i),
                child: Text("Next Stage"),
              ),
            ),
          );
        },
      ),
    );
  }
}
