pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

import 'WarUnit.sol';

contract Warrior is WarUnit{
    constructor(BaseStation station) WarUnit(station) public {
        tvm.accept();
        attack = 2;
        defence = 2;
    }    
}