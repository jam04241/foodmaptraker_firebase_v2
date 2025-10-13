import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:foodtracker_firebase/model/postUser.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:foodtracker_firebase/services/cloudinary_service.dart';
import 'package:foodtracker_firebase/services/database_service.dart';

class PostModal extends StatefulWidget {
  final TextEditingController postController;
  final String currentUserId;
  final String currentUserName;

  const PostModal({
    super.key,
    required this.postController,
    required this.currentUserId,
    required this.currentUserName,
  });

  @override
  State<PostModal> createState() => _PostModalState();
}

class _PostModalState extends State<PostModal> {
  final TextEditingController locationController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController restaurantController = TextEditingController();
  final CloudinaryService _cloudinaryService = CloudinaryService();
  final DatabaseService databaseService = DatabaseService();
  final FocusNode _restaurantFocusNode = FocusNode();

  Uint8List? _imageBytes;
  String? _imageName;
  int _rating = 0;
  bool _isLoading = false;

  // Restaurant search variables
  bool _showRestaurantSuggestions = false;
  List<Map<String, dynamic>> _restaurantData = [];
  List<Map<String, dynamic>> _filteredRestaurants = [];

  // Cloudinary Service
  final CloudinaryPublic _cloudinary = CloudinaryPublic(
    'ddxgbymvn',
    'Cloudinary_Foodpost',
    cache: false,
  );

  @override
  void initState() {
    super.initState();
    _restaurantFocusNode.addListener(_onRestaurantFocusChanged);
    _loadRestaurantData();
  }

  @override
  void dispose() {
    _restaurantFocusNode.removeListener(_onRestaurantFocusChanged);
    _restaurantFocusNode.dispose();
    locationController.dispose();
    descriptionController.dispose();
    restaurantController.dispose();
    super.dispose();
  }

  // Load restaurant data from Firestore
  Future<void> _loadRestaurantData() async {
    try {
      _debugLog('Loading restaurant data from Firestore...');
      final querySnapshot = await FirebaseFirestore.instance
          .collection('locations')
          .get();

      List<Map<String, dynamic>> restaurants = [];

      for (var doc in querySnapshot.docs) {
        final data = doc.data();
        final geoPoint = data['location'] as GeoPoint;

        restaurants.add({
          'id': doc.id,
          'foodName': data['foodName'] ?? 'Unknown',
          'foodCategory': data['foodCategory'] ?? 'Restaurant',
          'foodDescription':
              data['foodDescription'] ?? 'No description available',
          'latitude': geoPoint.latitude,
          'longitude': geoPoint.longitude,
        });
      }

      setState(() {
        _restaurantData = restaurants;
        _filteredRestaurants = restaurants;
      });
      _debugLog('Loaded ${restaurants.length} restaurants from Firestore');
    } catch (e) {
      _debugLog('Error loading restaurant data: $e');
    }
  }

  // Handle restaurant focus changes
  void _onRestaurantFocusChanged() {
    if (_restaurantFocusNode.hasFocus) {
      setState(() {
        _showRestaurantSuggestions = true;
      });
    } else {
      // Delay hiding so taps on suggestion list can register before the list disappears
      Future.delayed(const Duration(milliseconds: 150), () {
        if (mounted && !_restaurantFocusNode.hasFocus) {
          setState(() {
            _showRestaurantSuggestions = false;
          });
        }
      });
    }
  }

  // Filter restaurants based on search text
  void _filterRestaurants(String query) {
    if (query.isEmpty) {
      setState(() {
        _filteredRestaurants = _restaurantData;
      });
      return;
    }

    final filtered = _restaurantData.where((restaurant) {
      final name = restaurant['foodName'].toString().toLowerCase();
      final category = restaurant['foodCategory'].toString().toLowerCase();
      final searchLower = query.toLowerCase();

      return name.contains(searchLower) || category.contains(searchLower);
    }).toList();

    setState(() {
      _filteredRestaurants = filtered;
    });
  }

  // Select a restaurant from suggestions - fill restaurant only
  void _selectRestaurant(Map<String, dynamic> restaurant) {
    _debugLog('Selected restaurant: ${restaurant['foodName']}');

    final name = restaurant['foodName'] ?? '';
    restaurantController.text = name;
    restaurantController.selection = TextSelection.collapsed(
      offset: name.length,
    );

    setState(() {
      _showRestaurantSuggestions = false;
    });

    // Hide keyboard and remove focus
    _restaurantFocusNode.unfocus();

    _debugLog('Auto-filled restaurant: ${restaurantController.text}');
  }

