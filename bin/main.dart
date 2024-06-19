// import 'dart:collection';
import 'dart:io';

// Struktur Data Stack
class Stack<T> {
  final List<T> _list = [];

  void push(T value) => _list.add(value);

  T pop() => _list.removeLast();

  bool get isEmpty => _list.isEmpty;
}

// Struktur Data Queue
class Queue<T> {
  final List<T> _list = [];

  void enqueue(T value) => _list.add(value);

  T dequeue() => _list.removeAt(0);

  bool get isEmpty => _list.isEmpty;

  int get length => _list.length;
}

// Fungsi utama
void main() {
  // Inisialisasi menu
  List<String> menuItems = ['Burger', 'Pizza', 'Nugget', 'Soda', 'Salad'];
  Map<String, Map<String, dynamic>> menuDetails = {
    'Burger': {'price': 50000, 'description': 'Burger with beef patty'},
    'Pizza': {'price': 75000, 'description': 'Pizza with cheese and pepperoni'},
    'Nugget': {'price': 30000, 'description': 'Chicken nuggets'},
    'Soda': {'price': 15000, 'description': 'Soft drink'},
    'Salad': {'price': 25000, 'description': 'Fresh vegetable salad'},
  };

  // List untuk menyimpan pesanan
  List<Map<String, dynamic>> orders = [];
  // Stack untuk fitur "batal pesanan"
  Stack<Map<String, dynamic>> cancelledOrders = Stack();
  // Antrian untuk pemesanan
  Queue<Map<String, dynamic>> orderQueue = Queue();

  // Fungsi untuk menampilkan menu
  void displayMenu() {
    print('\nMenu:');
    for (int i = 0; i < menuItems.length; i++) {
      String item = menuItems[i];
      print(
          '${i + 1}. $item - Rp${menuDetails[item]!['price']} - ${menuDetails[item]!['description']}');
    }
  }

  // Fungsi untuk menambahkan pesanan
  void addOrder(String item, int quantity, String note) {
    orders.add({'item': item, 'quantity': quantity, 'note': note});
    print('Pesanan ditambahkan: $item, Jumlah: $quantity, Catatan: $note');
  }

  // Fungsi untuk membatalkan pesanan terakhir
  void cancelLastOrder() {
    if (orders.isNotEmpty) {
      Map<String, dynamic> lastOrder = orders.removeLast();
      cancelledOrders.push(lastOrder);
      print('Pesanan dibatalkan: ${lastOrder['item']}');
    } else {
      print('Tidak ada pesanan yang bisa dibatalkan.');
    }
  }

  // Fungsi untuk mengembalikan pesanan yang dibatalkan
  void undoCancelOrder() {
    if (!cancelledOrders.isEmpty) {
      Map<String, dynamic> lastCancelledOrder = cancelledOrders.pop();
      orders.add(lastCancelledOrder);
      print('Pesanan dikembalikan: ${lastCancelledOrder['item']}');
    } else {
      print('Tidak ada pesanan yang bisa dikembalikan.');
    }
  }

  // Fungsi untuk menghitung total biaya
  int calculateTotal() {
    int total = 0;
    for (var order in orders) {
      total += (menuDetails[order['item']]!['price'] as int) *
          (order['quantity'] as int);
    }
    return total;
  }

  // Fungsi untuk menambahkan pesanan ke antrian
  void addToQueue(Map<String, dynamic> order) {
    orderQueue.enqueue(order);
    print('Pesanan ditambahkan ke antrian: ${order['item']}');
  }

  // Fungsi untuk memproses pesanan dari antrian
  void processOrder() {
    if (!orderQueue.isEmpty) {
      Map<String, dynamic> order = orderQueue.dequeue();
      print('Memproses pesanan: ${order['item']}');
    } else {
      print('Tidak ada pesanan dalam antrian.');
    }
  }

  // Fungsi untuk melakukan pembayaran
  void processPayment(String method) {
    if (method == 'cash' || method == 'non-cash') {
      int total = calculateTotal();
      print('Pembayaran berhasil dengan metode: $method');
      print('Total yang dibayar: Rp$total');
    } else {
      print('Metode pembayaran tidak valid');
    }
  }

  // Fungsi untuk menampilkan menu interaktif dan memesan makanan
  void interactiveMenu() {
    while (true) {
      displayMenu();
      print(
          '\nPilih item dari menu (1-${menuItems.length}) atau 0 untuk selesai: ');
      int choice;
      try {
        choice = int.parse(stdin.readLineSync()!);
      } catch (e) {
        print('Pilihan tidak valid, silakan coba lagi.');
        continue;
      }
      if (choice == 0) break;

      if (choice > 0 && choice <= menuItems.length) {
        String selectedItem = menuItems[choice - 1];

        print('Masukkan jumlah: ');
        int quantity;
        try {
          quantity = int.parse(stdin.readLineSync()!);
        } catch (e) {
          print('Jumlah tidak valid, silakan coba lagi.');
          continue;
        }

        print('Masukkan catatan khusus (atau tekan Enter untuk melanjutkan): ');
        String note = stdin.readLineSync()!;

        addOrder(selectedItem, quantity, note);
        addToQueue({'item': selectedItem, 'quantity': quantity, 'note': note});
      } else {
        print('Pilihan tidak valid, silakan coba lagi.');
      }

      print('\nApakah Anda ingin membatalkan pesanan terakhir? (y/n): ');
      String cancelChoice = stdin.readLineSync()!;
      if (cancelChoice.toLowerCase() == 'y') {
        cancelLastOrder();
      }

      print(
          '\nApakah Anda ingin mengembalikan pesanan yang dibatalkan? (y/n): ');
      String undoCancelChoice = stdin.readLineSync()!;
      if (undoCancelChoice.toLowerCase() == 'y') {
        undoCancelOrder();
      }
    }

    print('\nTotal pesanan:');
    for (var order in orders) {
      print(
          '${order['item']} - Jumlah: ${order['quantity']} - Catatan: ${order['note']}');
    }

    int total = calculateTotal();
    print('Total biaya: Rp$total');

    print('\nPilih metode pembayaran (cash/non-cash): ');
    String paymentMethod = stdin.readLineSync()!;
    processPayment(paymentMethod);

    while (!orderQueue.isEmpty) {
      processOrder();
    }

    print('Terima kasih telah memesan melalui layanan drive-thru kami!');
  }

  // Jalankan menu interaktif
  interactiveMenu();
}
