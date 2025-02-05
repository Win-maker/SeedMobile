import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/feature/profile/view/ProfileView.dart';
import 'package:todo/feature/profile/view_models/profile_view_model.dart';

class TakePictureScreen extends StatefulWidget {
  const TakePictureScreen({
    super.key,
    required this.camera,
  });

  final CameraDescription camera;

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  late CameraDescription currentCamera;

  @override
  void initState() {
    super.initState();
    currentCamera = widget.camera; // Initialize with the given camera
    _initializeCamera(currentCamera);
  }

  // Initialize the camera controller with the selected camera
  void _initializeCamera(CameraDescription camera) {
    _controller = CameraController(
      camera,
      ResolutionPreset.high,
    );

    _initializeControllerFuture = _controller.initialize().then((_) {
      setState(() {}); // Rebuild when the camera is ready
    });
  }

  // Toggle between front and rear cameras
  void _toggleCamera() async {
    try {
      final cameras = await availableCameras();
      final currentCameraIndex =
          cameras.indexWhere((camera) => camera == currentCamera);

      // Find the next camera (toggle between front and back)
      CameraDescription newCamera;
      if (currentCameraIndex == -1 ||
          currentCameraIndex == cameras.length - 1) {
        newCamera = cameras.firstWhere(
            (camera) => camera.lensDirection == CameraLensDirection.front,
            orElse: () => cameras.last);
      } else {
        newCamera = cameras[(currentCameraIndex + 1) % cameras.length];
      }

      // If the camera changes, update the controller
      if (newCamera != currentCamera) {
        setState(() {
          currentCamera = newCamera;
        });
        _initializeCamera(newCamera);
      }
    } catch (e) {
      print("Error toggling camera: $e");
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profileViewModel = Provider.of<ProfileViewModel>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Take a picture')),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return CameraPreview(_controller);
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () async {
              try {
                await _initializeControllerFuture;
                final image = await _controller.takePicture();

                if (!context.mounted) return;

                File imageFile = File(image.path);

                String imgString = image.path;

                    await profileViewModel.updateProfilePic(imageFile, context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Profileview(
                            imgPath: imgString,
                          )),
                );
              } catch (e) {
                print(e);
              }
            },
            child: const Icon(Icons.camera_alt),
          ),
          SizedBox(height: 20),
          FloatingActionButton(
            onPressed: _toggleCamera,
            child: const Icon(Icons.switch_camera),
          ),
        ],
      ),
    );
  }
}
