import 'package:flutter/material.dart';
import '../core/api_service.dart';

class ForgotRequestScreen extends StatefulWidget {
  @override State<ForgotRequestScreen> createState()=>_ForgotRequestScreen();
}

class _ForgotRequestScreen extends State<ForgotRequestScreen>{
  List requests=[]; bool loading=false;

  @override void initState(){
    super.initState();
    loadRequests();
  }

  loadRequests() async {
    setState(()=>loading=true);
    final res = await ApiService.getForgotRequests();
    setState(()=>loading=false);

    if(res["body"]?["requests"]!=null){
      requests = res["body"]["requests"];
    }
  }

  @override Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: Text("Forgot Requests")),
      body: loading ?
      Center(child: CircularProgressIndicator()) :
      ListView.builder(
        itemCount: requests.length,
        itemBuilder: (_,i){
          final r = requests[i];
          return Card(
            child: ListTile(
              title: Text(r["email"]),
              subtitle: Text("Role: ${r["role"]}"),
              trailing: Text(r["created_at"]),
            ),
          );
        },
      ),
    );
  }
}
