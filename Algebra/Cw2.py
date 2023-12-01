import numpy as np
import matplotlib.pyplot as plt
from scipy.stats import binom, norm, poisson, kurtosis as kurtosis_scipy, skew

# Funkcja do generowania próbek dla danego rozkładu
def generate_samples(distribution, size, **params):
    return distribution(size=size, **params)

# Funkcja do obliczania statystyk opisowych
def calculate_statistics(data):
    mean_value = np.mean(data)
    variance_value = np.var(data)
    kurtosis_value = kurtosis_scipy(data)
    skewness_value = skew(data)
    return mean_value, variance_value, kurtosis_value, skewness_value

# Funkcja do rysowania histogramu i gęstości rozkładu normalnego
def plot_normal_distribution(mu, sigma, size):
    data = np.random.normal(mu, sigma, size)
    
    plt.hist(data, bins=20, density=True, alpha=0.7, color='blue', label='Histogram')
    
    x = np.linspace(mu - 3*sigma, mu + 3*sigma, 100)
    plt.plot(x, norm.pdf(x, mu, sigma), 'r--', label='Gęstość')
    
    plt.title('Rozkład normalny')
    plt.xlabel('Wartość')
    plt.ylabel('Prawdopodobieństwo')
    plt.legend()
    plt.show()

# Parametry rozkładu Bernoulliego
p_bernoulli = 1/6
size = 100

# Generowanie próbek dla rozkładu Bernoulliego
bernoulli_samples = generate_samples(np.random.binomial, size, n=1, p=p_bernoulli)

# Obliczanie statystyk opisowych dla rozkładu Bernoulliego
mean, variance, kurtosis_value, skewness_value = calculate_statistics(bernoulli_samples)
print(f'Rozkład Bernoulliego: Średnia={mean}, Wariancja={variance}, Kurtosis={kurtosis_value}, Skośność={skewness_value}')

# Rysowanie wykresu rozkładu prawdopodobieństwa dla rozkładu Bernoulliego
plt.bar([0, 1], [1-p_bernoulli, p_bernoulli], tick_label=['0', '1'])
plt.title('Rozkład prawdopodobieństwa dla rozkładu Bernoulliego')
plt.xlabel('Wartość')
plt.ylabel('Prawdopodobieństwo')
plt.show()

# Parametry rozkładu Dwumianowego
n_binomial = 20
p_binomial = 0.4

# Generowanie próbek dla rozkładu Dwumianowego
binomial_samples = generate_samples(np.random.binomial, size, n=n_binomial, p=p_binomial)

# Obliczanie statystyk opisowych dla rozkładu Dwumianowego
mean, variance, kurtosis_value, skewness_value = calculate_statistics(binomial_samples)
print(f'Rozkład Dwumianowy: Średnia={mean}, Wariancja={variance}, Kurtosis={kurtosis_value}, Skośność={skewness_value}')

# Rysowanie wykresu rozkładu prawdopodobieństwa dla rozkładu Dwumianowego
x_binomial = np.arange(0, n_binomial+1)
plt.bar(x_binomial, binom.pmf(x_binomial, n_binomial, p_binomial), tick_label=x_binomial)
plt.title('Rozkład prawdopodobieństwa dla rozkładu Dwumianowego')
plt.xlabel('Wartość')
plt.ylabel('Prawdopodobieństwo')
plt.show()

# Parametr rozkładu Poissona
lambda_poisson = 3

# Generowanie próbek dla rozkładu Poissona
poisson_samples = generate_samples(np.random.poisson, size, lam=lambda_poisson)

# Obliczanie statystyk opisowych dla rozkładu Poissona
mean, variance, kurtosis_value, skewness_value = calculate_statistics(poisson_samples)
print(f'Rozkład Poissona: Średnia={mean}, Wariancja={variance}, Kurtosis={kurtosis_value}, Skośność={skewness_value}')

# Rysowanie wykresu rozkładu prawdopodobieństwa dla rozkładu Poissona
x_poisson = np.arange(0, max(poisson_samples)+1)
plt.bar(x_poisson, poisson.pmf(x_poisson, lambda_poisson), tick_label=x_poisson)
plt.title('Rozkład prawdopodobieństwa dla rozkładu Poissona')
plt.xlabel('Wartość')
plt.ylabel('Prawdopodobieństwo')
plt.show()

# Parametry rozkładu normalnego
mu_normal = 0
sigma_normal = 2

# Generowanie próbek dla rozkładu normalnego
normal_samples = generate_samples(np.random.normal, size, loc=mu_normal, scale=sigma_normal)

# Obliczanie statystyk opisowych dla rozkładu normalnego
mean, variance, kurtosis_value, skewness_value = calculate_statistics(normal_samples)
print(f'Rozkład normalny (n=100): Średnia={mean}, Wariancja={variance}, Kurtosis={kurtosis_value}, Skośność={skewness_value}')

# Zwiększenie liczby danych
size_large = 1000
normal_samples_large = generate_samples(np.random.normal, size_large, loc=mu_normal, scale=sigma_normal)

# Obliczanie statystyk opisowych dla rozkładu normalnego z większą liczbą danych
mean_large, variance_large, kurtosis_value_large, skewness_value_large = calculate_statistics(normal_samples_large)
print(f'Rozkład normalny (n=1000): Średnia={mean_large}, Wariancja={variance_large}, Kurtosis={kurtosis_value_large}, Skośność={skewness_value_large}')

# Zdefiniowanie zmiennej x
x = np.linspace(mu_normal - 3*sigma_normal, mu_normal + 3*sigma_normal, 100)

# Rysowanie histogramu i gęstości rozkładu normalnego
plt.hist(normal_samples, bins=20, density=True, alpha=0.5, color='blue', label='Histogram (n=100)')
plt.plot(x, norm.pdf(x, mu_normal, sigma_normal), 'r--', label='Gęstość (teoretyczna)')

# Rysowanie histogramu dla rozkładu normalnego z większą liczbą danych
plt.hist(normal_samples_large, bins=20, density=True, alpha=0.5, color='green', label='Histogram (n=1000)')

# Rysowanie gęstości dla rozkładu normalnego o innych parametrach
plt.plot(x, norm.pdf(x, -1, 0.5), 'k-', label='Gęstość (mu=-1, sigma=0.5)')

plt.title('Rozkład normalny')
plt.xlabel('Wartość')
plt.ylabel('Prawdopodobieństwo')
plt.legend()
plt.show()

