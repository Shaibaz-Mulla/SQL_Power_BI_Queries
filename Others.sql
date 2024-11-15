CREATE OR ALTER VIEW OTHERS
AS

SELECT 

	EdgeQuery.ItemID AS 'ItemID',
	--EdgeQuery.Category AS 'Category',
	EdgeQuery.Media AS 'Media',
	EdgeQuery.Barcode AS 'Barcode',
	EdgeQuery.Document_# AS 'Document_#',

	EdgeQuery.Document_Date AS 'Document_Date',
	
	EdgeQuery.Document_Amount AS 'Document_Amount',
	EdgeQuery.Currency AS 'Currency',
	
	EdgeQuery.OU_Name AS 'OU_Name',
	EdgeQuery.Supplier_Name AS 'Supplier_Name',
	EdgeQuery.Current_Location AS 'Current_Location',

	EdgeQuery.FT_Creation_Date AS 'FT_Creation_Date',
	SUBSTRING(DATENAME(Month,EdgeQuery.FT_Creation_Date),1,3) AS 'FT_Creation_Month',
	YEAR(EdgeQuery.FT_Creation_Date) AS 'FT_Creation_Year',
	EdgeQuery.Created_By AS 'Created_By',
	
	EdgeQuery.CAT_REC_Date AS 'CAT_REC_Date',
	--EdgeQuery.PPT_REC_Date AS 'PPT_REC_Date',
	EdgeQuery.BNK_REC_Date AS 'BNK_REC_Date',
	EdgeQuery.HO_REC_Date AS 'HO_REC_Date',
	EdgeQuery.CMO_REC_Date AS 'CMO_REC_Date',
	EdgeQuery.CMO_TO_HO_REC_Date AS 'CMO_TO_HO_REC_Date',
	EdgeQuery.HO_TO_BNK_REC_Date AS 'HO_TO_BNK_REC_Date',
	EdgeQuery.FINAL_DEST_REC_Date AS 'FINAL_DEST_REC_Date',

	(CASE WHEN EdgeQuery.DIV_TAT < 0 THEN 0 ELSE EdgeQuery.DIV_TAT END) AS 'DIV_TAT',
	(CASE WHEN EdgeQuery.CAT_TAT < 0 THEN 0 ELSE EdgeQuery.CAT_TAT END) AS 'CAT_TAT',
	--(CASE WHEN EdgeQuery.PPT_TAT < 0 THEN 0 ELSE EdgeQuery.PPT_TAT END) AS 'PPT_TAT',
	(CASE WHEN EdgeQuery.BNK_TAT < 0 THEN 0 ELSE EdgeQuery.BNK_TAT END) AS 'BNK_TAT',
	(CASE WHEN EdgeQuery.HO_CMO_TAT < 0 THEN 0 ELSE EdgeQuery.HO_CMO_TAT END) AS 'HO_CMO_TAT',
	(CASE WHEN EdgeQuery.CMO_HO_TAT < 0 THEN 0 ELSE EdgeQuery.CMO_HO_TAT END) AS 'CMO_HO_TAT',
	(CASE WHEN EdgeQuery.HO_BNK_TAT < 0 THEN 0 ELSE EdgeQuery.HO_BNK_TAT END) AS 'HO_BNK_TAT',
	(CASE WHEN EdgeQuery.APSS_TAT < 0 THEN 0 ELSE EdgeQuery.APSS_TAT END) AS 'APSS_TAT',
	(CASE WHEN EdgeQuery.HO_TAT < 0 THEN 0 ELSE EdgeQuery.HO_TAT END) AS 'HO_TAT',
	(CASE WHEN EdgeQuery.APSS_HO_TAT < 0 THEN 0 ELSE EdgeQuery.APSS_HO_TAT END) AS 'APSS_HO_TAT',
	(CASE WHEN EdgeQuery.TOTAL_TAT < 0 THEN 0 ELSE EdgeQuery.TOTAL_TAT END) AS 'TOTAL_TAT'

