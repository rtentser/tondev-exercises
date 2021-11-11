pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

import 'Purchase.sol';
import 'Summary.sol';

interface ShoppingInterface {
    function getList() external view returns (Purchase[]);
    function getSummary() external view returns (Summary);

    function addPurchase(string name, uint quantity) external;
    function removePurchase(uint id) external;
    function buy(uint id, uint price) external;
}