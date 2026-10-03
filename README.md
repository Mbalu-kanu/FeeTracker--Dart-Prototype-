Fee Track: School Fee and Payment Tracker (Dart Console Prototype)
FeeTrack is a console prototype that shows the core logic of a school fee and payment tracking system. It is Assignment 1 of a three-stage project:
1. Dart console prototype (this repository)
2. Flutter mobile application
3. Supabase database and complete mobile application
 The problem
Private secondary schools often record fees by hand in a paper ledger. This makes balances, receipts and defaulter lists slow and error-prone. (This is an assumption based on typical practice, not a study of one named school.)
 Features
- Register students and guardians
- Set the fee for each class and term
- Record payments (cash, bank, mobile money), including part payments
- Automatic balance calculation and numbered receipts
- Payment history per student
- Defaulter list
- Collection summary per class
- Input validation (no negative amounts, no overpayment, no unknown students)

 Entities
Student, Guardian, SchoolClass, FeeStructure, Payment

 How to run
1. Install the Dart SDK from https://dart.dev/get-dart
2. Download or clone this repository
3. In the project folder, run:

```
dart run main.dart
```

 Notes
Sample data (names, phone numbers and amounts) is made up for demonstration only. Amounts are shown as "Le" (leones). Data is stored in memory and is lost when the program closes; Supabase will store it permanently in the final stage.

Author
[Mbalu Sillah Kanu], [905006186], Limkokwing University of Creative Technology, Sierra Leone
