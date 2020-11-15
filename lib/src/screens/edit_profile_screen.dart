import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../blocs/user_bloc.dart';
import '../providers/user_bloc_provider.dart';
import '../utils/navigator_util.dart';
import '../utils/snackbar_util.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return UserBlocProvider(
      child: ProfileBase(),
    );
  }
}

class ProfileBase extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Profile'),
      ),
      body: ProfileDetails(),
    );
  }
}

class ProfileDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    UserBloc _userBloc = UserBlocProvider.getUserBloc(context);
    SnackbarUtil _snackbarUtil = SnackbarUtil();
    _snackbarUtil.buildContextProfile = context;
    return ListView(
      children: <Widget>[
        Column(
          children: <Widget>[
            Stack(
              overflow: Overflow.visible,
              children: <Widget>[
                avatar(context, _userBloc),
              ],
            ),
            name(_userBloc),
            email(_userBloc),
            dob(context, _userBloc),
            contact(_userBloc),
            nextButton(context, _userBloc),
          ],
        ),
      ],
    );
  }

  Widget avatar(BuildContext context, UserBloc userBloc) {
    ImageProvider imageChild = AssetImage(
      'assets/avatar.png',
    );
    return GestureDetector(
      child: Padding(
        padding: const EdgeInsets.only(
          top: 40.0,
        ),
        child: Column(
          children: <Widget>[
            Center(
              child: Container(
                padding: EdgeInsets.all(4.0),
                decoration:
                    BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                child: Hero(
                  tag: 'user_image',
                  child: CircleAvatar(
                    backgroundImage: imageChild,
                    child: StreamBuilder(
                        stream: userBloc.image,
                        builder: (BuildContext context,
                            AsyncSnapshot<File> snapshot) {
                          if (snapshot.hasData) {
                            return CircleAvatar(
                              backgroundImage: imageChild,
                              radius: 70.0,
                              backgroundColor: Color.fromRGBO(247, 249, 249, 1),
                              child: ClipRRect(
                                borderRadius: new BorderRadius.circular(100.0),
                                child: Image.file(
                                  snapshot.data,
                                  fit: BoxFit.fill,
                                  matchTextDirection: true,
                                  filterQuality: FilterQuality.low,
                                  height: 140,
                                  width: 140,
                                ),
                              ),
                            );
                          } else {
                            if (userBloc.profileValue != null &&
                                userBloc.profileValue.isNotEmpty) {
                              imageChild = NetworkImage(userBloc.profileValue);
                            }
                            return CircleAvatar(
                              radius: 70.0,
                              backgroundColor: Color.fromRGBO(247, 249, 249, 1),
                              backgroundImage: imageChild,
                            );
                          }
                        }),
                    radius: 70.0,
                    backgroundColor: Color.fromRGBO(247, 249, 249, 1),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text('Edit Photo'),
            ),
          ],
        ),
      ),
      onTap: () {
        choosefromDialog(context, 'profile', userBloc);
      },
    );
  }

  Widget name(UserBloc userBloc) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 50.0,
        left: 20.0,
        right: 20.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            'Name',
            style: TextStyle(
              fontSize: 16.0,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 0.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Enter user name',
              ),
              style: TextStyle(
                fontSize: 12.0,
              ),
              controller: userBloc.nameController,
              onChanged: userBloc.updateUserName,
            ),
          ),
        ],
      ),
    );
  }

  Widget email(UserBloc userBloc) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 20.0,
        left: 20.0,
        right: 20.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            'Email',
            style: TextStyle(
              fontSize: 16.0,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 0.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Enter user email',
              ),
              style: TextStyle(
                fontSize: 12.0,
              ),
              controller: userBloc.emailController,
              onChanged: userBloc.updateEmail,
            ),
          ),
        ],
      ),
    );
  }

  Widget dob(BuildContext context, UserBloc userBloc) {
    return GestureDetector(
      child: StreamBuilder(
          stream: userBloc.dob,
          builder: (BuildContext context, AsyncSnapshot<String> dob) {
            Color textColor = Colors.grey;
            if (dob.hasData && dob.data.isNotEmpty) {
              textColor = Colors.black;
            }
            return Padding(
              padding: const EdgeInsets.only(
                top: 20.0,
                left: 20.0,
                right: 20.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    'Date of birth',
                    style: TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 15.0),
                    child: Text(
                      dob.hasData && dob.data.isNotEmpty
                          ? dob.data
                          : 'Click to select date',
                      style: TextStyle(
                        fontSize: 12.0,
                        color: textColor,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 10.0,
                      bottom: 10.0,
                    ),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 1.0,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
      onTap: () {
        userBloc.selectDate(context);
      },
    );
  }

  Widget contact(UserBloc userBloc) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 20.0,
        left: 20.0,
        right: 20.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            'Contact Number',
            style: TextStyle(
              fontSize: 16.0,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 0.0),
            child: TextField(
              readOnly: true,
              decoration: InputDecoration(
                hintText: 'Enter user contact number',
                counterText: "",
              ),
              style: TextStyle(
                fontSize: 12.0,
              ),
              maxLength: 10,
              controller: userBloc.mobileController,
              onChanged: userBloc.updateMobile,
            ),
          ),
        ],
      ),
    );
  }

  Widget nextButton(BuildContext context, UserBloc userBloc) {
    return GestureDetector(
      child: Padding(
        padding: const EdgeInsets.only(
          top: 40.0,
          bottom: 30.0,
          left: 20.0,
          right: 20.0,
        ),
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 80.0),
          decoration: BoxDecoration(
            color: Colors.lightBlueAccent,
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Save',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.0,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
        ),
      ),
      onTap: () async {
        bool isValid = await userBloc.saveProfile();
        if (isValid) {
          userBloc.updateProfileAPI(context);
        }
      },
    );
  }

  Future<void> choosefromDialog(
      BuildContext context, String title, UserBloc userBloc) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Choose document'),
          content: IntrinsicHeight(
            child: Column(
              children: <Widget>[
                GestureDetector(
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.image),
                        SizedBox(
                          width: 10.0,
                        ),
                        Expanded(
                          child: Text('Gallery'),
                        ),
                      ],
                    ),
                  ),
                  onTap: () => userBloc.updateImageFile(
                      context, ImageSource.gallery, title),
                ),
                GestureDetector(
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.camera),
                        SizedBox(
                          width: 10.0,
                        ),
                        Expanded(
                          child: Text('Camera'),
                        ),
                      ],
                    ),
                  ),
                  onTap: () => userBloc.updateImageFile(
                      context, ImageSource.camera, title),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
