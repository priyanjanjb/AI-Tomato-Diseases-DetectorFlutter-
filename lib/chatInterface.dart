// ignore_for_file: file_names, avoid_print

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
      receiveTimeout: const Duration(seconds: 15),
    ),
    enableLog: true,
  );

  final ChatUser currentUser = ChatUser(
    id: '1',
    firstName: 'Test',
    lastName: 'User',
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
        title: Row(
          children: [
            const Icon(
              Icons.smart_toy,
              color: Color.fromARGB(255, 255, 255, 255),
            ), // Just the icon
            const SizedBox(width: 10), // Space between the icon and text
            Text('', style: TextStyle(color: Colors.white)), // Title of the app
          ],
        ),
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

    // Convert messages to a serializable format for the API request
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

      print("Sending request to OpenAI...");
      final response = await openAI.onChatCompletion(request: request);
      print("Received response from OpenAI: ${response.toString()}");

      if (response != null) {
        // Process and display the response messages
        for (var element in response.choices) {
          if (element.message != null && element.message!.content.isNotEmpty) {
            print("GPT Response: ${element.message!.content}");
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
            print("Received empty or null message from GPT.");
          }
        }
      } else {
        print("Received null response from GPT API.");
      }
    } catch (e) {
      // Log the error and show an error message in the chat
      print("Error in fetching response: $e");
      setState(() {
        messages.insert(
          0,
          ChatMessage(
            user: gptChatuser,
            createdAt: DateTime.now(),
            text: "Error: Unable to fetch response. Please try again.",
          ),
        );
      });
    }

    // Remove typing indicator after response is processed
    setState(() {
      typingUser.remove(gptChatuser);
    });
  }
}
