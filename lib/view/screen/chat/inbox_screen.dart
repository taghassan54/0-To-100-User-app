import 'package:flutter/material.dart';
import 'package:zero_to_100_user_app/localization/language_constrants.dart';
import 'package:zero_to_100_user_app/provider/auth_provider.dart';
import 'package:zero_to_100_user_app/provider/chat_provider.dart';
import 'package:zero_to_100_user_app/utill/color_resources.dart';
import 'package:zero_to_100_user_app/utill/dimensions.dart';
import 'package:zero_to_100_user_app/view/basewidget/custom_app_bar.dart';
import 'package:zero_to_100_user_app/view/basewidget/no_internet_screen.dart';
import 'package:zero_to_100_user_app/view/basewidget/not_loggedin_widget.dart';
import 'package:zero_to_100_user_app/view/screen/chat/widget/chat_header.dart';
import 'package:zero_to_100_user_app/view/screen/chat/widget/chat_item_widget.dart';
import 'package:zero_to_100_user_app/view/screen/chat/widget/inbox_shimmer.dart';
import 'package:provider/provider.dart';


class InboxScreen extends StatefulWidget {
  final bool isBackButtonExist;
  InboxScreen({this.isBackButtonExist = true});

  @override
  State<InboxScreen> createState() => _InboxScreenState();
}

class _InboxScreenState extends State<InboxScreen> {


  bool isGuestMode;
  @override
  void initState() {
    bool isFirstTime = true;
    isGuestMode = !Provider.of<AuthProvider>(context, listen: false).isLoggedIn();
    if(isFirstTime) {
      if(!isGuestMode) {
        Provider.of<ChatProvider>(context, listen: false).getChatList(context, 1);
      }
      isFirstTime = false;
    }
    super.initState();
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorResources.getIconBg(context),
      body: Column(children: [
        CustomAppBar(title: getTranslated('inbox', context), isBackButtonExist: false),

        Container(
            height: 100,decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(Dimensions.PADDING_SIZE_OVER_LARGE),
                bottomRight: Radius.circular(Dimensions.PADDING_SIZE_OVER_LARGE))),
            padding: const EdgeInsets.symmetric(vertical:Dimensions.PADDING_SIZE_EXTRA_SMALL),
            child:  Column(
              children:  [
                const ChatHeader(),
              ],
            )),


        Expanded(
            child: isGuestMode ? NotLoggedInWidget() :  RefreshIndicator(
              backgroundColor: Theme.of(context).primaryColor,
              onRefresh: () async {
                await Provider.of<ChatProvider>(context, listen: false).getChatList(context, 1);
              },
              child: Consumer<ChatProvider>(
                builder: (context, chatProvider, child) {
                  return !chatProvider.isLoading? chatProvider.chatList.length != 0 ?
                  ListView.builder(
                    itemCount: chatProvider.chatList.length,
                    padding: EdgeInsets.all(0),
                    itemBuilder: (context, index) {
                      return ChatItemWidget(chat: chatProvider.chatList[index]);
                    },
                  ) : NoInternetOrDataScreen(isNoInternet: false): InboxShimmer();
                },
              ),
            ),
          ),
      ]),
    );
  }
}



