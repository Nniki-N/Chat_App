import 'package:camera/camera.dart';
import 'package:chat_app/domain/cubits/camera_cubit.dart';
import 'package:chat_app/domain/cubits/chats_cubit.dart';
import 'package:chat_app/domain/cubits/theme_cubit.dart';
import 'package:chat_app/domain/entity/chat_model.dart';
import 'package:chat_app/resources/resources.dart';
import 'package:chat_app/ui/navigation/main_navigation.dart';
import 'package:chat_app/ui/widgets/loading_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CameraPage extends StatelessWidget {
  const CameraPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cameraCubit = context.watch<CameraCubit>();
    final initializeControllerFuture = cameraCubit.initializeControllerFuture;
    final cameraController = cameraCubit.cameraController;
    final pictureIsTaken = cameraCubit.pictureIsTaken;

    return Scaffold(
      body: FutureBuilder<void>(
          future: initializeControllerFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Stack(
                children: [
                  SizedBox(
                    height: double.infinity,
                    child: CameraPreview(cameraController),
                  ),
                  const CloseCameraButton(),
                  const CameraPageFooter(),
                  Positioned(
                    top: 0,
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: !pictureIsTaken
                        ? const SizedBox()
                        : const ChatsToSendlist(),
                  ),
                ],
              );
            } else {
              return const LoadingPage();
            }
          }),
    );
  }
}

class CloseCameraButton extends StatelessWidget {
  const CloseCameraButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeColorsCubit = context.watch<ThemeCubit>();
    final themeColors = themeColorsCubit.themeColors;

    return Positioned(
      top: 50.h,
      right: 17.w,
      child: SizedBox(
        height: 20.w,
        width: 20.w,
        child: IconButton(
          onPressed: () {
            Navigator.of(context)
                .popAndPushNamed(MainNavigationRouteNames.mainScreen);
          },
          icon: SvgPicture.asset(
            Svgs.cross,
            color: themeColors.mainColor,
          ),
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          padding: const EdgeInsets.all(0),
        ),
      ),
    );
  }
}

class CameraPageFooter extends StatelessWidget {
  const CameraPageFooter({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cameraCubit = context.watch<CameraCubit>();

    return Positioned(
      bottom: 0,
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 25.w),
        color: Colors.black.withOpacity(0.7),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              height: 30.w,
              width: 30.w,
              child: IconButton(
                onPressed: () => cameraCubit.choosePictureFromGallery(),
                icon: SvgPicture.asset(
                  Svgs.image,
                  color: Colors.white,
                  width: 25.w,
                ),
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                padding: const EdgeInsets.all(0),
              ),
            ),
            GestureDetector(
              onTap: () async {
                await cameraCubit.takePicture();
              },
              behavior: HitTestBehavior.opaque,
              child: Container(
                height: 65.h,
                width: 65.w,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 4.w)),
              ),
            ),
            SizedBox(
              height: 30.w,
              width: 30.w,
              child: IconButton(
                onPressed: () => cameraCubit.swithcCamera(),
                icon: SvgPicture.asset(
                  Svgs.cameraSwitch,
                ),
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                padding: const EdgeInsets.all(0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatsToSendlist extends StatelessWidget {
  const ChatsToSendlist({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeColorsCubit = context.watch<ThemeCubit>();
    final themeColors = themeColorsCubit.themeColors;

    final cameraCubit = context.watch<CameraCubit>();

    final chatsCubit = context.watch<ChatsCubit>();
    final chatsStream = chatsCubit.chatsStream;

    return StreamBuilder(
      stream: chatsStream,
      builder: (context, snapshot) {
        final chatsList = chatsCubit.getChatsList();
        return Container(
          color: themeColors.backgroundColor,
          child: Padding(
            padding: EdgeInsets.only(left: 17.w, top: 50.h, right: 17.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 25.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.sendTo,
                        style: TextStyle(
                          color: themeColors.mainColor,
                          fontSize: 26.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(
                        height: 20.w,
                        width: 20.w,
                        child: IconButton(
                          onPressed: () => cameraCubit.cancelSending(),
                          icon: SvgPicture.asset(
                            Svgs.cross,
                            color: themeColors.mainColor,
                          ),
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          padding: const EdgeInsets.all(0),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.separated(
                    padding: EdgeInsets.only(bottom: 15.h),
                    itemBuilder: (context, index) {
                      final chatModel = chatsList.elementAt(index);

                      return ChatItem(
                        chatModel: chatModel,
                      );
                    },
                    separatorBuilder: (context, index) {
                      return SizedBox(
                        height: 15.h,
                      );
                    },
                    itemCount: chatsList.length,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class ChatItem extends StatelessWidget {
  const ChatItem({
    Key? key,
    required this.chatModel,
  }) : super(key: key);

  final ChatModel chatModel;

  @override
  Widget build(BuildContext context) {
    final themeColorsCubit = context.watch<ThemeCubit>();
    final themeColors = themeColorsCubit.themeColors;

    final cameraCubit = context.watch<CameraCubit>();
    final imageToSend = cameraCubit.image;

    final chatsCubit = context.watch<ChatsCubit>();

    final String? avatarUrl = chatModel.chatImageUrl;
    final String userName = chatModel.chatName;

    return GestureDetector(
      onTap: () async {
        final chatConfiguration = await chatsCubit.getChatConfiguration(
          contactUserId: chatModel.chatContactUserId,
          chatModel: chatModel,
          imageToSend: imageToSend,
        );

        if (chatConfiguration != null) {
          Navigator.of(context).pushNamed(
            MainNavigationRouteNames.chatScreen,
            arguments: chatConfiguration,
          );

          cameraCubit.cancelSending();
        }
      },
      child: Row(
        children: [
          Container(
            height: 45.h,
            width: 45.w,
            margin: EdgeInsets.only(right: 15.w),
            clipBehavior: Clip.hardEdge,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: avatarUrl == null || avatarUrl.trim().isEmpty
                ? SvgPicture.asset(Svgs.defaultUserImage)
                : Image.network(
                    avatarUrl,
                    fit: BoxFit.cover,
                  ),
          ),
          Expanded(
            child: Text(
              userName,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: TextStyle(
                color: themeColors.mainColor,
                fontSize: 18.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
