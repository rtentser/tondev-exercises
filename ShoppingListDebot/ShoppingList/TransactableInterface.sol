pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

interface TransactableInterface {
    function sendTransaction (address) external;
}