import 'dart:io';
import 'package:exif/exif.dart';
import 'package:image/image.dart' as img;

class ImageConvert {
  Future<File> fixExifRotation(String imagePath) async {
    final originalFile = File(imagePath);
    var imageBytes = await originalFile.readAsBytes();

    final originalImage = img.decodeImage(imageBytes);

    final exifData = await readExifFromBytes(imageBytes);

    if (exifData['Image Orientation'] == null) {
      return originalFile;
    }
    final fixedImage = img.copyRotate(originalImage!, angle: 0);
    // Here you can select whether you'd like to save it as png
    // or jpg with some compression
    // I choose jpg with 100% quality
    final fixedFile =
        await originalFile.writeAsBytes(img.encodeJpg(fixedImage));

    return fixedFile;
  }
}
