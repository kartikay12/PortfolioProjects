Select *
From portfolio.dbo.Nashville


-- Standardize Date Format


Select SaleDate ,CONVERT(Date,SaleDate) 
From portfolio.dbo.Nashville


UPDATE Nashville
SET SaleDate = CONVERT(Date,SaleDate) ;

ALTER TABLE Nashville
ADD SaleDateConverted DATE;

UPDATE Nashville
SET SaleDateConverted = CONVERT(Date,SaleDate)



-- Populate Property Address data

Select *
From Portfolio.dbo.Nashville
--Where PropertyAddress is null
order by ParcelID


SELECT a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress,ISNULL(a.PropertyAddress,b.PropertyAddress) as updated
FROM portfolio.dbo.Nashville as a
join portfolio.dbo.Nashville as b
on a.ParcelID = b.ParcelID
AND a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is not null

UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress) 
FROM portfolio.dbo.Nashville as a
join portfolio.dbo.Nashville as b
on a.ParcelID = b.ParcelID
AND a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null


-- Breaking out Address into Individual Columns (Address, City, State)

SELECT PropertyAddress
FROM portfolio.dbo.Nashville 
ORDER BY ParcelID


SELECT 
SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress) -1) as address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) as Address2

FROM portfolio.dbo.Nashville 


ALTER TABLE Nashville
ADD PropertySplitAddress NVARCHAR(255);

UPDATE Nashville
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )


ALTER TABLE Nashville
Add PropertySplitCity Nvarchar(255);

UPDATE Nashville
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))





 

 SELECT 
 PARSENAME(REPLACE(OwnerAddress,',' , '.' ),3) AS Adress_1,
 PARSENAME(REPLACE(OwnerAddress,',' , '.' ),2)AS Adress_2,
 PARSENAME(REPLACE(OwnerAddress,',' , '.' ),1)AS Adress_3
 FROM Nashville
 

 ALTER TABLE Nashville
Add OwnerSplitAddress Nvarchar(255);

Update Nashville
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)


ALTER TABLE Nashville
Add OwnerSplitCity Nvarchar(255);

Update Nashville
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)



ALTER TABLE Nashville
Add OwnerSplitState Nvarchar(255);

Update Nashville
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1);





-- Change Y and N to Yes and No in "Sold as Vacant" field

SELECT Distinct(SoldAsVacant),COUNT(SoldAsVacant)
FROM Nashville
GROUP BY SoldAsVacant
Order By 2



Select SoldAsVacant,
CASE when SoldAsVacant ='Y' then 'Yes'
		WHEN SoldAsVacant = 'N' then 'No'
		ELSE SoldAsVacant 
		END
FROM Nashville

UPDATE Nashville
SET SoldAsVacant =
CASE when SoldAsVacant ='Y' then 'Yes'
		WHEN SoldAsVacant = 'N' then 'No'
		ELSE SoldAsVacant 
		END
FROM Nashville


-- Remove Duplicates


WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From Portfolio.dbo.Nashville
--order by ParcelID
)
SELECT *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress



Select *
From Portfolio.dbo.Nashville


-- Delete Unused Columns


Select *
From Portfolio.dbo.Nashville


ALTER TABLE Portfolio.dbo.Nashville
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate







