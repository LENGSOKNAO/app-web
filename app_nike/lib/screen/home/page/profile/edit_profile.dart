import 'package:app_nike/data/user.dart';
import 'package:app_nike/screen/home/page/profile/util/pick_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final owner = userOwner.first;
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _hometownController;
  late TextEditingController _bioController;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController(text: owner.firstName);
    _lastNameController = TextEditingController(text: owner.lastName);
    _hometownController = TextEditingController(text: owner.address);
    _bioController = TextEditingController(text: owner.bio);
    _firstNameController.addListener(_checkChanges);
    _lastNameController.addListener(_checkChanges);
    _hometownController.addListener(_checkChanges);
    _bioController.addListener(_checkChanges);
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _hometownController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  Uint8List? _image;
  bool _isChanged = false;

  void selectProfile() async {
    Uint8List img = await pickImage(ImageSource.gallery);
    _image = img;
  }

  void _checkChanges() {
    final bool hasChanged =
        _firstNameController.text.trim() != owner.firstName.trim() ||
        _lastNameController.text.trim() != owner.lastName.trim() ||
        _hometownController.text.trim() != owner.address.trim() ||
        _bioController.text.trim() != owner.bio.trim() ||
        _image != null;

    if (hasChanged != _isChanged) {
      setState(() {
        _isChanged = hasChanged;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _bar(),
              SizedBox(height: 50.h),
              _profile(),
              SizedBox(height: 10.h),
              _edit(),
              SizedBox(height: 20.h),
              _name(),
              SizedBox(height: 50.h),
              _homeTown(),
              SizedBox(height: 50.h),
              _bio(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _bar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 18.sp,
                color: Colors.black,
              ),
            ),
          ),
          TextButton(
            onPressed: () {},
            child: Text(
              'Save',
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 18.sp,
                color: _isChanged ? Colors.black : Colors.grey.shade500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Align _profile() {
    return Align(
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(100.r),
        ),
        child: _image != null
            ? Image.memory(_image!, fit: BoxFit.cover)
            : owner.image.isNotEmpty
            ? Image.asset(owner.image, fit: BoxFit.cover)
            : Icon(Icons.camera_alt_sharp, color: Colors.white, size: 50),
      ),
    );
  }

  Widget _edit() {
    return GestureDetector(
      onTap: selectProfile,
      child: Text(
        'Edit',
        style: TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 14.sp,
          color: Colors.grey.shade500,
        ),
      ),
    );
  }

  Widget _name() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Name',
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 16.sp,
              color: Colors.grey.shade500,
            ),
          ),
          SizedBox(height: 5.h),
          TextField(
            controller: _firstNameController,
            decoration: InputDecoration(
              hintText: 'First Name',
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(5.r),
                  topRight: Radius.circular(5.r),
                ),
                borderSide: BorderSide(color: Colors.grey.shade500),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(5.r),
                  topRight: Radius.circular(5.r),
                ),
                borderSide: BorderSide(color: Colors.grey.shade500),
              ),
            ),
          ),
          TextField(
            controller: _lastNameController,
            decoration: InputDecoration(
              hintText: 'Last Name',
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(5.r),
                  bottomRight: Radius.circular(5.r),
                ),
                borderSide: BorderSide(color: Colors.grey.shade500),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(5.r),
                  bottomRight: Radius.circular(5.r),
                ),
                borderSide: BorderSide(color: Colors.grey.shade500),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _homeTown() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Hometown',
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 16.sp,
              color: Colors.grey.shade500,
            ),
          ),
          SizedBox(height: 5.h),
          TextField(
            controller: _hometownController,
            decoration: InputDecoration(
              hintText: 'Town/City, Country/Region',
              hintStyle: TextStyle(color: Colors.grey.shade500),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.r),
                borderSide: BorderSide(color: Colors.grey.shade500),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.r),
                borderSide: BorderSide(color: Colors.grey.shade500),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _bio() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Bio',
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 16.sp,
                  color: Colors.grey.shade500,
                ),
              ),
              Text(
                '0/150',
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 16.sp,
                  color: Colors.grey.shade500,
                ),
              ),
            ],
          ),
          SizedBox(height: 5.h),
          TextField(
            controller: _bioController,
            maxLines: 5,
            minLines: 5,
            decoration: InputDecoration(
              hintText: '150 characters',
              hintStyle: TextStyle(color: Colors.grey.shade500),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.r),
                borderSide: BorderSide(color: Colors.grey.shade500),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.r),
                borderSide: BorderSide(color: Colors.grey.shade500),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
