import 'package:duma_health/models/chat_option.dart';
import 'package:duma_health/screens/chat.dart';
import 'package:duma_health/widgets/dialogs_pop.dart';
import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';

class ChatInputField extends StatefulWidget {
  final TextEditingController controller;
  final Function onSend;
  final Function onChooseCamera;
  final Function onChoosePhoto;

  const ChatInputField({
    Key? key,
    required this.controller,
    required this.onSend,
    required this.onChooseCamera,
    required this.onChoosePhoto,
  }) : super(key: key);

  @override
  State<ChatInputField> createState() => _ChatInputFieldState();
}

class _ChatInputFieldState extends State<ChatInputField> {
  bool isFilling = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 10,
      ),
      color: Colors.white,
      child: SafeArea(
        child: Row(
          children: [
            IconButton(
              onPressed: () {
                _displayOptions(context);
              },
              icon: Icon(
                Icons.add,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
            Expanded(
              child: TextFormField(
                focusNode: ChatPageState.focusNode,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                onChanged: (text) {
                  setState(() {
                    isFilling = text.isNotEmpty ? true : false;
                  });
                },
                controller: widget.controller,
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
            isFilling
                ? IconButton(
                    onPressed: () => widget.onSend(),
                    icon: CircleAvatar(
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                      child: const Icon(
                        Ionicons.send_sharp,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  )
                : Row(
                    children: [
                      IconButton(
                        onPressed: () => widget.onChooseCamera(),
                        icon: Icon(
                          Ionicons.camera_outline,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                      IconButton(
                        onPressed: () => widget.onChoosePhoto(),
                        icon: Icon(
                          Ionicons.image_outline,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }

  void _displayOptions(
    BuildContext context,
  ) {
    showModalBottomSheet(
        context: context,
        useSafeArea: true,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: ChatOption.lists.map((option) {
                      return Column(
                        children: [
                          ListTile(
                            title: Text(option.title),
                            leading: Icon(
                              option.iconData,
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                            onTap: () {
                              if (!option.isAvailable) {
                                DialogPop.information(
                                  context,
                                  title: option.title,
                                  message: 'Coming Soon',
                                );
                              }else{
                                if(option.id == 1){
                                  widget.onChooseCamera();
                                }else if(option.id == 2){
                                  widget.onChoosePhoto();
                                }
                                Navigator.pop(context);
                              }
                            },
                          ),
                          const Divider(),
                        ],
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Cancel".toUpperCase()),
                  ),
                ),
              ],
            ),
          );
        });
  }
}
