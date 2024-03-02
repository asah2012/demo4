import 'dart:convert' show utf8;
import 'dart:typed_data';
import 'package:file_selector/file_selector.dart';
import 'package:barcode/barcode.dart' as barcode;
import 'package:flutter/material.dart';
//import 'package:barcode/barcode.dart';
import 'package:barcode_widget/barcode_widget.dart' as barcode_widget;

class Barcode extends StatefulWidget {
  const Barcode({super.key});

  @override
  State<Barcode> createState() => _BarcodeState();
}

class _BarcodeState extends State<Barcode> {
  final myController = TextEditingController();
  String barcodeData = "TQC";
  // Label Size Type is in height , width format
  final List<List<double>> labelSizeTypes = [
    [100, 100],
    [100, 40],
    [40, 40],
    [20, 20]
  ];
  double height = 100;
  double width = 100;

  List<double> selectedLabelSize = [];

  var barcodeTypes = {
    "code128": barcode_widget.Barcode.code128(),
    "code39": barcode_widget.Barcode.code39(),
    "qr_code": barcode_widget.Barcode.qrCode()
  };
  var selectedBarcodeKey = "";
  @override
  void initState() {
    super.initState();
    setState(() {
      selectedBarcodeKey = barcodeTypes.keys.first;
      selectedLabelSize = labelSizeTypes[0];
    });

    //Call below function when system wants to read each input
    //myController.addListener(_callBarcodeGenerator);
  }

  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }

  Future<void> _callBarcodeGenerator() async {
    final text = myController.text;
    print("Text is (${myController.text})");
    //final barcode_data = barcode_widget.Barcode.fromType(barcodeTypes[selectedBarcodeKey] as barcode_widget.Barcode);
    final barcodeType = barcodeTypes[selectedBarcodeKey];
    final barcode_svg = barcodeType?.toSvg(text,width : selectedLabelSize[1],height : selectedLabelSize[0]);

    final location = await getSaveLocation();
    final file = XFile.fromData(Uint8List.fromList(utf8.encode(barcode_svg!)),
    name: 'barcode.svg',
    mimeType: 'image/svg+xml',);
    await file.saveTo(location?.path ??'/');
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Expanded(
            flex: 2,
            child: Row(
              children: [
                const Expanded(
                  flex: 2,
                  child: SizedBox(),
                ),
                Expanded(
                    flex: 15,
                    child: Card(
                      color: Theme.of(context).colorScheme.inversePrimary,
                      child: TextField(
                        controller: myController,
                        decoration: const InputDecoration(
                            hintText: "Type Value", labelText: "Type value"),
                        style: TextStyle(color: Theme.of(context).primaryColor),
                        onChanged: (value) {
                          setState(() {
                            barcodeData = myController.text;
                          });
                        },
                        //onSubmitted: (text){print("The value is $text");},
                      ),
                    )),
                const Expanded(
                  flex: 2,
                  child: SizedBox(),
                ),
                Expanded(
                  flex: 10,
                  child: Card(
                    color: Theme.of(context).colorScheme.inversePrimary,
                    child: barcode_widget.BarcodeWidget(
                      barcode: barcodeTypes[selectedBarcodeKey] ??
                          barcodeTypes.values.first,
                      data: barcodeData, // Content
                      height: selectedLabelSize.elementAt(0),
                      width: selectedLabelSize.elementAt(1),
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.primary),
                    ),
                  ),
                ),
                const Expanded(
                  flex: 2,
                  child: SizedBox(),
                ),
              ],
            ),
          ),
          const Expanded(
            flex: 2,
            child: SizedBox(),
          ),
          Row(
            children: [
              const Expanded(
                flex: 3,
                child: SizedBox(),
              ),
              Expanded(
                flex: 4,
                child: DropdownButton<String>(
                  value: selectedBarcodeKey,
                  items: barcodeTypes.entries.map<DropdownMenuItem<String>>(
                      (MapEntry<String, barcode_widget.Barcode> entry) {
                    return DropdownMenuItem<String>(
                      value: entry.key,
                      child: Text(entry.key),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedBarcodeKey = value ?? selectedBarcodeKey;
                    });
                  },
                  //dropdownColor: Theme.of(context).colorScheme.inversePrimary,
                ),
              ),
              const Expanded(
                flex: 3,
                child: SizedBox(),
              ),
              Expanded(
                flex: 4,
                child: DropdownButton<List<double>>(
                  //value: ("${selectedLabelSize.elementAt(0).toString()} X ${selectedLabelSize.elementAt(1).toString()}") ,
                  value: selectedLabelSize,
                  items: labelSizeTypes.map<DropdownMenuItem<List<double>>>(
                      (List<double> entry) {
                    return DropdownMenuItem<List<double>>(
                      value: entry,
                      child: Text("${entry[0]} X ${entry[1]}"),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedLabelSize = value ?? selectedLabelSize;
                    });
                  },
                  //dropdownColor: Theme.of(context).colorScheme.inversePrimary,
                ),
              ),
              const Expanded(
                flex: 3,
                child: SizedBox(),
              ),
              Expanded(
                  flex: 6,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      _callBarcodeGenerator();
                    },
                    icon: const Icon(Icons.download),
                    label: const Text("Download"),
                  )),
              const Expanded(
                flex: 4,
                child: SizedBox(),
              ),
            ],
          ),
          const Expanded(
            flex: 3,
            child: SizedBox(),
          ),
        ],
      ),
    );
  }
}
