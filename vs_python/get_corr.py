import pandas as pd

joined_df = pd.read_csv("../tmp/joined.csv")

print("平均")
print(joined_df.mean())
print("")

print("標準偏差")
print(joined_df.std())
print("")

print("共分散")
print(joined_df.cov())
print("")

print("相関係数")
print(joined_df.corr())
print("")
