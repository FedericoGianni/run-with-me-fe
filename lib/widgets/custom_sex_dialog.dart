import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/color_scheme.dart';
import 'custom_scroll_behavior.dart';

class CustomSexDialog extends StatelessWidget {
  const CustomSexDialog({ Key? key }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    final colors = Provider.of<CustomColorScheme>(context);
    final double screenWidth = MediaQuery.of(context).size.width;

    List _sexList = ['Male', 'Female', "Don't know"];
    
    return AlertDialog(
      backgroundColor: colors.background,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      content: SizedBox(
        height: 180,
        child: Column(
          children: [
            Container(
              height: 180,
              width: screenWidth,
              child: ScrollConfiguration(
                behavior: CustomScrollBehavior(),
                child: CustomScrollView(
                  // This is needed to avoid overflow
                  // shrinkWrap: true,
                  slivers: [
                    SliverPadding(
                      padding: const EdgeInsets.only(
                          bottom: 0, top: 0, left: 0, right: 0),
                      sliver: SliverToBoxAdapter(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: _sexList.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  onTap: () {
                                    // print(_placeList[index]);
                                    Navigator.of(context)
                                        .pop(_sexList[index]);
                                  },
                                  title: Text(_sexList[index], style: TextStyle(color: colors.primaryTextColor, ),),
                                );
                              },
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}



