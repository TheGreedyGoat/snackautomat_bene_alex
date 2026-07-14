// import 'package:flutter/material.dart';

// import 'models/snack.dart';
// import 'widgets/snack_stack.dart';
// import 'widgets/vending_display.dart';

// class MainApp extends StatelessWidget {
//   const MainApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: Scaffold(
//         backgroundColor: const Color.fromARGB(
//           255,
//           90,
//           78,
//           78,
//         ),
//         body: Center(
//           child: SizedBox(
//             width: 1000,
//             height: 900,
//             child: VendingDisplay(
//               child: GridView.builder(
//                 padding: const EdgeInsets.all(24),
//                 gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 4,
//                   crossAxisSpacing: 24,
//                   mainAxisSpacing: 24,
//                   childAspectRatio: 0.8,
//                 ),
//                 itemCount: 16,
//                 itemBuilder: (_, index) {
//                   return
//                   SnackStack(
//                     slot: snacks[index],
//                   );
//                 },
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