FROM
	--Outer SELECT query, 
	--to hide some columns : ItemID, CatID 
	--format dates 
	--derive some columns from other columns present inside inner SELECT sub-query 
	--through their ALIAS : APSS_TAT = DATEDIFF(D,Document_Date,Banking) and HO_TAT = DATEDIFF(D,Banking,HO_Finance)
	(SELECT 

		OuterQuery.ItemID AS 'ItemID',
		--OuterQuery.Category AS 'Category',
		OuterQuery.Media AS 'Media',
		OuterQuery.Barcode AS 'Barcode',
		OuterQuery.Document_# AS 'Document_#',

		OuterQuery.Document_Amount AS 'Document_Amount',
		OuterQuery.Currency AS 'Currency',
		
		OuterQuery.OU_Name AS 'OU_Name',
		--OuterQuery.Supplier_Code AS 'Supplier_Code',
		OuterQuery.Supplier_Name AS 'Supplier_Name',
		OuterQuery.Current_Location AS 'Current_Location',

		--Invoice Date
        OuterQuery.Document_Date AS 'Document_Date', 
		--Creation Date
		OuterQuery.FT_Creation_Date AS 'FT_Creation_Date', 
		--Created By
		OuterQuery.Created_By AS 'Created_By',
        --CAT_REC_Date
		OuterQuery.CAT_REC_Date AS 'CAT_REC_Date',
		--PPT_REC_Date
		--CASE WHEN OuterQuery.PPT_REC_Date IS NOT NULL THEN CONCAT_WS('/',DAY(OuterQuery.PPT_REC_Date),MONTH(OuterQuery.PPT_REC_Date),YEAR(OuterQuery.PPT_REC_Date)) ELSE 'N.A.' END AS 'PPT_REC_Date',
		--BNK_REC_Date
		OuterQuery.BNK_REC_Date AS 'BNK_REC_Date',
		--HO_REC_Date
		OuterQuery.HO_REC_Date AS 'HO_REC_Date',
        --CMO_REC_Date
		OuterQuery.CMO_REC_Date AS 'CMO_REC_Date',
        --CMO_TO_HO_REC_Date
        OuterQuery.CMO_TO_HO_REC_Date AS 'CMO_TO_HO_REC_Date',
        --HO_TO_BNK_REC_Date
		OuterQuery.HO_TO_BNK_REC_Date AS 'HO_TO_BNK_REC_Date',
        --FINAL_DEST_REC_Date
        OuterQuery.FINAL_DEST_REC_Date AS 'FINAL_DEST_REC_Date',
        
		--DIV_TAT
        (CASE 
			WHEN OuterQuery.FT_Creation_Date IS NOT NULL AND OuterQuery.CAT_REC_Date IS NOT NULL 
			THEN DATEDIFF(D,OuterQuery.FT_Creation_Date,OuterQuery.CAT_REC_Date)
			ELSE 0
		END) AS 'DIV_TAT',

		--CAT_TAT
		(CASE 
			WHEN OuterQuery.CAT_REC_Date IS NOT NULL AND OuterQuery.BNK_REC_Date IS NOT NULL 
			THEN DATEDIFF(D,OuterQuery.CAT_REC_Date,OuterQuery.BNK_REC_Date)
			ELSE 0
		END) AS 'CAT_TAT',

		--PPT_TAT
		/*
		(CASE 
			WHEN OuterQuery.PPT_REC_Date IS NOT NULL AND OuterQuery.BNK_REC_Date IS NOT NULL 
			THEN DATEDIFF(D,OuterQuery.PPT_REC_Date,OuterQuery.BNK_REC_Date)
			ELSE 0
		END) AS 'PPT_TAT',
		*/

		--BNK_TAT
        (CASE 
			WHEN OuterQuery.BNK_REC_Date IS NOT NULL AND OuterQuery.HO_REC_Date IS NOT NULL 
			THEN DATEDIFF(D,OuterQuery.BNK_REC_Date,OuterQuery.HO_REC_Date)
			ELSE 0
		END) AS 'BNK_TAT',

		--HO_CMO_TAT
        (CASE 
			WHEN OuterQuery.HO_REC_Date IS NOT NULL AND OuterQuery.CMO_REC_Date IS NOT NULL 
			THEN DATEDIFF(D,OuterQuery.HO_REC_Date,OuterQuery.CMO_REC_Date)
			ELSE 0
		END) AS 'HO_CMO_TAT',

		--CMO_HO_TAT
        (CASE 
			WHEN OuterQuery.CMO_REC_Date IS NOT NULL AND OuterQuery.CMO_TO_HO_REC_Date IS NOT NULL 
			THEN DATEDIFF(D,OuterQuery.CMO_REC_Date,OuterQuery.CMO_TO_HO_REC_Date)
			ELSE 0
		END) AS 'CMO_HO_TAT',

		--HO_BNK_TAT
        (CASE 
			WHEN OuterQuery.CMO_TO_HO_REC_Date IS NOT NULL AND OuterQuery.HO_TO_BNK_REC_Date IS NOT NULL 
			THEN DATEDIFF(D,OuterQuery.CMO_TO_HO_REC_Date,OuterQuery.HO_TO_BNK_REC_Date)
			ELSE 0
		END) AS 'HO_BNK_TAT',

		--APSS_TAT
        (CASE 
			WHEN OuterQuery.CAT_REC_Date IS NOT NULL AND OuterQuery.HO_REC_Date IS NOT NULL 
			THEN DATEDIFF(D,OuterQuery.CAT_REC_Date,OuterQuery.HO_REC_Date)
			ELSE 0
		END) AS 'APSS_TAT',

		--HO_TAT
        (CASE 
			WHEN OuterQuery.HO_REC_Date IS NOT NULL AND OuterQuery.HO_TO_BNK_REC_Date IS NOT NULL 
			THEN DATEDIFF(D,OuterQuery.HO_REC_Date,OuterQuery.HO_TO_BNK_REC_Date)
			ELSE 0
		END) AS 'HO_TAT',

		--APSS+HO_TAT
        (
            (CASE 
                WHEN OuterQuery.CAT_REC_Date IS NOT NULL AND OuterQuery.HO_REC_Date IS NOT NULL 
                THEN DATEDIFF(D,OuterQuery.CAT_REC_Date,OuterQuery.HO_REC_Date)
                ELSE 0
		    END) 
            +
            (CASE 
                WHEN OuterQuery.HO_REC_Date IS NOT NULL AND OuterQuery.HO_TO_BNK_REC_Date IS NOT NULL 
                THEN DATEDIFF(D,OuterQuery.HO_REC_Date,OuterQuery.HO_TO_BNK_REC_Date)
                ELSE 0
		    END)
        ) AS 'APSS_HO_TAT',

		--TOTAL_TAT
        (CASE 
			WHEN OuterQuery.CAT_REC_Date IS NOT NULL AND OuterQuery.HO_TO_BNK_REC_Date IS NOT NULL 
			THEN DATEDIFF(D,OuterQuery.CAT_REC_Date,OuterQuery.HO_TO_BNK_REC_Date)
			ELSE 0
		END) AS 'TOTAL_TAT'

	FROM

		(SELECT 

			--This ItemID will be available to refer hereafter
			BaseQuery.ItemID AS ItemID, 

			--Finding Category
			--(SELECT lv.ValueName FROM Lookup_Value lv INNER JOIN Item i ON i.CatID = lv.ValueID
			--WHERE i.ItemID = BaseQuery.ItemID) AS 'Category',
			--Finding media
			(SELECT lv.ValueName FROM Lookup_Value lv INNER JOIN Item i ON i.MediaID = lv.ValueID
			WHERE i.ItemID = BaseQuery.ItemID) AS 'Media',

			--Finding document Barcode
			(SELECT vText FROM Item_Data WHERE FieldID = 76 AND ItemID = BaseQuery.ItemID) AS 'Barcode',
			--Finding Invoice #
			(SELECT vText FROM Item_Data WHERE FieldID = 56 AND ItemID = BaseQuery.ItemID) AS 'Document_#',
			--Finding Document Creation Date 
			(SELECT i.CreatedDate FROM Item i WHERE i.ItemID = BaseQuery.ItemID) AS 'FT_Creation_Date',
			--Finding document created by
			(SELECT u.UserName FROM Users u WHERE u.UserID = (SELECT i.CreatedBy FROM Item i WHERE i.ItemID = BaseQuery.ItemID)) AS 'Created_By',

			--Finding Document Invoice Date 
            (SELECT vDate FROM Item_Data WHERE FieldID = 57 AND ItemID = BaseQuery.ItemID) AS 'Document_Date',
			--Finding invoice amount
			(SELECT vNumber FROM Item_Data WHERE FieldID = 58 AND ItemID = BaseQuery.ItemID) AS 'Document_Amount',
			--CURRENCY
			(SELECT li.Name FROM List_Value li 
			 WHERE li.ID = (SELECT vNumber FROM Item_Data WHERE FieldID = 59 AND ItemID = BaseQuery.ItemID)) AS 'Currency',

			--OU Name : 
			--FieldID = 54,vNumber (JOIN) (ItemData)
			--Level1ID (JOIN),Level1Name (MasterList)
			(SELECT DISTINCT ml.Level1Name 
			FROM MasterList ml INNER JOIN Item_Data id ON ml.Level1ID = id.vNumber 
			WHERE id.FieldID = 54 AND id.ItemID = BaseQuery.itemID) AS 'OU_Name',

			--Supplier Name : 
			(SELECT DISTINCT id.vText 
			 FROM Item_Data id 
			 WHERE id.FieldID = 77 AND id.ItemID = BaseQuery.itemID) AS 'Supplier_Name',
			
			--Finding Status of the doc - current location
			(CASE 
				--Current Location : Place
				WHEN (SELECT i.Current_Type FROM Item i WHERE i.ItemID = BaseQuery.itemID) = 6 
				THEN (SELECT pl.PlaceName 
					FROM Place pl INNER JOIN Item i ON i.Current_Loc = pl.PlaceId 
					WHERE i.ItemID = BaseQuery.ItemID)

				--Current Location : Container
				WHEN (SELECT i.Current_Type FROM Item i WHERE i.ItemID = BaseQuery.itemID) = 1
				THEN (CASE 
					WHEN (SELECT i.Current_Type FROM Item i WHERE i.ItemID = i.Current_Loc) = 6  
					THEN (SELECT pl.PlaceName 
							FROM Place pl INNER JOIN Item i ON i.Current_Loc = pl.PlaceId 
							WHERE i.ItemID = i.Current_Loc)
							
					WHEN (SELECT i.Current_Type FROM Item i WHERE i.ItemID = i.Current_Loc) = 1
					THEN (SELECT pl.PlaceName 
							FROM Place pl INNER JOIN Item i ON i.Current_Loc = pl.PlaceId 
							WHERE i.ItemID = (SELECT i.Current_Loc FROM Item i WHERE i.ItemID = i.Current_Loc))
						
					WHEN (SELECT i.Current_Type FROM Item i WHERE i.ItemID = i.Current_Loc) = 2
					THEN (SELECT u.FirstName 
							FROM Users u INNER JOIN Item i ON i.Current_Loc = u.UserID 
							WHERE i.ItemID = i.Current_Loc)
						
					WHEN (SELECT i.Current_Type FROM Item i WHERE i.ItemID = i.Current_Loc) = 4
					THEN (SELECT lv.ValueName 
							FROM Lookup_Value lv INNER JOIN Item i ON i.Current_Loc = lv.ValueID
							WHERE i.ItemID = i.Current_Loc)

					WHEN (SELECT i.Current_Type FROM Item i WHERE i.ItemID = i.Current_Loc) = 120
					THEN 'Permanently Removed'

					ELSE 'N.A.'
					END)
					
					--Current Location : User
					WHEN (SELECT i.Current_Type FROM Item i WHERE i.ItemID = BaseQuery.itemID) = 2
					THEN (SELECT u.FirstName 
						FROM Users u INNER JOIN Item i ON i.Current_Loc = u.UserID 
						WHERE i.ItemID = BaseQuery.ItemID)

					--Current Location : Physical Office
					WHEN (SELECT i.Current_Type FROM Item i WHERE i.ItemID = BaseQuery.itemID) = 4
					THEN (SELECT lv.ValueName 
						FROM Lookup_Value lv INNER JOIN Item i ON i.Current_Loc = lv.ValueID
						WHERE i.ItemID = BaseQuery.ItemID)

					--Current Location : Permanently Removed
					WHEN (SELECT i.Current_Type FROM Item i WHERE i.ItemID = BaseQuery.itemID) = 120
					THEN 'Permanently Removed'

				ELSE 'N.A.'
        	END) AS 'Current_Location',

            --Place.PlaceId
            --Accounting (CAT) : 2
            --Payment (PPT) : 3
            --Banking (BNK) : 4
            --HO : 7
            --CMO : 8
            --Final Dest (Payment Done) : 24

			--Finding check-out date at Accounting Team
			--In some cases a location has more than 1 check-out date, then it is taking only the recent one
			--Also, some items are part of container where ItemID gets changed after that item is moved into container
			--This new ItemID of container will give next check-out transaction details
			ISNULL(
				(SELECT Current_Date_FT 
					FROM Hist_Item 
					WHERE ItemID = BaseQuery.ItemID 
					AND TransactionType = 1 
					AND Current_Loc = 2
					ORDER BY Current_Date_FT DESC
					OFFSET 0 ROW
					FETCH NEXT 1 ROW ONLY),
				ISNULL(
					(SELECT Current_Date_FT 
						FROM Hist_Item 
						WHERE ItemID = (SELECT Current_Loc 
										FROM Hist_Item 
										WHERE ItemID = BaseQuery.ItemID AND TransactionType = 33 
										ORDER BY Current_Loc
										OFFSET 0 ROW
										FETCH NEXT 1 ROW ONLY)
						AND TransactionType = 1 
						AND Current_Loc = 2
						ORDER BY Current_Date_FT DESC
						OFFSET 0 ROW
						FETCH NEXT 1 ROW ONLY), NULL
				)
			) AS 'CAT_REC_Date',

			--Finding check-out date at Payment Team
			/*
			ISNULL(
				(SELECT Current_Date_FT 
					FROM Hist_Item 
					WHERE ItemID = BaseQuery.ItemID 
					AND TransactionType = 1 
					AND Current_Loc = 3
					ORDER BY Current_Date_FT DESC
					OFFSET 0 ROW
					FETCH NEXT 1 ROW ONLY),
					ISNULL(
						(SELECT Current_Date_FT 
							FROM Hist_Item 
							WHERE ItemID = (SELECT Current_Loc 
											FROM Hist_Item 
											WHERE ItemID = BaseQuery.ItemID AND TransactionType = 33
											ORDER BY Current_Loc
											OFFSET 0 ROW
											FETCH NEXT 1 ROW ONLY)
							AND TransactionType = 1 
							AND Current_Loc = 3
							ORDER BY Current_Date_FT DESC
							OFFSET 0 ROW
							FETCH NEXT 1 ROW ONLY), NULL
					)
			) AS 'PPT_REC_Date',
			*/

			--Finding check-out date at Banking Team
			ISNULL(
				(SELECT Current_Date_FT 
					FROM Hist_Item 
					WHERE ItemID = BaseQuery.ItemID 
					AND TransactionType = 1 
					AND Current_Loc = 4
					ORDER BY Current_Date_FT ASC --Taking only first checkout date
					OFFSET 0 ROW
					FETCH NEXT 1 ROW ONLY),
					ISNULL(
						(SELECT Current_Date_FT 
							FROM Hist_Item 
							WHERE ItemID = (SELECT Current_Loc 
											FROM Hist_Item 
											WHERE ItemID = BaseQuery.ItemID AND TransactionType = 33
											ORDER BY Current_Loc
											OFFSET 0 ROW
											FETCH NEXT 1 ROW ONLY)
							AND TransactionType = 1 
							AND Current_Loc = 4
							ORDER BY Current_Date_FT DESC
							OFFSET 0 ROW
							FETCH NEXT 1 ROW ONLY), NULL
					)
			) AS 'BNK_REC_Date',

			--Finding check-out date at HO Finance
			ISNULL(
				(SELECT Current_Date_FT 
					FROM Hist_Item 
					WHERE ItemID = BaseQuery.ItemID 
					AND TransactionType = 1 
					AND Current_Loc = 7
					ORDER BY Current_Date_FT ASC --Taking only first checkout date
					OFFSET 0 ROW
					FETCH NEXT 1 ROW ONLY),
					ISNULL(
						(SELECT Current_Date_FT 
						FROM Hist_Item 
						WHERE ItemID = (SELECT Current_Loc 
										FROM Hist_Item 
										WHERE ItemID = BaseQuery.ItemID AND TransactionType = 33
										ORDER BY Current_Loc
										OFFSET 0 ROW
										FETCH NEXT 1 ROW ONLY)
						AND TransactionType = 1 
						AND Current_Loc = 7
						ORDER BY Current_Date_FT DESC
						OFFSET 0 ROW
						FETCH NEXT 1 ROW ONLY), NULL
					)
			) AS 'HO_REC_Date',

            --Finding check-out date at CMO
			ISNULL(
				(SELECT Current_Date_FT 
					FROM Hist_Item 
					WHERE ItemID = BaseQuery.ItemID 
					AND TransactionType = 1 
					AND Current_Loc = 8
					ORDER BY Current_Date_FT DESC
					OFFSET 0 ROW
					FETCH NEXT 1 ROW ONLY),
					ISNULL(
						(SELECT Current_Date_FT 
						FROM Hist_Item 
						WHERE ItemID = (SELECT Current_Loc 
										FROM Hist_Item 
										WHERE ItemID = BaseQuery.ItemID AND TransactionType = 33
										ORDER BY Current_Loc
										OFFSET 0 ROW
										FETCH NEXT 1 ROW ONLY)
						AND TransactionType = 1 
						AND Current_Loc = 8
						ORDER BY Current_Date_FT DESC
						OFFSET 0 ROW
						FETCH NEXT 1 ROW ONLY), NULL
					)
			) AS 'CMO_REC_Date',

            --Finding check-out date at CMO-HO Finance
			ISNULL(
				(SELECT Current_Date_FT 
					FROM Hist_Item 
					WHERE ItemID = BaseQuery.ItemID 
					AND TransactionType = 1 
					AND Current_Loc = 7
					ORDER BY Current_Date_FT DESC --Taking checkout date CMO-HO (if any)
					OFFSET 0 ROW
					FETCH NEXT 1 ROW ONLY),
					ISNULL(
						(SELECT Current_Date_FT 
						FROM Hist_Item 
						WHERE ItemID = (SELECT Current_Loc 
										FROM Hist_Item 
										WHERE ItemID = BaseQuery.ItemID AND TransactionType = 33
										ORDER BY Current_Loc
										OFFSET 0 ROW
										FETCH NEXT 1 ROW ONLY)
						AND TransactionType = 1 
						AND Current_Loc = 7
						ORDER BY Current_Date_FT DESC
						OFFSET 0 ROW
						FETCH NEXT 1 ROW ONLY), NULL
					)
			) AS 'CMO_TO_HO_REC_Date',

            --Finding check-out HO_TO_BNK_REC_Date 
			ISNULL(
				(SELECT Current_Date_FT 
					FROM Hist_Item 
					WHERE ItemID = BaseQuery.ItemID 
					AND TransactionType = 1 
					AND Current_Loc = 4
					ORDER BY Current_Date_FT DESC --Taking HO-BNK checkout date (if any)
					OFFSET 0 ROW
					FETCH NEXT 1 ROW ONLY),
					ISNULL(
						(SELECT Current_Date_FT 
							FROM Hist_Item 
							WHERE ItemID = (SELECT Current_Loc 
											FROM Hist_Item 
											WHERE ItemID = BaseQuery.ItemID AND TransactionType = 33
											ORDER BY Current_Loc
											OFFSET 0 ROW
											FETCH NEXT 1 ROW ONLY)
							AND TransactionType = 1 
							AND Current_Loc = 4
							ORDER BY Current_Date_FT DESC
							OFFSET 0 ROW
							FETCH NEXT 1 ROW ONLY), NULL
					)
			) AS 'HO_TO_BNK_REC_Date',

            --Finding check-out date at Final Destination
			ISNULL(
				(SELECT Current_Date_FT 
					FROM Hist_Item 
					WHERE ItemID = BaseQuery.ItemID 
					AND TransactionType = 1 
					AND Current_Loc = 24
					ORDER BY Current_Date_FT DESC
					OFFSET 0 ROW
					FETCH NEXT 1 ROW ONLY),
					ISNULL(
						(SELECT Current_Date_FT 
						FROM Hist_Item 
						WHERE ItemID = (SELECT Current_Loc 
										FROM Hist_Item 
										WHERE ItemID = BaseQuery.ItemID AND TransactionType = 33
										ORDER BY Current_Loc
										OFFSET 0 ROW
										FETCH NEXT 1 ROW ONLY)
						AND TransactionType = 1 
						AND Current_Loc = 24
						ORDER BY Current_Date_FT DESC
						OFFSET 0 ROW
						FETCH NEXT 1 ROW ONLY), NULL
					)
			) AS 'FINAL_DEST_REC_Date'

		FROM (SELECT DISTINCT i.ItemID FROM Item i WHERE i.CatID = 21) AS BaseQuery) AS OuterQuery) AS EdgeQuery;

/*

SELECT * FROM OTHERS
ORDER BY ItemID DESC OFFSET 0 ROW FETCH NEXT 100 ROW ONLY;
WHERE CAT_REC_Date <> 'N.A.'
AND BNK_REC_Date <> 'N.A.'
AND HO_REC_Date <> 'N.A.'
AND CMO_REC_Date <> 'N.A.'
AND CMO_TO_HO_REC_Date <> 'N.A.'
AND HO_TO_BNK_REC_Date <> 'N.A.'
AND FINAL_DEST_REC_Date <> 'N.A.'
ORDER BY ItemID DESC OFFSET 5000 ROW FETCH NEXT 1000 ROW ONLY;
					
*/

--select * from List --6 currency
--select * from List_Value where ListID = 6 --214 QAR
--select * from Item_Data where ItemID = 3287 FID 59