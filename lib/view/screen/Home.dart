import 'package:flutter/material.dart';
import 'package:flutter_application_2/view/screen/AddApartmentPage.dart';
import 'package:flutter_application_2/view/screen/login.dart';
import 'package:flutter_application_2/view/widget/CountainerviewApartment.dart';
import 'package:flutter_application_2/core/components/crud.dart';
import 'package:flutter_application_2/core/constant/linkapi.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

import 'FilterPage.dart';

class Home extends StatelessWidget {
  final Crud api = Crud();
  final storage = FlutterSecureStorage();
  final ValueNotifier<bool> refreshTrigger = ValueNotifier(false);

  Future<Map<String, dynamic>> loadData() async {
    String? token = await storage.read(key: "token");
    print("TOKEN IN HOME: $token");

    if (token == null) {
      throw Exception("Token not found");
    }

    var response = await api.getRequest(linkeViewAppartment);

    if (response == null) {
      throw Exception("No response from server");
    }
    String? role = await storage.read(key: "role");
    response["role"] = role;

    return response;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: refreshTrigger,
      builder: (context, _, __) {
        return FutureBuilder(


          future: loadData(),
          builder: (context, snapshot) {
            print("SNAPSHOT ERROR: ${snapshot.error}");

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            }

            final Map<String, dynamic> json =
            snapshot.data as Map<String, dynamic>;
            final String? role = json["role"];
            final List apartments = json['data']['Appartment'];
            final List addresses = json['data']['Apartment_Address'];

            if (apartments.isEmpty) {
              return Scaffold(   floatingActionButton: (role == "owner")
                  ? FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddApartmentPage()),
                  ).then((_) {
                    refreshTrigger.value = !refreshTrigger.value;
                  });
                },
                backgroundColor: Colors.blue,
                child: const Icon(Icons.add_home_work,
                    size: 35, color: Colors.white),
              ):null,
                  appBar: AppBar(
                    title: Text("13".tr),
                    actions: [
                      PopupMenuButton<String>(
                        onSelected: (value) {},
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            value: "change_lang",
                            onTap: () {
                              if (Get.locale!.languageCode == 'ar') {
                                Get.updateLocale(const Locale('en'));
                              } else {
                                Get.updateLocale(const Locale('ar'));
                              }
                            },
                            child: Text("17".tr),
                          ),
                          PopupMenuItem(
                            value: "theme",
                            onTap: () {
                              Future.delayed(Duration(milliseconds: 100), () {
                                if (Get.isDarkMode) {
                                  Get.changeThemeMode(ThemeMode.light);
                                } else {
                                  Get.changeThemeMode(ThemeMode.dark);
                                }
                              });
                            },
                            child: Text("19".tr),
                          ),
                          PopupMenuItem(
                            value: "logout",
                            onTap: () async {
                              await Future.delayed(Duration(milliseconds: 100));

                              var response = await api.postRequest(
                                linkelogout,
                                {},
                              );

                              print("LOGOUT RESPONSE: $response");

                              if (response != null &&
                                  response['status'] == true) {
                                await storage.delete(key: "token");

                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Login()),
                                );
                              } else {
                                Get.snackbar("Error", "Logout failed");
                              }
                            },
                            child: Text("18".tr),
                          ),
                        ],
                      )
                    ],
                  ),

                  body: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center,children: [Icon(Icons.image_not_supported_rounded,size: 200),Text("No Thing to view"),])));
            }

            return Scaffold(
              floatingActionButtonLocation:
              FloatingActionButtonLocation.endFloat,
              floatingActionButton:(role == "owner")

             ? FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddApartmentPage()),
                  ).then((_) {
                    refreshTrigger.value = !refreshTrigger.value;
                  });
                },
                backgroundColor: Colors.blue,
                child: const Icon(Icons.add_home_work,
                    size: 35, color: Colors.white),
              ):null,
              appBar: AppBar(
                title: Text("13".tr),
                actions: [IconButton(icon: Icon(Icons.search),onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => FilterPage()),
                  );

                },),
                  PopupMenuButton<String>(
                    onSelected: (value) {},
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: "change_lang",
                        onTap: () {
                          if (Get.locale!.languageCode == 'ar') {
                            Get.updateLocale(const Locale('en'));
                          } else {
                            Get.updateLocale(const Locale('ar'));
                          }
                        },
                        child: Text("17".tr),
                      ),
                      PopupMenuItem(
                        value: "theme",
                        onTap: () {
                          Future.delayed(Duration(milliseconds: 100), () {
                            if (Get.isDarkMode) {
                              Get.changeThemeMode(ThemeMode.light);
                            } else {
                              Get.changeThemeMode(ThemeMode.dark);
                            }
                          });
                        },
                        child: Text("19".tr),
                      ),
                      PopupMenuItem(
                        value: "logout",
                        onTap: () async {
                          await Future.delayed(Duration(milliseconds: 100));

                          var response = await api.postRequest(
                            linkelogout,
                            {},
                          );

                          print("LOGOUT RESPONSE: $response");

                          if (response != null &&
                              response['status'] == true) {
                            await storage.delete(key: "token");

                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Login()),
                            );
                          } else {
                            Get.snackbar("Error", "Logout failed");
                          }
                        },
                        child: Text("18".tr),
                      ),
                    ],
                  )
                ],
              ),
              body: GridView.builder(
                gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 1,
                  mainAxisSpacing: 1,
                  childAspectRatio: 0.55,
                ),
                itemCount: apartments.length,
                itemBuilder: (context, index) {
                  final apt = apartments[index];

                  final address = addresses.firstWhere(
                        (a) => a['id'] == apt['adress_Id'],
                    orElse: () => null,
                  );

                  return CountainerviewApartment(
                    city: address?["city"],
                    image: apt["image"] == null
                        ? "https://via.placeholder.com/300"
                        : "$linkeserverName/storage/apartments/${apt["image"]}",
                    streetName: address?["streetName"],



                    buildingNumber: address?["buildingNumber"] ?? "",
                    floorNumber: address?["floorNumber"] ?? "",
                    apartmentNumber: address?["apartmentNumber"] ?? "",

                    price: apt["price"] ?? "",
                    space: apt["space"] ?? "",
                    status: apt["statusApartments"] ?? "",

                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}