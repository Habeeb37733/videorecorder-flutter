import 'dart:typed_data';

import 'package:betodds/videoplayer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import 'homepge.dart';


class VideoList extends StatefulWidget {
  static const String routeName = "Video List";

  @override
  _VideoListState createState() => _VideoListState();
}

class _VideoListState extends State<VideoList> {
  late List<QueryDocumentSnapshot> videos;
  late List<QueryDocumentSnapshot> filteredVideos;

  TextEditingController searchController = TextEditingController();


  @override
  void initState() {
    super.initState();
    filteredVideos = [];

  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: Colors.white70,
      appBar: AppBar(
        title: Text("Video List"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: "Search Videos",
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    _filterVideos();
                  },
                ),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('Videos').snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text('Something went wrong');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                videos = snapshot.data!.docs;
                filteredVideos = videos;
                return GridView.builder(
                  padding: EdgeInsets.all(10),
                  itemCount: filteredVideos.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    mainAxisSpacing: 10,
                    childAspectRatio: 1.5,
                  ),
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      child: Column(
                        children: [
                          FutureBuilder<Uint8List?>(
                            future: VideoThumbnail.thumbnailData(
                              video: filteredVideos[index]["Video URL"],
                              imageFormat: ImageFormat.JPEG,
                              maxWidth: 100,
                              quality: 25,
                            ),
                            builder: (BuildContext context, AsyncSnapshot<Uint8List?> snapshot) {
                              if (snapshot.connectionState == ConnectionState.done &&
                                  snapshot.data != null) {
                                return SizedBox(
                                  height: MediaQuery.of(context).size.height * 0.2,
                                  width: MediaQuery.of(context).size.width ,
                                  child:Image.memory(snapshot.data!) ,
                                );
                              } else {
                                return Container();
                              }
                            },
                          ),
                          SizedBox(height: 10),
                          Text(
                            filteredVideos[index]["title"],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Divider(
                            height: 50,
                            thickness: 5,
                          ),
                        ],
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => VideoPlayerScreen(
                              videoUrl: filteredVideos[index]["Video URL"],
                              title: filteredVideos[index]["title"],
                            ),
                          ),
                        );
                      },
                    );

                  },
                );
              },
            ),
          ),

        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => VideoCapture()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _filterVideos() {
    String searchText = searchController.text;
    if (searchText.isNotEmpty) {
      setState(() {
        filteredVideos = videos.where((video) => video["title"].toLowerCase().contains(searchText.toLowerCase())).toList();
      });
    } else {
      setState(() {
        filteredVideos = videos;
      });
    }
  }
}
