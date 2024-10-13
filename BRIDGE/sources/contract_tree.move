module bridge::contract_tree {

    use sui::tx_context::TxContext;
    use bridge::credit::{Credit, get_credit_state, get_credit_risk, get_credit_amount, CreditState};
    use bridge::pool::{Pool, create_pool, add_credit, add_investment, get_pool_state, get_pool_credits};

    const RISK_MARGIN: u64 = 5;
    const TARGET_RISK: u64 = 90;

    /// Function to find compatible credits based on risk and create a pool
    public fun group_credits_by_90(credits: vector<bridge::credit::Credit>, ctx: &mut TxContext): Pool {
        let mut i: u64 = 0;
        let lower_bound: u64 = TARGET_RISK - RISK_MARGIN;
        let upper_bound: u64 = TARGET_RISK + RISK_MARGIN;
        let mut new_treshold: u64 = 0;
        // on crée une copie du vector de credits
        let mut credits_vector_ID_copy:vector<Credit> = vector[]; 
        let mut new_credits_vector: vector<Credit> = vector::empty<Credit>();

        while (i < vector::length(&credits)) {
            let credit = credits[i];	
            let credit_risk = get_credit_risk(&credit);
            if (credit_risk >= lower_bound && credit_risk <= upper_bound) {
                new_treshold = new_treshold + get_credit_amount(&credit);
                //ajoute le credit dans le new credits vector
                credits_vector_ID_copy.push_back(credit);
                };
            i = i + 1;
        };
        
        let mut pool = create_pool(new_treshold, ctx);
        let mut j: u64 = 0;
        while (j < vector::length(&new_credits_vector)) {
            add_credit(&mut pool, new_credits_vector[j]);
            j = j + 1;
        }; 
        pool             
    }

    /// Function to find compatible credits based on risk and create a pool
    public fun group_credits_by_arg_risk(credits: vector<bridge::credit::Credit>,target_risk: u64, ctx: &mut TxContext): Pool {
        let mut i: u64 = 0;
        let lower_bound: u64 = target_risk - RISK_MARGIN;
        let upper_bound: u64 = target_risk + RISK_MARGIN;
        let mut new_treshold: u64 = 0;
        // on crée une copie du vector de credits
        let mut credits_vector_ID_copy:vector<Credit> = vector[]; 
        let mut new_credits_vector: vector<Credit> = vector::empty<Credit>();

        while (i < vector::length(&credits)) {
            let credit = credits[i];	
            let credit_risk = get_credit_risk(&credit);
            if (credit_risk >= lower_bound && credit_risk <= upper_bound) {
                new_treshold = new_treshold + get_credit_amount(&credit);
                //ajoute le credit dans le new credits vector
                credits_vector_ID_copy.push_back(credit);
                };
            i = i + 1;
        };
        
        let mut pool = create_pool(new_treshold, ctx);
        let mut j: u64 = 0;
        while (j < vector::length(&new_credits_vector)) {
            add_credit(&mut pool, new_credits_vector[j]);
            j = j + 1;
        }; 
        pool             
    }
}



