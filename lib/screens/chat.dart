import 'dart:convert';
import 'dart:io';

import 'package:duma_health/models/chat_message.dart';
import 'package:duma_health/models/user.dart';
import 'package:duma_health/services/api.dart';
import 'package:duma_health/services/provider.dart';
import 'package:duma_health/utils/constants.dart';
import 'package:duma_health/utils/preferences.dart';
import 'package:duma_health/widgets/chat_card.dart';
import 'package:duma_health/widgets/chat_input.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  State<ChatPage> createState() => ChatPageState();
}

class ChatPageState extends State<ChatPage> {
  TextEditingController _sendController = TextEditingController();

  var userData = PreferenceUtils.getPreference(Constants.userData, null);
  User? user;
  TimeOfDay timeOfDay = TimeOfDay.now();
  static FocusNode focusNode = FocusNode();

  File? image;
  String? base64Image;

  final ImagePicker _picker = ImagePicker();
  XFile? _imageFile;
  dynamic _pickImageError;
  String? _retrieveDataError;

  Text? _getRetrieveErrorWidget() {
    if (_retrieveDataError != null) {
      final Text result = Text(_retrieveDataError!);
      _retrieveDataError = null;
      return result;
    }
    return null;
  }

  @override
  void initState() {
    focusNode.requestFocus();
    if (userData != null) {
      user = User.fromMap(jsonDecode(userData));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            ClipOval(
              child: Image.asset(
                'assets/logo.png',
                fit: BoxFit.cover,
                width: 40,
                height: 40,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Duma Health",
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  ),
                  Row(
                    children: const [
                      Icon(
                        Icons.circle,
                        color: Colors.green,
                        size: 12,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        "Online",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  focusNode.unfocus();
                });
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Consumer<ChatProvider>(builder: (context, provider, _) {
                  return ListView.builder(
                    itemCount: provider.chats.length,
                    shrinkWrap: true,
                    primary: true,
                    itemBuilder: (context, index) => ChatCardMessage(
                      message: provider.chats[index],
                    ),
                  );
                }),
              ),
            ),
          ),
          _bottomView(),
        ],
      ),
    );
  }

  Widget _bottomView() {
    if (_imageFile != null) {
      return Container(
        color: Colors.white,
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(
              onPressed: () {
                setState(() {
                  _imageFile = null;
                });
              },
              icon: Icon(
                Icons.close,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.3,
                color: Colors.black45,
                child: _previewImage(MediaQuery.of(context).size),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                vertical: 10,
              ),
              color: Colors.white,
              child: SafeArea(
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        controller: _sendController,
                        decoration: InputDecoration(
                          fillColor: Colors.grey.withOpacity(0.1),
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 5,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: const BorderSide(color: Colors.grey),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    IconButton(
                      onPressed: () {
                        _validateSend();
                      },
                      icon: CircleAvatar(
                        backgroundColor:
                            Theme.of(context).colorScheme.secondary,
                        child: const Icon(
                          Ionicons.send_sharp,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      return ChatInputField(
        controller: _sendController,
        onSend: () {
          _validateSend();
        },
        onChooseCamera: () {
          _chooseImage(ImageSource.camera, context: context);
        },
        onChoosePhoto: () {
          _chooseImage(ImageSource.gallery, context: context);
        },
      );
    }
  }

  _chooseImage(ImageSource source, {BuildContext? context}) async {
    try {
      final pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: MediaQuery.of(context!).size.width,
        maxHeight: 150,
      );
      setState(() {
        _imageFile = pickedFile;
        base64Image = base64Encode(File(_imageFile!.path).readAsBytesSync());
      });
    } catch (e) {
      setState(() {
        _pickImageError = e;
      });
    }
  }

  Widget _previewImage(Size size) {
    final Text? retrieveError = _getRetrieveErrorWidget();
    if (retrieveError != null) {
      return retrieveError;
    }
    if (_imageFile != null) {
      return kIsWeb
          ? Image.network(_imageFile!.path)
          : Image.file(
              File(_imageFile!.path),
              fit: BoxFit.fill,
              width: size.width,
              height: size.height,
            );
    } else if (_pickImageError != null) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.file_open_outlined,
            color: Colors.white,
            size: size.height * 0.1,
          ),
          const SizedBox(
            height: 10.0,
          ),
          Expanded(child: Text("Error: $_pickImageError")),
        ],
      );
    } else {
      return Icon(
        Icons.file_open_outlined,
        color: Colors.white,
        size: size.height * 0.1,
      );
    }
  }

  void _validateSend() {
    _onSendData(_sendController.text, _imageFile);
    setState(() {
      _imageFile = null;
      _sendController = TextEditingController(text: "");
      focusNode.unfocus();
    });
  }

  void _onSendData(String message, XFile? imagePreview) async {
    ChatMessage newMessage = ChatMessage(
        text: message.isNotEmpty ? message : null,
        date: TimeOfDay.now().format(context).toString(),
        id: "10000",
        messageStatus: MessageStatus.notView,
        isSender: true,
        previewImageFile: imagePreview);
    Provider.of<ChatProvider>(context, listen: false).addChat(newMessage);
    var data = {
      "sender": "${user?.id}",
      "receiver": "11",
      "chat": message.isNotEmpty ? message : null,
      "image": base64Image,
    };
    ChatMessage errorMessage = ChatMessage(
        text: message.isNotEmpty ? message : null,
        date: TimeOfDay.now().format(context).toString(),
        id: "10000",
        messageStatus: MessageStatus.notSent,
        isSender: true);
    Api.sendChat(errorMessage, data).then((value) {
      Provider.of<ChatProvider>(context, listen: false).deleteChat(newMessage);
      Provider.of<ChatProvider>(context, listen: false).addChat(value);
    });
  }
}
