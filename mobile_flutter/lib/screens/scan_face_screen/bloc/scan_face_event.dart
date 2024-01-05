part of 'scan_face_bloc.dart';

abstract class ScanFaceEvent {}

class RegisterFaceEvent extends ScanFaceEvent {
  final File? video;
  RegisterFaceEvent({required this.video});
}
