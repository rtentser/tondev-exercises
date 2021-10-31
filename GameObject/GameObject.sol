pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

import 'GameObjectInterface.sol';

abstract contract GameObject is GameObjectInterface {
    int public lives; // Здоровье объекта, может быть отрицательным
    uint public defence; // Защита объекта

    // Принять урон от отправителя
    function takeDamage(uint damage) external virtual override;
    
    // Принять урон не от отправителя
    function takeDamageFrom(address enemy, uint damage) internal {
        if (damage > defence)
            lives -= int(damage - defence);

        if (isDead())
            kill(enemy);
    }

    // Если жизни закончились, объёкт уничтожен
    function isDead() internal view returns (bool) { // internal, ибо нужен наследникам
        return !(lives > 0);
    }

    // Уничтожить объект. Виртуальный метод, ибо наследники реализуют по разному
    function kill(address killer) internal virtual;

    // Отправить все средства на счёт убийцы и уничтожить объект
    function die(address killer) internal pure {
        killer.transfer(0, false, 160);
    }
}