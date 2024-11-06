// ignore_for_file: file_names, avoid_print

import 'dart:async';
import 'dart:io';

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
  late final OpenAI openAI;

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
  void initState() {
    super.initState();
    // Initialize OpenAI instance with proper configuration
    openAI = OpenAI.instance.build(
      token: OPENAI_KEY,
      baseOption: HttpSetup(
        receiveTimeout: const Duration(seconds: 30), // Increased timeout
        connectTimeout: const Duration(seconds: 10),
      ),
      enableLog: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(
              Icons.smart_toy,
              color: Colors.white,
            ),
            const SizedBox(width: 10),
            const Text('Chat with GPT', style: TextStyle(color: Colors.white)),
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

    // Create a message history with a maximum of 10 entries
    final List<Map<String, dynamic>> messagesHistory = messages.reversed
        .take(10)
        .map((msg) => {
              'role': msg.user == currentUser ? 'user' : 'assistant',
              'content': msg.text,
            })
        .toList();

    int retryCount = 0;
    const int maxRetries = 3;

    while (retryCount < maxRetries) {
      try {
        final request = ChatCompleteText(
          model: GptTurbo0631Model(), // Ensure the correct model is used
          messages: messagesHistory,
          maxToken: 200,
        );

        print("Sending request to OpenAI...");
        final response = await openAI.onChatCompletion(request: request);

        if (response != null && response.choices.isNotEmpty) {
          final String? gptResponse = response.choices.first.message?.content;
          if (gptResponse != null && gptResponse.isNotEmpty) {
            print("GPT Response: $gptResponse");
            setState(() {
              messages.insert(
                0,
                ChatMessage(
                  user: gptChatuser,
                  createdAt: DateTime.now(),
                  text: gptResponse,
                ),
              );
            });
            return; // Exit loop after successful response
          } else {
            print("Received empty or null message from GPT.");
            _handleEmptyResponse();
            return;
          }
        } else {
          print("Received null or empty response from GPT API.");
          _handleEmptyResponse();
          return;
        }
      } catch (e) {
        if (e is HttpException && e.message.contains('429')) {
          print("Rate limit exceeded. Retrying...");
          retryCount++;
          await Future.delayed(
              Duration(seconds: 2 * retryCount)); // Exponential backoff
        } else {
          print("Error in fetching response: $e");
          _handleException(e);
          break; // Exit after non-rate-limit error
        }
      }
    }

    // If max retries are reached
    if (retryCount == maxRetries) {
      _handleException("Max retries reached. Please try again later.");
    } else {
      setState(() {
        typingUser.remove(gptChatuser); // Ensure typing indicator is removed
      });
    }
  }

  void _handleEmptyResponse() {
    setState(() {
      messages.insert(
        0,
        ChatMessage(
          user: gptChatuser,
          createdAt: DateTime.now(),
          text: "I didn't receive a proper response. Please try again.",
        ),
      );
    });
  }

  void _handleException(Object e) {
    String errorMessage = "An error occurred. Please try again.";
    if (e is HttpException) {
      errorMessage = "HTTP Error: ${e.message}";
      if (e.message.contains('404')) {
        errorMessage =
            "Error 404: Resource not found. Please check the API endpoint and configuration.";
      }
    } else if (e is TimeoutException) {
      errorMessage = "Timeout Error: Please check your connection.";
    } else if (e is SocketException) {
      errorMessage = "Network Error: Please check your internet connection.";
    } else {
      errorMessage = "General Error: ${e.toString()}";
    }
    setState(() {
      messages.insert(
        0,
        ChatMessage(
          user: gptChatuser,
          createdAt: DateTime.now(),
          text: errorMessage,
        ),
      );
    });
  }
}
