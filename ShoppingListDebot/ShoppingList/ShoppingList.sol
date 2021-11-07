pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

import 'ShoppingListInterface.sol';
import 'Owned.sol';
import 'Purchase.sol';
import 'ShoppingSummary.sol';

contract ShoppingList is ShoppingListInterface, Owned {
    Purchase[] public shoppingList;
    ShoppingSummary public summary;
    uint public nextID;

    constructor() public Owned(msg.pubkey()) {
        summary = ShoppingSummary(0,0,0);
        nextID = 0;
    }

    function findID(uint id) internal returns(uint) {
        for (uint p = 0; p < shoppingList.length; p++)
            if(shoppingList[p].id == id)
                return p;
        revert(98, "Этот товар не найден в списке."); // Если id не найден, то ошибка
    }

    function addPurchase(string name, uint quantity) public onlyOwner {
        Purchase purchase = Purchase(nextID, name, quantity, tx.timestamp, false, 0);
        shoppingList.push(purchase);
        summary.notPayed += quantity;
        nextID++;
    }

    function removePurchase(uint id) public onlyOwner {
        uint index = findID(id);
                
        if(shoppingList[index].isBought) {
            summary.payed -= shoppingList[index].quantity;
            summary.moneySpent -= shoppingList[index].price;
        }
        else
            summary.notPayed -= shoppingList[index].quantity;
        
        shoppingList[index] = shoppingList[shoppingList.length - 1];
        shoppingList.pop();
    }

    function buy(uint id, uint price) public onlyOwner {
        uint index = findID(id);
        require(!shoppingList[index].isBought, 97, "Этот товар уже куплен.");

        shoppingList[index].isBought = true;
        shoppingList[index].price = price;
        
        summary.payed += shoppingList[index].quantity;
        summary.notPayed -= shoppingList[index].quantity;
        summary.moneySpent += price;
    }
}