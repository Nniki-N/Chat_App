import 'package:chat_app/domain/cubits/chats_cubit.dart';
import 'package:chat_app/ui/screens/main_screen/chats_page/chat_item.dart';
import 'package:chat_app/ui/screens/main_screen/chats_page/chat_title_and_search_field.dart';
import 'package:chat_app/ui/widgets/loading_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatsPage extends StatelessWidget {
  const ChatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final chatsCubit = context.watch<ChatsCubit>();
    final chatsStream = chatsCubit.chatsStream;

    return StreamBuilder(
      stream: chatsStream,
      builder: (context, snapshot) {
        final chatsList = chatsCubit.getChatsList();

        return Column(
          children: [
            const ChatsTitleAndSearchField(),
            Expanded(
              child: Builder(
                builder: (context) {
                  final loading = chatsCubit.loading;
                  return loading
                      ? const LoadingPage()
                      : ListView.separated(
                          padding: EdgeInsets.only(bottom: 15.h),
                          itemBuilder: (context, index) {
                            final chatModel = chatsList.elementAt(index);

                            return ChatItem(
                              chatModel: chatModel,
                            );
                          },
                          separatorBuilder: (context, index) =>
                              SizedBox(height: 25.h),
                          itemCount: chatsList.length,
                        );
                },
              ),
            )
          ],
        );
      },
    );
  }
}
