import 'dart:html';





class Resource { // added new class for future resources
  var resourceName = String;
  var resourceNum = num;
  var resourceURL = Url;
  var resourceDesc = String;

}


// class NavTab extends StatelessWidget {
//   const NavTab({super.key});

// @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Navigation'),
//       ),
//       body: Center(
//         child: ElevatedButton(
//           child: const Text('Rewards'),
//           onPressed: () {
//             // Click here for reward!
//           },
//         )
//       )
//     );
//  // added a nav tab for future linking to other parts of the page
//   }
// }