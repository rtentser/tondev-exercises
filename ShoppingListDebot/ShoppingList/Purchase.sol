pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

struct Purchase {
    uint id;
    string name;
    uint quantity;
    uint timeAdded;
    bool isBought;
    uint price;
}