

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
      appBar: AppBar(
        backgroundColor: Color(0XFFF9F9F9),
        leading: Row(
          children: [
            SizedBox(
              width: Dimensions.width30,
            ),
            Icon(Iconsax.menu),
          ],
        ),
        actions: [
          Row(
            children: [
              Container(
                height: Dimensions.height40,
                width: Dimensions.width40,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                      AppConstants.getPngAsset('avatar'),
                    ),
                  ),
                ),
              ),
              SizedBox(width: Dimensions.width30)
            ],
          )
        ],
      ),
      backgroundColor: Color(0XFFF9F9F9),
      body: Container(
        margin: EdgeInsets.symmetric(
            vertical: Dimensions.height20, horizontal: Dimensions.width20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: Dimensions.height30),
            Row(
              children: [
                Text(
                  'Welcome back,',
                  style: TextStyle(
                      fontSize: Dimensions.font28, fontWeight: FontWeight.w400),
                ),
                SizedBox(width: Dimensions.width5),
                Text(
                  'Olotu!',
                  style: TextStyle(
                      fontSize: Dimensions.font28, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            SizedBox(height: Dimensions.height30),
            Text(
              'How are you feeling today?',
              style: TextStyle(
                  fontSize: Dimensions.font18, fontWeight: FontWeight.w400),
            ),
            SizedBox(height: Dimensions.height30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  height: Dimensions.height10 * 9,
                  width: Dimensions.width10 * 9,
                  decoration: BoxDecoration(
                    color: Colors.pink,
                    borderRadius: BorderRadius.circular(Dimensions.radius20),
                  ),
                  child: Container(
                    height: Dimensions.height10 * 5,
                    width: Dimensions.width10 * 5,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        scale: 2.5,
                        image: AssetImage(
                          AppConstants.getPngAsset('Happy'),
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  height: Dimensions.height10 * 9,
                  width: Dimensions.width10 * 9,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(Dimensions.radius20),
                  ),
                  child: Container(
                    height: Dimensions.height10 * 5,
                    width: Dimensions.width10 * 5,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        scale: 2.5,
                        image: AssetImage(
                          AppConstants.getPngAsset('Calm - Icon'),
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  height: Dimensions.height10 * 9,
                  width: Dimensions.width10 * 9,
                  decoration: BoxDecoration(
                    color: Colors.lightGreen,
                    borderRadius: BorderRadius.circular(Dimensions.radius20),
                  ),
                  child: Container(
                    height: Dimensions.height10 * 5,
                    width: Dimensions.width10 * 5,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        scale: 2.5,
                        image: AssetImage(
                          AppConstants.getPngAsset('Relax'),
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  height: Dimensions.height10 * 9,
                  width: Dimensions.width10 * 9,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(Dimensions.radius20),
                  ),
                  child: Container(
                    height: Dimensions.height10 * 5,
                    width: Dimensions.width10 * 5,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        scale: 2.5,
                        image: AssetImage(
                          AppConstants.getPngAsset('Focus'),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: Dimensions.height30),
            Text(
              'Today\'s Task',
              style: TextStyle(
                  fontSize: Dimensions.font18, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: Dimensions.height30),
            Container(
              padding: EdgeInsets.symmetric(
                  horizontal: Dimensions.width20,
                  vertical: Dimensions.height20),
              height: Dimensions.height150,
              width: Dimensions.screenWidth,
              decoration: BoxDecoration(
                color: Colors.pinkAccent.shade100.withOpacity(0.8),
                borderRadius: BorderRadius.circular(Dimensions.radius20),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          'Peer Group Meetup',
                          style: TextStyle(
                              fontSize: Dimensions.font20,
                              fontWeight: FontWeight.w500),
                        ),
                        Text(
                          'Lets open up to the thing that matters among the people',
                          style: TextStyle(
                              fontSize: Dimensions.font16,
                              fontWeight: FontWeight.w400),
                        ),
                        Row(
                          children: [
                            Text(
                              'Join Now',
                              style: TextStyle(
                                  fontSize: Dimensions.font16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.pink.shade800),
                            ),
                            Icon(
                              Icons.play_circle,
                              color: Colors.pink.shade800,
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  Container(
                    height: Dimensions.height100,
                    width: Dimensions.width100,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(
                          AppConstants.getPngAsset('Meetup Icon'),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: Dimensions.height30),
            Container(
              padding: EdgeInsets.symmetric(
                  horizontal: Dimensions.width20,
                  vertical: Dimensions.height20),
              height: Dimensions.height150 + Dimensions.height15,
              width: Dimensions.screenWidth,
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.5),
                borderRadius: BorderRadius.circular(Dimensions.radius20),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          'Meditation',
                          style: TextStyle(
                              fontSize: Dimensions.font20,
                              fontWeight: FontWeight.w500),
                        ),
                        Text(
                          'Aura is the most important thing that matters to you, join us on',
                          style: TextStyle(
                              fontSize: Dimensions.font16,
                              fontWeight: FontWeight.w400),
                        ),
                        Row(
                          children: [
                            Text(
                              '06:00 PM',
                              style: TextStyle(
                                  fontSize: Dimensions.font16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.brown),
                            ),
                            Icon(
                              Icons.access_time_filled_rounded,
                              color: Colors.brown,
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  Container(
                    height: Dimensions.height100,
                    width: Dimensions.width100,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(
                          AppConstants.getPngAsset('Meditation'),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
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
      ),
    );
  }
}
