import 'package:flutter/material.dart';
import 'package:mobileapp/core/components/exporting_packages.dart';

part 'hotel_state.dart';

class HotelCubit extends Cubit<HotelState> {
  HotelCubit() : super(HotelInitial());

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _websiteController = TextEditingController();
  final TextEditingController _mapLinkController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _aboutUzController = TextEditingController();
  final TextEditingController _aboutEnController = TextEditingController();
  final TextEditingController _aboutRuController = TextEditingController();
  List<String> _imageList = [];

  String _city = LocaleKeys.tashkent.tr();
  String _chosenCity = CityList().getCity(LocaleKeys.tashkent.tr());

  HotelCubit.editing(Hotel hotel) : super(HotelInitial()) {
    _nameController.text = hotel.name;
    _phoneController.text = hotel.tell[0];
    _websiteController.text = hotel.site.toString();
    _mapLinkController.text = hotel.karta;
    _priceController.text = '150';
    _aboutUzController.text = hotel.informUz;
    _aboutEnController.text = hotel.informEn;
    _aboutRuController.text = hotel.informRu;
    _imageList = hotel.media;
    _city = CityList().getCityName(hotel.city);

  }

  void cityChanged(dynamic value) {
    _city = value;
    _chosenCity = CityList().getCity(_city);
    emit(HotelInitial());
  }

  void setImage() {
    ImageChooser chooser = ImageChooser();
    chooser.notStatic().then((value) {
      _imageList = ImageChooser.imageList;
      emit(HotelInitial());
    });
  }

  void onDropdownMenuItemPressed() {}

  void onSavePressed() {
    if (_formKey.currentState!.validate()) {
      String name = _nameController.text.trim();
      String phone = _phoneController.text.trim();
      String link = _websiteController.text.trim();
      String map = _mapLinkController.text.trim();
      String aboutUz = _aboutUzController.text.trim();
      String aboutEn = _aboutEnController.text.trim();
      String aboutRu = _aboutRuController.text.trim();

      Hotel hotel = Hotel(
        name: name,
        categoryId: '',
        city: _chosenCity.toLowerCase(),
        informEn: aboutEn,
        informUz: aboutUz,
        informRu: aboutRu,
        karta: map,
        site: link,
        tell: [phone],
        media: ImageChooser.imageList,
        date: DateTime.now().toString(),
      );
      HotelService.createNewHotel(hotel).then((value) {
        ImageChooser.clearImageList();
        CustomNavigator().pushAndRemoveUntil(const HomeScreen());
      });
    }
  }

  TextEditingController get nameController => _nameController;

  TextEditingController get phoneController => _phoneController;

  TextEditingController get websiteController => _websiteController;

  TextEditingController get linkController => _priceController;

  TextEditingController get aboutUzController => _aboutUzController;

  TextEditingController get aboutEnController => _aboutEnController;

  TextEditingController get aboutRuController => _aboutRuController;

  GlobalKey<FormState> get formKey => _formKey;

  String get city => _city;

  TextEditingController get mapLinkController => _mapLinkController;

  List<String> get imageList => _imageList;

  TextEditingController get priceController => _priceController;
}
