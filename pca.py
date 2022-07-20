import pandas as pd
from sklearn.datasets import load_wine
from sklearn.preprocessing import StandardScaler
import numpy as np

wine = load_wine()  # Wineデータセットの読み込み
df_wine = pd.DataFrame(wine.data, columns=wine.feature_names)
df_wine['class'] = wine.target

print("df_wine")
print(df_wine)

X = df_wine.iloc[:, :-1].values  # classカラム以外を取得
y = df_wine.iloc[:, -1].values  # classカラムを取得
# 標準化
sc = StandardScaler()
X_std = sc.fit_transform(X)

print("X_std")
print(X_std)

# 分散共分散行列の作成
cov_mat = np.cov(X_std.T)

print("cov_mat")
print(cov_mat)

# 分散共分散行列の固有値、固有ベクトルを作成
eigen_vals, eigen_vecs = np.linalg.eig(cov_mat)
# 固有値、固有ベクトルのペアを作成
eigen_pairs = [(np.abs(eigen_vals[i]), eigen_vecs[:,i]) for i in range(len(eigen_vals))]
# 上記のペアを固有値の大きい順にソート
eigen_pairs.sort(key=lambda k: k[0], reverse=True)

w1 = eigen_pairs[0][1]  # 第1主成分に対応する固有ベクトル
w2 = eigen_pairs[1][1]  # 第2主成分に対応する固有ベクトル

print("eigen_vals")
print(eigen_vals)

print("w1")
print(w1)

print("w2")
print(w2)
