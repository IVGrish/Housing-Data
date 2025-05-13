# Nashville Housing Data Cleaning
This SQL script performs a comprehensive data cleaning process on the *NashvilleHousing dataset* to prepare it for analysis. The main tasks include:

+ ##### Standardizing Data 
    * Convert *SaleDate* to a standard date format and store it in a new column *SaleDateConverted*.

+ ##### Filling Missing Data
    * Populate missing *PropertyAddress* values by referencing other rows with the same *ParcelID*.

+ ##### Splitting Address Fields
    * Break down *PropertyAddress* into *PropertySplitAddress* and *PropertySplitCity*.
    * Split *OwnerAddress* into *OwnerSplitAddress*, *OwnerSplitCity* and *OwnerSplitState*.

+ ##### Normalizing Categorical Values
    * Standardize the *SoldAsVacant* field by replacing 'Y'/'N' with 'Yes'/'No'.

+ ##### Removing Duplicates
    * Identify and remove exact duplicates using a ROW_NUMBER() CTE.

+ ##### Dropping Unused Columns
    * Remove columns no longer needed after cleaning: *OwnerAddress*, *TaxDistrict*, *PropertyAddress* and *SaleDate*.<br><br>

**P.S.** This project was built with the help [Alex The Analyst](https://www.youtube.com/@AlexTheAnalyst).
