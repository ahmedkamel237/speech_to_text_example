import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';

class SpeechToTextExample extends StatefulWidget {
  const SpeechToTextExample({super.key});

  @override
  State<SpeechToTextExample> createState() => _SpeechToTextExampleState();
}

class _SpeechToTextExampleState extends State<SpeechToTextExample> {
  late SpeechToText speechToText;
  bool isListening = false;
  String recognizedText = "";

  @override
  void initState() {
    initSpeechToText();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Speech To Text Example"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                      ),
                      child: Text(
                        recognizedText,
                        style: TextStyle(
                          color: isListening ? Colors.red : Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                      onTap: () {
                        setState(() {
                          recognizedText = "";
                        });
                      },
                      child: const Icon(Icons.delete))
                ],
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Text(isListening ? "Listening" : "Not Listening"),
            const SizedBox(
              height: 30,
            ),
            ElevatedButton(
              onPressed: startListening,
              child: Text(
                isListening ? "Stop" : "Start",
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> initSpeechToText() async {
    speechToText = SpeechToText();
    bool available = await speechToText.initialize(
      onStatus: (status) => print("onStatus: $status"),
      onError: (errorNotification) => print("onError: $errorNotification"),
    );
    if (available) {
      setState(() {
        isListening = false;
      });
    }
  }

  Future<void> startListening() async {
    if (!isListening) {
      bool available = await speechToText.initialize(
        onStatus: (status) => print("onStatus: $status"),
        onError: (errorNotification) => print("onError: $errorNotification"),
      );
      if (available) {
        setState(() {
          isListening = true;
        });
        speechToText.listen(
          onResult: (result) => setState(() {
            recognizedText = result.recognizedWords;
          }),
        );
      }
    } else {
      setState(() {
        isListening = false;
      });
      speechToText.stop();
    }
    // speechToText.listen(
    //   onResult: (result) => setState(() {
    //     recognizedText = result.recognizedWords;
    //   }),
    // );
    // setState(() {
    //   isListening = true;
    // });
  }

  Future<void> stopListening() async {
    if (isListening) {
      setState(() {
        isListening = false;
      });
      speechToText.stop();
    }
  }
}
