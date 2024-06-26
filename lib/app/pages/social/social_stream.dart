import 'package:babysteps/app/pages/social/social_database.dart';
import 'package:babysteps/app/widgets/social_widgets.dart';
import 'package:babysteps/main.dart';
import 'package:babysteps/model/baby.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:pdf/pdf.dart';
import 'package:rxdart/rxdart.dart';

class SocialStream extends StatefulWidget {
  const SocialStream({super.key});

  @override
  State<StatefulWidget> createState() => _SocialStreamState();
}

class _SocialStreamState extends State<SocialStream> {
  late var posts;

  Future<pw.Document> createMultiPdf(posts) async {
    final pw.Document pdf = pw.Document();
    //For loop over posts and turn them into pdf widgets
    late String userName;
    late DateTime date;
    late String? title;
    late String? caption;
    late String child;
    late String? imagePath;
    // late Image? networkImage;
    List<pw.Widget> widgets = [];

    for (var post in posts) {
      userName = post['usersName'];
      date = post['date'].toDate();
      title = post['title'] ?? '';
      caption = post['caption'] ?? '';
      child = (post['child'] as List).join(", ");
      imagePath = post['image'];
      //If there is no image since image is optional don't add it to pdf
      //annoying that I have to do this twice, may be able to clean up by making a widget?
      if (imagePath == null) {
        widgets.add(
          pw.Padding(
            padding: const pw.EdgeInsets.all(16),
            child: pw.Container(
              width: 500,
              height: 200,
              decoration: pw.BoxDecoration(
                  color: PdfColor.fromHex("#F2BB9B"),
                  borderRadius: pw.BorderRadius.circular(20)),
              child: pw.Column(
                children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(3),
                    child: pw.Text(userName,
                        style: pw.TextStyle(
                            fontSize: 10, color: PdfColor.fromHex("#0D4B5F")),
                        textAlign: pw.TextAlign.start),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(3),
                    child: pw.Text(child,
                        style: pw.TextStyle(
                            fontSize: 10, color: PdfColor.fromHex("#FFFAF1")),
                        textAlign: pw.TextAlign.start),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(3),
                    child: pw.Text(date.toString(),
                        style: pw.TextStyle(
                            fontSize: 10, color: PdfColor.fromHex("#4F646F")),
                        textAlign: pw.TextAlign.start),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(6),
                    child: pw.Text(title ?? '',
                        style: pw.TextStyle(
                            fontSize: 15, color: PdfColor.fromHex("#0D4B5F"))),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(6),
                    child: pw.Text(caption ?? '',
                        style: pw.TextStyle(
                            fontSize: 10, color: PdfColor.fromHex("#4F646F"))),
                  ),
                ],
              ),
            ),
          ),
        );
        //Otherwise add it to the pdf
      } else {
        // networkImage = Image.network(imagePath!);

        Uint8List bytes =
            (await NetworkAssetBundle(Uri.parse(imagePath)).load(imagePath))
                .buffer
                .asUint8List();

        widgets.add(
          pw.Padding(
            padding: const pw.EdgeInsets.all(5),
            child: pw.Container(
              width: 500,
              height: 200,
              decoration: pw.BoxDecoration(
                  color: PdfColor.fromHex("#F2BB9B"),
                  borderRadius: pw.BorderRadius.circular(20)),
              child: pw.Row(
                children: [
                  pw.Container(
                    height: 200,
                    width: 200,
                    decoration: pw.BoxDecoration(
                      image: pw.DecorationImage(
                        image: pw.MemoryImage(bytes),
                      ),
                      borderRadius: const pw.BorderRadius.only(
                          topLeft: pw.Radius.circular(10),
                          bottomLeft: pw.Radius.circular(10)),
                    ),
                  ),
                  pw.Container(
                    width: 280,
                    height: 200,
                    child: pw.Padding(
                      padding: const pw.EdgeInsets.all(10),
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(3),
                            child: pw.Text(userName,
                                style: pw.TextStyle(
                                    fontSize: 10,
                                    color: PdfColor.fromHex("#0D4B5F")),
                                textAlign: pw.TextAlign.start),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(3),
                            child: pw.Text(child,
                                style: pw.TextStyle(
                                    fontSize: 10,
                                    color: PdfColor.fromHex("#FFFAF1")),
                                textAlign: pw.TextAlign.start),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(3),
                            child: pw.Text(date.toString(),
                                style: pw.TextStyle(
                                    fontSize: 10,
                                    color: PdfColor.fromHex("#4F646F")),
                                textAlign: pw.TextAlign.start),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(3),
                            child: pw.Text(title ?? '',
                                style: pw.TextStyle(
                                    fontSize: 15,
                                    color: PdfColor.fromHex("#0D4B5F"))),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(3),
                            child: pw.Text(caption ?? '',
                                style: pw.TextStyle(
                                    fontSize: 10,
                                    color: PdfColor.fromHex("#4F646F"))),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          //  ),
        );
        // }
      }
    }
    //then add pages from the widgets list
    pdf.addPage(
      pw.MultiPage(
        maxPages: 1000,
        pageFormat: PdfPageFormat.a4,
        build: (context) => widgets, //here goes the widgets list
      ),
    );
    //TODO have a file picker pop up here
    if (!await FlutterFileDialog.isPickDirectorySupported()) {
      print("Picking directory not supported");
      return pdf;
    }

    final pickedDirectory = await FlutterFileDialog.pickDirectory();
    final bytes = await pdf.save();
    if (pickedDirectory != null) {
      final bytes = await pdf.save();
      FlutterFileDialog.saveFileToDirectory(
          directory: pickedDirectory,
          data: bytes,
          fileName: "$child.pdf",
          replace: true,
          mimeType: "application/pdf");
      // print(pickedDirectory);
      // print(bytes);
    }

    // final output = await getDownloadsDirectory();
    // print(output?.path);
    // var path = "${output?.path}/test.pdf";
    // final file = File(path);
    // await file.writeAsBytes(await pdf.save());
    return pdf;
  }

  @override
  Widget build(BuildContext context) {
    List<Stream<QuerySnapshot>> socialStreams = [];
    Stream<List<QuerySnapshot>> socialStream() {
      if (currentUser.value!.babies != null) {
        for (Baby baby in currentUser.value!.babies!) {
          socialStreams
              .add(SocialDatabaseMethods().getStream(baby.collectionId));
        }
      }
      return ZipStream(socialStreams, (values) => [...values]);
    }

    return StreamBuilder<List<QuerySnapshot>>(
      stream: socialStream(),
      builder:
          (BuildContext context, AsyncSnapshot<List<QuerySnapshot>> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading");
        }
        var postWidgets = List<Widget>.empty(growable: true);

        if (snapshot.data != null) {
          List<dynamic> postList = [];
          for (dynamic data in snapshot.data!) {
            postList.addAll(data.docs);
            // postList.add(data);
          }
          // posts = snapshot.data;
          // posts = snapshot.data!.docs;
          postList.sort((a, b) {
            return (b['date'] as Timestamp)
                .toDate()
                .compareTo((a['date'] as Timestamp).toDate());
          });

          posts = postList;

          for (QueryDocumentSnapshot post in posts) {
            String userName = post['usersName'];
            DateTime date = post['date'].toDate();
            String? title = post['title'];
            String? caption = post['caption'];
            List<dynamic> child = post['child'];
            List<dynamic> likes = post['likes'];
            String? imagePath = post['image'];

            postWidgets.add(Post(
              usersName: userName,
              timeStamp: date.toIso8601String(),
              childName: child.join(", "),
              title: title,
              caption: caption,
              image: imagePath,
              postDoc: post.id,
              likes: likes,
            ));
          }
        }

        return Column(children: [
          Column(
            children:
                postWidgets.isNotEmpty ? postWidgets : [const Text("no posts")],
          ),
          ElevatedButton(
              onPressed: () => createMultiPdf(posts),
              child: const Text("save to pdf"))
        ]);
      },
    );
  }
}
