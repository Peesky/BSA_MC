module bridge::pool {

    //use sui::object::{Self, UID};
    //use sui::tx_context::TxContext;
    use bridge::credit::{Credit};

    /// Define the states of the pool
    public enum PoolState has copy, drop, store {
        Build,
        Open,
        Closed
    }

    /// Define the Pool object
    public struct Pool has key, store {
        id: UID,                        // Unique identifier for the pool
        credits: vector<Credit>,        // List of credits in the pool
        creditors: vector<address>,     // List of creditors
        investments: vector<u64>,       // Corresponding investments by each creditor
        total_investment: u64,          // Total amount invested in the pool
        threshold: u64,                 // Threshold needed to close the pool
        state: PoolState                // Current state of the pool (Build, Open, Closed)
    }

    /// Function to create a new pool
    public fun create_pool(threshold: u64, ctx: &mut TxContext): Pool {
        Pool {
            id: object::new(ctx),
            credits: vector::empty<Credit>(),
            creditors: vector::empty<address>(),
            investments: vector::empty<u64>(),
            total_investment: 0,
            threshold: threshold,
            state: PoolState::Build
        }
    }

    /// Function to add a credit to the pool (only allowed in Build state)
    public fun add_credit(pool: &mut Pool, credit: Credit) {
        assert!(pool.state == PoolState::Build, 0);
        vector::push_back(&mut pool.credits, credit);
    }

    /// Function to add an investment from a creditor
    public fun add_investment(pool: &mut Pool, creditor: address, amount: u64) {
        assert!(pool.state == PoolState::Open, 1);

        // Add creditor and their investment
        vector::push_back(&mut pool.creditors, creditor);
        vector::push_back(&mut pool.investments, amount);
        pool.total_investment = pool.total_investment + amount;

        // Check if pool can be closed
        if (pool.total_investment >= pool.threshold) {
            pool.state = PoolState::Closed;
        }
    }

    /// Function to close the pool (transitions from Open to Closed)
    /// Only allowed if the pool is open and the threshold is reached
    public fun close_pool(pool: &mut Pool) {
        assert!(pool.state == PoolState::Open, 2);
        assert!(pool.total_investment >= pool.threshold, 3);
        pool.state = PoolState::Closed;
    }
    

    /// Function to open the pool (transitions from Build to Open)
    public fun open_pool(pool: &mut Pool) {
        assert!(pool.state == PoolState::Build, 2);
        pool.state = PoolState::Open;
    }

    /// Function to check if the pool is closed
    public fun is_closed(pool: &Pool): bool {
        pool.state == PoolState::Closed
    }

    /// Public function to get the state of a pool
    public fun get_pool_state(pool: &Pool): PoolState {
        pool.state
    }

    /// Public function to access the credits in the pool
    public fun get_pool_credits(pool: &Pool): &vector<Credit> {
        &pool.credits
    }
}
