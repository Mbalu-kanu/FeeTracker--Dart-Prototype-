// FeeTrack: School Fee and Payment Tracker (Console Prototype)
// Assignment 1 - Software Engineering
// Run with: dart run main.dart

import 'dart:io';

// ======================================================
// 1. CLASSES (the five entities of the system)
// ======================================================

class Guardian {
  final int id;
  final String name;
  final String phone;

  Guardian(this.id, this.name, this.phone);
}

class SchoolClass {
  final int id;
  final String name; // e.g. "JSS 1"

  SchoolClass(this.id, this.name);
}

class Student {
  final int id;
  final String name;
  final int classId;
  final int guardianId;

  Student(this.id, this.name, this.classId, this.guardianId);
}

class FeeStructure {
  final int classId;
  final int term; // 1, 2 or 3
  double amount;

  FeeStructure(this.classId, this.term, this.amount);
}

class Payment {
  final String receiptNo;
  final int studentId;
  final int term;
  final double amount;
  final String method; // Cash, Bank or Mobile Money
  final DateTime date;

  Payment(this.receiptNo, this.studentId, this.term, this.amount, this.method,
      this.date);
}

// ======================================================
// 2. DATA STORAGE (lists in memory; Supabase replaces these later)
// ======================================================

List<Guardian> guardians = [];
List<SchoolClass> classes = [];
List<Student> students = [];
List<FeeStructure> fees = [];
List<Payment> payments = [];

int nextStudentId = 1;
int nextGuardianId = 1;
int nextReceiptNo = 1;

// ======================================================
// 3. INPUT HELPERS (with validation)
// ======================================================

// Reads a line of text. Stops the program if the input has ended.
String readText(String prompt) {
  stdout.write(prompt);
  String? line = stdin.readLineSync();
  if (line == null) {
    print('\nInput ended. Closing the program.');
    exit(0);
  }
  return line.trim();
}

// Keeps asking until the user enters a whole number between min and max.
int readInt(String prompt, int min, int max) {
  while (true) {
    String input = readText(prompt);
    int? value = int.tryParse(input);
    if (value == null) {
      print('Invalid input. Please enter a number.');
    } else if (value < min || value > max) {
      print('Please enter a number between $min and $max.');
    } else {
      return value;
    }
  }
}

// Keeps asking until the user enters a money amount greater than zero.
double readAmount(String prompt) {
  while (true) {
    String input = readText(prompt).replaceAll(',', '');
    double? value = double.tryParse(input);
    if (value == null) {
      print('Invalid amount. Please enter a number such as 500 or 250.50.');
    } else if (value <= 0) {
      print('The amount must be greater than zero.');
    } else {
      return roundMoney(value);
    }
  }
}

// Reads a student or guardian name (letters, spaces, . ' - only).
String readName(String prompt) {
  RegExp pattern = RegExp(r"^[A-Za-z .'-]{2,}$");
  while (true) {
    String input = readText(prompt);
    if (pattern.hasMatch(input)) {
      return input;
    }
    print('Invalid name. Use letters only (at least 2 characters).');
  }
}

// Reads a phone number (digits only, 8 to 11 digits).
String readPhone(String prompt) {
  RegExp pattern = RegExp(r'^[0-9]{8,11}$');
  while (true) {
    String input = readText(prompt);
    if (pattern.hasMatch(input)) {
      return input;
    }
    print('Invalid phone number. Enter 8 to 11 digits only.');
  }
}

// Lets the user choose a payment method.
String chooseMethod() {
  print('Payment method: 1) Cash  2) Bank  3) Mobile Money');
  int choice = readInt('Choose method (1-3): ', 1, 3);
  if (choice == 1) {
    return 'Cash';
  } else if (choice == 2) {
    return 'Bank';
  }
  return 'Mobile Money';
}

// ======================================================
// 4. HELPER FUNCTIONS (searching and calculating)
// ======================================================

// Rounds to 2 decimal places so small calculation errors do not appear.
double roundMoney(double value) {
  return double.parse(value.toStringAsFixed(2));
}

String money(double value) {
  return 'Le ${value.toStringAsFixed(2)}';
}

String formatDate(DateTime d) {
  String month = d.month.toString().padLeft(2, '0');
  String day = d.day.toString().padLeft(2, '0');
  return '${d.year}-$month-$day';
}

