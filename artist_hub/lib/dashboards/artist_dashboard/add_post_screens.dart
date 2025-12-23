import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../shared/constants/app_colors.dart';

class AddPostScreens extends StatefulWidget {
  final int artistId;

  const AddPostScreens({Key? key, required this.artistId}) : super(key: key);

  @override
  _AddPostScreensState createState() => _AddPostScreensState();
}

class _AddPostScreensState extends State<AddPostScreens> {
  final ImagePicker _picker = ImagePicker();
  File? _selectedImage;
  File? _selectedVideo;
  String _caption = '';
  String _location = '';
  List<String> _selectedHashtags = [];
  final TextEditingController _hashtagController = TextEditingController();
  double _aspectRatio = 1.0;

  // Available hashtags
  final List<String> _availableHashtags = [
    '#art', '#painting', '#digitalart', '#sketch',
    '#design', '#illustration', '#creative', '#artist',
    '#drawing', '#watercolor', '#portrait', '#abstract'
  ];

  // Pick image from gallery
  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );

    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
        _selectedVideo = null;
        _aspectRatio = 1.0;
      });
    }
  }

  // Pick video from gallery
  Future<void> _pickVideo() async {
    final XFile? video = await _picker.pickVideo(
      source: ImageSource.gallery,
    );

    if (video != null) {
      setState(() {
        _selectedVideo = File(video.path);
        _selectedImage = null;
        _aspectRatio = 16 / 9;
      });
    }
  }

  // Add hashtag
  void _addHashtag(String hashtag) {
    if (!_selectedHashtags.contains(hashtag)) {
      setState(() {
        _selectedHashtags.add(hashtag);
      });
    }
  }

  // Remove hashtag
  void _removeHashtag(String hashtag) {
    setState(() {
      _selectedHashtags.remove(hashtag);
    });
  }

  // Clear all selections
  void _clearSelection() {
    setState(() {
      _selectedImage = null;
      _selectedVideo = null;
      _caption = '';
      _location = '';
      _selectedHashtags.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: AppColors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'New Post',
          style: TextStyle(
            color: AppColors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        actions: [
          if (_selectedImage != null || _selectedVideo != null)
            TextButton(
              onPressed: () {},
              child: Text(
                'Share',
                style: TextStyle(
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Media Preview Section
            _buildMediaPreview(),

            // Divider
            Container(
              height: 8,
              color: AppColors.grey100,
            ),

            // Caption Section
            _buildCaptionSection(),

            // Location Section
            _buildLocationSection(),

            // Hashtags Section
            _buildHashtagsSection(),

            // Suggested Hashtags
            _buildSuggestedHashtags(),

            // Divider
            Container(
              height: 8,
              color: AppColors.grey100,
            ),

            // Advanced Options
            _buildAdvancedOptions(),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          border: Border(
            top: BorderSide(
              color: AppColors.grey200,
              width: 1,
            ),
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Media Type Buttons
            Row(
              children: [
                IconButton(
                  onPressed: _pickImage,
                  icon: Icon(
                    Icons.photo_library_outlined,
                    color: AppColors.primaryColor,
                  ),
                  tooltip: 'Add Photos',
                ),
                IconButton(
                  onPressed: _pickVideo,
                  icon: Icon(
                    Icons.videocam_outlined,
                    color: AppColors.primaryColor,
                  ),
                  tooltip: 'Add Video',
                ),
              ],
            ),

            // Clear Button
            if (_selectedImage != null || _selectedVideo != null)
              TextButton(
                onPressed: _clearSelection,
                child: Text(
                  'Clear',
                  style: TextStyle(
                    color: AppColors.error,
                    fontSize: 16,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildMediaPreview() {
    return Container(
      height: MediaQuery.of(context).size.width,
      color: AppColors.black12,
      child: Stack(
        children: [
          // Media Preview
          if (_selectedImage != null)
            Image.file(
              _selectedImage!,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
            )
          else if (_selectedVideo != null)
            Container(
              color: AppColors.black,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.videocam,
                      color: AppColors.white,
                      size: 80,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Video Selected',
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            _buildEmptyMediaPreview(),

          // Change Media Button
          if (_selectedImage != null || _selectedVideo != null)
            Positioned(
              bottom: 20,
              right: 20,
              child: FloatingActionButton.small(
                backgroundColor: AppColors.black.withOpacity(0.7),
                onPressed: _pickImage,
                child: Icon(Icons.edit, color: AppColors.white, size: 20),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildEmptyMediaPreview() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            gradient: AppColors.buttonGradient,
            shape: BoxShape.circle,
            boxShadow: AppColors.buttonShadow,
          ),
          child: Icon(
            Icons.add_photo_alternate_outlined,
            color: AppColors.white,
            size: 50,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'Add to your post',
          style: TextStyle(
            color: AppColors.grey800,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'Photos, videos, and more',
          style: TextStyle(
            color: AppColors.grey500,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 30),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Gallery Button
            Container(
              decoration: BoxDecoration(
                gradient: AppColors.blueGradient,
                borderRadius: BorderRadius.circular(25),
                boxShadow: AppColors.buttonShadow,
              ),
              child: ElevatedButton.icon(
                onPressed: _pickImage,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  foregroundColor: AppColors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                ),
                icon: Icon(Icons.photo_library, size: 20),
                label: Text('Gallery'),
              ),
            ),
            const SizedBox(width: 15),

            // Camera Button
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.primaryColor),
                borderRadius: BorderRadius.circular(25),
              ),
              child: OutlinedButton.icon(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primaryColor,
                  side: BorderSide(color: AppColors.primaryColor),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                ),
                icon: Icon(Icons.camera_alt, size: 20),
                label: Text('Camera'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCaptionSection() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  gradient: AppColors.purplePinkGradient,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.purple.withOpacity(0.3),
                      blurRadius: 8,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Icon(
                  Icons.person,
                  color: AppColors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Your Artist Profile',
                  style: TextStyle(
                    color: AppColors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              color: AppColors.grey500,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.grey200),
            ),
            child: TextField(
              onChanged: (value) => _caption = value,
              controller: TextEditingController(text: _caption),
              decoration: InputDecoration(
                hintText: "What's on your mind?",
                hintStyle: TextStyle(color: AppColors.grey500),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.all(16),
              ),
              maxLines: 4,
              style: TextStyle(
                color: AppColors.black,
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.grey100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${_caption.length}/2200',
                style: TextStyle(
                  color: AppColors.grey600,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.grey200),
        ),
        child: ListTile(
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primaryColor, AppColors.accent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.location_on_outlined,
              color: AppColors.white,
              size: 20,
            ),
          ),
          title: TextField(
            onChanged: (value) => _location = value,
            controller: TextEditingController(text: _location),
            decoration: InputDecoration(
              hintText: 'Add location',
              hintStyle: TextStyle(color: AppColors.grey500),
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
            ),
            style: TextStyle(
              color: AppColors.black,
              fontSize: 16,
            ),
          ),
          trailing: Icon(
            Icons.arrow_drop_down,
            color: AppColors.grey500,
          ),
        ),
      ),
    );
  }

  Widget _buildHashtagsSection() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.tag,
                color: AppColors.primaryColor,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Hashtags',
                style: TextStyle(
                  color: AppColors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          if (_selectedHashtags.isNotEmpty)
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _selectedHashtags.map((hashtag) {
                return Container(
                  decoration: BoxDecoration(
                    gradient: AppColors.blueGradient,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryColor.withOpacity(0.2),
                        blurRadius: 4,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Chip(
                    label: Text(hashtag),
                    backgroundColor: Colors.transparent,
                    deleteIcon: Icon(
                      Icons.close,
                      size: 16,
                      color: AppColors.white,
                    ),
                    onDeleted: () => _removeHashtag(hashtag),
                    labelStyle: TextStyle(
                      color: AppColors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }).toList(),
            )
          else
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.grey500,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.grey200,),
              ),
              child: Center(
                child: Text(
                  'Add hashtags to reach more people',
                  style: TextStyle(
                    color: AppColors.grey500,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSuggestedHashtags() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Popular Hashtags',
            style: TextStyle(
              color: AppColors.grey700,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _availableHashtags.map((hashtag) {
              return ChoiceChip(
                label: Text(
                  hashtag,
                  style: TextStyle(
                    fontSize: 13,
                    color: _selectedHashtags.contains(hashtag)
                        ? AppColors.white
                        : AppColors.primaryColor,
                  ),
                ),
                selected: _selectedHashtags.contains(hashtag),
                onSelected: (selected) {
                  if (selected) {
                    _addHashtag(hashtag);
                  } else {
                    _removeHashtag(hashtag);
                  }
                },
                selectedColor: AppColors.primaryColor,
                backgroundColor: AppColors.grey100,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(
                    color: _selectedHashtags.contains(hashtag)
                        ? AppColors.primaryColor
                        : AppColors.grey300,
                  ),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildAdvancedOptions() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'More Options',
            style: TextStyle(
              color: AppColors.grey700,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 12),

          // Tag People
          _buildOptionTile(
            icon: Icons.people_outline,
            title: 'Tag People',
            subtitle: 'Tag friends in your post',
            color: Colors.blue,
          ),

          // Add Fundraiser
          _buildOptionTile(
            icon: Icons.volunteer_activism_outlined,
            title: 'Add Fundraiser',
            subtitle: 'Support a cause',
            color: Colors.green,
          ),

          // Feeling/Activity
          _buildOptionTile(
            icon: Icons.emoji_emotions_outlined,
            title: 'Feeling/Activity',
            subtitle: 'Share how you\'re feeling',
            color: Colors.orange,
          ),

          // Check In
          _buildOptionTile(
            icon: Icons.pin_drop_outlined,
            title: 'Check In',
            subtitle: 'Share your location',
            color: Colors.red,
          ),
        ],
      ),
    );
  }

  Widget _buildOptionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.grey200),
        boxShadow: AppColors.cardShadow,
      ),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        title: Text(
          title,
          style: TextStyle(
            color: AppColors.black,
            fontWeight: FontWeight.w500,
            fontSize: 15,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            color: AppColors.grey500,
            fontSize: 12,
          ),
        ),
        trailing: Icon(
          Icons.chevron_right,
          color: AppColors.grey400,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      ),
    );
  }

  @override
  void dispose() {
    _hashtagController.dispose();
    super.dispose();
  }
}