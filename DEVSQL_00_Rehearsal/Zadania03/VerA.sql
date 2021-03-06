
-----------------------------------------------
--	polecenia wstępne
-----------------------------------------------	

	--	używając skryptu wystawionego na moodle odtworzyć bazę	[Chinook] (nie załączać kodu z moodle do skryptu egzaminacyjnego)
	--	w bazie danych utworzyć schemat o nazwie [egz]

	USE [Chinook]
	GO

-----------------------------------------------
--	CREATE TABLE + Constraints
-----------------------------------------------	
	
	--	w schemacie [egz] utworzyć dwie tabele (A i B), samedzielnie dobrać odpowiednie typy danych:

		--	A/ Studenci
			--	identyfikator studenta (PRIMARY KEY)
			--	Imię
			--	Nazwisko
			--	data urodzenia

		--	B/ Oceny
			--	identyfikator oceny (PRIMARY KEY, IDENTITY)
			--	identyfikator studenta (FOREIGN KEY)
			--	przedmiot
			--	ocena (CHECK - ocena z zakresu 1-6)
			--	data wstawienia oceny

			--	UNIQUE na kolumnach identyfikator studenta oraz przedmiot (każdy student ma tylko jedną ocenę z przedmiotu)

	--	wstawić po kilka wierszy do każdej z tabel	(min.3 na tabelę) 
			

-----------------------------------------------
--	WHERE
-----------------------------------------------	
	
	--	01 zwrócić listę klientów, których imię zaczyna się na literę A, B lub C (tabela: [dbo].[Customer])
	----------------------------------------------------------------------------------------

		SELECT *
		FROM [dbo].[Customer]

	--	02 zwrócić listę faktur, wystawionych pomiędzy datami 2011-05-01 oraz 2011-06-30 (tabela: [dbo].[Invoice])
	----------------------------------------------------------------------------------------


-----------------------------------------------
--	JOIN
-----------------------------------------------	

	--	03 zwrócić listę wszystkich Albumów nagranych przez zespoły: AC/DC', Led Zeppelin oraz Metallica
	--	(tab:	[dbo].[Artist],	[dbo].[Album])
	----------------------------------------------------------------------------------------


-----------------------------------------------
--	GROUP BY
-----------------------------------------------	

	--	04 tabela [dbo].[InvoiceLine] zawiera wszystkie faktury wystawione przez przedsiębiorstwo
	--	zwrócić sumaryczną kwotę sprzedaży ( tzn. ilość sprzedana razy cena jednostkowa, il.Quantity * il.UnitPrice)
	--	w podziale na Artystę
	--	pogrupować wg kwoty malejąco
	--	(tab:	[dbo].[Artist], [dbo].[Album],	[dbo].[Track],	[dbo].[InvoiceLine])

		/*
						[dbo].[Artist]			AS ar
			INNER JOIN	[dbo].[Album]			AS al	ON ar.ArtistId	= al.ArtistId
			INNER JOIN	[dbo].[Track]			AS tr	ON tr.AlbumId	= al.AlbumId
			INNER JOIN	[dbo].[InvoiceLine]		AS il	ON tr.TrackId	= il.TrackId
		*/
			

-----------------------------------------------
--	GROUPING SETS, GROUPING_ID(), CASE
-----------------------------------------------

	--	05
	--	przygotować raport, który zwraca sumaryczne kwoty faktur (kolumna [Total] w [dbo].[Invoice])
	--	pogrupowane po:
		--	mieście:	[BillingCity]
		--	państwie:	[BillingCountry]
	--	 raport ma zawierać również kwotę całkowitą
	--	posortować tak, aby najpierw wyświetlany był wiersz zbiorczy z kwotą całkowitą, następnie podsumowania po krajach a na końcu po miastach

	--	(tab:	[dbo].[Invoice])
	--	[uwaga]: zastosować jedną z klauzuli: GROUPING SETS/ ROLLUP/ CUBE. Zapytanie utworzone poprzez złączenie 3 podzapytań przez UNION ALL nie będą zaliczane


-----------------------------------------------
--	INDEX
-----------------------------------------------

	--	06
	--	utworzyć indeks nieklastrowany na tabeli [dbo].[InvoiceLine] na kolumnie [TrackId]
	--	do indeksu dołączyć kolumnę [InvoiceId] (nie pownna być częścią klucza indeksu)


