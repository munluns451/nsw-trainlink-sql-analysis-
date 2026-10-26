# ================================================
# NSW TrainLink Data Cleaning Script
# Author: Munna Naharki
# Purpose: Reshape Excel wide format to long format CSV for SQL analysis
# ================================================

import pandas as pd

# ------------------------------------------------
# STEP 1: Read raw Excel file (no auto header)
# header=None because headers span TWO rows (years + months)
# ------------------------------------------------
df_raw = pd.read_excel('nsw-trainlink-train-and-coach-patronage-jul-2021-to-aug-2026.xlsx',
                       sheet_name='Passenger Journeys',
                       header=None)

# ------------------------------------------------
# STEP 2: Extract years row and forward fill gaps
# Row 0 = financial years (e.g. 2021/22) — sparse, mostly empty
# ffill() fills empty cells with the previous value
# ------------------------------------------------
years_row = df_raw.iloc[0, 3:].copy()
years_row = years_row.ffill()

# Row 1 = month names (July, August, etc.)
months_row = df_raw.iloc[1, 3:].copy()

# ------------------------------------------------
# STEP 3: Loop through each route and build long format
# Wide format: 1 route = 1 row (72 month columns)
# Long format: 1 route = 72 rows (one per month) ← SQL needs this
# ------------------------------------------------
data_rows = df_raw.iloc[2:, :].copy()
data_rows[0] = data_rows[0].ffill()  # forward fill Train/Coach label

records = []

for _, row in data_rows.iterrows():
    transport_type = row[0]
    service_code = row[1]
    service_desc = row[2]

    # Skip empty or header-like rows
    if pd.isna(service_code) or service_code == 'Service Name':
        continue

    for i, (y, m) in enumerate(zip(years_row, months_row)):
        if pd.isna(y) or pd.isna(m) or m == 'FY Total':
            continue

        val = row[i + 3]

        # Handle privacy codes: TfNSW suppresses values 1-10 for privacy
        # We replace with midpoint value of 5 as best estimate
        if pd.isna(val):
            trips = None
        else:
            try:
                trips = int(val)
                if 1 <= trips <= 10:
                    trips = 5
            except:
                trips = None

        records.append({
            'transport_type': transport_type,
            'service_code': service_code,
            'service_description': service_desc,
            'financial_year': str(y),
            'month': str(m),
            'trips': trips
        })

# ------------------------------------------------
# STEP 4: Convert list of records to DataFrame and save
# index=False removes the auto-generated row numbers
# ------------------------------------------------
df_long = pd.DataFrame(records)
df_long.to_csv('trainlink_journeys.csv', index=False)
print(f"Saved trainlink_journeys.csv — {len(df_long)} rows")


# ================================================
# PASSENGER TYPE SHEET
# ================================================

df_pt = pd.read_excel('nsw-trainlink-train-and-coach-patronage-jul-2021-to-aug-2026.xlsx',
                      sheet_name='Passenger Type',
                      header=None)

# Row 0 = ticket type names, col 0 = FY, col 1 = month
ticket_types = df_pt.iloc[0, 2:].tolist()

data = df_pt.iloc[1:, :].copy()
data[0] = data[0].ffill()  # forward fill financial year

records_pt = []

for _, row in data.iterrows():
    fy = str(row[0])
    month = str(row[1])

    if pd.isna(row[1]) or month == 'nan':
        continue

    for i, ticket in enumerate(ticket_types):
        val = row[i + 2]

        if pd.isna(val):
            trips = None
        else:
            try:
                trips = int(val)
                if 1 <= trips <= 10:
                    trips = 5
            except:
                trips = None

        records_pt.append({
            'financial_year': fy,
            'month': month,
            'ticket_type': str(ticket),
            'trips': trips
        })

df_pt_long = pd.DataFrame(records_pt)
df_pt_long.to_csv('passenger_type.csv', index=False)
print(f"Saved passenger_type.csv — {len(df_pt_long)} rows")
