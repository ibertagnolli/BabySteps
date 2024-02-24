import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:babysteps/app/pages/social/social_database.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';

class PdfCreator {
    createPdf(AsyncSnapshot<QuerySnapshot> snapshot) async {
    var posts = snapshot.data!.docs;
    late String userName;
    late DateTime date;
    late String? title;
    late String? caption;
    late String child;
    late String? imagePath;

    for (var post in posts) {
      userName = post['usersName'];
      date = post['date'].toDate();
      title = post['title'];
      caption = post['caption'];
      child = post['child'];
      imagePath = post['image'];
    }
    final pw.Document pdf = pw.Document();
    final page = pw.Page(
      pageFormat: PdfPageFormat.a4,
      build: (pw.Context context) {
        return pw.Column(
          children: [
            pw.Text(userName),
            pw.Text(date.toString()),
            pw.Text(child),
            pw.Text(caption!),
            pw.Text(title!),
            pw.Image(imagePath as pw.ImageProvider),
          ],
        );
      },
    );
    pdf.addPage(page);
    // Save file
    final output = await getTemporaryDirectory();
    var path = "${output.path}/test.pdf";
    final file = File(path);
    await file.writeAsBytes(await pdf.save());
  }
}
