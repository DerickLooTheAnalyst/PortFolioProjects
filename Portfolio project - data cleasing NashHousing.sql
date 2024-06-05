
-- Populate property address data
Select a.[UniqueID ], a.ParcelID, a.PropertyAddress, b.[UniqueID ], b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
from NashHousing a
join
NashHousing b
on
a.ParcelID = b.ParcelID
and
a.[UniqueID ] <> b.[UniqueID ]
where
a.PropertyAddress is null



--update property address
update a
Set propertyaddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
from NashHousing a
join
NashHousing b
on
a.ParcelID = b.ParcelID
and
a.[UniqueID ] <> b.[UniqueID ]
where
a.PropertyAddress is null



select PropertyAddress, propertysplitaddress, propertysplitcity,
SUBSTRING(propertyaddress, 1, charindex(',', propertyaddress, 1) - 1)[Address],
SUBSTRING(propertyaddress, charindex(',', propertyaddress, 1) + 1, Len(propertyaddress))
from NashHousing

--Data Defination
alter table NashHousing
add propertysplitaddress nvarchar(255)

alter table NashHousing
add propertysplitcity nvarchar(255)


--Data Manipulation
update NashHousing set propertysplitaddress = SUBSTRING(propertyaddress, 1, charindex(',', propertyaddress, 1) - 1)

update NashHousing set propertysplitcity = SUBSTRING(propertyaddress, charindex(',', propertyaddress, 1) + 1, Len(propertyaddress))


Select OwnerAddress, 
ParseName(Replace(OwnerAddress, ',', '.'), 3), 
ParseName(Replace(OwnerAddress, ',', '.'), 2),
ParseName(Replace(OwnerAddress, ',', '.'), 1) 
from NashHousing where owneraddress is not null

alter table NashHousing
add ownersplitaddress nvarchar(255)

alter table NashHousing
add ownersplitcity nvarchar(255)

alter table NashHousing
add ownersplitstate nvarchar(255)

update NashHousing set ownersplitaddress = ParseName(Replace(OwnerAddress, ',', '.'), 3)

update NashHousing set ownersplitcity = ParseName(Replace(OwnerAddress, ',', '.'), 2)

update NashHousing set ownersplitstate = ParseName(Replace(OwnerAddress, ',', '.'), 1)


select * from NashHousing where owneraddress is not null


-- Change Y and N to Yes or No

Select Distinct(SoldAsVacant) from NashHousing


Update NashHousing Set SoldASVacant = Case When SoldAsVacant = 'Y' Then 'Yes'
                        When SoldAsVacant = 'N' Then 'No'
						else SoldAsVacant End 


Select * from NashHousing

With RowNumCTE as(
select 
	 ROW_NUMBER() Over(Partition by ParcelId, PropertyAddress, SalePrice, SaleDate, LegalReference Order By UniqueId) row_num
	 ,* 
from NashHousing
--order by ParcelID
)
Select * from RowNumCTE where row_num > 1 order by PropertyAddress

Delete from RowNumCTE where row_num > 1




--delete un-used column

alter table NashHousing
Drop Column PropertyAddress, OwnerAddress, TaxDistrict, SaleDate