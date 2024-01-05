part of 'attendance_face_bloc.dart';

abstract class AttendanceFaceEvent {}

class AttendanceByFaceEvent extends AttendanceFaceEvent {
  final List<File>? files;
  AttendanceByFaceEvent({this.files});
}
