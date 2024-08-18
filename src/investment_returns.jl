"""
Parameters for calculating an investment return.
"""

struct InvestmentReturnParameters
    purchase_price::Number
    notary_fee::Number
    loan_initiation_fee::Number
    loan_tax_rate::Number
    interest_rate::Number
    loan_term::Number
    down_payment_fraction::Number
    mortgage_insurance_rate::Number
    occupancy_rate::Number
    weekly_occupied_revenue::Number
    property_tax_rate::Number
    annual_maintenance_rate::Number
    utilities::Number
    closing_cost_rate::Number
    asset_appreciation_rate::Number
    hold_duration::Number
    sp500_return::Number
end

function total_initial_cost(p::InvestmentReturnParameters)
    p.purchase_price*(1.0+closing_cost_rate) + p.notary_fee + p.loan_initiation_fee
end

function down_payment(p::InvestmentReturnParameters)
    return total_initial_cost(p)*p.down_payment_fraction
end

function loan_amount(p::InvestmentReturnParameters)
    return total_initial_cost(p) - down_payment(p)
end

function monthly_payment(p::InvestmentReturnParameters)
    r = p.interest_rate*1u"yr"/12 # use monthly interest rate for monthly payment
    # Number of payments:
    n = p.loan_term*12/1u"yr"
    return loan_amount(p)*r*(1+r)^n/((1+r)^n - 1)
end

function annual_revenue(p::InvestmentReturnParameters)
    return p.occupancy_rate*p.weekly_occupied_revenue*52*1u"wk"/1u"yr"
end

function annual_costs(p::InvestmentReturnParameters)
    c = monthly_payment(p)*12/1u"yr" 
    c += (p.utilities*52.0*1u"wk")/1u"yr"
    c += p.purchase_price*p.property_tax_rate
    c += loan_amount(p)*p.mortgage_insurance_rate
    c += loan_amount(p)*p.loan_tax_rate
    c += p.purchase_price*p.annual_maintenance_rate
    return c
end

function return_on_capital(p::InvestmentReturnParameters)
    profit = annual_revenue(p) - annual_costs(p)
    return profit/down_payment(p)
end

function loan_balance_at_sale(p::InvestmentReturnParameters)
    x = 1 + p.mortgage_insurance_rate*1u"yr"
    n = ustrip(u"yr", p.loan_term)
    b = ustrip(u"yr", p.hold_duration)
    loan_balance = loan_amount(p)*(x^n - x^b)/(x^n -1)
    return loan_balance
end

function sale_price(p::InvestmentReturnParameters)
    # No seller fees:
    return p.purchase_price*exp(p.hold_duration*p.asset_appreciation_rate)
end

function total_money_at_sale(p::InvestmentReturnParameters)
    # This doesn't model the fact that you'd put your profits in the S&P 500!
    # That's probably a major effect. . . 
    profit = (annual_revenue(p) - annual_costs(p))*p.hold_duration
    x = 1 + p.mortgage_insurance_rate*1u"yr"
    n = ustrip(u"yr", p.loan_term)
    b = ustrip(u"yr", p.hold_duration)
    loan_balance = loan_amount(p)*(x^n - x^b)/(x^n -1)
    return profit + sale_price(p) - loan_balance
end



import Base: show

function show(io::IO, estimates::InvestmentReturnParameters)
    println(io, "Real Estate Return Assumptions:")
    println(io, "  Property Value         : ", estimates.purchase_price)
    println(io, "  Notary fee             : ", estimates.notary_fee)
    println(io, "  Loan initiation fee    : ", estimates.loan_initiation_fee)
    println(io, "  Loan Tax rate          : ", estimates.loan_tax_rate)
    println(io, "  Mortgage interest rate : ", estimates.interest_rate)
    println(io, "  Loan term              : ", estimates.loan_term)
    println(io, "  Down payment fraction  : ", estimates.down_payment_fraction)
    println(io, "  Mortgage insurance rate: ", estimates.mortgage_insurance_rate)
    println(io, "  Occupancy_rate         : ", estimates.occupancy_rate)
    println(io, "  Revenue when occupied  : ", estimates.weekly_occupied_revenue)
    println(io, "  Property tax rate      : ", estimates.property_tax_rate)
    println(io, "  Annual maintenance rate: ", estimates.annual_maintenance_rate)
    println(io, "  Utilities              : ", estimates.utilities)
    println(io, "  Closing cost rate      : ", estimates.closing_cost_rate)
    println(io, "  Asset appreciation rate: ", estimates.asset_appreciation_rate)
    println(io, "  Loan amount            : ", loan_amount(estimates))
    println(io, "  Down payment           : ", down_payment(estimates))
    println(io, "  Monthly payment        : ", monthly_payment(estimates))
    println(io, "  Annual revenue         : ", annual_revenue(estimates))
    println(io, "  Annual cost            : ", annual_costs(estimates))
    println(io, "  Annual profit          : ", annual_revenue(estimates) - annual_costs(estimates))
    println(io, "  Return on capital      : ", return_on_capital(estimates))
    println(io, "  Hold duration          : ", estimates.hold_duration)
    println(io, "  Sale price             : ", sale_price(estimates))
    println(io, "  Loan balance at sale   : ", loan_balance_at_sale(estimates))
    println(io, "  Total return at sale   : ", total_money_at_sale(estimates))
    println(io, "  Total return S&P500    : ", down_payment(estimates)*exp(estimates.sp500_return*estimates.hold_duration))
end
