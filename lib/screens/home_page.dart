import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:tablet_tabak/main.dart';
import 'package:tablet_tabak/theme/colors/light_colors.dart';
import 'package:http/http.dart' as http;
import 'package:styled_widget/styled_widget.dart';

class Order {
  final int id;
  final String productId;
  final int quantity;
  final String orderDate;
  final String deliveryStatusName;
  final String? deliveryDate;
  final int userId;
  final String? remark;
  final int supplierId;
  final String? ordered;
  final int status;
  final int? weight;
  final String price;
  final String createdAt;
  final String updatedAt;
  final String productName;
  final String productNumber;

  Order({
    required this.id,
    required this.productId,
    required this.quantity,
    required this.orderDate,
    required this.deliveryStatusName,
    this.deliveryDate,
    required this.userId,
    this.remark,
    required this.supplierId,
    this.ordered,
    required this.status,
    this.weight,
    required this.price,
    required this.createdAt,
    required this.updatedAt,
    required this.productName,
    required this.productNumber,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      productId: json['product_id'],
      quantity: json['quantity'],
      orderDate: json['order_date'],
      deliveryStatusName: json['name'],
      deliveryDate: json['delivery_date'],
      userId: json['user_id'],
      remark: json['remark'],
      supplierId: json['supplier_id'],
      ordered: json['ordered'],
      status: json['status'],
      weight: json['weight'],
      price: json['price'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      productNumber: json['product_number'],
      productName: json['product_name'],
    );
  }
}

class OrderDataTable extends StatefulWidget {
  final List<Order> orders;

  const OrderDataTable({
    Key? key,
    required this.orders,
  }) : super(key: key);

  @override
  _OrderDataTableState createState() => _OrderDataTableState();
}

class _OrderDataTableState extends State<OrderDataTable> {
  bool sort = true;
  List<bool> selected = [];
  late List<TextEditingController> quantityControllers;
  late List<TextEditingController> remarkControllers;
  late TextEditingController searchController;
  List<Order> filteredOrders = [];

  // Order Sorting
  onsortColum(int columnIndex, bool ascending){
    if(columnIndex == 0){
      if(ascending){
        filteredOrders!.sort((a,b) => a.productName!.compareTo(b.productName!));
      }else{
        filteredOrders!.sort((a,b) => b.productName!.compareTo(a.productName!));
      }
    }
  }


  @override
  void initState() {
    //filteredOrders = myData;
    super.initState();
    TextEditingController controller = TextEditingController();

    // İlgili öğelerin seçilip seçilmediğini takip etmek için bir liste oluşturuyoruz.
    selected = List<bool>.generate(widget.orders.length, (index) => false);
    // Her sipariş için bir miktar denetleyici (TextEditingController) oluşturuyoruz ve varsayılan değerlerini ayarlıyoruz.
    quantityControllers = List.generate(
      widget.orders.length,
          (index) => TextEditingController(text: widget.orders[index].quantity.toString()),
    );
    // Her sipariş için bir açıklama denetleyici (TextEditingController) oluşturuyoruz ve varsayılan değerlerini ayarlıyoruz.
    remarkControllers = List.generate(
      widget.orders.length,
          (index) => TextEditingController(text: widget.orders[index].remark ?? ''),
    );
    // Arama işlevi için bir denetleyici oluşturuyoruz ve varsayılan sipariş listesini filtrelenmemiş sipariş listesine kopyalıyoruz.
    searchController = TextEditingController();
    filteredOrders = widget.orders;
  }

  @override
  void dispose() {
    // Miktar denetleyicilerini (quantityControllers) temizliyoruz.
    for (final controller in quantityControllers) {
      controller.dispose();
    }
    // Açıklama denetleyicilerini (remarkControllers) temizliyoruz.
    for (final controller in remarkControllers) {
      controller.dispose();
    }
    // Arama denetleyicisini (searchController) temizliyoruz.
    searchController.dispose();
    // Üst sınıfın dispose yöntemini çağırarak bellek sızıntısını önlemeye yardımcı oluyoruz.
    super.dispose();
  }

