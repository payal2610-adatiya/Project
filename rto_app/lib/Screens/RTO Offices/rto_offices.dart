import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RtoOffices extends StatelessWidget {
  const RtoOffices({super.key});

  Future<List<dynamic>> fetchOffices() async {
    var url = Uri.parse("https://prakrutitech.xyz/gaurang/gr_view_offices.php");
    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['success'] == true) {
          return data['offices'];
        } else {
          throw Exception('Failed to load offices');
        }
      } else {
        throw Exception('Failed to load offices');
      }
    } catch (e) {
      throw Exception('Error fetching data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("RTO Offices")),
      body: FutureBuilder<List<dynamic>>(
        future: fetchOffices(), // Fetch the data
        builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          // Handle error state
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: TextStyle(color: Colors.red),
              ),
            );
          }

          // Handle no data state
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("No offices available"));
          }

          // Handle successful data fetch
          var officeList = snapshot.data!;
          return ListView.builder(
            itemCount: officeList.length,
            itemBuilder: (context, index) {
              var office = officeList[index];
              return Card(
                margin: EdgeInsets.all(10),
                elevation: 5,
                child: ListTile(
                  title: Text(office['office_name'] ?? 'No name'),
                  subtitle: Text(
                    "Address: ${office['address'] ?? 'No address'}\nContact: ${office['contact_number'] ?? 'No contact'}",
                  ),
                  leading: Icon(Icons.business),
                  onTap: () {
                    // If needed, you can open the office website here
                    print("Office Website: ${office['website']}");
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
