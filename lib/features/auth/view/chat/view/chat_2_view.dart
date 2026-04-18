// import 'package:chat_bubbles/chat_bubbles.dart';
// import 'package:dermalyze/core/constants/app_colors.dart';
// import 'package:flutter/material.dart';
//
// import '../../../../../core/constants/app_assets.dart';
// import '../model/message_model.dart';
// import 'const.dart';
//
// class Chat2View extends StatefulWidget {
//   const Chat2View({super.key});
//
//   @override
//   State<Chat2View> createState() => _Chat2ViewState();
// }
//
// class _Chat2ViewState extends State<Chat2View> {
//   TextEditingController text = TextEditingController();
//   String MyName = 'chat2';
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: AppColors.SkyBlue,
//         elevation: 0,
//         title: Text("Chat"),
//         centerTitle: true,
//       ),
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: AppColors.primaryGradient1,
//         ),
//         child: Column(
//           children: [
//             Expanded(
//               child: ListView.builder(
//                 itemCount: Chat.length,
//                 itemBuilder: (_, index) => BubbleSpecialThree(
//                   isSender: Chat[index].sender_name == MyName
//                       ? true
//                       : false,
//                   text: Chat[index].text.toString(),
//                   color: Chat[index].sender_name == MyName
//                       ? Colors.blue
//                       : Colors.grey,
//                   tail: true,
//                   textStyle: TextStyle(
//                     color: Theme.of(context).cardColor,
//                     fontSize: 16,
//                   ),
//                 ),
//               ),
//             ),
//             Container(
//               padding: EdgeInsets.all(15),
//               color: AppColors.SkyBlue,
//               height: 90,
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: TextField(
//                       controller: text,
//
//                       style: TextStyle(color: Colors.white),
//                     ),
//                   ),
//                   IconButton(
//                     onPressed: () {
//                       setState(() {
//                         Chat.add(message_model(text.text, MyName));
//                         text.clear();
//                       });
//                     },
//                     icon: ImageIcon(AssetImage(AppAssets.send_icon)),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
