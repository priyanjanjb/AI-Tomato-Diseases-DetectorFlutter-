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
  // OpenAI instance with API key and settings
  final _openAI = OpenAI.instance.build(
    token: OPENAI_API_KEY,
    baseOption: HttpSetup(
      receiveTimeout: const Duration(seconds: 5),
    ),
    enableLog: true,
  );

  // Define chat users
  final ChatUser _user = ChatUser(
    id: '1',
    firstName: 'User',
  );

  final ChatUser _gptChatUser = ChatUser(
    id: '2',
    firstName: 'Plant',
    lastName: 'Assistant',
  );

  // Message and typing state management
  final List<ChatMessage> _messages = <ChatMessage>[];
  final List<ChatUser> _typingUsers = <ChatUser>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(12, 128, 77, 0.4),
        title: const Text(
          'Plant Guard Assistant',
          style: TextStyle(
            color: Color.fromARGB(255, 0, 0, 0),
          ),
        ),
      ),
      body: DashChat(
        currentUser: _user,
        messageOptions: const MessageOptions(
          currentUserContainerColor: Color.fromRGBO(36, 131, 90, 0.4),
          containerColor: Color.fromRGBO(202, 202, 202, 1),
          textColor: Color.fromARGB(255, 22, 22, 22),
        ),
        onSend: (ChatMessage m) {
          getChatResponse(m);
        },
        messages: _messages,
        typingUsers: _typingUsers,
      ),
    );
  }

  Future<void> getChatResponse(ChatMessage m) async {
    // Add the user's message and show bot typing indicator
    setState(() {
      _messages.insert(0, m);
      _typingUsers.add(_gptChatUser);
    });

    // Prepare message history for the API request
    List<Map<String, dynamic>> messagesHistory =
        _messages.reversed.toList().map((msg) {
      if (msg.user == _user) {
        return Messages(role: Role.user, content: msg.text).toJson();
      } else {
        return Messages(role: Role.assistant, content: msg.text).toJson();
      }
    }).toList();

    // Make the API request to OpenAI
    final request = ChatCompleteText(
      messages: messagesHistory,
      maxToken: 200,
      model: Gpt4oMini2024ChatModel(),
    );

    try {
      final response = await _openAI.onChatCompletion(request: request);

      for (var choice in response!.choices) {
        if (choice.message != null) {
          // Remove '**' and '#' using regex
          String cleanedText = choice.message!.content.replaceAll(
            RegExp(r'[\*#]+'),
            '',
          );

          setState(() {
            _messages.insert(
              0,
              ChatMessage(
                user: _gptChatUser,
                createdAt: DateTime.now(),
                text: cleanedText,
              ),
            );
          });
        }
      }
    } catch (e) {
      print("Error: $e");
    }

    // Remove the typing indicator
    setState(() {
      _typingUsers.remove(_gptChatUser);
    });
  }
}
