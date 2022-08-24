import 'package:cached_network_image_builder/cached_network_image_builder.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:srtm/Widget/ShowFile.dart';
import 'package:provider/provider.dart';
import '../Services/googleDriveApi.dart';
import '../Widget/FullScreenImage.dart';
import '../providers/app_provider.dart';

class Ads extends StatefulWidget {
  final List<dynamic> ads;
  final bool deleteMode;
  const Ads({
    Key? key,
    required this.ads,
    required this.deleteMode,
  }) : super(key: key);

  @override
  State<Ads> createState() => _AdsState();
}

class _AdsState extends State<Ads> {
  late AppProvider _appProvider;
  
  List<PlatformFile> files = [];

  @override
  void initState() {
    super.initState();
  }

  void _download(url) async {
    _appProvider = Provider.of<AppProvider>(context, listen: false);

    await GoogleDriveService(appProvider: _appProvider).download(url);
  }

  _deleteFile(String fileId, BuildContext context) async {
    _appProvider = Provider.of<AppProvider>(context, listen: false);
    _appProvider.showLoading();
    await GoogleDriveService(appProvider: _appProvider)
        .delFiles(fileId: fileId, context: context)
        .then((value) => {
              if (value!.statusCode == 204)
                {
                  _appProvider.removeFile(fileId),
                  _appProvider.setdeleteOption(res: false),
                  Navigator.of(context).pop(),
                  _appProvider.hideLoading(),
                }
            })
        .catchError((err) => {
              showError(err, context),
            });
  }

  showError(err, ctx) {
    showDialog<String>(
      context: ctx,
      builder: (BuildContext context) => AlertDialog(
        title: const Icon(
          Icons.error_outline,
          color: Colors.red,
          size: 36.0,
        ),
        content: Text('$err'),
        actions: <Widget>[
          TextButton(
            onPressed: () => {
              _appProvider.hideLoading(),
              Navigator.pop(context),
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  showAlert(BuildContext context, id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('SUPPRESSION'),
          content: const Text("Êtes-vous sûr de vouloir supprimer?"),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  child: const Text("OUI"),
                  onPressed: () {
                    //Put your code here which you want to execute on Yes button click.
                    _deleteFile(id, context);
                  },
                ),
                TextButton(
                  child: const Text("ANNULER"),
                  style: TextButton.styleFrom(
                    primary: Colors.red,
                  ),
                  onPressed: () {
                    //Put your code here which you want to execute on Cancel button click.
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  showImage(BuildContext context, image) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: GestureDetector(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.height * 0.7,
              child: Hero(
                tag: image['name'],
                child: Image.network(
                  image['thumbnailLink']
                      .substring(0, image['thumbnailLink'].indexOf("=")),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          actions: <Widget>[],
        );
      },
    );
  }
    void openFiles(List<PlatformFile> files) {
    Showfile(files: files);
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          childAspectRatio: 1,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10),
      itemCount: widget.ads.length+1,
      itemBuilder: ((context, index) {
        if (index == 0) {
          return Card(
              child:   Center(
                child:  IconButton(
                        icon: const Icon(Icons.add),
                        tooltip: 'Add new Ads',
                        onPressed: () async {
                          final result = await FilePicker.platform
                  .pickFiles( type: FileType.image);
              if (result == null) return;
              files = result.files;
              openFiles(files);
              Navigator.pushNamed(context, "/showSelectedFile",
                  arguments: files);
                        },
                      ),
              ),
          );
        } else {
          var imageUrl = widget.ads[index-1]['thumbnailLink']
              .substring(0, widget.ads[index-1]['thumbnailLink'].indexOf('='));
          return GestureDetector(
            onTap: () => {
              //   _download(widget.ads[index]['webViewLink']),
              //  Navigator.pushNamed(context, '/image'),
              /*   Navigator.push(context, MaterialPageRoute(builder: (_) {
              return FullScreenImage(
                image: widget.ads[index],
              );
            })),
            */
              showImage(context, widget.ads[index-1]),
            },
            child: index == 0
                ? const Card(
                    child: Text("new card"),
                  )
                : Card(
                    elevation: 4.0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0)),
                    clipBehavior: Clip.antiAlias,
             
                    child: Stack(children: [
             

                      Container(
                        child: FadeInImage.assetNetwork(
                          alignment: Alignment.topCenter,
                          placeholder: 'assets/images/loadingImage.gif',
                          image: imageUrl,

                          fit: BoxFit.fill,
                          width: double.maxFinite,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: RichText(
                              overflow: TextOverflow.ellipsis,
                              strutStyle: const StrutStyle(fontSize: 12.0),
                              text: TextSpan(
                                  style: const TextStyle(
                                      color: Colors.black,
                                      backgroundColor: Colors.grey),
                                  text: widget.ads[index-1]['name']),
                            ),
                          ),
                           IconButton(
                                  icon: const Icon(Icons.delete),
                                  color: Colors.red,
                                  onPressed: () {
                                    showAlert(context, widget.ads[index-1]['id']);
                                  })
                        ],
                      ),
                    ]),
                  ),
          );
        }
      }),
    );
/*
    GridView.count(
      crossAxisCount: 5,
      children: List.generate(widget.ads.length + 1, (index) {
        var imageUrl = widget.ads[index]['thumbnailLink']
            .substring(0, widget.ads[index]['thumbnailLink'].indexOf('='));
        return GestureDetector(
          onTap: () => {
            //   _download(widget.ads[index]['webViewLink']),
            //  Navigator.pushNamed(context, '/image'),
            /*   Navigator.push(context, MaterialPageRoute(builder: (_) {
              return FullScreenImage(
                image: widget.ads[index],
              );
            })),
            */
            showImage(context, widget.ads[index]),
          },
          child: index == 0
              ? Card(
                  child: Text("new card"),
                )
              : Card(
                  elevation: 4.0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0)),
                  clipBehavior: Clip.antiAlias,
                  /*  shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),*/
                  child: Stack(children: [
                    /*   Ink.image(
                image: NetworkImage(
                  widget.ads[index]['thumbnailLink'],
                ),
                fit: BoxFit.cover,
              ),*/

                    Container(
                      child: FadeInImage.assetNetwork(
                        alignment: Alignment.topCenter,
                        placeholder: 'assets/images/loadingImage.gif',
                        image: imageUrl,

                        fit: BoxFit.fill,
                        width: double.maxFinite,
                        //  height: 210,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: RichText(
                            overflow: TextOverflow.ellipsis,
                            strutStyle: const StrutStyle(fontSize: 12.0),
                            text: TextSpan(
                                style: const TextStyle(
                                    color: Colors.black,
                                    backgroundColor: Colors.grey),
                                text: widget.ads[index]['name']),
                          ),
                        ),
                        widget.deleteMode
                            ? IconButton(
                                icon: const Icon(Icons.delete),
                                color: Colors.red,
                                onPressed: () {
                                  showAlert(context, widget.ads[index]['id']);
                                })
                            : const Text("")
                      ],
                    ),
                  ]),
                ),
        );
      }),
    );*/
  }
}
