using DrWatson
using YAML
using Unitful
using Measurements
using Zygote
using Dates: Month, Year, Week
@quickactivate "property_calculations"

# Here you may include files from the source directory
include(srcdir("investment_returns.jl"))

@unit € "€" Euro 1.0 false

# @unit month "month" Month 1/12u"yr" false

if !isinteractive()
    if length(ARGS) != 1
        println("Usage: julia script.jl estimates.yaml")
        exit(1)
    end
    estimates = YAML.load_file(ARGS[1])

    purchase_price = estimates["purchase_price"] * €
    cadastral_value_fraction = measurement(estimates["cadastral_value_fraction"], estimates["cadastral_value_fraction_uncertainty"])
    notary_fee = estimates["notary_fee"] * €
    loan_initiation_fee = estimates["loan_initiation_fee"] * €
    loan_tax_rate = estimates["loan_tax_rate"]/1u"yr"
    interest_rate = measurement(estimates["interest_rate"]/1u"yr", estimates["interest_rate_uncertainty"]/1u"yr")
    # interest_rate = estimates["interest_rate"]/1u"yr"
    loan_term = estimates["loan_term"] * 1u"yr"
    down_payment_fraction = estimates["down_payment_fraction"]
    mortgage_insurance_rate = estimates["mortgage_insurance_rate"] / 1u"yr"
    occupancy_rate = measurement(estimates["occupancy_rate"], estimates["occupancy_rate_uncertainty"])
    #occupancy_rate = estimates["occupancy_rate"]
    weekly_occupied_revenue = measurement(estimates["weekly_occupied_revenue"] * € / 1u"wk", estimates["weekly_occupied_revenue_uncertainty"] * € / 1u"wk")
    #weekly_occupied_revenue = estimates["weekly_occupied_revenue"] * € / 1u"wk"
    property_tax_rate = estimates["property_tax_rate"] / 1u"yr"
    annual_maintenance_rate = measurement(estimates["annual_maintenance_rate"] / 1u"yr", estimates["annual_maintenance_rate_uncertainty"] / 1u"yr")
    #annual_maintenance_rate = estimates["annual_maintenance_rate"] / 1u"yr"
    utilities = measurement(estimates["monthly_utilities"]* € / 4u"wk", estimates["monthly_utilities_uncertainty"]* € / 4u"wk")
    #utilities = estimates["monthly_utilities"]* € / 4u"wk"
    closing_cost_rate = estimates["closing_cost_rate"]
    asset_appreciation_rate = measurement(estimates["asset_appreciation_rate"]/1u"yr", estimates["asset_appreciation_rate_uncertainty"]/1u"yr")
    #asset_appreciation_rate = estimates["asset_appreciation_rate"]/1u"yr"
    hold_duration = estimates["hold_duration"]*1u"yr"
    sp500_return = measurement(estimates["sp500_return"]/1u"yr", estimates["sp500_return_uncertainty"]/1u"yr")
    #sp500_return = estimates["sp500_return"]/1u"yr"

    params = InvestmentReturnParameters(
        purchase_price,
        cadastral_value_fraction,
        notary_fee,
        loan_initiation_fee,
        loan_tax_rate,
        interest_rate,
        loan_term,
        down_payment_fraction,
        mortgage_insurance_rate,
        occupancy_rate,
        weekly_occupied_revenue,
        property_tax_rate,
        annual_maintenance_rate,
        utilities,
        closing_cost_rate,
        asset_appreciation_rate,
        hold_duration,
        sp500_return
    )
    println(params)

    # Doesn't work for now:
    # See: https://github.com/PainterQubits/Unitful.jl/issues/737
    # Zygote.gradient(params -> total_money_at_sale(params), params)

end
