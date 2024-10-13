module bridge::pool_test {

    use sui::tx_context::TxContext;
    use bridge::credit::{Credit, create_credit};
    use bridge::pool::{Pool, create_pool, add_credit, open_pool, add_investment, is_closed};

    #[test]
    fun test_pool_creation_and_operations() {
        let mut ctx = sui::tx_context::new_tx_context(@0x1);  // Creating a test context with a dummy address
        let borrower = @0x1;
        let pool_threshold = 1000u64;

        // Create a new pool with a threshold of 1000
        let mut pool = create_pool(pool_threshold, &mut ctx);
        assert!(pool.total_investment == 0, 100);
        assert!(pool.threshold == pool_threshold, 101);

        // Create a new credit and add it to the pool (while in Build state)
        let amount = 500u64;
        let pool_address = @0x2;
        let credit_info = b"Test credit";
        let credit = create_credit(borrower, amount, pool_address, credit_info, &mut ctx);

        add_credit(&mut pool, credit);
        assert!(vector::length(&pool.credits) == 1, 102);

        // Open the pool to allow investments
        open_pool(&mut pool);
        assert!(pool.state == bridge::pool::PoolState::Open, 103);

        // Add an investment from a creditor
        let creditor = @0x3;
        let investment_amount = 600u64;
        add_investment(&mut pool, creditor, investment_amount);
        assert!(pool.total_investment == 600, 104);

        // Add another investment to close the pool
        let creditor2 = @0x4;
        let investment_amount2 = 400u64;
        add_investment(&mut pool, creditor2, investment_amount2);
        assert!(pool.total_investment == 1000, 105);
        assert!(is_closed(&pool), 106);
    }
}
