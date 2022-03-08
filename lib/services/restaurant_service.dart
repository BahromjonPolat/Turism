import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobileapp/core/components/exporting_packages.dart';
import 'package:mobileapp/models/category_model.dart';
import 'package:mobileapp/models/restaurant_model.dart';

class RestaurantService {
  static String baseUrl = 'https://ucharteam-tourism.herokuapp.com/v1/api';

  static Future createNewRestaurant(Restaurant restaurant) async {
    try {
      String token = //await GetStorage().read('token');
          //'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiI1ZGI4OGM0Yy04ODYxLTRjMTgtOWI3MS04MjZjM2M0NGFlYzEiLCJpYXQiOjE2NDYxNTI2MDcsImV4cCI6MTY2MzQzMjYwN30.WUaeEN7SJeYNC-8pZ-Vh4FcLu5fRAKLAUjFS3JZUUqg';
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiJmMzIyYjkxNi01MjQ0LTQ5YTItOWY0Ni1jM2E3YTYzNjA0Y2IiLCJpYXQiOjE2NDUwOTUwNzEsImV4cCI6MTY2MjM3NTA3MX0.cX0A_pOKUn7K6iekxocSWK4K5WrtHph_2-WrOXPDyis';

      var headers = {'token': token};
      var request =
          http.MultipartRequest('POST', Uri.parse('$baseUrl/restaurant'));
      request.fields.addAll({
        'name': restaurant.name,
        'city': restaurant.city,
        'informUz': restaurant.informUz,
        'informRu': restaurant.informRu,
        'informEn': restaurant.informEn,
        'karta': restaurant.karta,
        'category': '903908cf-7f6d-424f-8c03-66d30e9347bf'
      });

      for (var tell in restaurant.tell) {
        request.files.add(
          http.MultipartFile.fromString('tell', tell),
        );
      }

      // FIXME: BIR NECHTA RASMLARNI JO'NATISH
      for (var photoPath in restaurant.media) {
        final mimeTypeData =
            lookupMimeType(photoPath, headerBytes: [0xFF, 0xD8])?.split('/');

        //------------------
        request.files.add(
          await http.MultipartFile.fromPath(
            'media',
            photoPath,
            filename: photoPath.split('/').last,
            contentType: MediaType(mimeTypeData![0], mimeTypeData[1]),
          ),
        );
      }

      request.headers.addAll(headers);

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 201) {
        
        //Restaurant rest = Restaurant.fromJson(jsonDecode(response.body)['data']);

        GetStorage().write('myRestaurant', jsonDecode(response.body)['data']);

        print("SUCCESFULL bytestostreamBody: " + response.body);
        print(GetStorage().read('myRestaurant'));
      } else {
        print('else error: ' + response.statusCode.toString());
      }
    } catch (e) {
      print('catch error: ' + e.toString());
    }
  }

  Future<List<Restaurant>?> fetchRestaurantsByCity(String cityName) async {
    try {
      var response = await http
          .get(Uri.parse("$baseUrl/restaurant"), headers: {"city": cityName});

      if (response.statusCode == 200) {
        //print(jsonDecode(response.body)['data']);
        List restaurantList =
            (jsonDecode(response.body)['data'] as List).map((e) {
          print("ELEMENT" + e.toString());
          return Restaurant.fromJson(e);
        }).toList();
        return restaurantList as List<Restaurant>;
      } else {
        print(jsonDecode(response.body[0]));
        return null;
      }
    } catch (e) {
      print("ERROR: " + e.toString());
    }
  }

  Future<List<Restaurant>?> fetchRestaurantsByCategory(String categryId) async {
    try {
      var response = await http.get(Uri.parse("$baseUrl/restaurant"),
          headers: {"category_id": categryId});
      if (response.statusCode == 200) {
        List restaurantList =
            (jsonDecode(response.body)['data'] as List).map((e) {
          print("ELEMENT" + e.toString());
          return Restaurant.fromJson(e);
        }).toList();
        print(restaurantList);
        return restaurantList as List<Restaurant>;
      } else {
        print(jsonDecode(response.body)['message']);
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future fetchCategoriesOfRestaurants() async {
    try {
      var response = await http.get(
        Uri.parse("$baseUrl/restaurants/categories"),
      );
      if (response.statusCode == 200) {
        List categoryList =
            (jsonDecode(response.body)['data'] as List).map((e) {
          print("ELEMENT" + e.toString());
          return Category.fromJson(e);
        }).toList();

        return categoryList;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

// TODO: iwlaw kk
  Future fetchRestaurantComments({required String restaurantId}) async {
    try {
      var response = await http.get(Uri.parse("$baseUrl/comment"),
          headers: {"restaurant_id": restaurantId});

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return jsonDecode(response.body);
      }
    } catch (e) {
      return e;
    }
  }

  Future addRatingToRestaurant(
      {required String restaurantId, required int rate}) async {
    String token = //await GetStorage().read('token');
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiI1ZGI4OGM0Yy04ODYxLTRjMTgtOWI3MS04MjZjM2M0NGFlYzEiLCJpYXQiOjE2NDYxNTI2MDcsImV4cCI6MTY2MzQzMjYwN30.WUaeEN7SJeYNC-8pZ-Vh4FcLu5fRAKLAUjFS3JZUUqg';

    try {
      var response = await http.post(
        Uri.parse('$baseUrl/reyting'),
        body: jsonEncode({"value": rate, "restaurantId": restaurantId}),
        headers: {'token': token, 'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        print(jsonDecode(response.body)['message']);
        return jsonDecode(response.body);
      } else {
        print(jsonDecode(response.body)['message']);
        return jsonDecode(response.statusCode.toString());
      }
    } catch (e) {
      print(e);
      return e;
    }
  }

  Future addCommentToRestaurant(
      {required String restaurantId, required String commentText}) async {
    String token = //await GetStorage().read('token');
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiJmMzIyYjkxNi01MjQ0LTQ5YTItOWY0Ni1jM2E3YTYzNjA0Y2IiLCJpYXQiOjE2NDUwOTUwNzEsImV4cCI6MTY2MjM3NTA3MX0.cX0A_pOKUn7K6iekxocSWK4K5WrtHph_2-WrOXPDyis';

    try {
      var response = await http.post(
        Uri.parse('$baseUrl/comment'),
        body: jsonEncode({"name": commentText, "restaurantId": restaurantId}),
        headers: {'token': token, 'Content-Type': 'application/json'},
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        print(jsonDecode(response.body));
        return jsonDecode(response.body);
      } else {
        print(response.body);
        return jsonDecode(response.body);
      }
    } catch (e) {
      print(e);
      return e;
    }
  }

  Future updateRestaurantData(Restaurant restaurant) async {
    String token = //await GetStorage().read('token');
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiJmMzIyYjkxNi01MjQ0LTQ5YTItOWY0Ni1jM2E3YTYzNjA0Y2IiLCJpYXQiOjE2NDUwOTUwNzEsImV4cCI6MTY2MjM3NTA3MX0.cX0A_pOKUn7K6iekxocSWK4K5WrtHph_2-WrOXPDyis';

    try {
      var response = await http.put(
        Uri.parse('$baseUrl/restaurant'),
        body: json.encode(restaurant.toJson()
            // {
            //   "name": restaurant.name,
            //   "informUz": restaurant.informUz,
            //   "informEn": restaurant.informEn,
            //   "informRu": restaurant.informRu,
            //   "site": restaurant.site,
            //   "tell": restaurant.tell,
            //   "karta": restaurant.karta,
            //   "category": restaurant.category,
            //   "restaurantId": restaurant.id
            // },
            ),
        headers: {'token': token, 'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return jsonDecode(response.statusCode.toString());
      }
    } catch (e) {
      return e;
    }
  }
//8. url/v1/api/restaurant/:{restaurantId} - body : { [media] } --- restaurant rasmlarini o'zgartirish

  static Future updateHotelMedia(
      {required String hotelId, required List hotelMedia}) async {
    try {
      String token = //await GetStorage().read('token');
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiJmMzIyYjkxNi01MjQ0LTQ5YTItOWY0Ni1jM2E3YTYzNjA0Y2IiLCJpYXQiOjE2NDUwOTUwNzEsImV4cCI6MTY2MjM3NTA3MX0.cX0A_pOKUn7K6iekxocSWK4K5WrtHph_2-WrOXPDyis';

      var headers = {'token': token};
      var request =
          http.MultipartRequest('POST', Uri.parse('$baseUrl/hotel/$hotelId'));

      // FIXME: BIR NECHTA RASMLARNI JO'NATISH
      for (var photoPath in hotelMedia) {
        final mimeTypeData =
            lookupMimeType(photoPath, headerBytes: [0xFF, 0xD8])?.split('/');

        //------------------
        request.files.add(await http.MultipartFile.fromPath(
          'media',
          photoPath,
          filename: photoPath.split('/').last,
          contentType: MediaType(mimeTypeData![0], mimeTypeData[1]),
        ));
      }

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        print(await response.stream.bytesToString());
        return response.stream.bytesToString();
      } else {
        print('else error: ' + response.reasonPhrase.toString());
        return response.reasonPhrase;
      }
    } catch (e) {
      print('catch error: ' + e.toString());
      return null;
    }
  }

  Future deleteRestaurant() async {
    String token = //await GetStorage().read('token');
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiJmMzIyYjkxNi01MjQ0LTQ5YTItOWY0Ni1jM2E3YTYzNjA0Y2IiLCJpYXQiOjE2NDUwOTUwNzEsImV4cCI6MTY2MjM3NTA3MX0.cX0A_pOKUn7K6iekxocSWK4K5WrtHph_2-WrOXPDyis';

      String restaurantId = GetStorage().read("myRestaurant")['id'].toString();
      
    try {
      var response = await http.delete(
        Uri.parse("$baseUrl/restaurant/$restaurantId"),
        headers: {'token': token},
      );

      if (response.statusCode == 201) {
        print(jsonDecode(response.body));
        return jsonDecode(response.body);
      } else {
        print(response.body);
        return jsonDecode(response.body);
      }
    } catch (e) {
      return e;
    }
  }
}
