
/*
	Hotel (Hotel_No, Name, Address(contry,state,city))
		-FD's
			- Hotel_No-> Name, Address
					After address expansion
            - Hotel_No-> Name, Country, state, city
            - country-> state
            - state-> City
		- Transitive dependency is here hotel_no->country->state->city.
		- decomposition : lossless, dependency should be maintained
        - Hotel(Hotel_No, Name,city_id)
        Country(country_id, Country_name)
        state(state_id,country_id,state_name)
        City(city_id,state_id,City_name)
        
        
		
    Room (room_id,Room_No, Hotel_No, Type, Price)
		- We want to add capacity of room. type-> capacity transitive dependency
        - Room(Room_No, Hotel_No, Type,room_capacity,price)
        -After decomposition
			Room(Room_No, Hotel_No, Type,price)
			room_type(type,room_capacity)

        - Room_No,Hotel_No-> Room_No, Hotel_No, Type, Price
		- PK(Room_No,Hotel_No)
        - There is no partial dependency
        - There is no transitive dependency. 
        - Suppose if there is only one hotel then room_no->type->price transitive dependency or
			same type of room having same price in differen hotels can also lead transitive dependency.
            But here I am considering different hotels having different location and different prices of rooms according
            to affordability of locality.
        
     Guest (Guest_No, Name, Address(contry,state,city))
		- Address might cause issue of 3NF in address field Country, zip, state, town
        - guest(Guest_No, Name, city_id)
		- Country(country_id, Country_name)
		  state(state_id, country_id, state_name)
          City(city_id,state_id,City_name)
          
    Booking (Hotel_No, Guest_No, Date_From, Date_To, Room_No) 
        - adding primary key booking_id
		- (booking_id, guest_No, Hotel_No, Room_No,from_date, to_date)
        -FD's
			- booking_id-> booking_id, guest_No, Hotel_No, Room_No,from_date, to_date
            - guest_no,hotel_no,from_date->guest_no,hotel_no,from_date,to_date,room_no,booking_id
            - No partial dependency, No transitive dependency
		
   

*/
create database project1;
use project1;
create table hotel
(
	hotel_no varchar(10) primary key , 
    hotel_name varchar(100) not null,
    city_id int not null,
    foreign key (city_id) references city(city_id) on delete cascade on update cascade
);

create table country
(country_id int primary key auto_increment,
 Country_name varchar(100) not null
 );

 create table state
 (state_id int primary key auto_increment,
  country_id int not null,
 state_name varchar(100) not null,
 foreign key (country_id) references country(country_id) on delete cascade on update cascade
 );
 
create table city
(city_id int primary key auto_increment,
state_id int not null,
City_name varchar(100) not null,
foreign key (state_id) references state(state_id) on delete cascade on update cascade
);

create table room
(
 room_id int primary key auto_increment,
 room_no int,
 hotel_no varchar(10) not null, 
 room_type varchar(200) not null,
 price int not null,
 foreign key (hotel_no) references hotel(hotel_no) on delete cascade on update cascade,
 foreign key (room_type) references room_types(room_type) on delete cascade on update cascade
 );

create table room_types
(
room_type varchar(200) primary key,
room_capacity int not null
);

create table guest
(
guest_no int primary key auto_increment,
guest_name varchar(500) not null, 
city_id int not null,
foreign key (city_id) references city(city_id) on delete cascade on update cascade
);

create table booking
(
booking_id int primary key auto_increment,
hotel_no varchar(10) not null,
guest_no int not null,
date_From timestamp default now(),  #Normaly you only can use constants for default-values. 
									#TIMESTAMP is the only column-type which supports a function like NOW()
date_to timestamp default now(), 
room_id int not null,
foreign key (guest_no) references guest(guest_no),
foreign key (hotel_no) references hotel(hotel_no),
foreign key (room_id) references room(room_id)
);

insert into country(country_name) values
('England'),
('India')
;
insert into state (country_id,state_name) values
(1,'Bedfordshire'),
(1,'Berkshire'),
(1,'Greater London'),
(1,'Hampshire'),
(2,'Maharashtra'),
(2,'Karnataka')
;
insert into city(state_id,city_name) values
(1,'Ampthill'),
(3,'London'),
(3 ,'Camden'),
(3,'Westminster'),
(5, 'Pune'	),
(6, 'Bengaluru'	);

insert into hotel(hotel_no,hotel_name,city_id) values
('H111', 'Grosvenor Hotel', 2),
('H112', 'Grosvenor Hotel', 2),
('I100', 'Grosvenor Hotel', 5)
;

SET FOREIGN_KEY_CHECKS=0; SET FOREIGN_KEY_CHECKS=1;

