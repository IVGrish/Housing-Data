/*
Clearing Data in SQL Queries
*/

SELECT *
FROM NashvilleHousing

-- Standardize Date Format

SELECT SaleDateConverted, CONVERT(date, SaleDate)
FROM NashvilleHousing

UPDATE NashvilleHousing
SET SaleDate = CONVERT(date, SaleDate)

ALTER TABLE NashvilleHousing
ADD SaleDateConverted date

UPDATE NashvilleHousing
SET SaleDateConverted = CONVERT(date, SaleDate)

-- Populate Property Address data

SELECT PropertyAddress
FROM NashvilleHousing
--WHERE PropertyAddress IS NULL
ORDER BY ParcelID

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress,
	ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM NashvilleHousing a
JOIN NashvilleHousing b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress IS NULL

UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM NashvilleHousing a
JOIN NashvilleHousing b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress IS NULL

-- Breaking out Address into Individual Columns (Address, City, State)

SELECT PropertyAddress
FROM NashvilleHousing
--WHERE PropertyAddress IS NULL
--ORDER BY ParcelID

SELECT 
	SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) - 1) AS Address,
	SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 2, LEN(PropertyAddress)) AS City
FROM NashvilleHousing

ALTER TABLE NashvilleHousing
ADD PropertySplitAddress nvarchar(255)

UPDATE NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) - 1)

ALTER TABLE NashvilleHousing
ADD PropertySplitCity nvarchar(255)

UPDATE NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 2, LEN(PropertyAddress))

SELECT 
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3),
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2),
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)
FROM NashvilleHousing

ALTER TABLE NashvilleHousing
ADD OwnerSplitAddress nvarchar(255)

UPDATE NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)

ALTER TABLE NashvilleHousing
ADD OwnerSplitCity nvarchar(255)

UPDATE NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)

ALTER TABLE NashvilleHousing
ADD OwnerSplitState nvarchar(255)

UPDATE NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)

SELECT * 
FROM NashvilleHousing

-- Change Y and N to Yes and No in "Sold and vacant" field

SELECT SoldAsVacant, COUNT(SoldAsVacant)
FROM NashvilleHousing
GROUP BY SoldAsVacant
ORDER BY 2

SELECT SoldAsVacant,
	CASE 
		WHEN SoldAsVacant = 'Y' THEN 'Yes'
		WHEN SoldAsVacant = 'N' THEN 'No'
		ELSE SoldAsVacant
	END
FROM NashvilleHousing

UPDATE NashvilleHousing
SET SoldAsVacant = 
	CASE 
		WHEN SoldAsVacant = 'Y' THEN 'Yes'
		WHEN SoldAsVacant = 'N' THEN 'No'
		ELSE SoldAsVacant
	END

-- Remove Dublicates

WITH RowNumCTE AS (
SELECT *,
	ROW_NUMBER() 
		OVER(
			PARTITION BY ParcelID, 
						 PropertyAddress,
						 SalePrice,
						 SaleDate,
						 LegalReference
			ORDER BY UniqueID) 
	AS row_num
FROM NashvilleHousing
--ORDER BY ParcelID
)
SELECT *
FROM RowNumCTE
WHERE row_num > 1
ORDER BY PropertyAddress

-- Delete Unused Columns

SELECT * 
FROM NashvilleHousing

ALTER TABLE NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

ALTER TABLE NashvilleHousing
DROP COLUMN SaleDate