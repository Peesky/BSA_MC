module bridge::credit {

    //use sui::object::UID;
    //use sui::tx_context::TxContext;

    /// Define the states of the credit with abilities
    /// We need 'copy', 'drop', and 'store' abilities to manipulate the enum in the ways required.
    public enum CreditState has copy, drop, store {
        Creating,
        Ask,
        OnGoing,
        FullFilled
    }

    /// Define the Credit object with visibility and required abilities
    public struct Credit has  store, copy, drop {
        id: u64,           // Unique identifier for each credit
        borrower: address, // Address of the borrower
        amount: u64,       // Amount requested by the borrower
        state: CreditState, // Current state of the credit
        pool: address,     // Address of the pool
        infos: vector<u8>,  // Additional information
        risk: u64          // Risk associated with the credit
    }

    /// Function to create a new credit
    public fun create_credit(id: u64, borrower: address, amount: u64, pool: address, infos: vector<u8>, risk: u64, ctx: &mut TxContext): Credit {
        Credit {
            id,
            borrower,
            amount: amount,
            state: CreditState::Creating,
            pool: pool,
            infos: infos,
            risk: risk
        }
    }

    /// Function to transition the credit to the Ask state
    public fun transition_to_ask(credit: &mut Credit, caller: address) {
        // Verify that the caller is the borrower
        assert!(credit.borrower == caller, 0);

        // Ensure the current state is Creating
        assert!(credit.state == CreditState::Creating, 1);

        // Transition to Ask state
        credit.state = CreditState::Ask;
    }

    /// Public function to get the state of a credit
    public fun get_credit_state(credit: &Credit): CreditState {
        credit.state
    }

    /// Public function to get the risk of a credit
    public fun get_credit_risk(credit: &Credit): u64 {
        credit.risk
    }

    /// Public function to get the amount of a credit
    public fun get_credit_amount(credit: &Credit): u64 {
        credit.amount
    }
}
