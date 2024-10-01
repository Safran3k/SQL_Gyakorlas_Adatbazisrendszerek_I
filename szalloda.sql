Use Szalloda;

-- 1. feladat
Create Table Foglalasok(
	Szoba Integer not null,
	Vendeg Integer not null,
	Kezdete Date Default Getdate() not null,
	Vege Date,
	Fizetett_osszeg Decimal(12, 2) not null
);

Create Table Vendegek(
	Id Integer not null,
	Nev Varchar(250) not null,
	Szulido Date,
	Szulhely Varchar(250),
	Lakcim Varchar(250),
	No Integer
);

Create Table Szobak(
	Szam Integer not null,
	Emelet Integer not null,
	Agyak_szama Integer not null,
	Tv Integer,
	Mini_bar Integer,
	Ar Decimal(12, 2) not null
);

Alter Table Szobak
	Add Constraint Szobak_PK Primary Key (Szam);

Alter Table Vendegek
	Add Constraint Vendegek_PK Primary Key (Id);

Alter Table Foglalasok
	Add Constraint PK_Foglalasok Primary Key (Szoba, Kezdete);

Alter Table Foglalasok
	Add Constraint FK_Foglalasok_Szoba Foreign Key (Szoba) References Szobak(Szam);

Alter Table Foglalasok
	Add Constraint FK_Foglalasok_Vendeg Foreign Key (Vendeg) References Vendegek(Id);

-- 2. feladat
Insert Into Szobak (Szam, Emelet, Agyak_szama, Tv, Mini_bar, Ar)
	Values 
		(102, 1, 1, 1, 0, 12000.00),
		(103, 1, 3, 1, 1, 20000.00),
		(201, 2, 2, 1, 1, 18000.00),
		(202, 2, 1, 1, 0, 11000.00),
		(203, 2, 4, 1, 1, 25000.00);

Insert Into Vendegek (Id, Nev, Szulido, Szulhely, Lakcim, No)
	Values
		(2, 'Nagy Anna', '1990-03-12', 'Debrecen', 'Debrecen, Kossuth utca 2.', 1),
		(3, 'Toth Gabor', '1987-11-22', 'Szeged', 'Szeged, Petofi utca 3.', 0),
		(4, 'Szabo Erika', '1995-06-05', 'Pecs', 'Pecs, Ady Endre utca 4.', 1),
		(5, 'Farkas Istvan', '1982-09-10', 'Gyor', 'Gyor, Kalvin ter 5.', 0),
		(6, 'Kiss Marta', '1978-01-30', 'Miskolc', 'Miskolc, Bartok Bela utca 6.', 1);

Insert Into Foglalasok (Szoba, Vendeg, Kezdete, Vege, Fizetett_osszeg)
	Values
		(102, 2, '2024-09-15', '2024-09-20', 60000.00),
		(103, 3, '2024-10-05', '2024-10-12', 140000.00),
		(201, 4, '2024-08-25', '2024-08-30', 90000.00),
		(202, 5, '2024-09-10', '2024-09-12', 22000.00),
		(203, 6, '2024-11-01', '2024-11-07', 175000.00);


-- 3. feladat
Select Szam, Agyak_szama, Tv, Mini_bar from Szobak Order by Emelet Asc, Ar Desc;

-- 4. feladat
Select * from Szobak 
    Where 
        Agyak_szama >= 2 and 
        Tv = 1 and 
        Emelet = 1 
    Order by Ar Asc;

-- Ha azt is figyelembe vesszuk hogy szabad-e a szoba
Select s.* from Szobak s
	left join Foglalasok f on s.Szam = f.Szoba
	Where 
		s.Agyak_szama >= 2 and
		s.Tv = 1 and
		s.Emelet = 1 and
		(f.Kezdete > GETDATE() OR f.Vege < GETDATE())
	Order by s.Ar Asc;

-- 5. feladat
Select *, Ar * 5 As Osszkoltseg from Szobak 
    Where 
        Agyak_szama >= 3 and 
        Tv = 1 and 
		Mini_bar = 1 and
        Ar * 5 <= 50000 
    Order by Ar Asc;
	
-- Ha azt is figyelembe vesszuk hogy szabad-e a szoba
Select s.*, Ar * 5 as Osszkoltseg from Szobak s
	left join Foglalasok f on s.Szam = f.Szoba
	Where 
		s.Agyak_szama >= 3 and 
        s.Tv = 1 and 
		s.Mini_bar = 1 and
        s.Ar * 5 <= 50000 and
		(f.Kezdete > GETDATE() OR f.Vege < GETDATE())
	Order by s.Ar Asc;

-- 6. feladat
Select Sum(Szobak.Agyak_szama) as Ossz_hely from Szobak;

-- 7. feladat
Select s.Szam, Cast((s.Ar / s.Agyak_szama) as Decimal(10, 0)) As 'Ejszakankenti 1 fore juto ar' from Szobak s 
	Order by (s.Ar / s.Agyak_szama) Desc;

-- 8. feladat
Select Cast(Avg(Ar / Agyak_szama) as Decimal(10, 0)) as 'Atlagos ar/fo' from Szobak
	Where 
		Tv = 1 and 
		Mini_bar = 1;

-- 9. feladat
Select s.Emelet, Sum(s.Ar * 10) as Osszes_koltseg_10_napra from Szobak s
	Group by 
		s.Emelet
	Having 
		Sum(s.Agyak_szama + 1) >= 10 and
		Sum(s.Ar * 10) Between 50000 and 5000000
	Order by 
		Sum(s.Ar * 10);

-- 10. feladat
Select Max(Ar) as Legdragabb_szoba from Szobak;

