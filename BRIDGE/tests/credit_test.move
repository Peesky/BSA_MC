module bridge::credit_active_test {

    use sui::tx_context::TxContext;
    use bridge::credit::{Credit, create_credit, get_credit_state, CreditState};

    #[test]
    fun test_create_credit_and_check_active() {
        // Crée un contexte de transaction
        let mut ctx = sui::tx_context::new_tx_context(@0x1);

        // Paramètres pour le crédit
        let borrower = @0x1;
        let pool_address = @0x2;
        let credit_info = b"Demande de crédit";
        let amount = 1u64;  // Montant du crédit de 1 SUI
        let risk = 10u64;   // Exemple de niveau de risque

        // Créer un nouveau crédit
        let credit = create_credit(borrower, amount, pool_address, credit_info, risk, &mut ctx);

        // Vérifier si le crédit est actif
        let credit_state = get_credit_state(&credit);
        let is_active = credit_state != CreditState::Creating;

        // Assertion pour vérifier si le crédit est considéré comme actif ou non
        assert!(is_active == false, 100);  // Le crédit ne doit pas être actif immédiatement après la création
    }
}
