import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:voiceassist/feature_box.dart';
import 'package:voiceassist/openai_service.dart';
import 'package:voiceassist/palette.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final flutterTts = FlutterTts();
  final speechToText = SpeechToText();
  String lastWords = "";
  final OpenAIService openAIService = OpenAIService();
  String? generatedcontent;
  String? generatedImageUrl;
  int start = 200;
  int delay = 200;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initSpeechToText();
    initTextToSpeech();
  }

  Future<void> initTextToSpeech() async {
    await flutterTts.setSharedInstance(true);
    setState(() {});
  }

  Future<void> initSpeechToText() async {
    await speechToText.initialize();
    setState(() {});
  }

  Future<void> startListening() async {
    await speechToText.listen(onResult: onSpeechResult);
    setState(() {});
  }

  Future<void> stopListening() async {
    await speechToText.stop();
    setState(() {});
  }

  Future<void> onSpeechResult(SpeechRecognitionResult result) async {
    setState(() {
      lastWords = result.recognizedWords;
    });
  }
  
  Future <void> systemSpeak (String content) async {
    await flutterTts.speak(content);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    speechToText.stop();
    flutterTts.stop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: BounceInDown(child: const Text("Jarvis")),
        leading: const Icon(Icons.menu),
      ),
      body: SingleChildScrollView(

        child: Column(
          children: [
            ZoomIn(
              child: Stack(
                children: [
                  Center(
                    child: Container(
                      height: 120,
                        width: 120,
                        margin: const EdgeInsets.only(top: 4),
                      decoration: const BoxDecoration(
                        color: Pallete.assistantCircleColor,
                        shape: BoxShape.circle
                      ),
                    ),
                  ),
                  Container(
                    height: 123,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: AssetImage("assets/images/virtualAssistant.png")
                      )
                    ),
                  )
                ],
              ),
            ),
            FadeInRight(
              child: Visibility(
                visible: generatedImageUrl == null,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  margin: const EdgeInsets.symmetric(horizontal: 40).copyWith(
                    top: 30,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: Pallete.borderColor),
                    borderRadius: BorderRadius.circular(20).copyWith(
                      topLeft: Radius.zero,
                    )
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Text(
                      generatedcontent == null ?
                      "Good Morning, What task can I do for you?": generatedcontent!, style: TextStyle(
                      color: Pallete.mainFontColor,
                      fontSize: generatedcontent == null ? 25 : 18,
                      fontFamily: "Cera pro",
                    ),),
                  ),
                ),
              ),
            ),
            if(generatedImageUrl != null) Padding(
              padding: const EdgeInsets.all(10).copyWith(top: 30),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                  child: Image.network(generatedImageUrl!)),
            ),
            SlideInLeft(
              child: Visibility(
                visible: generatedcontent == null && generatedImageUrl == null,
                child: Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.only(
                    top: 10,
                    left: 22,
                  ),
                  child: const Text("Here are a few features", style: TextStyle(
                    fontFamily: "Cera pro",
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Pallete.mainFontColor,
                  ),),
                ),
              ),
            ),
            Visibility(
              visible: generatedcontent == null && generatedImageUrl == null,
              child: Column(
                children: [
                  SlideInLeft(
                    delay: Duration(milliseconds: start),
                    child: const FeatureBox(color: Pallete.firstSuggestionBoxColor, headerText: "ChatGPT",discip: ""
                        "A smarter way to stay organized and informed with ChatGPT",),
                  ),
                  SlideInLeft(
                    delay: Duration(milliseconds: start + delay),
                    child: const FeatureBox(color: Pallete.secondSuggestionBoxColor, headerText: "Dall-E",discip: ""
                        "Get inspired and stay creative with your personal assistant powered by Dall-E",),
                  ),
                  SlideInLeft(
                    delay: Duration(milliseconds: start + 2 * delay),
                    child: const FeatureBox(color: Pallete.thirdSuggestionBoxColor, headerText: "Smart Voice Assistant",discip: ""
                        "Get the best of both worlds with a voice assistant powered by Dall-E and ChatGPT",),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: ZoomIn(
        delay:  Duration(milliseconds: start + 3 * delay),
        child: FloatingActionButton(
          backgroundColor: Pallete.firstSuggestionBoxColor,
          onPressed: () async {
            if(await speechToText.hasPermission && speechToText.isNotListening ){
              await startListening();
            }else if( speechToText.isListening ){
              final speech = await openAIService.isArtPromptAPI(lastWords);
              if(speech.contains("https")){
                generatedImageUrl = speech;
                generatedcontent = null;
                setState(() {});
              }else{
                generatedcontent = speech;
                generatedImageUrl = null;
                setState(() {});
                await systemSpeak(speech);
              }
              await stopListening();
            }else{
              initSpeechToText();
            }

          },
          child: Icon(speechToText.isListening ? Icons.stop : Icons.mic),
        ),
      ),
    );
  }
}