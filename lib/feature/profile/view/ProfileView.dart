import 'dart:convert';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/feature/auth/view_models/auth_viewmodel.dart';
import 'package:todo/feature/home/views/home_view.dart';
import 'package:todo/feature/profile/models/profile_update_model.dart';
import 'package:todo/feature/profile/view/CamerView.dart';
import 'package:todo/feature/profile/view/widgets/GenderSelector.dart';
import 'package:todo/feature/profile/view_models/profile_view_model.dart';

class Profileview extends StatefulWidget {
  final String? imgPath;
  const Profileview({super.key, this.imgPath});

  @override
  State<Profileview> createState() => _ProfileviewState();
}

class _ProfileviewState extends State<Profileview> {
  final TextEditingController _userIdController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  String? _selectedPrefix;
  String _gender = '';

  String img = '';

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
      final user = authViewModel.user;
      _gender = user?.gender?? 'male';
      if (user != null) {
        setState(() {
          _userIdController.text = user.id.toString();
          _emailController.text = user.email;
          _firstNameController.text = user.firstName;
          _lastNameController.text = user.lastName;
       
        });
      }

       final profileViewModel =
        Provider.of<ProfileViewModel>(context, listen: false);
      void getImg() async {
        img = await profileViewModel.getProfilePic(user?.id ?? 1129);
      }
      getImg();
      
    });
  }

  @override
  void dispose() {
    super.dispose();
    _userIdController.dispose();
    _emailController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    final user = authViewModel.user;
    final profileViewModel =
        Provider.of<ProfileViewModel>(context, listen: false);


    ImageProvider getProfileImage() {
      if (widget.imgPath != null && widget.imgPath!.isNotEmpty) {
        return FileImage(File(widget.imgPath!));
      } else if (img.isNotEmpty) {
        return MemoryImage(base64Decode(img));
      } else if (user?.profilePic.isNotEmpty ?? false) {
        return NetworkImage(user!.profilePic);
      }
      return AssetImage('assets/default_profile_pic.png');
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              height: 250,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [Colors.blue, Colors.green],
                ),
              ),
            ),
            Positioned(
              top: 50,
              left: 10,
              right: 10,
              child: Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 20),
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color.fromARGB(255, 80, 101, 131),
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.arrow_circle_left_outlined,
                        size: 35,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => HomeView()),
                        );
                      },
                    ),
                  ),
                  SizedBox(width: 10),
                  Text("Edit Profile",
                      style: TextStyle(fontSize: 30, color: Colors.white)),
                  SizedBox(width: 100),
                  Container(
                    margin: EdgeInsets.only(left: 20),
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color.fromARGB(255, 80, 101, 131),
                    ),
                    child: Icon(
                      Icons.delete,
                      size: 20,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: 150,
                left: 20,
                right: 20,
              ),
              child: Container(
                padding: EdgeInsets.only(left: 10, right: 10, top: 80),
                width: double.infinity,
                height: 600,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _userIdController,
                              decoration: InputDecoration(labelText: 'UserID'),
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: _selectedPrefix,
                              onChanged: (String? newValue) {
                                setState(() {
                                  _selectedPrefix = newValue;
                                });
                              },
                              decoration: InputDecoration(labelText: 'Prefix'),
                              items:
                                  ['Mr.', 'Mrs.', 'Miss'].map((String prefix) {
                                return DropdownMenuItem<String>(
                                  value: prefix,
                                  child: Text(prefix),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _firstNameController,
                              decoration:
                                  InputDecoration(labelText: 'First Name'),
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: TextFormField(
                              controller: _lastNameController,
                              readOnly: false,
                              decoration:
                                  InputDecoration(labelText: 'Last Name'),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      // Email
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(labelText: 'Email'),
                        readOnly: false,
                      ),
                      const SizedBox(height: 20),


                      Row(
                        children: [
                          Text('Gender:', style: TextStyle(fontSize: 16)),
                          SizedBox(width: 20),
                          Row(
                            children: [
                              Radio<String>(
                                value: 'male',
                                groupValue: _gender,
                                onChanged: (String? value) {
                                  setState(() {
                                    _gender = value!;
                                  });
                                },
                                activeColor: _gender == 'male'
                                    ? Colors.green
                                    : Colors.grey,
                              ),
                              Text('Male'),
                            ],
                          ),
                          Row(
                            children: [
                              Radio<String>(
                                value: 'female',
                                groupValue: _gender,
                                onChanged: (String? value) {
                                  setState(() {
                                    _gender = value!;
                                  });
                                },
                                activeColor: _gender == 'female'
                                    ? Colors.green
                                    : Colors.grey,
                              ),
                              Text('Female'),
                            ],
                          ),
                        ],
                      ),
                      
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () async {
                          try {
                            final Map<String, String> profilePic =
                                await profileViewModel.convertImagePathToBase64(
                                    widget.imgPath ?? '');

                            if (user != null) {
                              final updatedUserProfileInfo = UserProfileRequest(
                                id: user.id,
                                gender: _gender,
                                email: _emailController.text,
                                profilePic: profilePic,
                                prefix: _selectedPrefix ?? "Mr.",
                                firstName: _firstNameController.text,
                                lastName: _lastNameController.text,
                              );
                              await profileViewModel.updateUserProfileWeb(
                                  updatedUserProfileInfo, context);
                            }
                          } catch (e) {
                            print("Error updating profile: $e");
                          }
                        },
                        child: Text('Update', style: TextStyle(fontSize: 15)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: 100,
              left: 150,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: getProfileImage(),
                          fit: BoxFit.cover,
                        )),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      alignment: Alignment.center,
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.green,
                      ),
                      child: IconButton(
                        onPressed: () async {
                          final camera = await cameraChoosing();
                          if (camera != null) {
                            if (!mounted) return;
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    TakePictureScreen(camera: camera),
                              ),
                            );
                          }
                        },
                        icon: Icon(Icons.edit),
                        iconSize: 17,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<CameraDescription?> cameraChoosing() async {
    try {
      WidgetsFlutterBinding.ensureInitialized();
      final cameras = await availableCameras();

      // Check if the front camera exists and select it
      CameraDescription? frontCamera;
      for (var camera in cameras) {
        if (camera.lensDirection == CameraLensDirection.front) {
          frontCamera = camera;
          break;
        }
      }

      // If no front camera found, fallback to rear camera
      if (frontCamera == null && cameras.isNotEmpty) {
        frontCamera = cameras.last; // Rear camera as fallback
      }

      if (frontCamera == null) {
        print("No camera available.");
        return null;
      }
      print("this is camera type $frontCamera");
      return frontCamera; // Return CameraDescription instead of CameraController
    } catch (e) {
      print("Error accessing camera: $e");
      return null;
    }
  }
}
