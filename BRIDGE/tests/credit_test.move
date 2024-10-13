module bridge::credit_test {

    use bridge::credit::{create_credit, transition_to_ask, get_credit_state, CreditState};

    #[test]
    fun test_create_and_transition() {
        let mut ctx = sui::tx_context::new_tx_context(@0x1);
        let borrower = @0x1;
        let pool = @0x2;
        let amount = 100u64;
        let infos = b"Sample credit info";
        
        // Create a new credit
        let credit = create_credit(borrower, amount, pool, infos, &mut ctx);
        
        // Ensure the credit is in the Creating state
        assert!(get_credit_state(&credit) == CreditState::Creating, 100);

        // Transition the credit to Ask state
        transition_to_ask(&mut credit, borrower);
        
        // Verify the credit has transitioned to Ask
        assert!(get_credit_state(&credit) == CreditState::Ask, 101);
    }
}