  // Build restaurant suggestions list
  Widget _buildRestaurantSuggestions() {
    if (!_showRestaurantSuggestions) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.only(top: 8),
      decoration: BoxDecoration(
        color: const Color(0xff3a556e),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      constraints: const BoxConstraints(maxHeight: 200),
      child: _filteredRestaurants.isEmpty
          ? const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'No restaurants found',
                style: TextStyle(color: Colors.white70),
              ),
            )
          : ListView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.all(8),
              itemCount: _filteredRestaurants.length,
              itemBuilder: (context, index) {
                final restaurant = _filteredRestaurants[index];
                return GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTapDown: (_) {
                    _debugLog(
                      'Tapped on restaurant: ${restaurant['foodName']}',
                    );
                    _selectRestaurant(restaurant);
                  },
                  child: Material(
                    color: Colors.transparent,
                    child: ListTile(
                      leading: const Icon(
                        Icons.restaurant,
                        color: Colors.white70,
                      ),
                      title: Text(
                        restaurant['foodName'],
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                      subtitle: Text(
                        restaurant['foodCategory'],
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white70,
                        ),
                      ),
                      trailing: const Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: Colors.white70,
                      ),
                      // onTap intentionally omitted; onTapDown on parent captures early tap
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }

  // Debug logging function
  void _debugLog(String message) {
    if (kDebugMode) {
      print('🔥 POST_MODAL: $message');
    }
  }

  Future<void> pickPhoto() async {
    try {
      _debugLog('Starting image picker');
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );

      if (result != null && result.files.isNotEmpty) {
        _debugLog('Image selected: ${result.files.first.name}');
        setState(() {
          _imageBytes = result.files.first.bytes;
          _imageName = result.files.first.name;
        });
      } else {
        _debugLog('No image selected or selection cancelled');
      }
    } catch (e) {
      _debugLog('Error picking image: $e');
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error picking image: $e')));
      }
    }
  }

  Future<String?> _uploadImage() async {
    if (_imageBytes == null) {
      _debugLog('No image to upload');
      return null;
    }

    try {
      _debugLog('Starting image upload to Cloudinary');

      final uploadFuture = _cloudinaryService.uploadImageBytes(
        _imageBytes!,
        folder: 'cloudinary_foodpost',
      );

      final String imageUrl = await uploadFuture.timeout(
        const Duration(seconds: 20),
        onTimeout: () {
          throw TimeoutException(
            'Image upload timed out after 20 seconds. Please check your network connection.',
          );
        },
      );

      _debugLog('Cloudinary upload completed: $imageUrl');
      return imageUrl;
    } on TimeoutException catch (e) {
      _debugLog('Upload timeout: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.message ?? 'Upload timeout'),
            backgroundColor: Colors.orange,
            duration: const Duration(seconds: 5),
          ),
        );
      }
      return null;
    } catch (e) {
      _debugLog('Error uploading image to Cloudinary: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error uploading image: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return null;
    }
  }

  Future<void> _savePostToFirestore(String imageUrl) async {
    try {
      _debugLog('Starting Firestore save operation');
      final firestore = FirebaseFirestore.instance;
      final postsCollection = firestore.collection('posts');

      final postId = postsCollection.doc().id;
      _debugLog('Generated post ID: $postId');

      final postUser = PostUser(
        id: postId,
        description: descriptionController.text.trim(),
        location: locationController.text.trim(),
        rates: _rating.toString(),
        images: imageUrl,
        userId: widget.currentUserId,
        userName: widget.currentUserName,
        restaurantName: restaurantController.text.trim().isEmpty
            ? 'Restaurant'
            : restaurantController.text.trim(),
        timestamp: Timestamp.now(),
        isLiked: false,
        hearts: 0,
        likedBy: [],
        commentCount: 0,
      );

      _debugLog('Post data: ${postUser.toJson()}');
      await postsCollection.doc(postId).set(postUser.toJson());

      await databaseService.createPostNotification(
        username: widget.currentUserName,
      );

      _debugLog('Post successfully saved to Firestore');
    } catch (e) {
      _debugLog('Error saving to Firestore: $e');
      rethrow;
    }
  }

  Future<void> _createPost() async {
    if (descriptionController.text.trim().isEmpty) {
      _debugLog('Validation failed: Description is empty');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a description')),
      );
      return;
    }

    if (_rating == 0) {
      _debugLog('Validation failed: Rating is 0');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please provide a rating')));
      return;
    }

    setState(() {
      _isLoading = true;
    });

    _debugLog('Starting post creation process');

    try {
      _debugLog('Step 1: Uploading image to Cloudinary');
      String? imageUrl = await _uploadImage();
      _debugLog('Image upload result: $imageUrl');

      if (imageUrl == null) {
        _debugLog('Image upload failed or was cancelled');
        setState(() {
          _isLoading = false;
        });
        return;
      }

      _debugLog('Step 2: Saving to Firestore');
      await _savePostToFirestore(imageUrl);

      _debugLog('Step 3: Post created successfully');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Post created successfully!'),
            backgroundColor: Colors.green,
          ),
        );

        await Future.delayed(const Duration(milliseconds: 500));

        Navigator.pop(context);
        _resetForm();
      }
    } catch (e) {
      _debugLog('Error in _createPost: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to create post: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        _debugLog('Setting isLoading to false');
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _resetForm() {
    descriptionController.clear();
    locationController.clear();
    restaurantController.clear();
    setState(() {
      _rating = 0;
      _imageBytes = null;
      _imageName = null;
      _showRestaurantSuggestions = false;
    });
    _debugLog('Form reset');
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.7,
      minChildSize: 0.4,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Color(0xff2f4a5d),
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Create Post",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: _isLoading
                          ? null
                          : () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(16),
                  children: [
                    if (_imageBytes != null) ...[
                      Container(
                        height: 150,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          image: DecorationImage(
                            image: MemoryImage(_imageBytes!),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Stack(
                          children: [
                            Positioned(
                              top: 5,
                              right: 5,
                              child: IconButton(
                                icon: const Icon(
                                  Icons.close,
                                  color: Colors.white,
                                ),
                                onPressed: _isLoading
                                    ? null
                                    : () {
                                        setState(() {
                                          _imageBytes = null;
                                          _imageName = null;
                                        });
                                      },
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],

                    // Restaurant Name Field with suggestions
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextField(
                          controller: restaurantController,
                          focusNode: _restaurantFocusNode,
                          enabled: !_isLoading,
                          style: const TextStyle(color: Colors.white),
                          onChanged: _filterRestaurants,
                          onTap: () {
                            setState(() {
                              _showRestaurantSuggestions = true;
                            });
                          },
                          decoration: InputDecoration(
                            hintText: "Restaurant Name",
                            hintStyle: const TextStyle(color: Colors.white70),
                            prefixIcon: const Icon(
                              Icons.restaurant,
                              color: Colors.white70,
                            ),
                            filled: true,
                            fillColor: const Color(0xff3a556e),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: Color(0xff45607f),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: Color(0xff547792),
                              ),
                            ),
                          ),
                        ),
                        _buildRestaurantSuggestions(),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Post text
                    TextField(
                      controller: descriptionController,
                      maxLines: 5,
                      enabled: !_isLoading,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: "What's on your mind?",
                        hintStyle: const TextStyle(color: Colors.white70),
                        filled: true,
                        fillColor: const Color(0xff3a556e),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xff45607f),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xff547792),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Location field (auto-filled when restaurant is selected)
                    TextField(
                      controller: locationController,
                      enabled: !_isLoading,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: "Add Location",
                        hintStyle: const TextStyle(color: Colors.white70),
                        prefixIcon: const Icon(
                          Icons.location_on,
                          color: Colors.white70,
                        ),
                        filled: true,
                        fillColor: const Color(0xff3a556e),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xff45607f),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xff547792),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Ratings input
                    Row(
                      children: [
                        const Text(
                          "Rate:",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                        const SizedBox(width: 10),
                        Row(
                          children: List.generate(5, (index) {
                            return IconButton(
                              icon: Icon(
                                Icons.star,
                                color: index < _rating
                                    ? Colors.amber
                                    : Colors.grey,
                                size: 30,
                              ),
                              onPressed: _isLoading
                                  ? null
                                  : () {
                                      setState(() {
                                        _rating = index + 1;
                                      });
                                    },
                            );
                          }),
                        ),
                        Text(
                          _rating == 0 ? "" : "$_rating/5",
                          style: const TextStyle(
                            color: Colors.amber,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Image selection button
                    ElevatedButton.icon(
                      onPressed: _isLoading ? null : pickPhoto,
                      icon: const Icon(Icons.image),
                      label: Text(
                        _imageBytes == null ? "Add Photo" : "Change Photo",
                        style: const TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff547792),
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 50),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Debug info panel
                    if (kDebugMode)
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xff3a556e),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xff547792)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              children: [
                                Icon(
                                  Icons.bug_report,
                                  color: Colors.amber,
                                  size: 20,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  "Debug Info",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.amber,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Image: ${_imageBytes != null ? 'Selected' : 'Not selected'}",
                              style: const TextStyle(
                                fontSize: 10,
                                color: Colors.white70,
                              ),
                            ),
                            Text(
                              "Rating: $_rating/5",
                              style: const TextStyle(
                                fontSize: 10,
                                color: Colors.white70,
                              ),
                            ),
                            Text(
                              "Status: ${_isLoading ? 'Uploading...' : 'Ready'}",
                              style: const TextStyle(
                                fontSize: 10,
                                color: Colors.white70,
                              ),
                            ),
                            Text(
                              "Restaurants Loaded: ${_restaurantData.length}",
                              style: const TextStyle(
                                fontSize: 10,
                                color: Colors.white70,
                              ),
                            ),
                            Text(
                              "Restaurant Field: ${restaurantController.text}",
                              style: const TextStyle(
                                fontSize: 10,
                                color: Colors.white70,
                              ),
                            ),
                            Text(
                              "Location Field: ${locationController.text}",
                              style: const TextStyle(
                                fontSize: 10,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isLoading
                          ? const Color(0xff3a556e)
                          : const Color(0xff547792),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: _isLoading ? null : _createPost,
                    child: _isLoading
                        ? const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation(
                                    Colors.white,
                                  ),
                                ),
                              ),
                              SizedBox(width: 8),
                              Text(
                                "Posting...",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          )
                        : const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.cloud_upload, color: Colors.white),
                              SizedBox(width: 8),
                              Text(
                                "Post to Cloudinary",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
