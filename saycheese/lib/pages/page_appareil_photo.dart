import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';
import '../main.dart';

class PageAppareilPhoto extends StatefulWidget {
  const PageAppareilPhoto({Key? key}) : super(key: key);

  @override
  State<PageAppareilPhoto> createState() => _PageAppareilPhotoState();
}

class _PageAppareilPhotoState extends State<PageAppareilPhoto>
    with WidgetsBindingObserver {
  CameraController? controller;
  bool _isCameraInitialized = false;
  bool _isCameraPermissionGranted = false;

  void onNewCameraSelected(CameraDescription cameraDescription) async {
    final previousCameraController = controller;
    // Instantiating the camera controller
    final CameraController cameraController = CameraController(
      cameraDescription,
      ResolutionPreset.high,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );

    // Dispose the previous controller
    await previousCameraController?.dispose();

    // Replace with the new controller
    if (mounted) {
      setState(() {
        controller = cameraController;
      });
    }

    // Update UI if controller updated
    cameraController.addListener(() {
      if (mounted) setState(() {});
    });

    // Initialize controller
    try {
      await cameraController.initialize();
    } on CameraException catch (e) {
      print('Error initializing camera: $e');
    }

    // Update the Boolean
    if (mounted) {
      setState(() {
        _isCameraInitialized = controller!.value.isInitialized;
      });
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController? cameraController = controller;

    // App state changed before we got the chance to initialize.
    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      // Free up memory when camera not active
      cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      // Reinitialize the camera with same properties
      onNewCameraSelected(cameraController.description);
    }
  }

  getPermissionStatus() async {
    await Permission.camera.request();
    var status = await Permission.camera.status;
    if (status.isGranted) {
      setState(() {
        _isCameraPermissionGranted = true;
      });
      // Set and initialize the new camera
      onNewCameraSelected(cameras[0]);
      //refreshAlreadyCapturedImages();
    } else {
      debugPrint('Camera Permission: DENIED');
    }
  }

  @override
  void initState() {
    getPermissionStatus();
    super.initState();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _isCameraPermissionGranted
            ? _isCameraInitialized
                ? AspectRatio(
                    aspectRatio: 1 / controller!.value.aspectRatio,
                    child: controller!.buildPreview(),
                  )
                : Container()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(),
                  Text(
                    'Permission denied',
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      getPermissionStatus();
                    },
                    child: Text('Give permission'),
                  ),
                ],
              ));
  }
}
