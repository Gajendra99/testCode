class PrinterConnection{
  final BluePrintPos _bluePrintPos = BluePrintPos.instance;
  List<BlueDevice> _blueDevices = <BlueDevice>[];
  BlueDevice? _selectedDevice;
  _isLoading = false.obs;
  int _loadingAtIndex = -1;
  var isBluetooth = false.obs;
  var isLocation = false.obs;

  //bluetooth connectivity
  checkConnectivity()async{
    var status = await Permission.bluetooth.status;
if (status.isGranted) {
  isBluetooth(true);
} else {
  isBluetooth(false);
  status = await Permission.bluetooth.request();
  if (status.isGranted) {
    isBluetooth(true);
  } else {
    isBluetooth(false);
  }
}

//location permission
var status = await Permission.location.status;
if (status.isGranted) {
  isLocation(true);
} else {
  isLocation(false);
  status = await Permission.location.request();
  if (status.isGranted) {
    isLocation(true);
  } else {
    isLocation(false);
  }
}

  }

  //initialize printer

  //scan devices //_onScanPressed
  Future<void> scanDevices() async {
    checkConnectivity();
    if(isBluetooth && isLocation){
    _isLoading(true);
    _bluePrintPos.scan().then((List<BlueDevice> devices) {
      if (devices.isNotEmpty) {
          _blueDevices = devices;
          _isLoading(false);
      } else {
        _isLoading(false);
      }
    });
    }else{
      //Show Alert To get permission for bluetooth and location
    }
  }

  //Disconnect printer
  void _onDisconnectDevice() {
    _bluePrintPos.disconnect().then((ConnectionStatus status) {
      if (status == ConnectionStatus.disconnect) {        
          _selectedDevice = null;        
      }
    });
  }

  //select printer
  void selectPrinter(int index) {
    
      if(isBluetooth && isLocation){
      _isLoading(true);
      _loadingAtIndex = index;
    
    final BlueDevice blueDevice = _blueDevices[index];
    _bluePrintPos.connect(blueDevice).then((ConnectionStatus status) {
      if (status == ConnectionStatus.connected) {
        _selectedDevice = blueDevice;
      } else if (status == ConnectionStatus.timeout) {
        _onDisconnectDevice();
      } else {
        print('$runtimeType - something wrong');
      }
      _isLoading(false);
    });
      }
      else{
        //ask for both permissions
      }
  }

  //print through printer
  Future<void> printRecipt(dynamic printData) async {
    if(isBluetooth && isLocation){
      final ReceiptSectionText receiptText = ReceiptSectionText();
      if(printData is String){
        List<String> myList = printData.split('\n');
        //Now data is converted to list string ......perform task on it
      }else{
        //if Data is in other format
      }
    receiptText.addText(
      'Bluetooth Printer Works!',
      size: ReceiptTextSizeType.medium,
      style: ReceiptTextStyleType.bold,
    );
    await _bluePrintPos.printReceiptText(receiptText);
    }else{
      //ask for both premissions
    }
    
  }
}
