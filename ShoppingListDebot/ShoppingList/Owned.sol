pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

abstract contract Owned {
    uint256 m_ownerPubkey;

    constructor(uint256 pubkey) public {
        require(pubkey != 0, 120);
        tvm.accept();
        m_ownerPubkey = pubkey;
    }

    modifier onlyOwner() {
        require(msg.pubkey() == m_ownerPubkey, 101);
        tvm.accept();
        _;
    }
}