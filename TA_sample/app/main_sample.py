from ta_db.ta_db import engine
import pandas as pds
from tabulate import tabulate

query = """
  SELECT 
   n.branch_id,
   n.product_id,
   COALESCE(n.needs, 0) AS needs,
   COALESCE(bp.balance, 0) - COALESCE(bp.reserve, 0) AS branch_available,
   COALESCE(bp.reserve, 0) AS branch_reserve,
   COALESCE(s.priority, 0) AS priority,
   COALESCE(dp.balance, 0) - COALESCE(dp.reserve, 0) AS dc_available
  FROM needs_1 n
  LEFT JOIN branch_product_1 bp ON n.branch_id = bp.branch AND n.product_id = bp.product
  LEFT JOIN stores_1 s ON n.branch_id = s.branch_id
  LEFT JOIN dc_product_1 dp ON n.product_id = dp.product
"""

df = pds.read_sql_query(query, engine)
df = df.sort_values(by="branch_available", ascending=False)
dc_balance = {}
result_table = []

for line in df.itertuples(index=False):
    product = line.product_id
    need = line.needs
    available = line.branch_available
    priority = line.priority
    dc_available = line.dc_available

    if product not in dc_balance:
        dc_balance[product] = dc_available

    need_to_deliver = max(need - available, 0)
    deliver_now = min(need_to_deliver, dc_balance[product])

    dc_balance[product] -= deliver_now
    result_table.append({
        "branch_id": line.branch_id,
        "product_id": line.product_id,
        "priority": line.priority,
        "need": line.needs,
        "branch_available": available,
        "deliver": deliver_now,
        "dc_left": dc_balance[product]
    })
result_df = pds.DataFrame(result_table)

#print(tabulate(result_df.head(10), headers="keys", tablefmt="pretty"))
result_df.to_csv("result_table.csv", index=False, encoding='utf-8-sig')

