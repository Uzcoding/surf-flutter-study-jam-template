import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
// import 'package:location/location.dart';
import 'package:surf_practice_chat_flutter/data/chat/chat.dart';

import '../data/chat/repository/firebase.dart';

class ChatViewModel extends ChangeNotifier {
  static final chatRepository =
      ChatRepositoryFirebase(FirebaseFirestore.instance);

  bool isFetchingMessages = false;
  bool isSendingMessage = false;
  String? _errorMessage;
  final _nicknameController = TextEditingController();
  final _messageController = TextEditingController();
  List<ChatMessageDto> _messages = [];

  // final Location _location = Location();
  String _localName = '';

  List<ChatMessageDto> get messages => _messages;
  String? get errorMessage => _errorMessage;
  String get localName => _localName;
  TextEditingController get nicknameController => _nicknameController;
  TextEditingController get messageController => _messageController;

  ChatViewModel() {
    getMessages();
  }

  void getMessages() async {
    isFetchingMessages = true;
    _errorMessage = null;
    notifyListeners();
    try {
      _messages = await chatRepository.messages;
    } catch (e) {
      _errorMessage = 'Произошла ошибка';
    } finally {
      isFetchingMessages = false;
      notifyListeners();
    }
  }

  void sendMessage(BuildContext context) async {
    isSendingMessage = true;
    notifyListeners();
    try {
      final nickname = _nicknameController.text.trim();
      final message = _messageController.text.trim();
      _localName = nickname;
      _messages = await chatRepository.sendMessage(nickname, message);
    } on InvalidNameException catch (e) {
      final snackBar = SnackBar(
        backgroundColor: Colors.red,
        content: Text(
          e.message,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } on InvalidMessageException catch (e) {
      final snackBar = SnackBar(
        backgroundColor: Colors.red,
        content: Text(
          e.message,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } catch (e) {
      _errorMessage = 'Произошла ошибка';
    } finally {
      isSendingMessage = false;
      _messageController.clear();
      notifyListeners();
    }
  }

  // void sendGeoLocation(BuildContext context) async {
  //   try {
  //     final location = await _getLocation();
  //     if (location == null) throw 'Need location when in use';
  //     final nickname = _nicknameController.text.trim();
  //     final message = _messageController.text.trim();
  //     _messages = await chatRepository.sendGeolocationMessage(
  //       nickname: nickname,
  //       message: message,
  //       location: ChatGeolocationDto(
  //         latitude: location.latitude!,
  //         longitude: location.longitude!,
  //       ),
  //     );
  //   } on Exception catch (_, e) {
  //     final snackBar = SnackBar(
  //       backgroundColor: Colors.red,
  //       content: Text(
  //         e.toString(),
  //         style: const TextStyle(
  //           color: Colors.white,
  //         ),
  //       ),
  //     );
  //     ScaffoldMessenger.of(context).showSnackBar(snackBar);
  //   } finally {
  //     notifyListeners();
  //   }
  // }

  // Future<LocationData?> _getLocation() async {
  //   bool _serviceEnabled;
  //   PermissionStatus _permissionGranted;
  //   LocationData _locationData;

  //   _serviceEnabled = await _location.serviceEnabled();
  //   if (!_serviceEnabled) {
  //     _serviceEnabled = await _location.requestService();
  //     if (!_serviceEnabled) {
  //       return null;
  //     }
  //   }

  //   _permissionGranted = await _location.hasPermission();
  //   if (_permissionGranted == PermissionStatus.denied) {
  //     _permissionGranted = await _location.requestPermission();
  //     if (_permissionGranted != PermissionStatus.granted) {
  //       return null;
  //     }
  //   }

  //   _locationData = await _location.getLocation();
  //   return _locationData;
  // }
}
