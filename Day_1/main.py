import pandas as pd
import csv 
from sklearn.impute import SimpleImputer


data=pd.read_csv(r"D:\Self_Learning\Data intern\day 1\marketing_campaign_cleaned.csv")

null_details=data.isnull().sum()

print(data.columns)
print(null_details)

imputer=SimpleImputer(strategy="mean")
imputer.fit(data[['Income']])
data[['Income']]=imputer.transform(data[['Income']])

print()
print("After cleaning\n",data.isnull().sum())

# duplicates
duplicate=data.duplicated()
print(data[duplicate])

# dtypes
print("data types : ",data.dtypes)

# change data_type for year
data['Year_Birth']=pd.to_datetime(data['Year_Birth'],format="%y",errors="coerce")
print("datatype of Year_Birth",data['Year_Birth'].dtype)

# change data_type for Dt_customer
data['Dt_Customer']=pd.to_datetime(data['Dt_Customer'],format="%d-%m-%y" , errors="coerce")
print("datatype of Dt_Customer",data.dtypes)

print("Finally the data types are : ",data.dtypes)

# changing all column name into lower
print("Columns name before changing:\n",data.columns)
print()
data.columns = [
    'id', 'year_birth', 'education', 'marital_status', 'income', 'kidhome', 'teenhome',
    'dt_customer', 'recency', 'mntwines', 'mntfruits', 'mntmeatproducts',
    'mntfishproducts', 'mntsweetproducts', 'mntgoldprods', 'numdealspurchases',
    'numwebpurchases', 'numcatalogpurchases', 'numstorepurchases', 'numwebvisitsmonth',
    'acceptedcmp3', 'acceptedcmp4', 'acceptedcmp5', 'acceptedcmp1', 'acceptedcmp2',
    'complain', 'z_costcontact', 'z_revenue', 'response'
]
# Print updated column names
print("Renamed columns:")
print(data.columns)

# only numeric columns
num_col=data.select_dtypes(include='number').columns
print("Numeric columns:    ",num_col)

# str or text columns
text_col=data.select_dtypes(include='object').columns
print("Text columns:       ",text_col)