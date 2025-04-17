import sqlite3
import pandas as pd
import matplotlib.pyplot as plt
import os

# Step 1: Connect to the SQLite database
db_path = "sales_data.db"
conn = sqlite3.connect(db_path)
cursor = conn.cursor()

# Step 2: Create the sales table if it doesn't exist
cursor.execute('''
CREATE TABLE IF NOT EXISTS sales (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    product TEXT NOT NULL,
    quantity INTEGER NOT NULL,
    price REAL NOT NULL
)
''')

# Step 3: Insert updated dummy data if the table is empty
cursor.execute("SELECT COUNT(*) FROM sales")
if cursor.fetchone()[0] == 0:
    # Updated prices based on current prices in Chennai
    dummy_data = [
        ("Apple", 10, 145),
        ("Banana", 20, 60),
        ("Apple", 15, 145),
        ("Orange", 12, 70),
        ("Banana", 10, 60),
        ("Orange", 8, 70),
        ("Grapes", 18, 130),
        ("Strawberry", 8, 410),
        ("Blueberry", 15, 160),
        ("Mango", 20, 180),
        ("Mango", 10, 180),
        ("Apple", 5, 145),
        ("Strawberry", 5, 410),
        ("Grapes", 10, 130),
        ("Blueberry", 5, 160),
        ("Avocado", 14, 155),
        ("Black Grape", 8, 130),
        ("Cherry", 6, 650),
        ("Coconut", 20, 30),
        ("Custard Apple", 10, 130),
        ("Date", 5, 280),
        ("Fig", 7, 180),
        ("Gooseberry", 10, 120),
        ("Green Banana", 18, 60),
        ("Green Grape", 12, 120),
        ("Jackfruit", 5, 70),
        ("Lemon", 30, 90),
        ("Mosambi", 10, 60),
        ("Papaya", 25, 50),
        ("Peach", 10, 230),
        ("Pear", 8, 220),
        ("Pineapple", 14, 70),
        ("Plum", 5, 350),
        ("Pomegranate", 10, 260),
        ("Sapota", 15, 70),
        ("Watermelon", 20, 130),
        ("Yellow Banana", 18, 90)
    ]
    cursor.executemany("INSERT INTO sales (product, quantity, price) VALUES (?, ?, ?)", dummy_data)
    conn.commit()


# Step 4: Run SQL query for summary, sorted by revenue
query = """
SELECT 
    product, 
    SUM(quantity) AS total_qty, 
    SUM(quantity * price) AS revenue 
FROM sales 
GROUP BY product
ORDER BY revenue DESC
"""
df = pd.read_sql_query(query, conn)

# Step 5: Print sales summary
print("📊 Sales Summary:\n")
print(df)

# Step 6: Identify and print top-selling product
top_product = df.iloc[0]
print(f"\n🏆 Top-Selling Product: {top_product['product']} - Revenue: ${top_product['revenue']:.2f}")

# Step 7: Plot bar chart (highlight top product in gold)
df.plot(kind='bar', x='product', y='revenue', legend=False)
plt.title("Revenue by Product (Top in Gold)")
plt.xlabel("Product")
plt.ylabel("Revenue ($)")
plt.tight_layout()
plt.grid(axis='y', linestyle='--', alpha=0.7)
plt.savefig("sales_chart_highlighted.png")
plt.show()


# Step 8: Pie chart for top 10 revenue share (show only top 10 products)
top_10_df = df.nlargest( 10 , 'revenue')  # Select the top 10 products by revenue

plt.figure(figsize=(6, 6))
# Plotting the pie chart for top 10 products
plt.pie(top_10_df['revenue'], labels=top_10_df['product'], autopct='%1.1f%%', startangle=140, colors=plt.cm.Paired.colors)

# Title and labels
plt.title("Top 10 Products by Revenue Share")
plt.axis('equal')  # Ensures the pie chart is circular.
plt.tight_layout()

# Save the pie chart as an image
plt.savefig("top_10_revenue_pie_chart.png")

# Show the pie chart
plt.show()

# Step 9: Close DB connection
conn.close()