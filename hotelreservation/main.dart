DateTime dateToday =new DateTime.now(); 
void main(List<String> args) {

  /*
  User Guide -> 
  
  1.You must add room for reservation and You can add room with this function  -> RoomCollection.addRoom("RoomName"); 

  2.You can make reservation with this function ->  Funcs.makeReservation("Name", "Surname", Age, "RoomName",CheckInTime, CheckOutTime);

  3.You can get reservation information as a ResponseSearch Object with this function ->  Funcs.getReservationInfo("Roomname",CheckInTime, CheckOutTime);
  
*/

  //Code Example ->  
  for (var i =0 ;i<= 50;i++){
    RoomCollection.addRoom("Room$i");
  }

  final startTime = DateTime(2021, 12, 17);
  final finishTime = DateTime(2021, 12, 25);

  //Code Example -> 
  Funcs.makeReservation("Altan", "Baysal", 19, "Room", startTime, finishTime);

  //Code Example -> 
  Funcs.getReservationInfo("Room",startTime, finishTime);

  //if you want to get search result
  //print(ResponseSearch.customersInfo.first.name);
  //print(ResponseSearch.reservationsInfo.first.timeList.first);


}







class Funcs{

  static makeReservation(String name, String surname, int age,String roomnameI,DateTime checkInDateI,DateTime checkOutDateI){
    if(!RoomCollection.checkRoomIsAvailable(roomnameI)){
      print("Rezervasyon Yapmak istediğiniz oda mevcut değil");
    }

    else if(ReservationCollection.checkReservationIsAvailable(roomnameI, checkInDateI, checkOutDateI).isEmpty ){
      int _customerid = CustomerCollection.createOrGetCustomerId(name, surname, age);
      ReservationCollection.create(roomnameI,_customerid,checkInDateI, checkOutDateI);
      print("Rezervasyon başarıyla oluşturuldu");     
    }
  } 

  static getReservationInfo(String roomname,DateTime checkInDateI,DateTime checkOutDateI){

    if(!RoomCollection.checkRoomIsAvailable(roomname)){
      print("Bilgi almak istediğiniz oda mevcut değil");
    }

    Iterable<Reservation> reservations = ReservationCollection.checkReservationIsAvailable(roomname, checkInDateI, checkOutDateI);
    if(reservations.isNotEmpty){
      ResponseSearch.responseSearchfunc(reservations);
    }
    else{
      print("Girilen tarih aralığında herhangi bir rezervasyon bulunmamaktadır");
    }
  }

  static bool isTwoTimeListHaveSameElement(List<DateTime> list1,list2){
    if(list1.any((item) => list2.contains(item))){
      return true;
    }

    return false;
  }

  static List<DateTime> checkInOutConvertTimeList (DateTime checkInTimeI,DateTime checkOutTimeI){
    List<DateTime> _times =[];
    final diffDay = checkOutTimeI.difference(checkInTimeI).inDays;

    for(var i=0; i<diffDay+1;i++){
      _times.add(checkInTimeI.subtract(Duration(days: -i)));
    };
        
    return _times;
  }

}

class ResponseSearch{
  static List<Customer> customersInfo = [];
  static List<Reservation> reservationsInfo = [];
  
  static responseSearchfunc(Iterable<Reservation> reservationsinfoI){
    customersInfo = [];   
    reservationsInfo = []; 

    reservationsInfo.addAll(reservationsinfoI);

    reservationsInfo.forEach((element) {
      addcustomer(element);
    });
  }

  static addcustomer(Reservation reservation){
    Customer customer = CustomerCollection.customerlist[reservation.customerid];
    customersInfo.add(customer);
  }

}


class ReservationCollection{
  static List<Reservation> reservationlist = [];

  static create(String roomid,int customerid,DateTime checkInTime,DateTime checkOutTime){
    String id = createid(roomid,  checkInTime, checkOutTime);
    Reservation reservation =Reservation(id, roomid, customerid, checkInTime, checkOutTime);
    reservationlist.add(reservation);
  }

  static Iterable<Reservation> checkReservationIsAvailable (String roomidI,DateTime checkInDateI,DateTime checkOutDateI){
    var list2 = Funcs.checkInOutConvertTimeList(checkInDateI, checkOutDateI);

    Iterable<Reservation> data = reservationlist.where((reservation) => (reservation.roomname == roomidI && Funcs.isTwoTimeListHaveSameElement(reservation.timeList, list2)));
    
    return data;
  }

  static String createid(String roomid,DateTime checkInTime,DateTime checkOutTime){
    String idreservation = roomid+checkInTime.toString().substring(0,10)+checkOutTime.toString().substring(0,10);
    return idreservation;
  }
}

class CustomerCollection{
  static List<Customer> customerlist = [];

  static int createCustomer(String name, String surname, int age ){
    int _index = customerlist.length;
    Customer customer = Customer(_index, name, surname, age);
    customerlist.add(customer);
    print("$name adlı kullanıcı başarıyla eklendi");
    return _index;
    
  }

  static Iterable<Customer> checkCustomerIsAvailable(String name, String surname, int age){
    Iterable<Customer> data = customerlist.where((customer) => (customer.age == age && customer.name == name && customer.surname == surname));
    return data;
  }

  static int createOrGetCustomerId(String name, String surname, int age){
 
    Iterable<Customer> customerIterable = checkCustomerIsAvailable(name, surname, age);

    if(customerIterable.isNotEmpty){
      return customerIterable.first.id;
    }    
    return  createCustomer(name, surname, age);
  }
}

class RoomCollection{
  static List<Room> rooms =[];

  static createroom(String roomname,String roomvalue){
    Room room = Room(roomname, roomvalue);
    rooms.add(room);
    
  }

  static bool checkRoomIsAvailable(String roomname){
    var data = rooms.where((room) => (room.roomname == roomname));

    if(data.length >=1)
    {
      return true;
    }
    return false;
  }  

  static addRoom(roomname){
    if(!RoomCollection.checkRoomIsAvailable(roomname) && roomname != ""){}
  }
}


class Reservation{
  String id = ""; //must be unique
  String roomname = ""; 
  int customerid = -1;

  List<DateTime> timeList = [];

  Reservation(String id,String roomname,int customerid,DateTime checkInTime,DateTime checkOutTime){
    this.id = id;
    this.roomname = roomname;
    this.customerid = customerid;
    this.timeList = Funcs.checkInOutConvertTimeList(checkInTime, checkOutTime);
  }
}

class Room{
  String roomname = ""; //already unique
  
  Room(String  roomname,String roomcount){
    this.roomname = roomname;
  }
}

class Customer{
  int id =  -1 ; //must be unique
  String name = "";
  String surname = "";
  int age = -1;

  Customer(int id,String name,String surname,int age){
    this.id = id;
    this.name = name;
    this.surname = surname;
    this.age = age;
  }   
}