insert into room_types values
('single bed',1),
('double bed',2),
('delux',4),
('single bed ac',1),
('double bed ac',2),
('delux ac',4)
;

insert into room(room_no, hotel_no, room_type, price) values
(1,'H111','single bed',500),
(2,'H111','single bed',500),
(3,'H111','single bed',500),
(4,'H111','single bed ac',700),
(5,'H111','single bed ac',700),
(6,'H111','double bed',1000),
(7,'H111','double bed ac',1200),
(8,'H111','delux',1500),
(9,'H111','delux ac',1700),

(1,'H112','single bed ac',500),
(2,'H112','single bed',300),
(3,'H112','double bed',500),
(4,'H112','double bed ac',700)
;

insert into guest (guest_name, city_id) values
('Paul smith',2),
('Lauren Kiyoski',2),
('Sandy Shmis',2),
('Alex Andrew',2),
('Kaithy Williom',2),
('Amison Sundre',2),
('Kevin Pattyson',2),

('Lavin Simans',1),
('Andrew James',3),
('Shikara sethi',4)
;

INSERT INTO booking (room_id,guest_no,date_from, date_to)
VALUES 
(1, 1, '1995-07-10','1995-07-12'),
(2, 2, '1996-05-11','1996-05-13'),
(3, 3, '1999-01-09','1999-01-10'),
(1, 6, '2000-01-05','2000-01-06'),
(5, 7, '2001-08-10','2001-08-13'),
(8, 2, '2002-09-05','2002-09-06')

;

INSERT INTO booking (room_id,guest_no,date_from, date_to)
VALUES 
 (2,2,'2022-10-09','2022-10-12');

/*
	Updating the Tables
	UPDATE room SET price = price*1.05;
	Create a separate table with the same structure as the Booking table to hold archive records.
	Using the INSERT statement, copy the records from the Booking table to the archive table relating to bookings before 1st January 2000. 
	Delete all bookings before 1st January 2000 from the Booking table.
*/

#UPDATE room SET price = price*1.05;
update room set price=price*1.05;

#Create a separate table with the same structure as the Booking table to hold archive records.
create table booking_archive
(
booking_id int primary key auto_increment,
hotel_no varchar(10) not null,
guest_no int not null,
date_From timestamp default now(),  #Normaly you only can use constants for default-values. 
									#TIMESTAMP is the only column-type which supports a function like NOW()
date_to timestamp default now(), 
room_id int not null,
foreign key (guest_no) references guest(guest_no),
foreign key (hotel_no) references hotel(hotel_no),
foreign key (room_id) references room(room_id)

);

#Using the INSERT statement, copy the records from the Booking table to the archive table relating to bookings before 1st January 2000. 
insert into booking_archive(hotel_no,guest_no,date_from,date_to,room_id) (select * from booking where date_from< '2000-01-01');
select * from booking_archive; 

# Delete all bookings before 1st January 2000 from the Booking table.
delete from booking where from_date<'2000-01-01';


# simple queries
# 1. List full details of all hotels.
select h.hotel_no,h.hotel_name,c.city_name,s.state_name,co.country_name from hotel h 
inner join city c on h.city_id=c.city_id
inner join state s on c.state_id=s.state_id
inner join country co on co.country_id=s.country_id ;

# 2. List full details of all hotels in London.

select h.hotel_no,h.hotel_name,c.city_name,s.state_name,co.country_name from hotel h 
inner join city c on h.city_id=c.city_id
inner join state s on c.state_id=s.state_id
inner join country co on co.country_id=s.country_id where c.city_name ='London'; 

# 3. List the names and addresses of all guests in London, alphabetically ordered by name.
select g.guest_name, concat(c.city_name,', ',s.state_name,', ',co.country_name) as address from guest g
inner join city c on g.city_id=c.city_id
inner join state s on s.state_id=c.state_id
inner join country co on co.country_id=s.country_id where c.city_name='London' order by g.guest_name asc;

# 4. List all double or family rooms with a price below £40.00 per night, in ascending order of price.
select * from room where room_type in('double bed','double bed ac','delux','delux ac') and price<40 order by price;

# 5. List the bookings for which no date_to has been specified.
select * from booking where date_from= null or date_to =null;

# Aggregate Functions

#  1. How many hotels are there?
select  count(*) as number_of_hotel from hotel;
select count(hotel_no) as number_of_hotel from hotel;

# 2. What is the average price of a room?
select avg(price) as average_price_of_rooms from room;

# 3. What is the total revenue per night from all double rooms?
select sum(price) 'total revenue per night from all double rooms' from room where room_type in('double bed', 'double bed ac');

# 4. How many different guests have made bookings for August?
select distinct count(g.guest_name)  from guest g
inner join booking b on b.guest_no=g.guest_no
where month(b.date_from)='08';

