import 'package:catfact/models/catFact.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CatsFactPage extends StatefulWidget {
  const CatsFactPage({Key? key}) : super(key: key);

  @override
  State<CatsFactPage> createState() => _CatsFactPageState();
}

class _CatsFactPageState extends State<CatsFactPage> {
  
  @override
  Widget build(BuildContext context) {
    


    var _catsFactProvider = Provider.of<CatFactModel>(context, listen: true);
    refreshFactFuture() => Future.wait([
              _catsFactProvider.fetchRandomFact(),
              _catsFactProvider.fetchCatImageUrl(),
              _catsFactProvider.fetchCatImage(),
    ]);
    var refreshFact = refreshFactFuture();

    Future<void> _showMyDialog() async {
      return showDialog<void>(
        context: context,
        barrierDismissible: true, 
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Fact Info'),
            content:  SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  const Text(
                    "API Fact Response:",
                     style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(_catsFactProvider.apiResponse),
                  const Text(
                    "Image Url:",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(_catsFactProvider.imageUrl),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Close'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }

    return Consumer<CatFactModel>(
      builder: (context, catFactModel, child) {
      
        return Scaffold(
          backgroundColor: Colors.black38,
        appBar: AppBar(
          actions: [
            IconButton(
              color: Colors.white,
              icon: const Icon(Icons.info),
              onPressed: () {
                _showMyDialog();
              },
            ),],
          backgroundColor: Colors.deepPurple,          
          title: const Text('Cats Fact'),
        ),
        body: FutureBuilder(
          future: refreshFact,
          builder: (context, snapshotList) {
            
            if (snapshotList.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }else if (snapshotList.hasError) {
              return Center(child: Text('Error: ${snapshotList.error}'));
            }
            return Stack(
              children: [
                Center(child: Image.memory(
                    _catsFactProvider.imageBytes,
                    errorBuilder: (context, error, stackTrace) => const Text(''),
                    height: double.infinity,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    
                  )),
                Center(child: Text(
                  _catsFactProvider.fact,
                  softWrap: true,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        blurRadius: 10.0,
                        color: Colors.black,
                      ),
                    ],
                  ),
                  )),
              ],
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.refresh),
          onPressed: () {
            setState(() {
              refreshFact = refreshFactFuture();
            });
          }),
        );
      }
    );
  }
}

