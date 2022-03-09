import 'package:flutter/material.dart';
import 'package:mobileapp/core/components/exporting_packages.dart';
import 'package:mobileapp/models/business_account_model.dart';
import 'package:mobileapp/screens/business_profile/hotel/input_hotel_page.dart';
import 'package:mobileapp/widgets/buttons/link_with_icon_button.dart';
import 'package:mobileapp/widgets/rating_bar_widget.dart';
import 'base_business_tile.dart';

class BusinessHotelTile extends StatelessWidget {
  final Hotels hotels;

  const BusinessHotelTile({Key? key, required this.hotels}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseBusinessTile(
      // TODO: Bu yerga Hotel rasmi qo'yiladi
      imgUrl: MockData.place.media[0],
      title: hotels.name!,
      infoWidget: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RatingBarWidget(rating: hotels.reyting!.toDouble()),
          SizedBox(height: 8.h),
          LinkWithIconButton(
            icon: AppIcons.location,
            label: LocaleKeys.mapLink.tr(),
            link: hotels.karta!,
          ),
          SizedBox(height: 8.h),
          hotels.site != null
              ? LinkWithIconButton(
                  icon: AppIcons.link,
                  label: hotels.site.toString(),
                  link: hotels.site.toString(),
                )
              : const SizedBox(),
        ],
      ),
    ).onClick(() => CustomNavigator.push(InputHotelPage(
          isEditing: true,
          hotel: Hotel.fromJson(hotels.toJson()),
        )));
  }
}