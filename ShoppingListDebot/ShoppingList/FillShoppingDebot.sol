pragma ton-solidity >=0.35.0;
pragma AbiHeader expire;
pragma AbiHeader time;
pragma AbiHeader pubkey;

import '../Debot.sol';
import '../Terminal.sol';
import '../Menu.sol';

import 'ExtendedShoppingDebot.sol';

contract FillShoppingDebot is ExtendedShoppingDebot {

        function getDebotInfo() public functionID(0xDEB) view override returns(
        string name, string version, string publisher, string caption, string author,
        address support, string hello, string language, string dabi, bytes icon
    ) {
        name = "FillShoppingDebot";
        version = "1.0";
        publisher = "RTentser Incorporated";
        caption = "Debot for Managing Your Shopping List";
        author = "Roman Tentser";
        support = address.makeAddrStd(0, 0xac8e4ae04cce7a2c565b08e652ea77c83c163ae18bbb4328229086e38b0b4077);
        hello = "Hello, wanna buy something?";
        language = "en";
        dabi = m_debotAbi.get();
        icon = "";
    }

    function getRequiredInterfaces() public view override returns (uint256[] interfaces) {
        return [Terminal.ID, Menu.ID];
    }

    function menu() public override {
        Menu.select("Menu for Your Shopping List", "Add or remove anything you want", [
            MenuItem("Add Purchase", "", tvm.functionId(addPurchase)),
            MenuItem("Show Shopping List", "", tvm.functionId(getPurchases)),
            MenuItem("Remove Item", "", tvm.functionId(removePurchase))
        ]);
    }
}