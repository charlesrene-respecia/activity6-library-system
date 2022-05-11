import 'dart:io';

//class for books
class Book{
  var title;
  var author;
  var ISBN;
  var genre;
  late bool isAvailable;
  Book(){
    stdout.write("Title - ");
    title=stdin.readLineSync();
    stdout.write("Author - ");
    author=stdin.readLineSync();
    stdout.write("ISBN - ");
    ISBN=stdin.readLineSync();
    stdout.write("Genre - ");
    genre=stdin.readLineSync();
    isAvailable=true;
  }
  Book.forMock(var title, var author, var genre, var ISBN){
    this.title=title;
    this.author=author;
    this.genre=genre;
    this.ISBN=ISBN;
    this.isAvailable=true;
  }
}

//class for users
class User{
  var name;
  var address;
  var studentID;  //assuming all users have student IDs
  late List books;
  User(){
    books=[];
    stdout.write("Name - ");
    name=stdin.readLineSync();
    stdout.write("Address - ");
    address=stdin.readLineSync();
    stdout.write("Student ID - ");
    studentID=stdin.readLineSync();
  }
}

class Admin{
  //mock admin code for log in
  String code="iamadmin";
  late int booksInCollection, booksLent;
  late List lentBooks, availableBooks, users;

  //constructor initializing available and lent out books to 0
  Admin(){
    stdout.write("Enter admin code - ");
    var inputCode=stdin.readLineSync();
    if(inputCode==code){
      print("Welcome Admin...");
    }
    else{
      print("Your code is incorrect.");
    }
    lentBooks=[];
    availableBooks=[];
    users=[];
    booksInCollection=0;
    booksLent=0;
  }

  Admin.forUser(){
    lentBooks=[];
    availableBooks=[];
    users=[];
    booksInCollection=0;
    booksLent=0;
  }

  //admin adding a book to the collection
  void add(){
    var newBook=new Book();
    availableBooks.add(newBook);
    booksInCollection++;
  }

  //add mock books
  void addMOCK(var title, var author, var genre, var ISBN){
    var newBook=new Book.forMock(title, author, genre, ISBN);
    availableBooks.add(newBook);
    booksInCollection++;
  }

  //admin lends out books
  void letBorrow(){
    stdout.write("Enter book title - ");
    var title=stdin.readLineSync();
    stdout.write("Enter book author - ");
    var author=stdin.readLineSync();
    bool found=false;
    int index=0;
    for(var tempBook in availableBooks){
      if(title==tempBook.title && author==tempBook.author){
        var newUser=new User();
        newUser.books.add(tempBook);
        users.add(newUser); 
        tempBook.isAvailable=false;       
        lentBooks.add(tempBook);
        availableBooks.removeAt(index);
        booksLent++;
        booksInCollection--;
        print("Book ${title} by ${author} is added to your borrowed books list.");
        found=true;
        break;
      }
      index++;
    }
    if(found==false){
      print("Book you requested to borrow is not available for now.\n");
    }
  }

  //admin accepts returned books
  void acceptBook(){
    stdout.write("Enter Student ID - ");
    var studentID=stdin.readLineSync();
    for(var tempUser in users){
      if(tempUser.studentID==studentID){
        for(var tempBook in lentBooks){
          for(var tempLent in tempUser.books){
            if(tempLent==tempBook){
              tempLent.isAvailable=true;
              availableBooks.add(tempLent);
              booksLent--;
              booksInCollection++;
            }
          }
        }
        print("All books in your borrow list have been returned.\n");
        tempUser.books.clear();
      }
    }
  }
}

//adding mock info to library
void mockAdd(var mock){
  mock.addMOCK("Book1", "Author1", "Philosophy", "12300000000");
  mock.addMOCK("Book2", "Author2", "Pure Science", "12400000000");
  mock.addMOCK("Book3", "Author3", "Computer Science", "12500000000");
  mock.addMOCK("Book4", "Author4", "Art and Recreation", "12600000000");
  mock.addMOCK("Book5", "Author5", "History", "12700000000");
  mock.addMOCK("Book6", "Author6", "Philosophy", "12800000000");
}

void main(){
  var admin1;
  print("Who are you?");
  print("1-Admin\n2-User");
  var option=stdin.readLineSync();
  if(option=='1'){
    admin1=new Admin();
    print("Time to add books!");
    for(;;){
      print("\n1 - Continue adding\n2 - View books\n3 - Exit");
      var choice=stdin.readLineSync();
      if(choice=='1'){
        admin1.add();
      }
      else if(choice=='3'){
        break;
      }
      else if(choice=='2'){
        for(var tempBook in admin1.availableBooks){
          print("${tempBook.title} by ${tempBook.author} with ISBN ${tempBook.ISBN}");
        }
      }
    }
  }
  else if(option=='2'){
    admin1=new Admin.forUser();
    mockAdd(admin1);
    for(;;){
      print("Hello User! What do you want to do?");
      print("1 - View available books\n2 - Borrow books\n3 - Return books\n4 - Exit");
      var option=stdin.readLineSync();
      if(option=='1'){
        for(var tempBook in admin1.availableBooks){
          print("${tempBook.title} by ${tempBook.author} with ISBN ${tempBook.ISBN}");
        }
      }
      else if(option=='2'){
        admin1.letBorrow();
      }
      else if(option=='3'){
        admin1.acceptBook();
      }
      else if(option=='4'){
        break;
      }
      else{
        print("Oops. Looks like your input is not valid.\n");
      }
    }
  }
  else{
    print("Your input is incorrect. Failed to enter the system.");
  }
}