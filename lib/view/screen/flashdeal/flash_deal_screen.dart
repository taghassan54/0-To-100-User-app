import 'package:flutter/material.dart';

import 'package:zero_to_100_user_app/localization/language_constrants.dart';
import 'package:zero_to_100_user_app/provider/flash_deal_provider.dart';
import 'package:zero_to_100_user_app/utill/dimensions.dart';
import 'package:zero_to_100_user_app/view/basewidget/custom_app_bar.dart';
import 'package:zero_to_100_user_app/view/basewidget/title_row.dart';
import 'package:zero_to_100_user_app/view/screen/home/widget/flash_deals_view.dart';
import 'package:provider/provider.dart';

class FlashDealScreen extends StatefulWidget {

  @override
  State<FlashDealScreen> createState() => _FlashDealScreenState();
}

class _FlashDealScreenState extends State<FlashDealScreen> {


  @override
  void initState() {
     Provider.of<FlashDealProvider>(context, listen: false).getMegaDealList(true, context, true);
    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Column(children: [

        CustomAppBar(title: getTranslated('flash_deal', context)),

        Padding(
          padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
          child: TitleRow(title: getTranslated('flash_deal', context), eventDuration: Provider.of<FlashDealProvider>(context).duration),
        ),

        Expanded(child: RefreshIndicator(
          backgroundColor: Theme.of(context).primaryColor,
          onRefresh: () async {
            await Provider.of<FlashDealProvider>(context, listen: false).getMegaDealList(true, context, false);
          },
          child: Padding(
            padding: EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_SMALL),
            child: FlashDealsView(isHomeScreen: false),
          ),
        )),

      ]),
    );
  }
}
