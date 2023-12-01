import pandas as pd
from scipy import stats
import statistics
import matplotlib.pyplot as plt

df = pd.read_csv('MDR_RR_TB_burden_estimates_2023-11-28.csv')

# Wybierz wybraną kolumnę numeryczną
wybrana_kolumna = pd.to_numeric(df['e_rr_in_notified_labconf_pulm_hi'], errors='coerce')  # Convert to numeric, set errors='coerce' to handle non-numeric values

# Usuń wiersze zawierające NaN (nieprzekonwertowane wartości)
wybrana_kolumna = wybrana_kolumna.dropna()

# Oblicz podstawowe statystyki
srednia = statistics.mean(wybrana_kolumna)
mediana = statistics.median(wybrana_kolumna)
wariancja = statistics.variance(wybrana_kolumna)
odchylenie_standardowe = statistics.stdev(wybrana_kolumna)

print("Srednia:", srednia)
print("Mediana:", mediana)
print("Wariancja:", wariancja)
print("Odchylenie standardowe:", odchylenie_standardowe)

df_wzrost = pd.read_csv('Wzrost.csv', header=None, delimiter=',')

# Transponuj ramkę danych, aby wartości były w kolumnach
df_wzrost = df_wzrost.transpose()

# Oblicz statystyki opisowe za pomocą funkcji describe()
summary_stats = df_wzrost.describe()
print(summary_stats)

# Oblicz dodatkowe statystyki z biblioteki scipy.stats
mean_value = df_wzrost.mean().values[0]
median_value = df_wzrost.median().values[0]
mode_value = df_wzrost.mode().iloc[0, 0]

print(f'Średnia: {mean_value}')
print(f'Mediana: {median_value}')
print(f'Moda: {mode_value}, Liczebność: {len(df_wzrost[df_wzrost[0] == mode_value])}')

df_brain = pd.read_csv('brain_size.csv', sep=';')

# Średnia dla kolumny VIQ
srednia_viq = df_brain['VIQ'].mean()

# Ilość kobiet i mężczyzn
ilosc_kobiet = df_brain[df_brain['Gender'] == 'Female'].shape[0]
ilosc_mezczyzn = df_brain[df_brain['Gender'] == 'Male'].shape[0]

print("\nŚrednia VIQ:", srednia_viq)
print("Ilość kobiet:", ilosc_kobiet)
print("Ilość mężczyzn:", ilosc_mezczyzn)

# Histogramy dla zmiennych VIQ, PIQ, FSIQ
df_brain[['VIQ', 'PIQ', 'FSIQ']].hist()
plt.show()

# Histogramy trzech kolumn tylko dla kobiet
df_brain[df_brain['Gender'] == 'Female'][['VIQ', 'PIQ', 'FSIQ']].hist()
plt.show()
