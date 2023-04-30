import 'package:chatview/chatview.dart';
import 'package:example/data.dart';
import 'package:example/models/theme.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const Example());
}

class Example extends StatelessWidget {
  const Example({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Chat UI Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xffEE5366),
        colorScheme:
            ColorScheme.fromSwatch(accentColor: const Color(0xffEE5366)),
      ),
      home: const ChatScreen(),
    );
  }
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  AppTheme theme = LightTheme();
  bool isDarkTheme = false;
  final currentUser = ChatUser(
    id: '1',
    name: 'Flutter',
    profilePhoto: Data.profileImage,
  );
  final _chatController = ChatController(
    initialMessageList: Data.messageList,
    scrollController: ScrollController(),
    chatUsers: [
      ChatUser(
        id: '2',
        name: 'Simform',
        profilePhoto: Data.profileImage,
      ),
      ChatUser(
        id: '3',
        name: 'Jhon',
        profilePhoto: Data.profileImage,
      ),
      ChatUser(
        id: '4',
        name: 'Mike',
        profilePhoto: Data.profileImage,
      ),
      ChatUser(
        id: '5',
        name: 'Rich',
        profilePhoto: Data.profileImage,
      ),
    ],
  );

  void _showHideTypingIndicator() {
    _chatController.setTypingIndicator = !_chatController.showTypingIndicator;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChatView(
        isLastPage: true,
        featureActiveConfig: const FeatureActiveConfig(
          enableTextField: true,
          enableDoubleTapToLike: false,
          enableReactionPopup: false,
          enableOtherUserProfileAvatar: false,
          enablePagination: false,
          enableReplySnackBar: false,
          enableSwipeToReply: false,
        ),
        repliedMessageConfig: RepliedMessageConfiguration(
            fileIconWidget: const Icon(Icons.file_copy)),
        reactionPopupConfig: ChatConfig.reactionPopupConfig,
        showTypingIndicator: false,
        typeIndicatorConfig: ChatConfig.typeIndicatorConfiguration,
        loadingWidget: const CircularProgressIndicator(),
        appBar: ChatViewAppBar(
          backGroundColor: Colors.white,
          backArrowColor: Colors.grey,
          userStatusTextStyle: const TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 13,
            color: Colors.green,
            fontFamily: 'Satoshi',
          ),
          showLeading: true,
          chatTitleTextStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            fontFamily: 'Satoshi',
          ),
          profileWidget: GestureDetector(
              onTap: () {
                // Get.to(
                //   () => const MemberUserChatInfoScreen(),
                // );
              },
              child: const CircleAvatar()),
          chatTitle: 'Samuel',
          userStatus: "Online",
          elevation: 0.3,
          actions: const [
            // GestureDetector(
            //   onTap: () => showReportUser(),
            //   child: SvgPicture.asset(
            //     AppImages.guard,
            //     height: 16,
            //     width: 16,
            //   ),
            // ),
            SizedBox(),
          ],
        ),
        swipeToReplyConfig: const SwipeToReplyConfiguration(
          animationDuration: Duration(milliseconds: 150),
        ),
        messageConfig: MessageConfiguration(
          imageMessageConfig: ImageMessageConfiguration(
              padding: const EdgeInsets.only(bottom: 2, top: 2),
              // errorImagePlaceholder: SvgPicture.asset(
              //   AppImages.place_holder,
              //   fit: BoxFit.cover,
              // ),
              // loadingImagePlaceholder: const FadeShimmer(
              //   height: double.infinity,
              //   width: double.infinity,
              //   highlightColor: Color(0xffEDEEF3),
              //   baseColor: Color(0xffAAABB0),
              //   radius: 16,
              //   fadeTheme: FadeTheme.light,
              // ),
              // onTap: (imageUrl) {
              //   final imageProvider =
              //       Image(image: CachedNetworkImageProvider(imageUrl)).image;
              //   showImageViewer(
              //     context,
              //     imageProvider,
              //     swipeDismissible: true,
              //     doubleTapZoomable: true,
              //   );
              // },
              shareIconConfig: ShareIconConfiguration(
                defaultIconColor: Colors.white,
                defaultIconBackgroundColor: Colors.white,
              )),
          customMessageBuilder: (message) {
            // var ex = message.extras;
            // var fileName = ex['attachment_name'].toString();
            // var a = ex['attachment_size'].toString();
            // String size = Utils.formatFileSize(int.parse(a));
            return Align(
                alignment: message.sendBy == currentUser.id.toString()
                    ? Alignment.centerRight
                    : Alignment.centerLeft,
                child: GestureDetector(
                    onTap: () {
                      // openFile(url: message.message, fileName: fileName);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.only(right: 5),
                      width: MediaQuery.of(context).size.width * 0.6,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.green,
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.file_copy),
                          const SizedBox(),
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  'File name',
                                  softWrap: true,
                                  // maxLine: 1,
                                  // textColor: message.sendBy ==
                                  //                                                       .currentUserProfileController
                                  //             .userId
                                  //             .toString()
                                  //     ? Colors.white10
                                  //     : Colors.black,
                                ),
                                SizedBox(),
                                Text(
                                  '303Kb',
                                  softWrap: true,
                                  // textColor: message.sendBy ==
                                  //                                                       .currentUserProfileController
                                  //             .userId
                                  //             .toString()
                                  //     ? Colors.white10
                                  //     : Colors.black,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )));
          },
        ),
        currentUser: currentUser,
        chatController: _chatController,
        onSendTap: _onSendTap,
        chatViewState: ChatViewState.hasMessages,
        chatBubbleConfig: ChatBubbleConfiguration(
          margin: const EdgeInsets.only(bottom: 1, top: 1),
          outgoingChatBubbleConfig: ChatBubble(
            linkPreviewConfig: ChatConfig.linkPreviewConfig,
            senderNameTextStyle: const TextStyle(color: Colors.white),
            textStyle: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Colors.white,
              fontFamily: 'Satoshi',
            ),
            // Receiver's message chat bubble
            color: Colors.green,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
              bottomRight: Radius.circular(15),
              bottomLeft: Radius.circular(15),
            ),
          ),
          inComingChatBubbleConfig: ChatBubble(
            linkPreviewConfig: ChatConfig.linkPreviewConfig,
            senderNameTextStyle: const TextStyle(color: Colors.white),
            textStyle: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
              fontFamily: 'Satoshi',
            ),
            // Receiver's message chat bubble
            color: Colors.white10,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
              bottomRight: Radius.circular(15),
              bottomLeft: Radius.circular(15),
            ),
          ),
        ), //ChatConfig.chatBubbleConfig,
        sendMessageConfig: SendMessageConfiguration(
          replyTitleColor: Colors.green,
          closeIconColor: Colors.red,
          replyMessageColor: Colors.grey,
          imagePickerIconsConfig: ImagePickerIconsConfiguration(
            textStyle: const TextStyle(
              fontStyle: FontStyle.normal,
              fontSize: 16,
              fontWeight: FontWeight.w500,
              fontFamily: 'Satoshi',
            ),
            galleryImagePickerIcon: const Icon(Icons.photo),
            cameraImagePickerIcon: const Icon(Icons.camera_alt_rounded),
          ),
          allowRecordingVoice: false,
          textFieldConfig: const TextFieldConfiguration(
            contentPadding: EdgeInsets.symmetric(horizontal: 3),
            hintText: 'Type message here...',
            // hintStyle: AppTextStyle.hintStyle,
            // textStyle: AppTextStyle.regularStyle.copyWith(
            //   fontSize: 15,
            //   fontWeight: FontWeight.w500,
            // ),
          ),
          sendButtonIcon: const Icon(Icons.send),
        ),
        chatBackgroundConfig: ChatConfig.chatBackgroundConfig,
      ),
    );
  }

  void _onSendTap(
    String message,
    ReplyMessage replyMessage,
    MessageType messageType,
  ) {
    final id = int.parse(Data.messageList.last.id) + 1;
    _chatController.addMessage(
      Message(
        id: id.toString(),
        createdAt: DateTime.now(),
        message: message,
        sendBy: currentUser.id,
        replyMessage: replyMessage,
        messageType: messageType,
      ),
    );
    Future.delayed(const Duration(milliseconds: 300), () {
      _chatController.initialMessageList.last.setStatus =
          MessageStatus.undelivered;
    });
    Future.delayed(const Duration(seconds: 1), () {
      _chatController.initialMessageList.last.setStatus = MessageStatus.read;
    });
  }

  void _onThemeIconTap() {
    setState(() {
      if (isDarkTheme) {
        theme = LightTheme();
        isDarkTheme = false;
      } else {
        theme = DarkTheme();
        isDarkTheme = true;
      }
    });
  }
}

