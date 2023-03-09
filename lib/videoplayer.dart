import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerScreen extends StatefulWidget {
  final String videoUrl;
  final String title;

  VideoPlayerScreen({required this.videoUrl, required this.title, });

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;
  late List<QueryDocumentSnapshot> videos;
  late List<QueryDocumentSnapshot> filteredVideos;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    filteredVideos = [];
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl);
    _initializeVideoPlayerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    searchController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset : false,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Video Player"),
            SizedBox(height: 4),
           
          ],
        ),

      ),
      body: FutureBuilder(
        future: _initializeVideoPlayerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Column(
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
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.50,
                  child: AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  ),
                ),
                SizedBox(height: 10,),
                Text(widget.title,style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),),
                SizedBox(height: 15,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      onPressed: () {
                        // Add your like functionality here
                      },
                      icon: Icon(Icons.thumb_up),
                    ),
                    IconButton(
                      onPressed: () {
                        // Add your share functionality here
                      },
                      icon: Icon(Icons.share),
                    ),
                    IconButton(
                      onPressed: () {
                        // Add your comments functionality here
                      },
                      icon: Icon(Icons.comment),
                    ),
                  ],
                ),
                TextField(
                  maxLines: null,
                  decoration: InputDecoration(
                    hintText: 'Write a comment...',
                    border: OutlineInputBorder(),
                  ),
                ),

              ],
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            if (_controller.value.isPlaying) {
              _controller.pause();
            } else {
              _controller.play();
            }
          });
        },
        child: Icon(
          _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
        ),
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
