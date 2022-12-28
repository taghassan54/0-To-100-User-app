import 'package:flutter/material.dart';
import 'package:zero_to_100_user_app/utill/custom_themes.dart';
import 'package:zero_to_100_user_app/utill/dimensions.dart';

class AmountWidget extends StatelessWidget {
  final String title;
  final String amount;

  AmountWidget({@required this.title, @required this.amount});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(title, style: titilliumRegular.copyWith(fontSize: Dimensions.FONT_SIZE_DEFAULT)),
        Text(amount, style: titilliumRegular.copyWith(fontSize: Dimensions.FONT_SIZE_DEFAULT)),
      ]),
    );
  }
}