  void filterOrders(String query) {
    setState(() {
      filteredOrders = widget.orders.where((order) {
        final productNameLower = order.productName.toLowerCase();
        final productNumberLower = order.productNumber.toLowerCase();
        final queryLower = query.toLowerCase();

        return productNameLower.contains(queryLower) || productNumberLower.contains(queryLower);
      }).toList();
    });
  }
  @override
  Widget build(BuildContext context) {

    String? authToken = MyApp.authToken;
    String? userName = MyApp.userName;
    Padding(padding: EdgeInsets.all(25.0));
    double columnWidth = 60.0;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: searchController,
            decoration: InputDecoration(
              labelText: 'Suchen...',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
            ),
            onChanged: filterOrders,
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal, // Tablonun yatay kaydırılabilir olmasını sağlar
          child: DataTable(
            columns: const <DataColumn>[
              DataColumn(
                label: Text('Button'),
              ),
              DataColumn(
                label: Text('Produktname'),
              ),
              DataColumn(
                label: Text('Gewicht'),
              ),
              DataColumn(
                label: Text('Preise'),
              ),
              DataColumn(
                label: Text('Anzahl'),
              ),
              DataColumn(
                label: Text('Bemerkung'),
              ),
              DataColumn(
                label: Text('Produktnummer'),
              ),
              DataColumn(
                label: Text('Bestelldatum'),
              )
            ],
            rows: List<DataRow>.generate(
              filteredOrders.length,
                  (index) => DataRow(
                  cells: <DataCell>[
                    DataCell(
                      ElevatedButton(
                        onPressed: () {
                          // Düğmeye tıklandığında modalı açmak için bir işlem yapın
                          showModal(context, widget.orders[index]); // showModal fonksiyonu bir modal gösterir
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.green,
                        ),
                        child:Icon(Icons.add_box_rounded),
                      ),
                    ),
                    DataCell(
                      SizedBox(
                        width: 150.0, // Genişlik ayarını burada kullanın
                        child: Text(widget.orders[index].productName),
                      ),
                    ),
                    DataCell(
                      SizedBox(
                      width: 45.0, // Genişlik ayarını burada kullanın
                      child: Text(widget.orders[index].weight.toString()),
                      ),
                    ),
                    DataCell(
                      SizedBox(
                        width: 45.0, // Genişlik ayarını burada kullanın
                        child: Text(widget.orders[index].price),
                      ),
                    ),
                    DataCell(
                      TextField(
                        controller: quantityControllers[index],
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: 'Geben Sie die Menge ein', // Placeholder text
                        ),
                        onChanged: (newValue) {
                          //widget.orders[index].quantity = int.parse(newValue);
                        },
                      ),
                    ),
                    DataCell(
                      TextField(
                        controller: remarkControllers[index],
                        decoration: InputDecoration(
                          hintText: 'Beschreibung eingeben',
                        ),
                        onChanged: (newValue) {
                          // Handle the updated remark value here
                          // You can access it using newValue
                        },
                      ),
                    ),
                    DataCell(
                      SizedBox(
                        width: 75.0, // Genişlik ayarını burada kullanın
                        child: Text(widget.orders[index].productNumber),
                      ),
                    ),
                    DataCell(
                      SizedBox(
                        width: 75.0, // Genişlik ayarını burada kullanın
                        child: Text(widget.orders[index].orderDate),
                      ),
                    ),
                  ],
                selected: selected[index],
                onSelectChanged: (bool? value) {
                  setState(() {
                    selected[index] = value!;
                  });
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

}

// Ürünü Palet ekleme formu
Widget _buildForm() {
  return Table(
    border: TableBorder.all(), // Tablo sınırlarını çizmek için
    defaultColumnWidth: IntrinsicColumnWidth(), // Sütun genişliklerini ayarlamak için
    children: [
      TableRow(
        children: [
          TableCell(
            child: Text('#', style: TextStyle(color: Colors.green, fontSize: 20)),
          ),
          TableCell(
            child: Text('Lager', style: TextStyle(color: Colors.green, fontSize: 20)),
          ),
          TableCell(
            child: Text('Palet', style: TextStyle(color: Colors.green, fontSize: 20)),
          ),
          TableCell(
            child: Text('Notiz', style: TextStyle(color: Colors.green, fontSize: 20)),
          ),
          TableCell(
            child: Text('Aktion', style: TextStyle(color: Colors.green, fontSize: 20)),
          ),
        ],
      ),
      TableRow(
        children: [
          TableCell(child: Text('1')), // #
          TableCell(child: TextFormField()), // Notiz
          TableCell(child: TextFormField()), // Notiz// @lang('content.pallets_title')
          TableCell(child: TextFormField()), // Notiz
          TableCell(
            child: IconButton(
              icon: Icon(Icons.remove), // Dash iconu kullanılmıştır, ilgili ikonu değiştirin
              onPressed: () {
                // Satırı kaldırmak için gerekli işlemi burada yapın
              },
            ),
          ), // @lang('content.action')
        ],
      ),
    ],
  );
}



void showModal(BuildContext context, Order order) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (BuildContext context) {
      return SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Produkte Details'),
              _buildForm(),
            ],
          ),
        ),
      );
    },
  );
}

