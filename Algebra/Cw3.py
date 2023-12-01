import numpy as np
from scipy import stats
import pandas as pd

# Generowanie próby losowej dla rozkładu normalnego
np.random.seed(42)
mean = 2
std_dev = 30
sample_size = 200

random_sample = np.random.normal(mean, std_dev, sample_size)

# Testowanie hipotezy o średniej
hypothesized_mean = 2.5
t_stat, p_value = stats.ttest_1samp(random_sample, hypothesized_mean)

print(f"T-statistic: {t_stat}")
print(f"P-value: {p_value}")

# Interpretacja wyników testu
alpha = 0.05
if p_value < alpha:
    print("Odrzucamy hipotezę zerową - średnia różni się istotnie od 2.5")
else:
    print("Nie ma podstaw do odrzucenia hipotezy zerowej - brak istotnej różnicy od 2.5")

df = pd.read_csv("napoje.csv", delimiter=';')

# Wygenerowanie losowej próbki z rozkładu normalnego o średniej=2, odchyleniu standardowym=30 i rozmiarze=200
random_sample = np.random.normal(loc=2, scale=30, size=200)

# Test hipotezy, że średnia losowej próbki jest równa 2.5
mean_hypothesis = 2.5
t_stat, p_value = stats.ttest_1samp(random_sample, mean_hypothesis)

# Sprawdzenie wartości p, aby ustalić, czy odrzucić hipotezę zerową
alpha = 0.05
if p_value < alpha:
    print(f"Odrzuć hipotezę zerową. Średnia nie jest równa {mean_hypothesis}.")
else:
    print(f"Nie udało się odrzucić hipotezy zerowej. Średnia jest równa {mean_hypothesis}.")

# Weryfikacja hipotez dotyczących średnich wartości
lech_hypothesis = stats.ttest_1samp(df['lech'], 60500)
cola_hypothesis = stats.ttest_1samp(df['cola'], 222000)
regionalne_hypothesis = stats.ttest_1samp(df['regionalne'], 43500)

print("\nHipoteza Lech:", lech_hypothesis)
print("Hipoteza Cola:", cola_hypothesis)
print("Hipoteza Regionalne:", regionalne_hypothesis)

# Sprawdzenie normalności zmiennych w pliku napoje.csv
normality_tests = {}
for column in df.columns[2:]:
    _, p_value = stats.normaltest(df[column])
    normality_tests[column] = p_value

print("\nTesty normalności:")
for variable, p_value in normality_tests.items():
    if p_value < alpha:
        print(f"{variable}: Odrzuć hipotezę zerową. Rozkład nie jest normalny.")
    else:
        print(f"{variable}: Nie udało się odrzucić hipotezy zerowej. Rozkład jest normalny.")

# Zbadanie równości średnich dla par zmiennych
okocim_lech_comparison = stats.ttest_ind(df['okocim'], df['lech'])
fanta_regionalne_comparison = stats.ttest_ind(df['fanta'], df['regionalne'])
cola_pepsi_comparison = stats.ttest_ind(df['cola'], df['pepsi'])

print("\nTesty równości średnich:")
print("Okocim - Lech:", okocim_lech_comparison)
print("Fanta - Regionalne:", fanta_regionalne_comparison)
print("Cola - Pepsi:", cola_pepsi_comparison)

# Zbadanie równości wariancji
okocim_lech_var_comparison = stats.levene(df['okocim'], df['lech'])
zywiec_fanta_var_comparison = stats.levene(df['żywiec'], df['fanta'])
regionalne_cola_var_comparison = stats.levene(df['regionalne'], df['cola'])

print("\nTesty równości wariancji:")
print("Okocim - Lech:", okocim_lech_var_comparison)
print("Żywiec - Fanta:", zywiec_fanta_var_comparison)
print("Regionalne - Cola:", regionalne_cola_var_comparison)

# Zbadanie równości średnich pomiędzy latami 2001 i 2015 dla piw regionalnych
regionalne_2001 = df.loc[df['rok'] == 2001, 'regionalne']
regionalne_2015 = df.loc[df['rok'] == 2015, 'regionalne']

regionalne_years_comparison = stats.ttest_ind(regionalne_2001, regionalne_2015)

print("\nTest równości średnich dla lat 2001 i 2015 dla piw regionalnych:", regionalne_years_comparison)

df_po_reklamie = pd.read_csv("napoje_po_reklamie.csv", delimiter=';')

# Zbadanie równości średnich dla roku 2016
cola_2016_comparison = stats.ttest_rel(df.loc[df['rok'] == 2016, 'cola'], df_po_reklamie['cola'])
fanta_2016_comparison = stats.ttest_rel(df.loc[df['rok'] == 2016, 'fanta'], df_po_reklamie['fanta'])
pepsi_2016_comparison = stats.ttest_rel(df.loc[df['rok'] == 2016, 'pepsi'], df_po_reklamie['pepsi'])

print("\nTesty równości średnich dla roku 2016:")
print("Cola:", cola_2016_comparison)
print("Fanta:", fanta_2016_comparison)
print("Pepsi:", pepsi_2016_comparison)
