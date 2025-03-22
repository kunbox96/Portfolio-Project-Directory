import pandas as pd
import plotly.express as px
import janitor
from datetime import datetime


def clean_data(path: str ,series_code: str, country_code=['VNM', 'USA', 'CHN'], start_year=1990, end_year=2024):
    
    #Read dataframe
    df = pd.read_csv(path)
    
    # Lam sach columns title
    df.columns = [col[0:4] if '[' in col else col for col in df.columns]
    df = df.clean_names()
    
    #Chon nhung cot muon su dung
    selected_years = [str(year) for year in range(start_year, end_year)]

    selected_columns = ['country_name', 'country_code',	'series_name', 'series_code']

    df = df[selected_columns + selected_years]
    
    #Chon nhung quoc gia muon phan tich
    selected_countries = country_code

    #Chon metrics / series_code muon phan tich
    df = df[df['country_code'].isin(selected_countries)]
    
    final_df = df[df['series_code'] == series_code]

    final_df = final_df.drop(['country_code', 'series_name', 'series_code'], axis=1)
    
    final_df = final_df.melt(id_vars=['country_name'], value_name='pct_internet_users', var_name='years')
    
    final_df = final_df.replace('..', pd.NA)
    
    #Fill null value and correct data type
    final_df['years'] = pd.to_numeric(final_df['years'], errors='coerce')

    final_df['pct_internet_users'] = pd.to_numeric(final_df['pct_internet_users'], errors='coerce')
    
    final_df = final_df.sort_values(by=['country_name', 'years'])

    final_df['pct_internet_users'] = final_df['pct_internet_users'].interpolate()
    
    return final_df

if __name__ == "__main__":
    path = r'C:\Users\Alvin Nguyen\OneDrive\1. Project\Practice\Internet\data\worldbank-country-internet-data.csv'
    series_code = 'IT.NET.USER.ZS'
    internet_usage = clean_data(path=path, series_code=series_code, start_year=2023, country_code=['VNM', 'IND', 'IDN', 'MYS', 'MMR'])
    print(internet_usage)
    