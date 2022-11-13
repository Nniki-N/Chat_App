import 'package:camera/camera.dart';
import 'package:chat_app/ui/utils/app_constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

enum CameraState {
  initial,
  inProcess,
  done,
}

class CameraCubit extends Cubit<CameraState> {
  late CameraController _cameraController;
  late Future<void> _initializeControllerFuture;

  CameraController get cameraController => _cameraController;
  Future<void> get initializeControllerFuture async =>
      _initializeControllerFuture;

  CameraDescription camera = cameras[0];
  bool _pictureIsTaken = false;
  XFile? _image;

  bool get pictureIsTaken => _pictureIsTaken;
  XFile? get image => _image;

  CameraCubit() : super(CameraState.initial) {
    _initialize();
  }

  Future<void> _initialize() async {
    emit(CameraState.inProcess);

    _cameraController = CameraController(
      camera,
      ResolutionPreset.high,
    );

    _initializeControllerFuture = _cameraController.initialize();

    emit(CameraState.done);
  }

  // take picture
  Future<void> takePicture() async {
    try {
      emit(CameraState.inProcess);

      await _initializeControllerFuture;
      await _cameraController.setFlashMode(FlashMode.off);

      _image = await _cameraController.takePicture();

      _pictureIsTaken = true;
      emit(CameraState.done);
    } on CameraException {
      emit(CameraState.done);
    }
  }

  // select picture from gallery
  Future<void> choosePictureFromGallery() async {
    emit(CameraState.inProcess);

    final imagePicker = ImagePicker();

    _image = await imagePicker.pickImage(source: ImageSource.gallery);
    _pictureIsTaken = true;

    emit(CameraState.done);
  }

  // switch camera between front-view and back-view
  void swithcCamera() {
    emit(CameraState.inProcess);

    if (camera == cameras[0]) {
      camera = cameras[1];
    } else if (camera == cameras[1]) {
      camera = cameras[0];
    }

    emit(CameraState.done);
  }

  // cancel sending photo
  void cancelSending() {
    emit(CameraState.inProcess);

    _image = null;
    _pictureIsTaken = false;

    emit(CameraState.done);
  }

  @override
  Future<void> close() async {
    _cameraController.dispose();
    return super.close();
  }
}
