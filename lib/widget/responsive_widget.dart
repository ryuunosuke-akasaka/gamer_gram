import 'package:flutter/material.dart';
import 'package:gamer_gram/providers/user_provider.dart';
import 'package:gamer_gram/util/global_variable.dart';
import 'package:provider/provider.dart';

class ResponsiveWidget extends StatefulWidget {
  final Widget webScreenLayout;
  final Widget mobileScreenLayout;
  const ResponsiveWidget({Key? key,required this.webScreenLayout, required this.mobileScreenLayout,}) : super(key: key);

  @override
  State<ResponsiveWidget> createState() => _ResponsiveWidgetState();
}

class _ResponsiveWidgetState extends State<ResponsiveWidget> {

  @override
  void initState() {
    super.initState();
    addData();
  }


  addData() async{
    UserProvider _userProvider = Provider.of(context, listen: false);
    await _userProvider.refreshUser();
  }


  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (context, constraints){
          if(constraints.maxWidth > webScreenSize){
            return widget.webScreenLayout;
          }
          return widget.mobileScreenLayout;
        });
  }
}
