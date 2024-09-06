create database LibraryAnalysis;


use LibraryAnalysis;

-- Publisher
create table Publisher(Publisher_Name varchar(255) primary key, Address varchar(255), Publisher_PhNo varchar(255));

-- Borrower
create table borrower(Borrower_id smallint primary key, Borrower_Name varchar(255), borrower_Address varchar(255), borrower_PhNo varchar(255));

-- Branch
create table Branch(Branch_id smallint auto_increment primary key, Branch_Name varchar(255), branch_Address varchar(255));

-- Books
create table books(Book_id smallint auto_increment primary key, Book_Title varchar(255), Book_Publisher_Name varchar(255), foreign key (Book_Publisher_Name) references Publisher(Publisher_Name));

-- Authors
create table Authors(Author_id smallint auto_increment primary key, Book_Id smallint, Author_Name varchar(255), foreign key (Book_Id) references books(Book_id));

-- Book Copies
create table Copies(Copies_id smallint auto_increment primary key, Book_Id smallint, Branch_Id smallint, No_of_Copies int, foreign key (Book_Id) references books(Book_id), foreign key (Branch_Id) references Branch(Branch_id));

-- Loans
create table Loans(Loans_id smallint auto_increment primary key, Book_Id smallint, Branch_Id smallint, Borrower_Id smallint, Book_DateOut varchar(255), Book_DueDate varchar(255), foreign key (Book_Id) references books(Book_id), foreign key (Branch_Id) references Branch(Branch_id), foreign key (Borrower_Id) references Borrower(Borrower_id));

-- Questions:
-- 1.How many copies of the book titled "The Lost Tribe" are owned by the library branch whose name is "Sharpstown"?
select Book_title, Branch_name, No_of_Copies from copies join books using(book_id) join branch using(branch_id)
 where Book_id = (select book_id from books where book_title = "The Lost Tribe") 
 and branch_id = (select branch_id from branch where branch_Name = "Sharpstown");

-- 2.How many copies of the book titled "The Lost Tribe" are owned by each library branch?
select branch_name, sum(no_of_copies) as Count from copies join branch using(branch_id) 
group by branch_name, book_id having Book_id = (select book_id from books 
where book_title = "The Lost Tribe");

-- 3.Retrieve the names of all borrowers who do not have any books checked out.
select borrower_name from borrower
 where borrower_id not in (select borrower_id from loans);

-- 4.For each book that is loaned out from the "Sharpstown" branch and whose DueDate is 2/3/18, retrieve the book title, the borrower's name, and the borrower's address.
with cte_1 as(select *, str_to_date(Book_DateOut, '%m/%d/%Y') as new_Book_DateOut, str_to_date(Book_DueDate, '%m/%d/%Y') 
	as new_Book_DueDate from loans join books using(Book_Id) join borrower using(Borrower_Id) 
    where Branch_id = (select branch_id from branch where branch_name = 'Sharpstown'))
select Book_title, Borrower_Name, Borrower_Address from cte_1
 where new_Book_DueDate = '2018-02-03';

-- 5.For each library branch, retrieve the branch name and the total number of books loaned out from that branch.
select Branch_Name, count(book_id) as Number_of_Books from branch join loans using(branch_id) 
group by Branch_Name;

-- 6.Retrieve the names, addresses, and number of books checked out for all borrowers who have more than five books checked out.
select borrower_name, borrower_address, count(*) as Number_of_books_checked from borrower join loans 
using(borrower_id) group by borrower_name, borrower_address;

-- 7. For each book authored by "Stephen King", retrieve the title and the number of copies owned by the library branch whose name is "Central".
with cte_1 as (select * from books join copies using(Book_id) join branch using(branch_id) join authors using(book_id))
select Book_Title, No_of_Copies from cte_1 where author_name = 'Stephen King' and Branch_name = 'Central';