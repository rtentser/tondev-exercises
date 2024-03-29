pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

contract Product {

	// State variable storing the sum of arguments that were passed to function 'add',
	uint public product = 1;

	constructor() public {
		// check that contract's public key is set
		require(tvm.pubkey() != 0, 101);
		// Check that message has signature (msg.pubkey() is not zero) and message is signed with the owner's private key
		require(msg.pubkey() == tvm.pubkey(), 102);
		tvm.accept();
	}

	// Modifier that allows to accept some external messages
	modifier checkOwnerAndAccept {
		// Check that message was signed with contracts key.
		require(msg.pubkey() == tvm.pubkey(), 102);
		tvm.accept();
		_;
	}

	// Function that adds its argument to the state variable.
	function multiple(uint value) public checkOwnerAndAccept {
        require(0 < value && value <= 10);
		product *= value;
	}
}