import 'package:flutter/material.dart';

import '../../Widgets/Custom Appbar/custom_appbar.dart';
import '../Exam Details/exam_details.dart';


class Exam extends StatefulWidget {
  const Exam({super.key});

  @override
  State<Exam> createState() => _ExamState();
}

class _ExamState extends State<Exam> {
  String? _selectedItem;

  final List<Map<String, String>> _categoryList = [
    {
      'name': 'MCWOG',
      'description':
          'Motorcycle without Gear: Gearless motorcycles like scooters and mopeds.',
    },
    {
      'name': 'MCWG',
      'description':
          'Motorcycle with Gear: Standard motorcycles requiring gear shifts.',
    },
    {
      'name': 'LMV',
      'description':
          'Light Motor Vehicle: Passenger cars, jeeps, and vans under 3,500 kg.',
    },
    {
      'name': 'HMV',
      'description':
          'Heavy Motor Vehicle: Vehicles for goods or large passenger transport.',
    },
    {
      'name': 'TR',
      'description':
          'Transport Vehicle: Commercial use vehicles for goods/passengers.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(title: 'Exam', centerTitle: true),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 16.0,
              horizontal: 24.0,
            ),
            child: Center(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.indigo, width: 1),
                ),
                child: DropdownButton<String>(
                  value: _selectedItem,
                  hint: Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: Text(
                      'Select Category for exam',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                  ),
                  items: _categoryList.map((category) {
                    return DropdownMenuItem<String>(
                      value: category['name'],
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 12.0,
                          horizontal: 12.0,
                        ),
                        child: Text(
                          category['name']!,
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedItem = newValue;
                    });

                    final selectedCategory = _categoryList.firstWhere(
                      (element) => element['name'] == newValue,
                    );

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ExamDetails()
                      ),
                    );
                  },
                  isExpanded: true,
                  icon: Icon(Icons.arrow_drop_down, color: Colors.blueAccent),
                  iconSize: 30,
                  underline: SizedBox(),
                  dropdownColor: Colors.white,
                ),
              ),
            ),
          ),
          SizedBox(height: 15),
          Expanded(
            child: ListView.builder(
              itemCount: _categoryList.length,
              itemBuilder: (context, index) {
                final category = _categoryList[index];
                return ListTile(
                  title: Text(
                    category['name']!,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  subtitle: Text(category['description']!),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
