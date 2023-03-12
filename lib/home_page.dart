import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:chat_gpt/dio_helper.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> list = [
  ];
  TextEditingController textEditingController = TextEditingController();
  ScrollController scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ChatGPT"),
        centerTitle: true,
        backgroundColor: const Color(0xff343541),
      ),
      backgroundColor: const Color(0xff343541),
      body: SafeArea(
        child: Center(
            child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                          color: index % 2 == 0
                              ? Colors.transparent
                              : const Color(0xff434654),
                          padding: const EdgeInsets.all(10),
                          child: (ListTile(
                            leading: CircleAvatar(
                              child: Icon(index % 2 == 0
                                  ? Icons.account_circle
                                  : Icons.ac_unit),
                            ),
                            title: index % 2 == 0?Text(list[index]):AnimatedTextKit(
                              animatedTexts: [
                              TypewriterAnimatedText(
                                    list[index],
                                speed: const Duration(milliseconds: 40),
                                  ),
                              ],
                              totalRepeatCount: 1,
                            )
                          ))),
                    );
                  }),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: const Color(0xff343740),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.grey, //(x,y)
                        blurRadius: 0.1,
                      ),
                    ]),
                padding: const EdgeInsets.all(9),
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: textEditingController,
                        decoration: const InputDecoration.collapsed(
                            hintText: "Ask What You Want...."),
                      ),
                    ),
                    TextButton(
                      onPressed: () {

                        if (!textEditingController.text.isEmpty) {
                          setState(() {
                            list.add(textEditingController.text);
                          });
                        }
                        getResponse();
                      },
                      child: const Icon(
                        Icons.send,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        )),
      ),
    );
  }

  getResponse() {
    if (!textEditingController.text.isEmpty) {
      //textEditingController.clear();
      DioHelper.postData(url: "completions", data: {
        "model": "gpt-3.5-turbo",
        "messages": [{"role": "user", "content": "${textEditingController.text}"}]
         ,
        // "temperature": 0,
        // "max_tokens": 500
      }).then((value) {
        print(textEditingController.text);
        if (value.statusCode == 200) {

          setState(() {
            list.add(value.data["choices"][0]["message"]["content"]);
          });

        } else {
          print(value);
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("${value.statusMessage.toString()}")));
        }
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Type Your Massage First")));
    }
    textEditingController.clear();
  }
}
