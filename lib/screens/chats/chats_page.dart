import 'package:flutter/material.dart';
import '../../data/app_data.dart';
import 'chat_detail_page.dart';

class ChatsPage extends StatelessWidget {
  const ChatsPage({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xff0B0F1A),

      body: SafeArea(
        child: Column(
          children: [

            /// 🔥 HEADER
            const Padding(
              padding: EdgeInsets.all(20),
              child: Row(
                children: [
                  Text(
                    "Mensajes",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            /// 🔥 LISTA
            Expanded(
              child: ListView.separated(
                itemCount: AppData.chats.length,
                separatorBuilder: (_, __) =>
                    const Divider(color: Colors.white12),

                itemBuilder: (context, index) {

                  final chat = AppData.chats[index];

                  return ListTile(

                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ChatDetailPage(
                            name: chat["name"],
                            image: chat["image"],
                          ),
                        ),
                      );
                    },

                    leading: Stack(
                      children: [

                        CircleAvatar(
                          radius: 28,
                          backgroundImage:
                              NetworkImage(chat["image"]),
                        ),

                        /// 🔥 ONLINE DOT
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: Colors.green,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.black,
                                width: 2,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),

                    title: Row(
                      children: [
                        Text(
                          chat["name"],
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 5),

                        /// 🔥 VERIFICADO
                        const Icon(Icons.verified,
                            color: Colors.blue, size: 16),
                      ],
                    ),

                    subtitle: Text(
                      chat["lastMessage"] ?? "",
                      style: const TextStyle(color: Colors.white70),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}