--Cleaniing Data in SQL Queries

Select *
From PorfolioProject.dbo.NashvilleHousing

--Standardize Date Format

select SaleDate
From PorfolioProject.dbo.NashvilleHousing

ALTER TABLE NashvilleHousing
ALTER COLUMN SaleDate DATE

--Populate Property Address data
--29 Rows in PropertyAddress with NULL Values
-- 0 Rows in ParcelID with NULL Values

select *
From PorfolioProject.dbo.NashvilleHousing
--Where PropertyAddress is NULL
order by ParcelID

select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From PorfolioProject.dbo.NashvilleHousing a
Join PorfolioProject.dbo.NashvilleHousing b 
 on a.ParcelID = b.ParcelID
 AND a.[UniqueID] <> b.[UniqueID]
 Where a.PropertyAddress is null

 

 UPDATE a
SET a.PropertyAddress = COALESCE(a.PropertyAddress, b.PropertyAddress)
FROM PorfolioProject.dbo.NashvilleHousing a
JOIN PorfolioProject.dbo.NashvilleHousing b 
    ON a.ParcelID = b.ParcelID
    AND a.[UniqueID] <> b.[UniqueID]
WHERE a.PropertyAddress IS NULL;

--Dividing out Address into Individual Columns (Address,City, State)

select PropertyAddress
From PorfolioProject.dbo.NashvilleHousing
--Where PropertyAddress is NULL
--order by ParcelID

select 
SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) as Address
,SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress)) as Address
From PorfolioProject.dbo.NashvilleHousing



--
ALTER TABLE PorfolioProject.dbo.NashvilleHousing
Add PropertySplitAddress Nvarchar(255);

Update PorfolioProject.dbo.NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress) -1)

--
ALTER TABLE PorfolioProject.dbo.NashvilleHousing
Add PropertySplitCity Nvarchar(255);

Update PorfolioProject.dbo.NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress))

select *
From PorfolioProject.dbo.NashvilleHousing

----Another way to split address
select *
From PorfolioProject.dbo.NashvilleHousing

select
PARSENAME(REPLACE(OwnerAddress,',', '.'),3)
,PARSENAME(REPLACE(OwnerAddress,',', '.'),2)
,PARSENAME(REPLACE(OwnerAddress,',', '.'),1)
From PorfolioProject.dbo.NashvilleHousing

--

ALTER TABLE PorfolioProject.dbo.NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);

Update PorfolioProject.dbo.NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',', '.'),3)

--
ALTER TABLE PorfolioProject.dbo.NashvilleHousing
Add OwnerSplitCity Nvarchar(255);

Update PorfolioProject.dbo.NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',', '.'),2)

--
ALTER TABLE PorfolioProject.dbo.NashvilleHousing
Add OwnerSplitState Nvarchar(255);

Update PorfolioProject.dbo.NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress,',', '.'),1)

--Change Y and N to Yes and No in "Sold As Vacant" field

Select Distinct(SoldAsVacant),Count(SoldAsVacant)
From PorfolioProject.dbo.NashvilleHousing
Group by SoldAsVacant
Order by 2

Select SoldAsVacant
,CASE when SoldAsVacant = 'Y' THEN 'Yes'
When SoldAsVacant = 'N' THEN 'No'
ELSE SoldAsVacant
END
From PorfolioProject.dbo.NashvilleHousing

Update PorfolioProject.dbo.NashvilleHousing
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes' 
When SoldAsVacant = 'N' THEN 'No'
ELSE SoldAsVacant
END

--Remove Duplicates
WITH rowNumCTE AS(
select*,
ROW_NUMBER() OVER (
PARTITION BY ParcelID,
PropertyAddress,
SaleDate,
LegalReference
ORDER BY 
UniqueID
) row_number
From PorfolioProject.dbo.NashvilleHousing
--Order by ParcelID
)
Select *
From rowNumCTE
Where row_number > 1
--Order by PropertyAddress

--Delete Unused Columns

select *
From PorfolioProject.dbo.NashvilleHousing

ALTER TABLE PorfolioProject.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

ALTER TABLE PorfolioProject.dbo.NashvilleHousing
DROP COLUMN SaleDate