Student? findStudent(int id) {
  for (Student s in students) {
    if (s.id == id) {
      return s;
    }
  }
  return null;
}

Guardian? findGuardian(int id) {
  for (Guardian g in guardians) {
    if (g.id == id) {
      return g;
    }
  }
  return null;
}

String className(int classId) {
  for (SchoolClass c in classes) {
    if (c.id == classId) {
      return c.name;
    }
  }
  return 'Unknown';
}

FeeStructure? getFee(int classId, int term) {
  for (FeeStructure f in fees) {
    if (f.classId == classId && f.term == term) {
      return f;
    }
  }
  return null;
}

// Adds up all payments a student made in one term.
double totalPaid(int studentId, int term) {
  double total = 0;
  for (Payment p in payments) {
    if (p.studentId == studentId && p.term == term) {
      total += p.amount;
    }
  }
  return roundMoney(total);
}

// Creates a payment with an automatic receipt number and saves it.
Payment addPayment(int studentId, int term, double amount, String method) {
  String receiptNo = 'RCP-${nextReceiptNo.toString().padLeft(4, '0')}';
  nextReceiptNo++;
  Payment p =
      Payment(receiptNo, studentId, term, amount, method, DateTime.now());
  payments.add(p);
  return p;
}

void printLine() {
  print('-' * 60);
}

void pause() {
  readText('\nPress Enter to continue...');
}

// ======================================================
// 5. SAMPLE DATA (made-up values for demonstration only)
// ======================================================

void loadSampleData() {
  List<String> classNames = ['JSS 1', 'JSS 2', 'JSS 3', 'SSS 1', 'SSS 2', 'SSS 3'];
  List<double> term1Fees = [1200, 1300, 1400, 1500, 1600, 1800];

  for (int i = 0; i < classNames.length; i++) {
    classes.add(SchoolClass(i + 1, classNames[i]));
    fees.add(FeeStructure(i + 1, 1, term1Fees[i]));
  }

  guardians.add(Guardian(nextGuardianId++, 'Mohamed Kamara', '076111222'));
  guardians.add(Guardian(nextGuardianId++, 'Isatu Sesay', '077333444'));
  guardians.add(Guardian(nextGuardianId++, 'Abu Bangura', '078555666'));

  students.add(Student(nextStudentId++, 'Aminata Kamara', 1, 1));
  students.add(Student(nextStudentId++, 'Ibrahim Sesay', 1, 2));
  students.add(Student(nextStudentId++, 'Fatmata Bangura', 2, 3));
  students.add(Student(nextStudentId++, 'Mariama Kamara', 4, 1));
  students.add(Student(nextStudentId++, 'Joseph Sesay', 4, 2));

  addPayment(1, 1, 1200, 'Cash'); // paid in full
  addPayment(2, 1, 500, 'Mobile Money'); // part payment
  addPayment(4, 1, 700, 'Bank'); // part payment
}

// ======================================================
// 6. MAIN FEATURES
// ======================================================

// Feature 1: Register a new student
void registerStudent() {
  print('\n--- Register New Student ---');
  String name = readName('Student full name: ');

  print('\nAvailable classes:');
  for (SchoolClass c in classes) {
    print('  ${c.id}. ${c.name}');
  }
  int classId = readInt('Choose class number: ', 1, classes.length);

  String guardianName = readName('Guardian full name: ');
  String phone = readPhone('Guardian phone number: ');

  Guardian guardian = Guardian(nextGuardianId++, guardianName, phone);
  guardians.add(guardian);

  Student student = Student(nextStudentId++, name, classId, guardian.id);
  students.add(student);

  print('\nStudent registered successfully.');
  print('Student ID: ${student.id}  Name: ${student.name}  '
      'Class: ${className(classId)}');
}

// Feature 2: Set (or change) the fee for a class and term
void setClassFee() {
  print('\n--- Set Class Fee ---');
  for (SchoolClass c in classes) {
    print('  ${c.id}. ${c.name}');
  }
  int classId = readInt('Choose class number: ', 1, classes.length);
  int term = readInt('Enter term (1-3): ', 1, 3);
  double amount = readAmount('Enter fee amount: ');

  FeeStructure? existing = getFee(classId, term);
  if (existing != null) {
    existing.amount = amount;
    print('Fee updated for ${className(classId)}, term $term: ${money(amount)}');
  } else {
    fees.add(FeeStructure(classId, term, amount));
    print('Fee set for ${className(classId)}, term $term: ${money(amount)}');
  }
}

