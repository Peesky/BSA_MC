module bridge::contract_tree {

    use sui::tx_context::TxContext;
    use bridge::credit::{Credit, get_credit_state, get_credit_risk, CreditState};
    use bridge::pool::{Pool, create_pool, add_credit, add_investment, get_pool_state, get_pool_credits};

    const RISK_MARGIN: u64 = 5;

    /// Function to find compatible credits based on risk and create a pool
    public fun group_credits_by_risk(credits: vector<bridge::credit::Credit>, threshold: u64, ctx: &mut TxContext): Pool {
        let mut pool = create_pool(threshold, ctx);
        let mut total_risk = 0;
        let mut i = 0;
        while (i < vector::length<bridge::credit::Credit>(credits)) {
            let credit = &mut credits[i];
            let risk = get_credit_risk(&credit);
            total_risk = total_risk + risk /vector::length(credits);
            i = i + 1;
            
    }

    // Ouvre le pool après avoir ajouté les crédits
    open_pool(&mut pool);
    pool
}


    /// Helper function to calculate the absolute difference between two values
    public fun abs_diff(a: u64, b: u64): u64 {
        if (a > b) a - b else b - a
    }

    /// Function to manage the investment process
    public fun invest_in_pool(pool: &mut Pool, creditor: address, amount: u64) {
        add_investment(pool, creditor, amount);

        if (get_pool_state(&pool) == bridge::pool::PoolState::Closed) {
            let credits = get_pool_credits(&pool);
            let mut i = 0;
            while (i < vector::length(credits)) {
                let credit = vector::borrow_mut(credits, i);
                credit.state = CreditState::OnGoing;
                i = i + 1;
            }
        }
    }
}