-----------------------------------------------
--	CTE/Subquery lub OUTER-APPLY
-----------------------------------------------
	
	--	07
	--	przygotować zapytanie, któe dla każdego klienta zwraca jego trzy ostatnie faktury
	--	(ostatnie, czyli z najstarszą datą [InvoiceDate])

	--	(tab:	[dbo].[Invoice],	[dbo].[Customer])

		/*
						[dbo].[Invoice]		AS iv
			INNER JOIN	[dbo].[Customer]	AS cu ON iv.CustomerId = cu.CustomerId
		*/

-----------------------------------------------
--	View
-----------------------------------------------	

	--	08	
	--	utworzyć widok, który zwraca wszystkie piosenki ([dbo].[Track])
	--	wraz z nazwą nośnika: ([dbo].[MediaType].[Name])
	--	oraz nazwą gatunku muzycznego:	([dbo].[Genre].[Name])
	--	widok ma być powiązany z obiektami, które zostały w nim użyte: tzn, ma blokować jakiekolwiek zmiany na tabelach, z których pobiera dane

	--	(tab:	[dbo].[Track], [dbo].[MediaType], [dbo].[Genre] )

		/*
						[dbo].[Track]		AS tr
			INNER JOIN	[dbo].[MediaType]	AS mt	ON tr.MediaTypeId	
			INNER JOIN	[dbo].[Genre]		AS gn	ON tr.GenreId		
		*/

-----------------------------------------------
--	Procedura
-----------------------------------------------	

	--	09
	--	poniższy kod tworzy kopię tabeli [Invoice] w schemacie [egz], proszę wywołać i utworzyć tabelę
	
	--	utworzyć procedurę, która:
		--	przyjmuje dwa parametry, oba typu DATETIME, nazwy parametrów dowolne
			--	parametr#1: data początkowa, wartość domyślna 19000101
			--	parametr#2: data końcowa, wartość domyślna 20990101
		
		--	procedura w pierwszym kroku czyści tabelę [egz].[Invoice] (usuwa wszystkie rekordy)
		
		--	procedura w drugim kroku przeładowuje z tabeli [dbo].[Invoice] 
		--	wszystkie wiersze z datą księgowania (InvoiceDate) pomiędzy parametrem#1 oraz parametrem#2

		CREATE TABLE [egz].[Invoice]
		(
			[InvoiceId]			[int] NOT NULL,
			[CustomerId]		[int] NOT NULL,
			[InvoiceDate]		[datetime] NOT NULL,
			[BillingAddress]	[nvarchar](70) NULL,
			[BillingCity]		[nvarchar](40) NULL,
			[BillingState]		[nvarchar](40) NULL,
			[BillingCountry]	[nvarchar](40) NULL,
			[BillingPostalCode] [nvarchar](10) NULL,
			[Total]				[numeric](10, 2) NOT NULL,
		)
		GO

-----------------------------------------------
--	XML
-----------------------------------------------	
	
	--	10
	--	Do poniższego zapytania SELECT dopisać klauzulę FOR XML tak,
	--	aby zwracała wynik jak w zakomentowanym tekście
	--------------------------------------------------------------

		SELECT 
			e.EmployeeId
		,	e.LastName
		,	e.FirstName
		,	e.Title
		FROM [dbo].[Employee] AS e

	/*
		<Employees>
		  <row EmployeeId="1" LastName="Adams" FirstName="Andrew" Title="General Manager" />
		  <row EmployeeId="2" LastName="Edwards" FirstName="Nancy" Title="Sales Manager" />
		  <row EmployeeId="3" LastName="Peacock" FirstName="Jane" Title="Sales Support Agent" />
		  <row EmployeeId="4" LastName="Park" FirstName="Margaret" Title="Sales Support Agent" />
		  <row EmployeeId="5" LastName="Johnson" FirstName="Steve" Title="Sales Support Agent" />
		  <row EmployeeId="6" LastName="Mitchell" FirstName="Michael" Title="IT Manager" />
		  <row EmployeeId="7" LastName="King" FirstName="Robert" Title="IT Staff" />
		  <row EmployeeId="8" LastName="Callahan" FirstName="Laura" Title="IT Staff" />
		</Employees>
	*/