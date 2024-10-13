# How to Use and Test Our Code

## Testing the Loan Contract on Sui Testnet

Follow these steps to test the loan contract by transitioning a loan from the "Creating" state to the "Ask" state on the Sui Testnet.

### 1. Create a Loan on the Blockchain

After publishing the contract on the testnet, you can create a new loan by calling the `create_credit` function. Use the command below:

```bash
sui client call --function create_credit --module credit --package <package_id> --args <borrower_address> <amount> --gas-budget 1000
```

- `<package_id>`: The package ID obtained after publishing the contract on the blockchain.
- `<borrower_address>`: The borrower's address on the blockchain.
- `<amount>`: The loan amount.

This command will create a "Credit" object on the blockchain with the state set to "Creating."

### 2. Transition to the Ask State

To transition the loan from the "Creating" state to the "Ask" state, call the `transition_to_ask` function:

```bash
sui client call --function transition_to_ask --module credit --package <package_id> --args <credit_object_id> <borrower_address> --gas-budget 1000
```

- `<credit_object_id>`: The ID of the "Credit" object you just created.
- `<borrower_address>`: The borrower's address, which must match the creator of the credit.

This step ensures that the state transition works correctly and that only the borrower who created the loan can trigger this change.

By following these steps, you will have successfully tested the loan contract's state transitions on the Sui Testnet.