// Feature 3: Record a payment and print a receipt
void recordPayment() {
  print('\n--- Record Payment ---');
  int id = readInt('Enter student ID: ', 1, 999999);
  Student? student = findStudent(id);
  if (student == null) {
    print('Error: no student found with ID $id.');
    return;
  }

  int term = readInt('Enter term (1-3): ', 1, 3);
  FeeStructure? fee = getFee(student.classId, term);
  if (fee == null) {
    print('Error: no fee has been set for ${className(student.classId)} '
        'in term $term. Use option 2 first.');
    return;
  }

  double paid = totalPaid(student.id, term);
  double balance = roundMoney(fee.amount - paid);
  print('Fee: ${money(fee.amount)}  Paid so far: ${money(paid)}  '
      'Balance: ${money(balance)}');

  if (balance <= 0) {
    print('This student has already paid in full for term $term.');
    return;
  }

  double amount = readAmount('Enter amount paid: ');
  if (amount > balance) {
    print('Error: the amount is more than the balance of ${money(balance)}. '
        'Payment not recorded.');
    return;
  }

  String method = chooseMethod();
  Payment p = addPayment(student.id, term, amount, method);
  printReceipt(p, student, roundMoney(balance - amount));
}

void printReceipt(Payment p, Student student, double balanceAfter) {
  print('');
  print('=' * 60);
  print('                 FEETRACK PAYMENT RECEIPT');
  print('=' * 60);
  print('Receipt No : ${p.receiptNo}');
  print('Date       : ${formatDate(p.date)}');
  print('Student    : ${student.name} (ID ${student.id})');
  print('Class      : ${className(student.classId)}');
  print('Term       : ${p.term}');
  print('Method     : ${p.method}');
  print('Amount     : ${money(p.amount)}');
  print('Balance    : ${money(balanceAfter)}');
  print('=' * 60);
}

// Feature 4: View a student's balance for a term
void viewBalance() {
  print('\n--- View Student Balance ---');
  int id = readInt('Enter student ID: ', 1, 999999);
  Student? student = findStudent(id);
  if (student == null) {
    print('Error: no student found with ID $id.');
    return;
  }

  int term = readInt('Enter term (1-3): ', 1, 3);
  FeeStructure? fee = getFee(student.classId, term);
  if (fee == null) {
    print('No fee has been set for ${className(student.classId)} in term $term.');
    return;
  }

  double paid = totalPaid(student.id, term);
  double balance = roundMoney(fee.amount - paid);

  String status;
  if (balance <= 0) {
    status = 'PAID IN FULL';
  } else if (paid > 0) {
    status = 'PART PAYMENT';
  } else {
    status = 'NOT PAID';
  }

  printLine();
  print('Student : ${student.name} (${className(student.classId)})');
  print('Term    : $term');
  print('Fee     : ${money(fee.amount)}');
  print('Paid    : ${money(paid)}');
  print('Balance : ${money(balance)}');
  print('Status  : $status');
  printLine();
}

// Feature 5: View all payments made by one student
void viewPaymentHistory() {
  print('\n--- Payment History ---');
  int id = readInt('Enter student ID: ', 1, 999999);
  Student? student = findStudent(id);
  if (student == null) {
    print('Error: no student found with ID $id.');
    return;
  }

  print('\nPayments for ${student.name} (${className(student.classId)})');
  printLine();

  int count = 0;
  double total = 0;
  for (Payment p in payments) {
    if (p.studentId == student.id) {
      count++;
      total += p.amount;
      print('${p.receiptNo}  ${formatDate(p.date)}  Term ${p.term}  '
          '${money(p.amount)}  ${p.method}');
    }
  }

  if (count == 0) {
    print('No payments have been recorded for this student.');
  } else {
    printLine();
    print('Number of payments: $count   Total paid: ${money(roundMoney(total))}');
  }
}