class ChatConfig {
  static TypeIndicatorConfiguration typeIndicatorConfiguration =
      const TypeIndicatorConfiguration(
    flashingCircleDarkColor: Colors.green,
    flashingCircleBrightColor: Colors.white,
    indicatorSize: 5,
    indicatorSpacing: 5,
  );
  static ReactionPopupConfiguration reactionPopupConfig =
      const ReactionPopupConfiguration(
    showGlassMorphismEffect: true,
  );
  static ChatBackgroundConfiguration chatBackgroundConfig =
      const ChatBackgroundConfiguration(
    loadingWidget: CircularProgressIndicator(),
    padding: EdgeInsets.only(bottom: 18),
    margin: EdgeInsets.zero,
    sortEnable: false,
    backgroundColor: Colors.white,
    defaultGroupSeparatorConfig: DefaultGroupSeparatorConfiguration(
      padding: EdgeInsets.only(bottom: 10, top: 10),
      textStyle: TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: 12,
        color: Colors.black54,
        fontFamily: 'Satoshi',
      ),
    ),
  );
  static LinkPreviewConfiguration linkPreviewConfig =
      const LinkPreviewConfiguration(
    loadingColor: Colors.green,
    linkStyle: TextStyle(
      color: Colors.black,
      decoration: TextDecoration.underline,
    ),
    backgroundColor: Colors.grey,
    // bodyStyle: AppTextStyle.regularStyle
    //     .copyWith(fontSize: 13, color: Colors.white),
    // titleStyle: AppTextStyle.semiBoldStyle
    //     .copyWith(fontSize: 15, color: Colors.white),
  );

  static ChatBubbleConfiguration chatBubbleConfig = ChatBubbleConfiguration(
    outgoingChatBubbleConfig: ChatBubble(
      linkPreviewConfig: ChatConfig.linkPreviewConfig,
      senderNameTextStyle: const TextStyle(color: Colors.white),
      // textStyle: AppTextStyle.regularStyle.copyWith(
      //   fontSize: 15,
      //   fontWeight: FontWeight.w600,
      //   color: Colors.white,
      // ),
      // Receiver's message chat bubble
      color: Colors.green,
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(15),
        topRight: Radius.circular(15),
        bottomRight: Radius.circular(15),
        bottomLeft: Radius.circular(15),
      ),
    ),
    inComingChatBubbleConfig: ChatBubble(
      linkPreviewConfig: ChatConfig.linkPreviewConfig,
      senderNameTextStyle: const TextStyle(color: Colors.white),
      // textStyle: AppTextStyle.regularStyle.copyWith(
      //   fontSize: 15,
      //   fontWeight: FontWeight.w600,
      //   color: Colors.tinyDarkY,
      // ),
      // Receiver's message chat bubble
      color: Colors.white,
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(15),
        topRight: Radius.circular(15),
        bottomRight: Radius.circular(15),
        bottomLeft: Radius.circular(15),
      ),
    ),
  );
}
