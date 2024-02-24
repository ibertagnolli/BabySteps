import 'package:babysteps/app/pages/social/social_database.dart';
import 'package:babysteps/app/widgets/social_widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';

class SocialStream extends StatefulWidget {
  const SocialStream({super.key});

  @override
  State<StatefulWidget> createState() => _SocialStreamState();
}

class _SocialStreamState extends State<SocialStream> {
  final Stream<QuerySnapshot> _socialStream =
      SocialDatabaseMethods().getStream();
  //final pw.Document pdf = pw.Document();
  //late var pdf;
  late var posts;


Future<pw.Document> createPdf(userName, date, child, caption, title, imagePath) async {
  final pw.Document pdf = pw.Document();
  //Image image = Image.file(File(imagePath));
    final page = pw.Page(
      pageFormat: PdfPageFormat.a4,
      build: (pw.Context context) {
        return pw.Column(
          children: [
            pw.Text(userName),
            pw.Text(date.toString()),
            pw.Text(child),
            //pw.Text(caption!),
            pw.Text(title!),
            //pw.Image(image as pw.ImageProvider),
          ],
        );
      },
    );
    pdf.addPage(page);
    return pdf;
  }



Future<pw.Document> createMultiPdf(posts) async {
  final pw.Document pdf = pw.Document();
  //Image image = Image.file(File(imagePath));
   late String userName;
   late DateTime date;
   late String? title;
   late String? caption;
   late String child;
   late String? imagePath;

  print(posts);
   for (var post in posts) {
            userName = post['usersName'];
             date = post['date'].toDate();
             title = post['title'];
             caption = post['caption'];
             child = post['child'];
             imagePath = post['image'];
    //pdf.editPage(index, page)
    pdf.addPage(
      pw.Page(
      pageFormat: PdfPageFormat.a4,
      build: (pw.Context context) {
        return pw.Column(
          children: [
            pw.Text(userName),
            pw.Text(date.toString()),
            pw.Text(child),
            pw.Text(caption!),
            pw.Text(title!),
            //pw.Image(image as pw.ImageProvider),
          ],
        );
      },
    ),
    );
    //pdf.addPage(page);
    print(Page);
   }
    pw.Document save_pdf = await pdf;
    final output = await getTemporaryDirectory();
    var path = "${output.path}/test.pdf";
    final file = File(path);
    await file.writeAsBytes(await save_pdf.save());
    return pdf;
}

// Future<void> savePdf(pdf) async{
//      // Save file
//     pw.Document save_pdf = await pdf;
//     final output = await getTemporaryDirectory();
//     var path = "${output.path}/test.pdf";
//     final file = File(path);
//     await file.writeAsBytes(await save_pdf.save());
// }
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _socialStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading");
        }
        var postWidgets = List<Widget>.empty(growable: true);

        if (snapshot.data != null) {
          posts = snapshot.data!.docs;

          for (var post in posts) {
            String userName = post['usersName'];
            DateTime date = post['date'].toDate();
            String? title = post['title'];
            String? caption = post['caption'];
            String child = post['child'];
            String? imagePath = post['image'];

            postWidgets.add(Post(
              usersName: userName,
              timeStamp: date.toIso8601String(),
              childName: child,
              title: title,
              caption: caption,
              image: imagePath,
            ));
          }
        
        }

        return Column(
            children: [
              Column( children: postWidgets.isNotEmpty
                ? postWidgets
                : [const Text("no posts")],),
                ElevatedButton(onPressed: () => createMultiPdf(posts), child: const Text("save to pdf"))]);
      },


    );
  }
}
