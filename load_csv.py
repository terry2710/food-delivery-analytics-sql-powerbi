import pandas as pd
from sqlalchemy import create_engine, text

# Read CSV
file_path = r"./data/order_history_kaggle_data_cleaned_fixed.csv"
df = pd.read_csv(file_path, encoding="latin1")

# Check original shape
print("Original shape:", df.shape)

# Clean column names for MySQL compatibility
df.columns = (
    df.columns.str.strip()
    .str.replace(" ", "_", regex=False)
    .str.replace("(", "", regex=False)
    .str.replace(")", "", regex=False)
    .str.replace("/", "_", regex=False)
    .str.replace("-", "_", regex=False)
)

# Optional: normalize repeated underscores
df.columns = df.columns.str.replace("__", "_", regex=False)

print("Columns:")
print(df.columns.tolist())

# MySQL connection
engine = create_engine(
    "mysql+pymysql://root:Yahooyyh147.@localhost:3306/food_delivery"
)

# Load into MySQL
df.to_sql(
    name="food_orders",
    con=engine,
    if_exists="replace",
    index=False,
    chunksize=1000,
    method="multi"
)

print("Upload complete.")

# Quick validation
with engine.connect() as conn:
    result = conn.execute(text("SELECT COUNT(*) AS row_count FROM food_orders"))
    for row in result:
        print("Row count in MySQL:", row[0])