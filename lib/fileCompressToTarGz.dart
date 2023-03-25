import 'dart:io';
import 'package:archive/archive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:tar/tar.dart';

class FileCompressor {
  //inputs
  //Send Source File
  //tarFileName with full path
  //output tarFile

  Future<File> convertToTar(File file, String tarFileName) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final bytes = await file.readAsBytes();
    final archive = Archive();
    final archiveFile = ArchiveFile(p.basename(file.path), bytes.length, bytes);
    archive.addFile(archiveFile);
    final encoder = TarEncoder();
    final tarData = encoder.encode(archive);
    final tarFile = File("${directory.path}/$tarFileName");
    await tarFile.writeAsBytes(tarData);

    return tarFile;
  }


  Future<File> compressTarToGz(File tarFile, String gzFileName) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    // Read the contents of the .tar file
    final bytes = await tarFile.readAsBytes();
    // Compress the contents of the .tar file using GZip
    final gzData = GZipEncoder().encode(bytes);
    // Write the compressed data to the new .gz file
    String gzFilePath = gzFileName; // name of the gz file
    File gzFile = File("${directory.path}/$gzFilePath");
    await gzFile.writeAsBytes(gzData!);

    return gzFile;
  }

  Future<File> createTarGzListFile(List<File> sourceFiles) async {
  final String sourceName = "mytransfile";
  final Directory destDir = await getApplicationDocumentsDirectory();
  final File destFile = File(p.join(destDir.path, '$sourceName.tar.gz'));

  // Create a new archive
  final Archive archive = Archive();

  // Add each file to the archive
  for (File sourceFile in sourceFiles) {
    final bytes = await sourceFile.readAsBytes();
    final archiveFile = ArchiveFile(p.basename(sourceFile.path), bytes.length, bytes);
    archive.addFile(archiveFile);
  }

  // Create a new TarEncoder object
  final tarEncoder = TarEncoder();

  // Encode the archive to the .tar file
  final tarData = tarEncoder.encode(archive);

  // Write the .tar data to a new file
  final tarFile = File(p.join(destDir.path, '$sourceName.tar'));
  await tarFile.writeAsBytes(tarData);

  // Create a new GZipEncoder object
  final gzipEncoder = GZipEncoder();

  // Encode the .tar file to the .tar.gz file
  final gzData = gzipEncoder.encode(await tarFile.readAsBytes());

  // Write the .tar.gz data to the new file
  await destFile.writeAsBytes(gzData!);

  return destFile;
}


  Future<File> createTarGzFile(File sourceFile) async {
    final Directory sourceDir = sourceFile.parent;
    final String sourceName = "866700047844343_TarExportFiles";
    final Directory destDir = await getApplicationDocumentsDirectory();
    final File destFile = File(p.join(destDir.path, '$sourceName.tar.gz'));

    // Create a new archive
    final Archive archive = Archive();

    // Add the file to the archive
    final bytes = await sourceFile.readAsBytes();
    final archiveFile =
        ArchiveFile(p.basename(sourceFile.path), bytes.length, bytes);
    archive.addFile(archiveFile);

    // Create a new TarEncoder object
    final tarEncoder = TarEncoder();

    // Encode the archive to the .tar file
    final tarData = tarEncoder.encode(archive);

    // Write the .tar data to a new file
    final tarFile = File(p.join(destDir.path, '$sourceName.tar'));
    await tarFile.writeAsBytes(tarData);

    // Create a new GZipEncoder object
    final gzipEncoder = GZipEncoder();

    // Encode the .tar file to the .tar.gz file
    final gzData = gzipEncoder.encode(await tarFile.readAsBytes());

    // Write the .tar.gz data to the new file
    await destFile.writeAsBytes(gzData!);

    // Delete the temporary directory
    // await destDir.delete(recursive: true);

    return destFile;
  }

  Future<File> createTarFile(File sourceFile, String tarFileName) async {
    try {
      final Directory directory = await getApplicationDocumentsDirectory();

      // Create a new archive
      Archive archive = Archive();

      // Read the contents of the source file
      List<int> bytes = await sourceFile.readAsBytes();

      // Add the file to the archive
      final archiveFile = ArchiveFile(sourceFile.path, bytes.length, bytes);
      archive.addFile(archiveFile);

      // Create a new .tar file
      String tarFilePath = tarFileName; // name of the tar file
      File tarFile = File("${directory.path}/$tarFilePath");

      // Create a new TarEncoder object
      TarEncoder tarEncoder = TarEncoder();

      // Encode the archive to the .tar file
      List<int> tarData = tarEncoder.encode(archive);

      // Write the .tar data to the new file
      await tarFile.writeAsBytes(tarData);

      print("Printing tar file path \n" + tarFile.path.toString());

      return tarFile;
    } catch (e) {
      print('Error creating tar file: $e');
      rethrow;
    }
  }

  Future<File> convertTarToGzip(File tarFile, String gzipFilePath) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    // Read the contents of the tar file into memory
    List<int> tarBytes = tarFile.readAsBytesSync();
    // Create a new GZipEncoder object
    GZipEncoder gzipEncoder = GZipEncoder();
    // Use the GZipEncoder to compress the tar file bytes
    List<int> gzipBytes = gzipEncoder.encode(tarBytes)!;
    // Write the compressed bytes to the output file
    File gzipFile = File("${directory.path}/$gzipFilePath");
    gzipFile.writeAsBytesSync(gzipBytes);
    // Return the compressed file

    return gzipFile;
  }
}
