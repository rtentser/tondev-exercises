pragma ton-solidity >=0.35.0;
pragma AbiHeader expire;
pragma AbiHeader time;
pragma AbiHeader pubkey;

import '../Debot.sol';
import '../Terminal.sol';
import '../Menu.sol';

contract ShoppingListDebot is Debot {
    bytes m_icon;

    function start() public override {
        Terminal.print(tvm.functionId(menu), "Hello, Debot World!");
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
        return [Terminal.ID, Menu.ID];
    }

    function menu() public {
        Menu.select("The Simplest Menu", "It doesn't do much", [
            MenuItem("Just exit", "", tvm.functionId(justExit)),
            MenuItem("Exit with music", "", tvm.functionId(exitWithMusic))
        ]);
    }

    function justExit() public {
        Terminal.print(0, "Goodbye!");
    }

    function exitWithMusic() public {
        Terminal.print(0, "La-la-la! Goodbye!");
    }
}