import pandas as pd

df = pd.read_json(r'outapk.json')
df.to_csv(r'outapk.csv', index=None)
