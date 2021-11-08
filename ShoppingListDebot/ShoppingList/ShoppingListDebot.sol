pragma ton-solidity >=0.35.0;
pragma AbiHeader expire;
pragma AbiHeader time;
pragma AbiHeader pubkey;

import '../Debot.sol';
import '../Terminal.sol';

contract ShoppingListDebot is Debot {
    bytes m_icon;

    function start() public override {
        Terminal.print(0, "Hello, Debot World!");
    }

    function getDebotInfo() public functionID(0xDEB) view override returns(
        string name, string version, string publisher, string caption, string author,
        address support, string hello, string language, string dabi, bytes icon
    ) {
        name = "Shopping List DeBot";
        version = "0.0.1";
        publisher = "RTentser Incorporated";
        caption = "Shopping List Manager";
        author = "Roman Tentser";
        support = address.makeAddrStd(0, 0xac8e4ae04cce7a2c565b08e652ea77c83c163ae18bbb4328229086e38b0b4077);
        hello = "Hello, wanna buy something?";
        language = "en";
        dabi = m_debotAbi.get();
        icon = m_icon;
    }

        function getRequiredInterfaces() public view override returns (uint256[] interfaces) {
            return [Terminal.ID];
        }
}