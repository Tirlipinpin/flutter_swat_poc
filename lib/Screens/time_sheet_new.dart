// import 'package:flutter/material.dart';
// import 'package:hooks_riverpod/hooks_riverpod.dart';
// import 'package:swat_poc/main.dart';
// import 'dart:developer' as developer;

// class TimeSheet extends HookConsumerWidget {
//   const TimeSheet({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     developer.log("TimeSheet > build");
//     final calendarState = ref.watch(calendarStateProvider);

//     return Scaffold(
//         appBar: AppBar(actions: [
//           IconButton(
//             icon: const Icon(Icons.logout),
//             onPressed: ref.read(authStateProvider).logout,
//           ),
//         ]),
//         body: calendarState.when(
//           data: (data) {
//             if (data.isEmpty) {
//               return const Center(
//                 child: Text("No data"),
//               );
//             }
//             return Column(
//               children: [
//                 Text(
//                   "${calendarState.value!.date!.year}-${calendarState.value!.date!.month}-${calendarState.value!.date!.day}",
//                 ),
//                 ...calendarState.value!.assignments!.map((assignment) {
//                   String project = assignment.key;
//                   int hours = assignment.value;
//                   return Row(
//                     children: [
//                       Text(project),
//                       Text("$hours"),
//                     ],
//                   );
//                 }).toList(),
//                 Row(
//                   children: [
//                     const Text('Total'),
//                     Text('${calendarState.value!.total}')
//                   ],
//                 )
//               ],
//             );
//           },
//           error: (error, stacktrace) {
//             return Center(
//               child: Text("error: $error"),
//             );
//           },
//           loading: () => const Center(child: CircularProgressIndicator()),
//         ));
//   }
// }
