import 'package:flutter/material.dart';

import '../../Widgets/Custom Appbar/custom_appbar.dart';

class Processoflicense extends StatefulWidget {
  const Processoflicense({super.key});

  @override
  State<Processoflicense> createState() => _ProcessoflicenseState();
}

class _ProcessoflicenseState extends State<Processoflicense> {

  final List<Map<String, dynamic>> processes = [
    {
      'title': 'New License Process',
      'steps': [
        '1. Submit Application Form: Complete the application form online or offline.',
        '2. Age Verification: Ensure you meet the minimum age requirement.',
        '3. Medical Fitness: Provide a medical certificate if required.',
        '4. Document Submission: Submit necessary documents (ID proof, address proof, etc.).',
        '5. Learner\'s License Test: Pass the written test.',
        '6. Learner\'s License Issuance: Receive your learner\'s license.',
        '7. Driving Test: Appear for the practical driving test.',
        '8. License Issuance: Get your permanent license after passing the test.',
      ],
    },
    {
      'title': 'License Renewal Process',
      'steps': [
        '1. Fill Renewal Application: Complete the renewal application form.',
        '2. Document Submission: Submit your old driving license and other required documents.',
        '3. Age Verification: Ensure your age meets the renewal criteria (if required).',
        '4. Medical Test (if applicable): In some cases, a medical fitness test may be required.',
        '5. Pay Renewal Fee: Pay the applicable fee for license renewal.',
        '6. License Issuance: Receive your renewed license either online or by post.',
      ],
    },
    {
      'title': 'Lost License Reporting',
      'steps': [
        '1. File a Police Report: Report the lost license at the local police station.',
        '2. Submit Application for Duplicate License: Apply for a duplicate license at the RTO.',
        '3. Document Submission: Submit your identity proof, FIR, and old license (if available).',
        '4. Pay Duplicate License Fee: Pay the fee for issuing a duplicate license.',
        '5. License Issuance: Receive your duplicate driving license.',
      ],
    },
    {
      'title': 'International Driving Permit',
      'steps': [
        '1. Submit Application: Fill the application form for an international driving permit.',
        '2. Document Submission: Submit documents such as your driving license, passport, and visa.',
        '3. Age Verification: Ensure you meet the age criteria (usually 18 years or older).',
        '4. Medical Fitness: Provide a medical certificate if required.',
        '5. Pay Permit Fee: Pay the necessary fee for the international driving permit.',
        '6. Permit Issuance: Receive your international driving permit within a few days.',
      ],
    },
    {
      'title': 'Change Details in License',
      'steps': [
        '1. Submit Application: Fill out the application for updating details.',
        '2. Provide Supporting Documents: Submit proof of the new details (e.g., address proof for address change).',
        '3. Pay Fee: Pay the fee for updating the details in the license.',
        '4. Verification: The RTO will verify the submitted documents.',
        '5. New License Issuance: Receive a new license with the updated details.',
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(title: 'Driving License Processes', centerTitle: true),
      body: ListView.builder(
        itemCount: processes.length,
        itemBuilder: (context, processIndex) {
          final process = processes[processIndex];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  process['title'],
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: process['steps'].length,
                itemBuilder: (context, stepIndex) {
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                    elevation: 4,
                    child: ListTile(
                      leading: Icon(Icons.check_circle_outline, color: Colors.blue),
                      title: Text(
                        process['steps'][stepIndex],
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
