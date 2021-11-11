pragma ton-solidity >=0.35.0;
pragma AbiHeader expire;
pragma AbiHeader time;
pragma AbiHeader pubkey;

import '../AddressInput.sol';
import '../Debot.sol';
import '../Sdk.sol';
import '../Terminal.sol';
import '../Upgradable.sol';

import 'ShoppingList.sol';
import 'TransactableInterface.sol';

abstract contract BaseShoppingDebot is Debot, Upgradable {
    uint256 publicKey;
    TvmCell stateInit;
    TvmCell deployState;
    address listAddress;

    uint32 constant INITIAL_VALUE = 1000000000;

    function onCodeUpgrade() internal override {
        tvm.resetStorage();
    }
    
    function start() public override {
        Terminal.input(tvm.functionId(savePublicKey), "Please, enter your public key: ", false);
    }

    function setStateInit (TvmCell code, TvmCell data) public {
        require(msg.pubkey() == tvm.pubkey(), 101);
        tvm.accept();
        stateInit = tvm.buildStateInit(code, data);
    }

    function savePublicKey (string value) public {
        (uint256 key, bool status) = stoi("0x" + value);

        if (status) {
            publicKey = key;
            deployState = tvm.insertPubkey(stateInit, publicKey);
            listAddress = address.makeAddrStd(0, tvm.hash(deployState));

            Terminal.print(0, "Thank you!\nChecking if you already have a shopping list...");
            Terminal.print(0, format("Your shopping list's address is: {}", listAddress));
            Sdk.getAccountType(tvm.functionId(statusActions), listAddress);
        } else {
            Terminal.input(tvm.functionId(savePublicKey), "Wrong public key! Please try again.\nEnter your public key: ", false);
        }
    }

    function statusActions (int8 acc_type) public {
        if (acc_type == 1) { // the account is active and the contract is already deployed
            menu();
        } else if (acc_type == -1) { // the account does not exist
            Terminal.print(0, "You don't have a shopping list yet, so a new contract with an initial balance of 0.2 tokens will be deployed");
            AddressInput.get(tvm.functionId(creditAccount), "Select a wallet for payment. We will ask you to sign two transactions: ");
        } else if (acc_type == 0) { // the account has money but not deployed yet
            Terminal.print(0, "Deploying a new list. If error occurs, check if your list has enough funds");
            deploy();
        } else if (acc_type == 2) {// the account is frozen
            Terminal.print(0, format("Can't continue: the account {} if frozen.", listAddress));
        }
    }

    function deploy () private view {
        optional(uint256) none;
        TvmCell deployMsg = tvm.buildExtMsg({
            abiVer: 2,
            dest: listAddress,
            callbackId: tvm.functionId(onSuccess),
            onErrorId:  tvm.functionId(onError),
            time: 0,
            expire: 0,
            sign: true,
            pubkey: none,
            stateInit: deployState,
            call: {ShoppingList, publicKey}
        });
        tvm.sendrawmsg(deployMsg, 1);
    }

    function onSuccess() public {
        menu();
    }
    
    function creditAccount (address value) public {
        optional (uint) pubkey = 0;
        TvmCell empty;

        TransactableInterface(value).sendTransaction{
            abiVer: 2,
            extMsg: true,
            sign: true,
            pubkey: pubkey,
            time: uint64(now),
            expire: 0,
            callbackId: tvm.functionId(waitBeforeDeploy),
            onErrorId: tvm.functionId(onError)
        }(listAddress, INITIAL_VALUE, false, 3, empty);
    }

    function waitBeforeDeploy () public {
        Sdk.getAccountType(tvm.functionId(checkIfAccountReadyForDeploy), listAddress);
    }

    function checkIfAccountReadyForDeploy (int8 acc_type) public {
        if(acc_type == -1) // Если аккаунт не существует
            waitBeforeDeploy(); // Подождать, пока деньги придут
        else
            statusActions(acc_type);
    }

    function onError(uint32 sdkError, uint32 exitCode) public {
        Terminal.print(0, format("Operation failed! sdkError: {}, exitCode: {}", sdkError, exitCode));
    }

    function menu() public virtual;
}