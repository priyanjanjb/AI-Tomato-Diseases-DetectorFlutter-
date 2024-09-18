// ignore: file_names
import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:tmtdiseases/const.dart';

class Chatinterface extends StatefulWidget {
  const Chatinterface({super.key});

  @override
  State<Chatinterface> createState() => _ChatinterfaceState();
}

class _ChatinterfaceState extends State<Chatinterface> {
  final openAI = OpenAI.instance.build(
    token: OPENAI_KEY,
    baseOption: HttpSetup(
      receiveTimeout: const Duration(seconds: 5), // actual request timeout
    ),
    enableLog: true,
  );

  final ChatUser currentUser = ChatUser(
    id: '1',
    firstName: 'John',
    lastName: 'Wick',
  );
  final ChatUser gptChatuser = ChatUser(
    id: '2',
    firstName: 'GPT',
    lastName: 'Bot',
  );

  List<ChatMessage> messages = <ChatMessage>[];
  List<ChatUser> typingUser = <ChatUser>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
            child: Text(
          'Chat Interface',
          style: TextStyle(fontSize: 20, color: Colors.white),
        )),
        backgroundColor: const Color.fromRGBO(12, 128, 77, 0.8),
      ),
      body: DashChat(
        messageOptions: const MessageOptions(
          currentUserContainerColor: Color.fromRGBO(12, 128, 77, 0.8),
          containerColor: Color.fromRGBO(211, 214, 213, 0.8),
        ),
        currentUser: currentUser,
        typingUsers: typingUser,
        onSend: (ChatMessage msg) {
          getChatResponse(msg);
        },
        messages: messages,
      ),
    );
  }

  Future<void> getChatResponse(ChatMessage msg) async {
    setState(() {
      messages.insert(0, msg);
      typingUser.add(gptChatuser); // Show typing indicator
    });

    // Convert messages to a serializable format
    List<Map<String, dynamic>> messagesHistory = messages.reversed.map((msg) {
      return {
        'role': msg.user == currentUser ? 'user' : 'assistant',
        'content': msg.text,
      };
    }).toList();

    try {
      final request = ChatCompleteText(
        model: GptTurbo0301ChatModel(),
        messages: messagesHistory,
        maxToken: 200,
      );

      final response = await openAI.onChatCompletion(request: request);

      if (response != null) {
        // Check if the response is received properly
        for (var element in response.choices) {
          if (element.message != null) {
            setState(() {
              messages.insert(
                0,
                ChatMessage(
                    user: gptChatuser,
                    createdAt: DateTime.now(),
                    text: element.message!.content),
              );
            });
          } else {
            debugPrint("Received a null message from GPT response.");
          }
        }
      } else {
        debugPrint("Received null response from GPT API.");
      }
    } catch (e) {
      // If there is an error, log it
      debugPrint("Error in fetching response: $e");
    }

    setState(() {
      typingUser.remove(gptChatuser); // Remove typing indicator
    });
  }
}
