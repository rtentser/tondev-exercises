pragma ton-solidity >=0.35.0;
pragma AbiHeader expire;
pragma AbiHeader time;
pragma AbiHeader pubkey;

import 'Purchase.sol';
import 'Summary.sol';

interface ShoppingInterface {
    function getList() external returns (Purchase[] list);
    function getSummary() external returns (Summary summ);

    function addPurchase(string name, uint quantity) external;
    function removePurchase(uint id) external;
    function buy(uint id, uint price) external;
}