class HomePage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  Future<List<Order>> fetchOrders() async {
    final String apiUrl = 'https://app.tabak-welt.de/api/v1/order/list';
    final String token = MyApp.authToken ?? '19|eZVE9k5EdWxqsf74GDX0EnihU1vznUaiNPmK0emw'; // Bearer tokeni buraya ekleyin
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      return jsonData.map((json) => Order.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch orders');
    }
  }
  Text subheading(String title) {
    return Text(
      title,
      style: TextStyle(
          color: LightColors.kDarkBlue,
          fontSize: 20.0,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2),
    );
  }

  static CircleAvatar calendarIcon() {
    return CircleAvatar(
      radius: 25.0,
      backgroundColor: LightColors.kGreen,
      child: Icon(
        Icons.calendar_today,
        size: 20.0,
        color: Colors.white,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: LightColors.kLightYellow,
      appBar: AppBar(
        backgroundColor: Colors.brown,
        title: Row(
          children: [
            Image.network('https://cdn-icons-png.flaticon.com/512/5987/5987420.png',
              fit: BoxFit.contain,
              width: 45,
              height: 40,),
            Text(
              MyApp.userName ?? '', // Eğer userName null ise boş bir string gösterir
              style: TextStyle(
                color: Colors.white, // İstediğiniz rengi seçebilirsiniz
                fontSize: 16.0, // İstediğiniz boyutu seçebilirsiniz
                fontWeight: FontWeight.bold, // İstediğiniz kalınlığı seçebilirsiniz
              ),
            ),
            IconButton(
              color: Colors.red,
              icon: Icon(Icons.logout),
              onPressed: (){
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => MyApp()), (route) => false,);
              },
            ),
            Text(
              'Ausloggen', // Eğer userName null ise boş bir string gösterir
              style: TextStyle(
                color: Colors.red, // İstediğiniz rengi seçebilirsiniz
                fontSize: 16.0, // İstediğiniz boyutu seçebilirsiniz
                fontWeight: FontWeight.bold, // İstediğiniz kalınlığı seçebilirsiniz
              ),
            ),
          ],
          mainAxisAlignment: MainAxisAlignment.end,
        ),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Armaturenbrett'),
            ),
            ListTile(
              leading: Icon(Icons.list),
              title: Text('Bestellliste'),
            ),
            ListTile(
              leading: Icon(Icons.view_list),
              title: Text('Warebestellung'),
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Einstellungen'),
            ),
            ListTile(
              leading: Icon(Icons.help),
              title: Text('Helfen'),
            ),
            ListTile(
              textColor: Colors.red,
              leading: IconButton(
                  color: Colors.red,
                  icon: Icon(Icons.logout),
                  onPressed: (){
                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => MyApp()), (route) => false,);
                  },
              ),
              title: Text('Ausloggen',),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Container(
                      color: Colors.transparent,
                      padding: EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 10.0),
                      child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              InkWell(
                                child: Container(
                                  width: 170,
                                  height:55,
                                  decoration: BoxDecoration(
                                      color: Colors.teal,
                                      border: Border.all(
                                        color: Colors.white,
                                        width: 2,
                                      ),
                                      borderRadius: BorderRadius.all(Radius.circular(50))
                                  ),
                                  padding: EdgeInsets.all(10.0),
                                  child: Row(
                                    children: [
                                      Icon(Icons.add_road, color: Colors.white, size: 30),
                                      Text(' Lagereintrag',
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                onTap: () {
                                  // Başka bir sayfaya yönlendir.
                                },
                              ),
                              InkWell(
                                child: Container(
                                  width: 170,
                                  height:55,
                                  decoration: BoxDecoration(
                                      color: Colors.green,
                                      border: Border.all(
                                        color: Colors.white,
                                        width: 2,
                                      ),
                                      borderRadius: BorderRadius.all(Radius.circular(50))
                                  ),
                                  padding: EdgeInsets.all(10.0),
                                  child: Row(
                                    children: [
                                      Icon(Icons.add_box, color: Colors.white, size: 30),
                                      Text(' Produkte',
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                onTap: () {
                                  // Başka bir sayfaya yönlendir.
                                },
                              ),
                              InkWell(
                                child: Container(
                                  width: 180,
                                  height:55,
                                  decoration: BoxDecoration(
                                      color: Colors.red.shade900,
                                      border: Border.all(
                                        color: Colors.white,
                                        width: 2,
                                      ),
                                      borderRadius: BorderRadius.all(Radius.circular(50))
                                  ),
                                  padding: EdgeInsets.all(10.0),
                                  child: Row(
                                    children: [
                                      Icon(Icons.add_alert, color: Colors.white, size: 30),
                                      Text(' Kritisches Inventar',
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                onTap: () {
                                  // Başka bir sayfaya yönlendir.
                                },
                              ),
                              InkWell(
                                child: Container(
                                  width: 170,
                                  height:55,
                                  decoration: BoxDecoration(
                                      color: Colors.brown,
                                      border: Border.all(
                                        color: Colors.white,
                                        width: 2,
                                      ),
                                      borderRadius: BorderRadius.all(Radius.circular(50))
                                  ),
                                  padding: EdgeInsets.all(10.0),
                                  child: Row(
                                    children: [
                                      Icon(Icons.crisis_alert_outlined, color: Colors.white, size: 30),
                                      Text(' Bestandsausgabe',
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                onTap: () {
                                  // Başka bir sayfaya yönlendir.
                                },
                              ),
                            ],
                          ),
                          SizedBox(height: 5.0),
                        ],
                      ),
                    ),
                    Container(
                      color: Colors.transparent,
                      padding: EdgeInsets.all(10.0),
                      child: Card(
                        color: Colors.white,
                        margin: EdgeInsets.all(1.0),
                        elevation: 4.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Form(
                              key: _formKey,
                              child: Column(
                                children: <Widget>[
                                FutureBuilder<List<Order>>(
                                  future: fetchOrders(),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState == ConnectionState.waiting) {
                                      return CircularProgressIndicator();
                                    } else if (snapshot.hasError) {
                                      return Text('Veriler alınamadı: ${snapshot.error.toString()}');
                                    } else if (!snapshot.hasData || snapshot.data?.isEmpty == true) {
                                      return Text('Hiç sipariş bulunamadı.');
                                    } else {
                                      return OrderDataTable(orders: snapshot.data!);
                                    }
                                  },
                                ),
                                // Form eklemesi
                                  ElevatedButton(
                                    onPressed: () async {
                                      if (_formKey.currentState?.validate() ?? false) {
                                        // Form doğrulama işleminden geçti, işlem yapabilirsiniz
                                        _formKey.currentState?.save();
                                        // Verileri işlemek için bir metodu çağırabilirsiniz
                                        // Formdan alınan verileri bir Map'e dönüştürün
                                        Map<String, dynamic> formData = {

                                        };
                                        // API'ye POST isteği yapın
                                        final apiUrl = 'https://app.tabak-welt.de/api/v1/order/store'; // API endpoint URL'nizi buraya ekleyin
                                        final response = await http.post(
                                          Uri.parse(apiUrl),
                                          headers: {
                                            'Content-Type': 'application/json', // Veri türünü JSON olarak belirtin
                                          },
                                          body: json.encode(formData), // Veriyi JSON formatına dönüştürün
                                        );
                                        if (response.statusCode == 200) {
                                          // İşlem başarılı olduysa burada gerekli işlemleri yapabilirsiniz
                                          print('Veri başarıyla gönderildi.');
                                        } else {
                                          // İşlem başarısız olduysa hata mesajını görüntüleyebilirsiniz
                                          print('Veri gönderme hatası: ${response.statusCode}');
                                        }
                                      }
                                    },
                                    child: Text('Speichern'),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 20.0),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}
