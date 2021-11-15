pragma ton-solidity >=0.35.0;
pragma AbiHeader expire;
pragma AbiHeader time;
pragma AbiHeader pubkey;

import 'BaseShoppingDebot.sol';
import 'ShoppingInterface.sol';

abstract contract ExtendedShoppingDebot is BaseShoppingDebot {
    string constant SEPARATOR = "============";
    
    string tempName;
    uint tempID;

    function getSummaryMasked() public {
        getSummary();
    }

    function getPurchases() public {
        optional (uint) none;
        ShoppingInterface(listAddress).getList {
            abiVer: 2,
            extMsg: true,
            sign: true,
            pubkey: none,
            time: uint64(now),
            expire: 0,
            callbackId: tvm.functionId(showPurchases),
            onErrorId: tvm.functionId(onError)
        } ();
    }

    function showPurchases(Purchase[] list) public {
        if (list.length > 0) {
            for (uint p = 0; p < list.length; p++) {
                Terminal.print( 0, format(
                    "ID: {} \n Purchase name: {} \n Quantity: {} \n Time added: {} \n Status: {} \n Money payed: {} \n {}",
                    list[p].id,
                    list[p].name,
                    list[p].quantity,
                    list[p].timeAdded,
                    list[p].isBought ? "Bought" : "Not bought",
                    list[p].price,
                    SEPARATOR)
                );
            }
        } else {
            Terminal.print(0, "Your shopping list is empty!");
        }
        getSummaryMasked();
    }

    function getSummary() public override{
        optional (uint) none;
        ShoppingInterface(listAddress).getSummary {
            abiVer: 2,
            extMsg: true,
            sign: true,
            pubkey: none,
            time: uint64(now),
            expire: 0,
            callbackId: tvm.functionId(showSummary),
            onErrorId: tvm.functionId(onError)
        } ();
    }

    function showSummary(Summary summ) public {
        Terminal.print(0, format(
            "Payed items: {} \n Not payed items: {} \n Money spent: {} \n {}",
            summ.payed,
            summ.notPayed,
            summ.moneySpent,
            SEPARATOR
        ));
        menu();
    }

    function addPurchase() public {
        Terminal.input(tvm.functionId(addPurchase_), "Please enter the name of the item: ", false);
    }

    function addPurchase_(string value) public {
        tempName = value;
        Terminal.input(tvm.functionId(addPurchase__), "Please enter the quantity of the purchase: ", false);
    }

    function addPurchase__(string value) public {
        (uint quantity, bool success) = stoi(value);
        if (success) {
            optional (uint) none;
            ShoppingInterface(listAddress).addPurchase{
                abiVer: 2,
                extMsg: true,
                sign: true,
                pubkey: none,
                time: uint64(now),
                expire: 0,
                callbackId: tvm.functionId(getSummaryMasked),
                onErrorId: tvm.functionId(onError)
            } (tempName, quantity);
        } else {
            Terminal.print(tvm.functionId(getSummaryMasked), "It's not a valid quantity!");
        }
    }

    function removePurchase() public {
        Terminal.input(tvm.functionId(removePurchase_), "Please enter the purchase's id: ", false);
    }

    function removePurchase_(string value) public {
        (uint id, bool success) = stoi(value);
        if (success) {
            optional (uint) none;
            ShoppingInterface(listAddress).removePurchase{
                abiVer: 2,
                extMsg: true,
                sign: true,
                pubkey: none,
                time: uint64(now),
                expire: 0,
                callbackId: tvm.functionId(getSummaryMasked),
                onErrorId: tvm.functionId(onError)
            } (id);
        } else {
            Terminal.print(tvm.functionId(getSummaryMasked), "It's not a valid id!");
        }
    }

    function buy() public {
        Terminal.input(tvm.functionId(buy_), "Please enter the purchase's id: ", false);
    }

    function buy_(string value) public {
        (uint id, bool success) = stoi(value);
        if (success) {
            tempID = id;
            Terminal.input(tvm.functionId(buy__), "Please enter the price of the purchase: ", false);
        } else {
            Terminal.print(tvm.functionId(getSummaryMasked), "It's not a valid id!");
        }
    }

    function buy__(string value) public {
        (uint price, bool success) = stoi(value);
        if (success) {
            optional (uint) none;
            ShoppingInterface(listAddress).buy{
                abiVer: 2,
                extMsg: true,
                sign: true,
                pubkey: none,
                time: uint64(now),
                expire: 0,
                callbackId: tvm.functionId(getSummaryMasked),
                onErrorId: tvm.functionId(onError)
            } (tempID, price);
        } else {
            Terminal.print(tvm.functionId(getSummaryMasked), "It's not a valid price!");
        }
    }

    function menu() public virtual;
}