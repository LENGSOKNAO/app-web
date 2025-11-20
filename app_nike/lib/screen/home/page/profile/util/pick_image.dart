import 'package:image_picker/image_picker.dart';

pickImage(ImageSource source) async {
  final ImagePicker _pickImage = ImagePicker();
  XFile? _file = await _pickImage.pickImage(source: source);
  if (_file != null) {
    return await _file.readAsBytes();
  }
}