#Subqueries and Joins

# 1. List the price and type of all rooms at the Grosvenor Hotel.
select * from room;
	select r.price ,r.room_type from room r where r.hotel_no in (select h.hotel_no from hotel h where hotel_name='Grosvenor Hotel');

# 2. List all guests currently staying at the Grosvenor Hotel.
SELECT * FROM project1.booking;
select * from room;
 select (select  h.hotel_name from hotel h where h.hotel_no=(select r.hotel_no  from room r where r.room_id=b.room_id)) as hotel_name,
 (select g.guest_name from guest g where g.guest_no=b.guest_no) as guest_name,
 b.date_from,b.date_to from booking b where sysdate() between (b.date_from) and (b.date_to);
 
#  3. List the details of all rooms at the Grosvenor Hotel, including the name of the guest staying in the room, if the room is occupied.
with cte as
(
	select r.room_no,r.price,h.hotel_no,h.hotel_name,g.guest_name,b.date_from,b.date_to from room r
    inner join hotel h on h.hotel_no=r.hotel_no
    inner join booking b on b.room_id=r.room_id
    inner join guest g on g.guest_no=b.guest_no
)
select cte.room_no,cte.price,cte.hotel_no,cte.hotel_name,cte.guest_name,cte.date_from,cte.date_to from cte 
where date(cte.date_to) >= date(sysdate());

# 4. What is the total income from bookings for the Grosvenor Hotel today?
with cte as
(
	select r.room_no,(r.price* datediff(b.date_to,b.date_from)) as price,h.hotel_no,h.hotel_name,g.guest_name,b.date_from,b.date_to from room r
    inner join hotel h on h.hotel_no=r.hotel_no
    inner join booking b on b.room_id=r.room_id
    inner join guest g on g.guest_no=b.guest_no
)
select sum(cte.price) as total from cte ;
-- where date(sysdate()) between date(cte.date_from) and date(cte.date_from);


# 5. List the rooms that are currently unoccupied at the Grosvenor Hotel.
with cte as
(
	select r.room_no, r.hotel_no from room r where r.room_id not in
    (select b.room_id from booking b where date(sysdate()) between date(b.date_from) and date(b.date_to))
 
)
select * from cte;

#6. What is the lost income from unoccupied rooms at the Grosvenor Hotel?

with cte as
(
	select r.room_no, r.hotel_no,r.price from room r where r.room_id not in
    (select b.room_id from booking b where date(sysdate()) between date(b.date_from) and date(b.date_to))
 
)
select sum(cte.price) lost_income from cte;

#Grouping

#1. List the number of rooms in each hotel.
	select h.hotel_name, H.hotel_no, r.room_no from room r
    inner join hotel h on h.hotel_no=r.hotel_no
    group by h.hotel_no,r.room_no;
    
    select h.hotel_no,count(r.room_no) from room r
inner join hotel h on r.hotel_no=h.hotel_no
inner join city ct on ct.city_id= h.city_id
group by h.hotel_no;
    
# 2. List the number of rooms in each hotel in London.
select h.hotel_no,count(r.room_no),ct.city_name from room r
inner join hotel h on r.hotel_no=h.hotel_no
inner join city ct on ct.city_id= h.city_id
group by h.hotel_no having ct.City_name='london' ;


# 3. What is the average number of bookings for each hotel in August?
select count(*) from booking b 
inner join room r on r.room_id=b.room_id
inner join hotel h on h.hotel_no=r.hotel_no
where month(b.date_from)='08' 
group by h.hotel_no;

# 4. What is the most commonly booked room type for each hotel in London?
with cte as
(
select hotel_no,room_type,max(sum_same_room_type) as max
 from (select hotel_no,room_type,sum(same_room_type) as sum_same_room_type 
 from(SELECT h.hotel_no,r.room_type,b. room_id,count(b.room_id) as same_room_type FROM booking b
inner join room r on r.room_id=b.room_id
inner join hotel h on h.hotel_no=r.hotel_no
 group by b.room_id,h.hotel_no) t1 group by hotel_no,room_type)  t2 group by hotel_no 
)
select *, dense_rank() over(order by cte.max) from cte;


#5. What is the lost income from unoccupied rooms at each hotel today?

with cte as
(
	select r.room_no, r.hotel_no,r.price from room r where r.room_id not in
    (select b.room_id from booking b where date(sysdate()) between date(b.date_from) and date(b.date_to))
 
)
select cte.hotel_no,sum(cte.price) lost_income from cte inner join hotel h on h.hotel_no=cte.hotel_no group by cte.hotel_no;

/*inner join city cc
on cc.city_id=h.city_id where cc.city_name='london';
*/