// Feature 6: List students who still owe fees
void listDefaulters() {
  print('\n--- Defaulter List ---');
  int term = readInt('Enter term (1-3): ', 1, 3);

  print('\nStudents with an outstanding balance in term $term');
  printLine();

  int count = 0;
  double totalOwed = 0;
  for (Student s in students) {
    FeeStructure? fee = getFee(s.classId, term);
    if (fee == null) {
      continue; // no fee set for this class, so skip
    }
    double balance = roundMoney(fee.amount - totalPaid(s.id, term));
    if (balance > 0) {
      count++;
      totalOwed += balance;
      Guardian? g = findGuardian(s.guardianId);
      String phone = (g == null) ? 'N/A' : g.phone;
      print('ID ${s.id}  ${s.name.padRight(18)} ${className(s.classId).padRight(6)} '
          'Owes ${money(balance)}  Tel: $phone');
    }
  }

  if (count == 0) {
    print('No defaulters. All students are paid up for this term.');
  } else {
    printLine();
    print('Defaulters: $count   Total outstanding: ${money(roundMoney(totalOwed))}');
  }
}

// Feature 7: Collection summary for each class
void classSummary() {
  print('\n--- Collection Summary per Class ---');
  int term = readInt('Enter term (1-3): ', 1, 3);

  print('\nTerm $term summary');
  printLine();
  print('${'Class'.padRight(8)}${'Students'.padRight(10)}${'Expected'.padRight(14)}'
      '${'Collected'.padRight(14)}Rate');
  printLine();

  double grandExpected = 0;
  double grandCollected = 0;

  for (SchoolClass c in classes) {
    FeeStructure? fee = getFee(c.id, term);
    if (fee == null) {
      print('${c.name.padRight(8)}No fee set for this term');
      continue;
    }

    int studentCount = 0;
    double collected = 0;
    for (Student s in students) {
      if (s.classId == c.id) {
        studentCount++;
        collected += totalPaid(s.id, term);
      }
    }

    double expected = fee.amount * studentCount;
    double rate = (expected == 0) ? 0 : (collected / expected) * 100;
    grandExpected += expected;
    grandCollected += collected;

    print('${c.name.padRight(8)}${studentCount.toString().padRight(10)}'
        '${expected.toStringAsFixed(2).padRight(14)}'
        '${collected.toStringAsFixed(2).padRight(14)}'
        '${rate.toStringAsFixed(1)}%');
  }

  printLine();
  double overallRate =
      (grandExpected == 0) ? 0 : (grandCollected / grandExpected) * 100;
  print('Total expected : ${money(roundMoney(grandExpected))}');
  print('Total collected: ${money(roundMoney(grandCollected))}');
  print('Outstanding    : ${money(roundMoney(grandExpected - grandCollected))}');
  print('Collection rate: ${overallRate.toStringAsFixed(1)}%');
}

// Feature 8: List all students
void viewAllStudents() {
  print('\n--- All Registered Students ---');
  printLine();
  if (students.isEmpty) {
    print('No students registered yet.');
    return;
  }
  for (Student s in students) {
    Guardian? g = findGuardian(s.guardianId);
    String guardianName = (g == null) ? 'N/A' : g.name;
    print('ID ${s.id}  ${s.name.padRight(18)} ${className(s.classId).padRight(6)} '
        'Guardian: $guardianName');
  }
  printLine();
  print('Total students: ${students.length}');
}

// ======================================================
// 7. MENU AND MAIN
// ======================================================

void showMenu() {
  print('');
  print('=' * 60);
  print('      FEETRACK - SCHOOL FEE AND PAYMENT TRACKER');
  print('=' * 60);
  print('1. Register a student');
  print('2. Set class fee for a term');
  print('3. Record a payment');
  print('4. View student balance');
  print('5. View payment history');
  print('6. List defaulters');
  print('7. Collection summary per class');
  print('8. View all students');
  print('0. Exit');
  print('-' * 60);
}

void main() {
  loadSampleData();
  print('Sample data loaded: 6 classes, 5 students, 3 payments (Term 1).');

  bool running = true;
  while (running) {
    showMenu();
    int choice = readInt('Enter your choice (0-8): ', 0, 8);

    switch (choice) {
      case 1:
        registerStudent();
        break;
      case 2:
        setClassFee();
        break;
      case 3:
        recordPayment();
        break;
      case 4:
        viewBalance();
        break;
      case 5:
        viewPaymentHistory();
        break;
      case 6:
        listDefaulters();
        break;
      case 7:
        classSummary();
        break;
      case 8:
        viewAllStudents();
        break;
      case 0:
        running = false;
        print('\nThank you for using FeeTrack. Goodbye!');
        break;
    }

    if (running) {
      pause();
    }
  }
}