-- 11. feladat
Select Min(Ar) as Legolcsobb_szoba from Szobak;

-- 12. feladat
Select Top 1 Szam from Szobak
	Order by Ar Desc, Szam Asc;

-- 13. feladat
Select * from Szobak
	Where Ar = (Select Min(Ar) from Szobak)
	Order by Szam Asc;

-- 14. feladat
Select Emelet, Sum(Agyak_szama) as Osszes_ferohely from Szobak
	Group by 
		Emelet
	Order by 
		Emelet Desc;

-- 15. feladat
Select Emelet, 
       Sum(Agyak_szama) as Emeleti_agyak, 
       Cast(Sum(Agyak_szama) * 100.0 / (Select Sum(Agyak_szama) from Szobak) as Decimal(10, 0)) as Szazalek from Szobak
	Group by Emelet
	Order by Szazalek Asc;

-- 16. feladat
Select Szam from Szobak 
	Where Szam not in (Select Szoba from Foglalasok);

-- 17. feladat
Update Szobak
Set Tv = 1, 
    Mini_bar = 1
Where (Ar / Agyak_szama) > 5000;

-- 18. feladat
Select Nev, Szulhely, Szulido, Lakcim from Vendegek
	Order by Datediff(Year, Szulido, Getdate()) Asc;

-- 19. feladat
Select Nev, Szulhely, Szulido, Lakcim from Vendegek
	Where No = 1
	Order by Nev Asc;

-- 20. feladat
Select Nev, Szulido from Vendegek
	Where Szulido Between '1910-01-01' and '1987-12-31'
	Order by Nev Asc;

-- 21. feladat
Select Nev, Szulhely, Szulido from Vendegek
	Where Nev like 'Na__%Andor Ga__%'
	  and Szulhely like '__da_%'
	  and Szulido like '1912-1_-_1';

-- 22. feladat
Select Nev, Szulhely, Lakcim from Vendegek
	Where Szulhely = Substring(Lakcim, Charindex(' ', Lakcim) + 1, Charindex(',', Lakcim) - Charindex(' ', Lakcim) - 1)
	Order by Szulhely Desc;

-- 23. feladat
Select Nev, Szulhely, Szulido from Vendegek
	Where Szulido = (Select Min(Szulido) from Vendegek)
	Order by Nev Asc;

-- 24. feladat
Select Nev, Szulhely, Szulido from Vendegek
	Where Szulido = (Select Max(Szulido) from Vendegek)
	Order by Nev Asc;

-- 25. feladat
Select Count(*) as Vendeg_szam from Vendegek;

-- 26. feladat
Select Szulhely, Count(*) as Vendeg_szam from Vendegek
	Group by Szulhely;

-- 27. feladat
Select No, Count(*) as Vendeg_szam from Vendegek
	Group by No;

-- 28. feladat
Select Avg(Datediff(YY, Szulido, Getdate())) as Atlag_kor from Vendegek;

-- 29. feladat
Select Avg(Datediff(YY, Szulido, Getdate())) as Atlag_kor from Vendegek
	Group by No;

-- 30. feladat
Select Nev, Szulhely from Vendegek
	Where Id not in (Select Vendeg from Foglalasok);

-- 31. feladat
Delete from Vendegek
	Where Id not in (Select Vendeg from Foglalasok);

-- 32. feladat
Update Vendegek
	Set Szulhely = 'Eger'
	Where Szulhely = 'eger';

-- 33. feladat
Select Count(*) as Foglalt_szobak from Foglalasok
	Where Vege is null or Vege >= Getdate();

-- 34. feladat
Select Szoba from Foglalasok
	Where Vege is null or Vege >= Getdate()
	Order by Szoba Asc;

-- 35. feladat
Select Distinct Szoba from Foglalasok
	Where Year(Kezdete) = 2024;

-- 36. feladat
Select Szoba from Foglalasok
	Where Year(Kezdete) = 2014
	Group by Szoba
	Having Count(*) >= 5;

-- 37. feladat
Select v.Nev, f.Szoba, f.Kezdete, f.Vege, Datediff(Day, f.Kezdete, f.Vege) as Foglalas_hossza_napokban from Foglalasok f
	join Vendegek v on f.Vendeg = v.Id
	Order by f.Kezdete Asc;

-- 38. feladat
Select s.Szam, s.Emelet, s.Tv, s.Mini_bar, Count(f.Szoba) as Kivetelek_szama from Szobak s
	left join Foglalasok f on s.Szam = f.Szoba
	Group by s.Szam, s.Emelet, s.Tv, s.Mini_bar
	Order by s.Szam Asc;
	
-- 39. feladat
Select Sum(Fizetett_osszeg) as Szalloda_arbevete from Foglalasok
	Where Year(Kezdete) = 2013;

-- 40. feladat
Select f.Szoba, f.Kezdete, f.Vege, f.Fizetett_osszeg from Foglalasok f
	join Vendegek v on f.Vendeg = v.Id
	Where v.Nev = 'Tothne dr. Kiss Katalin'
	Order by f.Kezdete Asc;

-- 41. feladat
Select v.Nev, 
       Count(f.Szoba) as Kivetelek_szama, 
       Sum(f.Fizetett_osszeg) as Osszeg_fizetett,
       (Sum(f.Fizetett_osszeg) * 100.0 / (Select Sum(Fizetett_osszeg) from Foglalasok)) as Szazalek from Vendegek v
	join Foglalasok f on v.Id = f.Vendeg
	Group by v.Nev;

-- 42. feladat
Select Max(Datediff(Day, Kezdete, Vege)) as Leghosszabb_foglalas,
       Sum(Fizetett_osszeg) as Ossz_arbevetel from Foglalasok
	Where Vege is not null;

