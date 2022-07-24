import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:bluetooth_thermal_printer/bluetooth_thermal_printer.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart' show ByteData, rootBundle;
import 'package:image/image.dart' as img;
import 'package:image/image.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pnpdict/src/services/Session.dart';
import 'package:qr_flutter/qr_flutter.dart';

class PrinterFunctions {
  final formatter = new NumberFormat("#,##0.00#", "en_US");

  Future<void> testPrintTicket() async {
    String isConnected = await BluetoothThermalPrinter.connectionStatus;
    List<String> driverDetails = await Session.getListDriverDetails();
    List<String> violations = await Session.getListViolations();
    List<String> vehicleDetails = await Session.getListVehicleDetails();
    print(isConnected);
    if (isConnected == "true") {
      Ticket ticket = await getTestTicketFormat(driverDetails, vehicleDetails, violations);
      await BluetoothThermalPrinter.writeBytes(ticket.bytes);
    }
  }

  Future<Ticket> getTestTicketFormat(List<String> driverDetails, List<String> vehicleDetails, List<String> violations) async {
    CapabilityProfile profile = await CapabilityProfile.load();
    final Ticket ticket = Ticket(PaperSize.mm58, profile);

    final ByteData bytes = await rootBundle.load('assets/images/pnplogo.png');
    final Uint8List uList = bytes.buffer.asUint8List();
    final img.Image testImage = img.decodeImage(uList);
    ticket.image(img.copyResize(testImage, width: 120));


    ticket.text("Philippine",
      styles: PosStyles(
        align: PosAlign.center,
        height: PosTextSize.size1,
        width: PosTextSize.size2,
        bold: true
      ),
    );

    ticket.text("National",
      styles: PosStyles(
          align: PosAlign.center,
          height: PosTextSize.size1,
          width: PosTextSize.size2,
          bold: true
      ),
    );

    ticket.text("Police",
      styles: PosStyles(
          align: PosAlign.center,
          height: PosTextSize.size1,
          width: PosTextSize.size2,
          bold: true
      ),
    );

    ticket.text(" ",
      styles: PosStyles(
        align: PosAlign.center,
      ),
    );

    ticket.text("Traffic Ticket Violation",
      styles: PosStyles(
        align: PosAlign.center,
      ),
    );

    ticket.text(" ",
      styles: PosStyles(
        align: PosAlign.center,
      ),
    );

    ticket.hr(ch: '=');

    ticket.text("TEMPORARY",
      styles: PosStyles(
        align: PosAlign.center,
        height: PosTextSize.size1,
        width: PosTextSize.size2,
          bold: true
      ),
    );

    ticket.text("OPERATORS",
      styles: PosStyles(
          align: PosAlign.center,
          height: PosTextSize.size1,
          width: PosTextSize.size2,
          bold: true
      ),
    );

    ticket.text("PERMIT (TOP)",
      styles: PosStyles(
        align: PosAlign.center,
        height: PosTextSize.size1,
        width: PosTextSize.size2,
          bold: true
      ),
    );

    ticket.hr(ch: '=');

    ticket.text("DRIVER DETAILS",
      styles: PosStyles(
          align: PosAlign.center,
          height: PosTextSize.size1,
          width: PosTextSize.size2,
          bold: true
      ),
    );
    ticket.text(" ",
      styles: PosStyles(
        align: PosAlign.center,
      ),
    );

    ticket.text("Ticket No.",
      styles: PosStyles(
        align: PosAlign.left,
      ),
    );
    ticket.text("  "+new Random().nextInt(10000000).toString(),
      styles: PosStyles(
        align: PosAlign.left,
          bold: true
      ),
    );

    ticket.text("Driver's Name",
      styles: PosStyles(
        align: PosAlign.left,
      ),
    );
    ticket.text("  "+driverDetails[0],
      styles: PosStyles(
        align: PosAlign.left,
          bold: true
      ),
    );

    ticket.text("Address",
      styles: PosStyles(
        align: PosAlign.left,
      ),
    );
    ticket.text("  "+driverDetails[1],
      styles: PosStyles(
        align: PosAlign.left,
          bold: true
      ),
    );

    ticket.text("Driver's License No.",
      styles: PosStyles(
        align: PosAlign.left,
      ),
    );
    ticket.text("  "+driverDetails[2],
      styles: PosStyles(
        align: PosAlign.left,
          bold: true
      ),
    );

    ticket.text("Type",
      styles: PosStyles(
        align: PosAlign.left,
      ),
    );
    ticket.text("  "+driverDetails[3],
      styles: PosStyles(
        align: PosAlign.left,
          bold: true
      ),
    );

    ticket.text("Expiration Date",
      styles: PosStyles(
        align: PosAlign.left,
      ),
    );
    ticket.text("  "+driverDetails[4],
      styles: PosStyles(
        align: PosAlign.left,
          bold: true
      ),
    );

    ticket.hr(ch: '-');

    ticket.text("VEHICLE DETAILS",
      styles: PosStyles(
          align: PosAlign.center,
          height: PosTextSize.size1,
          width: PosTextSize.size2,
          bold: true
      ),
    );
    ticket.text(" ",
      styles: PosStyles(
        align: PosAlign.center,
      ),
    );

    ticket.text("Plate No.",
      styles: PosStyles(
        align: PosAlign.left,
      ),
    );
    ticket.text("  "+vehicleDetails[0],
      styles: PosStyles(
          align: PosAlign.left,
          bold: true
      ),
    );

    ticket.text("Make and Type",
      styles: PosStyles(
        align: PosAlign.left,
      ),
    );
    ticket.text("  "+vehicleDetails[1],
      styles: PosStyles(
          align: PosAlign.left,
          bold: true
      ),
    );

    ticket.text("Engine No",
      styles: PosStyles(
        align: PosAlign.left,
      ),
    );
    ticket.text("  "+vehicleDetails[2],
      styles: PosStyles(
          align: PosAlign.left,
          bold: true
      ),
    );

    ticket.text("Chassis No",
      styles: PosStyles(
        align: PosAlign.left,
      ),
    );
    ticket.text("  "+vehicleDetails[3],
      styles: PosStyles(
          align: PosAlign.left,
          height: PosTextSize.size1,
          width: PosTextSize.size1,
          bold: true
      ),
    );

    ticket.text("Registered Owner",
      styles: PosStyles(
        align: PosAlign.left,
      ),
    );
    ticket.text("  "+vehicleDetails[4],
      styles: PosStyles(
          align: PosAlign.left,
          height: PosTextSize.size1,
          width: PosTextSize.size1,
          bold: true
      ),
    );

    ticket.text("Registered Until",
      styles: PosStyles(
        align: PosAlign.left,
      ),
    );
    ticket.text("  "+vehicleDetails[5],
      styles: PosStyles(
          align: PosAlign.left,
          height: PosTextSize.size1,
          width: PosTextSize.size1,
          bold: true
      ),
    );

    ticket.hr(ch: '-');

    ticket.text("VIOLATIONS",
      styles: PosStyles(
          align: PosAlign.center,
          height: PosTextSize.size1,
          width: PosTextSize.size2,
          bold: true
      ),
    );
    ticket.text(" ",
      styles: PosStyles(
        align: PosAlign.center,
      ),
    );

    double total  = 0;
    for(String strViolations in violations){
      total += 1000;
      ticket.row([
        PosColumn(
          text: formatter.format(1000),
          width: 4,
          //styles: PosStyles(align: PosAlign.center),
        ),

        PosColumn(
          text: strViolations,
          width: 8,
          // styles: PosStyles(align: PosAlign.center),
        ),
      ]);
    }

    ticket.row([
      PosColumn(
        text: formatter.format(total),
        width: 4,
        styles: PosStyles(bold: true),
      ),

      PosColumn(
        text: 'TOTAL',
        width: 8,
        styles: PosStyles(bold: true),
      ),
    ]);

    ticket.hr(ch: '-');

    ticket.text("PAYMENT LINK",
      styles: PosStyles(
          align: PosAlign.center,
          height: PosTextSize.size1,
          width: PosTextSize.size2,
          bold: true
      ),
    );

    ticket.text(" ",
      styles: PosStyles(
        align: PosAlign.center,
      ),
    );

    ticket.text("For your convenience and safety, kindly scan the QR below to pay via online transaction.",
      styles: PosStyles(
          align: PosAlign.left,
          bold: true
      ),
    );

    ticket.text(" ",
      styles: PosStyles(
        align: PosAlign.center,
      ),
    );


    try {
      const String qrData = 'https://www.xendit.co/en/';
      const double qrSize = 200;
      final uiImg = await QrPainter(
        data: qrData,
        version: QrVersions.auto,
        gapless: false,
      ).toImageData(qrSize);
      final dir = await getTemporaryDirectory();
      final pathName = '${dir.path}/qr_tmp.png';
      final qrFile = File(pathName);
      final imgFile = await qrFile.writeAsBytes(uiImg.buffer.asUint8List());
      final img = decodeImage(imgFile.readAsBytesSync());

      ticket.image(img);
    } catch (e) {
      print(e);
    }
    // ticket.qrcode('example.com');
    ticket.text(" ",
      styles: PosStyles(
        align: PosAlign.center,
      ),
    );

    ticket.hr(ch: '-');

    ticket.text(" ",
      styles: PosStyles(
        align: PosAlign.center,
      ),
    );

    ticket.text(" ",
      styles: PosStyles(
        align: PosAlign.center,
      ),
    );

    ticket.text(" ",
      styles: PosStyles(
        align: PosAlign.center,
      ),
    );

    ticket.text("____________________________",
      styles: PosStyles(
        align: PosAlign.center,
      ),
    );
    ticket.text("PO3 Ranchito Ernest Salunga",
      styles: PosStyles(
        align: PosAlign.center,
        bold: true,
      ),
    );
    ticket.text("Apprehending Officer",
      styles: PosStyles(
        align: PosAlign.center,

      ),
    );

    ticket.text(" ",
      styles: PosStyles(
        align: PosAlign.center,
      ),
    );

    ticket.text(" ",
      styles: PosStyles(
        align: PosAlign.center,
      ),
    );

    ticket.text("Please make sure to drive safely Your safety is our Priority.",
      styles: PosStyles(
          align: PosAlign.left,
          bold: true
      ),
    );

    ticket.text(" ",
      styles: PosStyles(
        align: PosAlign.center,
      ),
    );


    ticket.cut();
    return ticket;
  }

  Future<bool> connectPrinterAutomatic() async {
    bool result = false;

    String isConnected = await BluetoothThermalPrinter.connectionStatus;
    List blueTooths = await BluetoothThermalPrinter.getBluetooths;
    //print("Print $bluetooths");


    if(isConnected == "true"){
      //print("printer connected");
      result = true;
    } else {
      if(blueTooths.length == 0){
        result = false;
      } else {
        for(int i = 0; i < blueTooths.length; i++){
          String select = blueTooths[i].toString();
          String lowerCaseSelect = select.toLowerCase();
          //print(select);
          if(lowerCaseSelect.contains("printer") || lowerCaseSelect.contains("rpp") || lowerCaseSelect.contains("mtp")){
            List list = select.split("#");
            String mac = list[1];
            //print("Mac => " + mac);
            bool status = await setConnect(mac);
            if(status){
              result = true;
              break;
            }
          }

        }
      }

    }

    return result;
  }

  Future<bool> setConnect(String mac) async {
    String result = await BluetoothThermalPrinter.connect(mac);
    //print("state connected $result");
    if (result == "true") {
      return true;
      //connected = true;
    } else {
      return false;
      //connected = false;
    }
  }
}