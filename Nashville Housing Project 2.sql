Select *
From NashvilleHousing



Select SaleDate, CONVERT(Date, SaleDate)
From NashvilleHousing

ALTER TABLE NashvilleHousing ALTER COLUMN SaleDate DATE

Update NashvilleHousing
SET SaleDate= CONVERT(Date, SaleDate)




Select *
From NashvilleHousing
order by ParcelID



Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, 
ISNULL ( a.propertyaddress, b.PropertyAddress)
From NashvilleHousing a
JOIN NashvilleHousing b
	on a.ParcelID= b.ParcelID
	and a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is null

Update a
SET PropertyAddress= ISNULL ( a.propertyaddress, b.PropertyAddress)
From NashvilleHousing a
JOIN NashvilleHousing b
	on a.ParcelID= b.ParcelID
	and a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is null



Select PropertyAddress
From NashvilleHousing


Select
SUBSTRING (PropertyAddress, 1, CHARINDEX (',', PropertyAddress) -1) as Address,
SUBSTRING (PropertyAddress, CHARINDEX (',', PropertyAddress) +1, LEN(PropertyAddress)) as Address
From NashvilleHousing


ALTER TABLE NashvilleHousing
Add PropertySplitAddress Nvarchar(255);

Update NashvilleHousing
SET PropertySplitAddress= SUBSTRING (PropertyAddress, 1, CHARINDEX (',', PropertyAddress) -1)


ALTER TABLE NashvilleHousing
Add PropertySplitCity Nvarchar(255);

Update NashvilleHousing
SET PropertySplitCity= SUBSTRING (PropertyAddress, CHARINDEX (',', PropertyAddress) +1, LEN(PropertyAddress))


Select *
From NashvilleHousing





Select OwnerAddress
From NashvilleHousing

Select
PARSENAME (REPLACE (OwnerAddress, ',', '.'), 3),
PARSENAME (REPLACE (OwnerAddress, ',', '.'), 2),
PARSENAME (REPLACE (OwnerAddress, ',', '.'), 1)
From NashvilleHousing


ALTER TABLE NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitAddress= PARSENAME (REPLACE (OwnerAddress, ',', '.'), 3)

ALTER TABLE NashvilleHousing
Add OwnerSplitCity Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitCity= PARSENAME (REPLACE (OwnerAddress, ',', '.'), 2)

ALTER TABLE NashvilleHousing
Add OwnerSplitState Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitState= PARSENAME (REPLACE (OwnerAddress, ',', '.'), 1)

Select *
From NashvilleHousing





Select Distinct (SoldAsVacant), Count (SoldAsVacant)
From NashvilleHousing
Group by SoldAsVacant
order by 2



Select SoldAsVacant,
	Case When SoldAsVacant= 'Y' THEN 'Yes'
	When SoldAsVacant= 'N' Then 'No'
	ELSE SoldAsVacant
	END
From NashvilleHousing

Update NashvilleHousing
SET SoldAsVacant= Case When SoldAsVacant= 'Y' THEN 'Yes'
	When SoldAsVacant= 'N' Then 'No'
	ELSE SoldAsVacant
	END





WITH RowNumCTE as(
Select *,
	Row_Number() OVER (
	Partition by parcelID,
				PropertyAddress,
				SalePrice,
				SaleDate,
				LegalReference
				Order by UniqueID) row_num
From NashvilleHousing

)
DELETE
From RowNumCTE
Where row_num> 1







Select *
From NashvilleHousing

Alter Table NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress