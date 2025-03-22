import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:rheel_estate/utils/app_constants.dart';
import 'package:rheel_estate/utils/dimensions.dart';

class Next extends StatefulWidget {
  const Next({super.key});

  @override
  State<Next> createState() => _NextState();
}

class _NextState extends State<Next> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
        body: SizedBox(
      height: Dimensions.screenHeight,
      width: Dimensions.screenWidth,
      child: Stack(
          children: [
        Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                  horizontal: Dimensions.width20,
                  vertical: Dimensions.height20),
              height: Dimensions.screenHeight / 2.7,
              width: Dimensions.screenWidth,
              decoration: BoxDecoration(color: Colors.black87),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: Dimensions.height76),
                  Text(
                    'Location',
                    style: TextStyle(
                        color: Colors.white70,
                        fontSize: Dimensions.font15,
                        fontWeight: FontWeight.w300),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Ekiti State University',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: Dimensions.font18,
                            fontWeight: FontWeight.w500),
                      ),
                      Icon(Icons.arrow_drop_down, color: Colors.white),
                    ],
                  ),
                  SizedBox(height: Dimensions.height20),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            fillColor: Colors.grey.withOpacity(0.05),
                            filled: true,
                            hintText: 'Search Coffee',
                            hintStyle: TextStyle(color: Colors.white70),
                            prefixIcon: Icon(
                              Iconsax.search_normal,
                              color: Colors.white70,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(Dimensions.radius15),
                              borderSide: BorderSide(
                                  color: Colors.black87,
                                  width:
                                      Dimensions.width5 / Dimensions.width20),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(Dimensions.radius15),
                              borderSide: BorderSide(
                                  color: Colors.black87,
                                  width:
                                      Dimensions.width5 / Dimensions.width20),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: Dimensions.width40,
                                vertical: Dimensions.height20),
                          ),
                        ),
                      ),
                      SizedBox(width: Dimensions.width20),
                      Container(
                        height: Dimensions.height10 * 6,
                        width: Dimensions.width10 * 6,
                        decoration: BoxDecoration(
                            color: Colors.deepOrange,
                            borderRadius:
                                BorderRadius.circular(Dimensions.radius15)),
                        child: Icon(
                          Iconsax.sort,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
        Positioned(
          top: Dimensions.width30,
          child: Container(
            height: Dimensions.height100 * 1.5,
            margin: EdgeInsets.symmetric(horizontal: Dimensions.width30),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Dimensions.radius20),
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage(
                  AppConstants.getPngAsset('Banner 1'),
                ),
              ),
            ),
          ),
        )
      ]),
    )

        /*bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        iconSize: Dimensions.iconSize20,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Iconsax.home),
            label: 'Home'
          ),
          BottomNavigationBarItem(
            icon: Icon(Iconsax.music),
            label: 'Music'
          ),
          BottomNavigationBarItem(
            icon: Icon(Iconsax.people),
            label: 'Friends'
          ),
          BottomNavigationBarItem(
            icon: Icon(Iconsax.setting),
            label: 'Settings'
          ),
        ],
      ),*/
        );
  }
}
