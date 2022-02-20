import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:surf_practice_chat_flutter/screens/chat_view_model.dart';

import '../data/chat/models/message.dart';

/// Chat screen templete. This is your starting point.
class ChatScreen extends StatelessWidget {
  const ChatScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _wm = context.watch<ChatViewModel>();
    final _read = context.read<ChatViewModel>();
    final errorMessage = _wm.errorMessage ?? '';
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _wm.nicknameController,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18.0,
          ),
          decoration: const InputDecoration(
            border: InputBorder.none,
            hintText: 'Введите ник',
            hintStyle: TextStyle(
              color: Colors.white54,
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15.0),
            child: IconButton(
              onPressed: _read.getMessages,
              splashRadius: 25.0,
              icon: const Icon(Icons.refresh),
            ),
          ),
        ],
      ),
      body: _wm.isFetchingMessages
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : !_wm.isFetchingMessages && errorMessage.isNotEmpty
              ? Center(
                  child: Text(errorMessage),
                )
              : ListView.builder(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).size.height * .11),
                  itemCount: _wm.messages.length,
                  itemBuilder: (context, index) {
                    final message = _wm.messages[index];
                    return ChatItemWidget(message: message);
                  },
                ),
      bottomSheet: const _ChatBottomWidget(),
    );
  }
}

class _ChatBottomWidget extends StatelessWidget {
  const _ChatBottomWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _read = context.read<ChatViewModel>();
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            blurRadius: 24.0,
            color: Colors.grey.shade300,
          )
        ],
      ),
      height: MediaQuery.of(context).size.height * .11,
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // не успел(
          // IconButton(
          //   splashRadius: 25.0,
          //   padding: EdgeInsets.zero,
          //   color: Theme.of(context).primaryColor,
          //   onPressed: () => _read.sendGeoLocation(context),
          //   icon: const Icon(Icons.share_location_outlined),
          // ),
          Expanded(
            child: TextField(
              controller: _read.messageController,
              decoration: const InputDecoration(hintText: 'Сообщение'),
            ),
          ),
          const SizedBox(width: 10.0),
          IconButton(
            splashRadius: 25.0,
            padding: EdgeInsets.zero,
            onPressed: () => _read.sendMessage(context),
            icon: _read.isSendingMessage
                ? const SizedBox(
                    width: 30.0,
                    height: 30.0,
                    child: CircularProgressIndicator(),
                  )
                : const Icon(Icons.send),
          ),
        ],
      ),
    );
  }
}

class ChatItemWidget extends StatelessWidget {
  const ChatItemWidget({
    Key? key,
    required this.message,
  }) : super(key: key);

  final ChatMessageDto message;

  @override
  Widget build(BuildContext context) {
    final _read = context.read<ChatViewModel>();
    final authorNameFirstLetter = message.author.name[0];
    final isAuthor = _read.localName == message.author.name;
    return ListTile(
      tileColor: isAuthor
          ? Theme.of(context).primaryColor.withOpacity(.3)
          : Colors.white,
      leading: _CircleAvatarWithName(authorNameFirstLetter),
      title: Text(
        message.author.name,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        message.message,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 15.0,
        ),
      ),
    );
  }
}

class _CircleAvatarWithName extends StatelessWidget {
  const _CircleAvatarWithName(
    this.authorName, {
    Key? key,
  }) : super(key: key);

  final String authorName;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50.0,
      height: 50.0,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        shape: BoxShape.circle,
      ),
      child: Text(
        authorName,
        style: const TextStyle(
          fontSize: 25.0,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
