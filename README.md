# property_calculations

To run this code, install [Julia](https://julialang.org/downloads/) and run

```bash
$ julia --project=. scripts/intro.jl data/default.yaml
```

This is specifically tuned to computing the return of short-term rental properties in Italy, but the principles are the same everywhere:
Compute the opportunity cost by using the upfront cost of the loan to invest in the S&P 500.

Each payment puts principle into your property, but you cannot access that until you sell or use it to securitize another loan.
I have assumed that you _do not_ want to securitize another loan, and instead compute the return at the time of sale.

For occupancy and weekly revenue estimates, use [AirDNA](https://www.airdna.co/).
For historical price apprecation, use the Fed's data, or immobiliare (Italy only).

Here is an example output:

```
Real Estate Return Assumptions:
  Property Value         : 550000.0 €
  Cadastral Value        : 220000.0 ± 55000.0 €
  Notary fee             : 4500.0 €
  Loan initiation fee    : 1000.0 €
  Loan Tax rate          : 0.0025 yr⁻¹
  Mortgage interest rate : 0.036 ± 0.01 yr⁻¹
  Loan term              : 30.0 yr
  Down payment fraction  : 0.4
  Mortgage insurance rate: 0.002 yr⁻¹
  Occupancy_rate         : 0.5 ± 0.1
  Revenue when occupied  : 1500.0 ± 200.0 € wk⁻¹
  Property tax rate      : 0.001375 yr⁻¹
  Annual maintenance rate: 0.01 ± 0.01 yr⁻¹
  Utilities              : 125.0 ± 12.0 € wk⁻¹
  Closing cost rate      : 0.09
  Asset appreciation rate: 0.0 ± 0.02 yr⁻¹
  Loan amount            : 345200.0 ± 3000.0 €
  Down payment           : 230100.0 ± 2000.0 €
  Monthly payment        : 1570.0 ± 190.0 €
  Annual revenue         : 39000.0 ± 9400.0 € yr⁻¹
  Annual cost            : 33100.0 ± 6000.0 € yr⁻¹
  Annual profit          : 5900.0 ± 11000.0 € yr⁻¹
  Return on capital      : 0.025 ± 0.048 yr⁻¹
  Hold duration          : 15.0 yr
  Sale price             : 550000.0 ± 160000.0 €
  Loan balance at sale   : 217000.0 ± 12000.0 €
  Total return at sale   : 420000.0 ± 240000.0 €
  Total return S&P500    : 760000.0 ± 340000.0 €
  ```
