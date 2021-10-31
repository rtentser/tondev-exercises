pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

import 'GameObject.sol';

contract BaseStation is GameObject {
    GameObject[] public units;

    constructor() public {
        tvm.accept();
        lives = 5;
        defence = 2;
    }

    function addUnit(GameObject unit) public {
        tvm.accept();
        units.push(unit);
    }

    function removeUnit(GameObject unit) public {
        tvm.accept();
        for (uint u = 0; u < units.length; u++)
            if (units[u] == unit) {
                units[u] = units[units.length - 1];
                units.pop();
                break;
            }
    }

    function takeDamage(uint damage) external override{
        tvm.accept();
        takeDamageFrom(msg.sender, damage);
    }

    function kill(address killer) internal override {
        tvm.accept();
        for (uint u = 0; u < units.length; u++) // При гибели базовой станции
            units[u].takeDamage(0); // Гибнут все приписанные к ней юниты
        die(killer);
    }
}