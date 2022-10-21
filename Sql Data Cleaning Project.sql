--Cleaning Data using SQL queries

Select *
From PortafolioProject.dbo.NashvilleHousing_datacleaningproject

-- Change SaleDate

Select SaleDateTransformed, Convert(Date,SaleDate)
From PortafolioProject.dbo.NashvilleHousing_datacleaningproject

Update NashvilleHousing_datacleaningproject
Set SaleDate = Convert(Date,SaleDate)

Alter Table NashvilleHousing_datacleaningproject
add SaleDateTransformed Date;

Update NashvilleHousing_datacleaningproject
Set SaleDateTransformed = Convert(Date,SaleDate)

-- Populate Property Address data

Select *
From PortafolioProject.dbo.NashvilleHousing_datacleaningproject
Where PropertyAddress is null

Select *
From PortafolioProject.dbo.NashvilleHousing_datacleaningproject
order by ParcelID

Select E.ParcelID, E.PropertyAddress, F.ParcelID, F.PropertyAddress, ISNULL(E.PropertyAddress, F.PropertyAddress) 
From PortafolioProject.dbo.NashvilleHousing_datacleaningproject E
Join PortafolioProject.dbo.NashvilleHousing_datacleaningproject F
    on  E.ParcelID = F.ParcelID
	And E.[UniqueID ] <> F.[UniqueID ]
Where E.PropertyAddress is  null

Update E
Set PropertyAddress =  ISNULL(E.PropertyAddress, F.PropertyAddress) 
From PortafolioProject.dbo.NashvilleHousing_datacleaningproject E
Join PortafolioProject.dbo.NashvilleHousing_datacleaningproject F
    on  E.ParcelID = F.ParcelID
	And E.[UniqueID ] <> F.[UniqueID ]

-- Breaking out Address into individual columns (Address, City, State)


Select PropertyAddress
From PortafolioProject.dbo.NashvilleHousing_datacleaningproject

Select 
Substring(PropertyAddress, 1,Charindex(',',PropertyAddress)-1) as Address,
Substring(PropertyAddress, Charindex(',',PropertyAddress)+1, LEN(PropertyAddress)) as Address
From PortafolioProject.dbo.NashvilleHousing_datacleaningproject

Alter Table NashvilleHousing_datacleaningproject
add PropertyDivision Nvarchar(255);


Update NashvilleHousing_datacleaningproject
set PropertyDivision = Substring(PropertyAddress, 1,Charindex(',',PropertyAddress)-1)

Alter Table NashvilleHousing_datacleaningproject
add PropertyDivisionity Nvarchar(255);

Update NashvilleHousing_datacleaningproject
set PropertyDivisionity = Substring(PropertyAddress, Charindex(',',PropertyAddress)+1, LEN(PropertyAddress))


Select *
From PortafolioProject.dbo.NashvilleHousing_datacleaningproject



Select OwnerAddress
From PortafolioProject.dbo.NashvilleHousing_datacleaningproject


Select 
Parsename(Replace(OwnerAddress,',','.'),3),
Parsename(Replace(OwnerAddress,',','.'),2),
Parsename(Replace(OwnerAddress,',','.'),1)
From PortafolioProject.dbo.NashvilleHousing_datacleaningproject


Alter Table NashvilleHousing_datacleaningproject
add OwnerSplitAddress Nvarchar(255);


Update NashvilleHousing_datacleaningproject
set OwnerSplitAddress = Parsename(Replace(OwnerAddress,',','.'),3)

Alter Table NashvilleHousing_datacleaningproject
add OwnerSplitCity Nvarchar(255);

Update NashvilleHousing_datacleaningproject
set OwnerSplitCity = Parsename(Replace(OwnerAddress,',','.'),2)

Alter Table NashvilleHousing_datacleaningproject
add OwnerSplitState Nvarchar(255);

Update NashvilleHousing_datacleaningproject
set OwnerSplitState = Parsename(Replace(OwnerAddress,',','.'),1)



Select *
From PortafolioProject.dbo.NashvilleHousing_datacleaningproject


-- Change Y and N to Yes and No in "Sold as Vacant" field

Select Distinct(SoldASVacant), Count(SoldAsVacant)
From PortafolioProject.dbo.NashvilleHousing_datacleaningproject
Group By SoldAsVacant
Order By 2


Select SoldAsVacant,
CASE When SoldAsVacant = 'Y' THEN 'Yes'
     When SoldAsVacant = 'N' THEN 'No'
	 Else SoldAsVacant
	 End
From PortafolioProject.dbo.NashvilleHousing_datacleaningproject

Update NashvilleHousing_datacleaningproject
Set SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
     When SoldAsVacant = 'N' THEN 'No'
	 Else SoldAsVacant
	 End


-- Removing Duplicates 

With RowNumCTE as (
Select * ,
  ROW_NUMBER() Over (
  Partition by ParcelID,
               PropertyAddress,
			   SalePrice,
			   LegalReference
			   Order By 
			          UniqueID
					  ) row_num


From PortafolioProject.dbo.NashvilleHousing_datacleaningproject
)
Select *
From RowNumCTE
Where Row_Num > 1

-- Delete Unused Columns

Select *
From PortafolioProject.dbo.NashvilleHousing_datacleaningproject


Alter Table PortafolioProject.dbo.NashvilleHousing_datacleaningproject
Drop Column OwnerAddress, Taxdistrict, PropertyAddress


Alter Table PortafolioProject.dbo.NashvilleHousing_datacleaningproject
Drop Column SaleDate

