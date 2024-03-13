import 'package:flutter/material.dart';
import 'package:mood_waves/classes/resource_Class.dart';

class ResourcesPage extends StatelessWidget {
  final List<Resource> resources = sampleLists;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mental Health Resources'),
      ),
      body: ListView.builder(
        itemCount: resources.length,
        itemBuilder: (context, index) {
          final resource = resources[index];
          return ListTile(
            title: Text(resource.resourceName),
            subtitle: Text(resource.resourceDesc),
            // text: Text(resource.resourceURL),
          );
        },
      ),
    );
  }
}
