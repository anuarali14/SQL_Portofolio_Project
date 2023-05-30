create database Project;

-- Import Data
Select *
From project.nashville_housing_data;

-- Memuat ulang format Date
Select SaleDate
From Project.nashville_housing_data;

-- Properti
Select PropertyAddress
From project.nashville_housing_data
Where PropertyAddress is null;

Select *
From project.nashville_housing_data a
Join project.nashville_housing_data b
	on a.ParcelID = b.ParcelID
where a.PropertyAddress is null;

-- Memisahkan alamat
Select PropertyAddress
From project.nashville_housing_data
where PropertyAddress is null
order by ParcelID;

Select
substring(PropertyAddress, 1, char(',' , PropertyAddress) -1 ) as Address
From project.nashville_housing_data;

-- Merubah Y dan N menjadi kalimat utuh
Select distinct(SoldAsVacant), count(SoldAsVacant)
From project.nashville_housing_data
Group by SoldAsVacant
Order by 2;

select SoldAsVacant,
case when SoldAsVacant = 'Y' then 'Yes'
	when SoldAsVacant = 'N' then 'No'
	else SoldAsVacant
	end
from project.nashville_housing_data;

update nashville_housing_data
set SoldAsVacant = case when SoldAsVacant = 'Y' then 'Yes'
	when SoldAsVacant = 'N' then 'No'
    else SoldAsVacant
    end;

-- Menghilangkan duplikat data
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
From project.nashville_housing_data
order by ParcelID
)

Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress;

Select *
From project.nashville_housing_data;
