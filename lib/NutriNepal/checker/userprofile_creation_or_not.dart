// // home_wrapper.dart
// import 'package:flutter/material.dart';
// import 'package:nutrinepal_1/NutriNepal/UI/Profile/profile_update.dart';
// import '../Client_Method/profile_service.dart';
// import '../UI/pages/home_page.dart';
// import '../UI/pages/profile_completion_screen.dart';
// import '../calculation_logic/profile_checker.dart';
// import '../models/user_profile.dart';
//
//
// class HomeWrapper extends StatefulWidget {
//   final String token;
//   const HomeWrapper({super.key, required this.token,});
//
//   @override
//   State<HomeWrapper> createState() => _HomeWrapperState();
// }
//
// class _HomeWrapperState extends State<HomeWrapper> {
//   UserProfile? profile;
//   bool loading = true;
//
//   @override
//   void initState() {
//     super.initState();
//     loadUser();
//   }
//
//   Future<void> loadUser() async {
//     // 1️⃣ Fetch user profile from backend
//     profile = await ProfileService().getProfile(widget.token);
//
//     // 2️⃣ If profile is NOT found → go to login
//     if (profile == null) {
//       Navigator.pushReplacementNamed(context, '/login');
//       return;
//     }
//
//     // 3️⃣ If profile exists BUT incomplete → open ProfileCompletionScreen
//     if (isProfileIncomplete(profile!)) {
//       final updated = await Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (_) => ProfileCompletionScreen(
//             token: widget.token,
//             profile: profile!, UserProfile: dummyProfile,
//           ),
//         ),
//       );
//
//       // If user completed the profile → refresh data and show SnackBar
//       if (updated == true) {
//         profile = await ProfileService().getProfile(widget.token);
//         if (mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(
//               content: Text("Profile completed successfully!"),
//               backgroundColor: Colors.green,
//               duration: Duration(seconds: 2),
//             ),
//           );
//         }
//       }
//     }
//
//     // 4️⃣ Mark loading complete
//     setState(() => loading = false);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // 1️⃣ Show loading spinner while fetching profile
//     if (loading) {
//       return const Scaffold(
//         body: Center(child: CircularProgressIndicator()),
//       );
//     }
//
//     // 2️⃣ If profile still incomplete after user refused to fill
//     if (isProfileIncomplete(profile!)) {
//       return Scaffold(
//         body: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               const Text(
//                 "Your profile is incomplete.",
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 16),
//               ElevatedButton(
//                 onPressed: () async {
//                   final updated = await Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (_) => ProfileCompletionScreen(
//                         token: widget.token,
//                         profile: profile!, UserProfile: dummyProfile,
//                       ),
//                     ),
//                   );
//                   if (updated == true) {
//                     profile = await ProfileService().getProfile(widget.token);
//                     if (mounted) {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         const SnackBar(
//                           content: Text("Profile completed successfully!"),
//                           backgroundColor: Colors.green,
//                           duration: Duration(seconds: 2),
//                         ),
//                       );
//                     }
//                     setState(() {});
//                   }
//                 },
//                 child: const Text("Complete Profile"),
//               ),
//             ],
//           ),
//         ),
//       );
//     }
//
//     // 3️⃣ Profile complete → show HomeScreen
//     return HomePage(profile: profile!, userName: 'keshav',);
//   }
// }
