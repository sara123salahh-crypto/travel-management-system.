// ignore_for_file: dead_code

import 'dart:io';

enum BookingStatus {
  pending,
  confirmed,
  cancelled,
}

class Traveler {
  String name;
  int age;
Traveler(this.name,this.age);
String get type {
  if (age >= 12) {
    return "adult";
  } else {
    return "child";
  }
}
  double calculatePrice(double basePrice){
    if(type=="adult"){
      return basePrice;
    }
    else{
      return basePrice*0.7;
    }
  }
}
class Trip{
  String name;
  String destination;
  double basePrice;
  int capacity;
  Trip(this.name,this.destination,this.basePrice,this.capacity);
}
class Customer{
  int id;
  String name;
  String phone;
  String email;
  Customer(this.id,this.name,this.phone,this.email);
}
class Booking{
  String id;
  Customer customer;
  Trip trip;
  List<Traveler> travelers;
  BookingStatus status;
  Booking(this.id,this.customer,this.trip,this.travelers,this.status);
  double calculateTotalPrice(){
    double total = 0;
    for(int i=0 ; i<travelers.length ; i++){
      total+= travelers[i].calculatePrice(trip.basePrice);
    }
    return total;
  }
}
class TravelCompany{
  List<Trip> trips;
List<Customer> customers;
List<Booking> bookings;
TravelCompany(this.trips,this.customers,this.bookings);
void addTrip(Trip trip){
  trips.add(trip);
}
void addCustomer(Customer customer){
  customers.add(customer);
}
void addBooking(Booking booking){
  if(canBook( booking)){
bookings.add(booking);
}
else{
  print("No Available Seats");
}
}
int getBookedTravelers(Trip trip){
  int travelers=0;
  for(int i =0 ; i<bookings.length;i++){
    if(bookings[i].trip==trip &&bookings[i].status != BookingStatus.cancelled ){
      travelers += bookings[i].travelers.length;

    }

  }
  return travelers;
}
int getAvailableSeats(Trip trip){
  return trip.capacity - getBookedTravelers(trip);
}
bool canBook(Booking booking){
   if(getAvailableSeats(booking.trip)>=booking.travelers.length){
    return true;
   }
   else {
    return false;
   }
  
}
void cancelBooking(String bookingId) {
  bool found = false;

  for (int i = 0; i < bookings.length; i++) {
    if (bookings[i].id == bookingId) {
      bookings[i].status = BookingStatus.cancelled;
      found = true;
      break;
    }
  }

  if (!found) {
    print("Booking not found");
  }
}
List<Trip> searchTrips(String destination){
   return trips.where((trip) {
  return trip.destination == destination;
}).toList();
}
void showTrips() {
  trips.forEach((trip) {
    print("Trip: ${trip.name}");
    print("Destination: ${trip.destination}");
    print("Price: ${trip.basePrice}");
    print("Available Seats: ${getAvailableSeats(trip)}");
    print("--------------------");
  });
}

List<Booking> getCustomerBookings(int customerId) {
  return bookings.where((book) {
    return book.customer.id == customerId;
  }).toList();
}
double getTotalRevenue() {
  double totalRevenue = 0.0;

  for (int i = 0; i < bookings.length; i++) {
    if (bookings[i].status != BookingStatus.cancelled) {
      totalRevenue += bookings[i].calculateTotalPrice();
    }
  }

  return totalRevenue;
}
void showBookingDetails(String bookingId) {
  bool found = false;

  for (int i = 0; i < bookings.length; i++) {
    if (bookings[i].id == bookingId) {
      print("Booking ID: ${bookings[i].id}");
      print("Customer: ${bookings[i].customer.name}");
      print("Trip: ${bookings[i].trip.name}");
      print("Destination: ${bookings[i].trip.destination}");
      print("Travelers:");

      for (int j = 0; j < bookings[i].travelers.length; j++) {
        print("- ${bookings[i].travelers[j].name}");
      }

      print("Status: ${bookings[i].status}");
      print("Total Price: ${bookings[i].calculateTotalPrice()}");

      found = true;
      break;
    }
  }

  if (!found) {
    print("Booking not found");
  }
}
}
  void main() {
  List<Trip> trips = [];
  List<Customer> customers = [];
  List<Booking> bookings = [];

  TravelCompany company = TravelCompany(
    trips,
    customers,
    bookings,
  );

  while (true) {
    print('''
===== Travel Management System =====

1. Add Trip
2. Add Customer
3. Search Trips
4. Create Booking
5. View Booking
6. Cancel Booking
7. View Customer Bookings
8. Show Trips
9. Exit
''');

    int choice = int.parse(stdin.readLineSync()!);

    switch (choice) {
      
      case 1:
        print("Enter trip name:");
        String name = stdin.readLineSync()!;

        print("Enter destination:");
        String destination = stdin.readLineSync()!;

        print("Enter base price:");
        double basePrice = double.parse(stdin.readLineSync()!);

        print("Enter capacity:");
        int capacity = int.parse(stdin.readLineSync()!);

        Trip trip = Trip(
          name,
          destination,
          basePrice,
          capacity,
        );

        company.addTrip(trip);

        print("Trip added successfully!");
        break;

      
      case 2:
        print("Enter customer ID:");
        int id = int.parse(stdin.readLineSync()!);

        print("Enter customer name:");
        String name = stdin.readLineSync()!;

        print("Enter phone:");
        String phone = stdin.readLineSync()!;

        print("Enter email:");
        String email = stdin.readLineSync()!;

        Customer customer = Customer(
          id,
          name,
          phone,
          email,
        );

        company.addCustomer(customer);

        print("Customer added successfully!");
        break;

      
      case 3:
        print("Enter destination:");
        String destination = stdin.readLineSync()!;

        List<Trip> results = company.searchTrips(destination);

        if (results.isEmpty) {
          print("No trips found.");
        } else {
          for (int i = 0; i < results.length; i++) {
            print("Trip: ${results[i].name}");
            print("Destination: ${results[i].destination}");
            print("Price: ${results[i].basePrice}");
            print(
              "Available Seats: ${company.getAvailableSeats(results[i])}",
            );
            print("--------------------");
          }
        }
        break;

      
      case 4:
        print("Enter booking ID:");
        String bookingId = stdin.readLineSync()!;

        print("Enter customer ID:");
        int customerId = int.parse(stdin.readLineSync()!);

        Customer? selectedCustomer;

        for (int i = 0; i < customers.length; i++) {
          if (customers[i].id == customerId) {
            selectedCustomer = customers[i];
            break;
          }
        }

        if (selectedCustomer == null) {
          print("Customer not found.");
          break;
        }

        print("Enter trip name:");
        String tripName = stdin.readLineSync()!;

        Trip? selectedTrip;

        for (int i = 0; i < trips.length; i++) {
          if (trips[i].name == tripName) {
            selectedTrip = trips[i];
            break;
          }
        }

        if (selectedTrip == null) {
          print("Trip not found.");
          break;
        }

        print("How many travelers?");
        int numberOfTravelers = int.parse(stdin.readLineSync()!);

        List<Traveler> travelers = [];

        for (int i = 0; i < numberOfTravelers; i++) {
          print("Enter traveler ${i + 1} name:");
          String travelerName = stdin.readLineSync()!;

          print("Enter traveler ${i + 1} age:");
          int travelerAge = int.parse(stdin.readLineSync()!);

          travelers.add(
            Traveler(travelerName, travelerAge),
          );
        }

        Booking booking = Booking(
          bookingId,
          selectedCustomer,
          selectedTrip,
          travelers,
          BookingStatus.confirmed,
        );

        company.addBooking(booking);

        print("Booking process completed.");
        break;

      
      case 5:
        print("Enter booking ID:");
        String bookingId = stdin.readLineSync()!;

        company.showBookingDetails(bookingId);
        break;

      
      case 6:
        print("Enter booking ID:");
        String bookingId = stdin.readLineSync()!;

        company.cancelBooking(bookingId);
        break;

      
      case 7:
        print("Enter customer ID:");
        int customerId = int.parse(stdin.readLineSync()!);

        List<Booking> customerBookings =
            company.getCustomerBookings(customerId);

        if (customerBookings.isEmpty) {
          print("No bookings found.");
        } else {
          for (int i = 0; i < customerBookings.length; i++) {
            print("Booking ID: ${customerBookings[i].id}");
            print("Trip: ${customerBookings[i].trip.name}");
            print("Status: ${customerBookings[i].status}");
            print(
              "Total Price: ${customerBookings[i].calculateTotalPrice()}",
            );
            print("--------------------");
          }
        }
        break;

      
      case 8:
        company.showTrips();
        break;

      
        print("Goodbye!");
        return;

      default:
        print("Invalid choice.");
    }
  }
}