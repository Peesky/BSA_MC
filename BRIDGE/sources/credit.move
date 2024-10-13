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
    public struct Credit has key, store {
        id: UID,           // Unique identifier for each credit
        borrower: address, // Address of the borrower
        amount: u64,       // Amount requested by the borrower
        state: CreditState, // Current state of the credit
        pool: address,     // Address of the pool
        infos: vector<u8>  // Additional information
    }

    /// Function to create a new credit
    public fun create_credit(borrower: address, amount: u64, pool: address, infos: vector<u8>, ctx: &mut TxContext): Credit {
        Credit {
            id: object::new(ctx),
            borrower: borrower,
            amount: amount,
            state: CreditState::Creating,
            pool: pool,
            infos: infos
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
}
