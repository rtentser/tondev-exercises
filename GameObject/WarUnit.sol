pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

import 'GameObject.sol';
import 'BaseStation.sol';

contract WarUnit is GameObject {
    uint256 public attack; // Атака Военного Юнита
    BaseStation baseStation; // Адрес Базовой Станции, к которой приписан Военный Юнит

    constructor(BaseStation station) public {
        tvm.accept();
        lives = 3; // Здоровье Военного Юнита по умолчанию равно 3
        baseStation = station;
        baseStation.addUnit(this);
    }

    function takeDamage(uint damage) external override {
        tvm.accept();
        if (msg.sender == baseStation) // Если юнит погиб из-за гибели базовой станции
            die(baseStation); // Юнит гибнет безусловно, убирать его с базовой станции нет нужды
            // Деньги уходят базовой станции... и могут остаться у неё из-за ассинхронности
        else // Иначе наносится урон, и проверяется, не погиб ли юнит
            takeDamageFrom(msg.sender, damage);
    }

    function attackObject (GameObjectInterface target) public view {
        tvm.accept();
        target.takeDamage(attack);
    }   

    function kill(address killer) internal override {
        tvm.accept();
        baseStation.removeUnit(this);
        die(killer);
    }

}