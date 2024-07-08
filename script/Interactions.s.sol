// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Script, console} from "forge-std/Script.sol";
import {DevOpsTools} from "foundry-devops/src/DevOpsTools.sol";
// import {DevOpsTools} from "lib/foundry-devops/src/DevOpsTools.sol";
import {FundMe} from "../src/FundMe.sol";

contract FundFundMe is Script {
    uint256 constant SEND_VALUE = 0.01 ether;

    function fundFundMe(address contractAddress, address sender) public {
        console.log("sender=", sender);
        console.log("senderBalance[below]=", sender.balance);
        vm.startBroadcast(sender);
        FundMe fundMe = FundMe(payable(contractAddress));
        fundMe.fund{value: SEND_VALUE}();
        vm.stopBroadcast();
        console.log("senderBalance[after]=", sender.balance);
    }

    function fundFundMe(address contractAddress) public {
        fundFundMe(contractAddress, msg.sender);
    }

    function run() external {
        console.log("block.chainid", block.chainid);
        address contractAddress = DevOpsTools.get_most_recent_deployment("FundMe", block.chainid);
        console.log("contractAddress", contractAddress);
        fundFundMe(contractAddress);
    }
}

contract WithdrawFundMe is Script {
    function withdrawFundMe(address contractAddress) public {
        console.log("sender=", msg.sender);
        console.log("senderBalance[below]=", msg.sender.balance);
        vm.startBroadcast();
        FundMe fundMe = FundMe(payable(contractAddress));
        fundMe.withdraw();
        vm.stopBroadcast();
        console.log("senderBalance[after]=", msg.sender.balance);
    }

    function run() external {
        address contractAddress = DevOpsTools.get_most_recent_deployment("FundMe", block.chainid);
        withdrawFundMe(contractAddress);
    }
}

contract GetInfo is Script {
    function printFunders(FundMe fundMe) public view {
        address[] memory funders = fundMe.getFunders();
        for (uint256 funderIndex = 0; funderIndex < funders.length; funderIndex++) {
            address funder = funders[funderIndex];
            uint256 amountFunded = fundMe.getAddressToAmountFunded(funder);
            console.log("funder= %s  |  amountFunded= %s", funder, amountFunded);
        }
    }

    function getFundMeInfo(address contractAddress) public {
        vm.startBroadcast();
        FundMe fundMe = FundMe(payable(contractAddress));
        address owner = fundMe.getOwner();
        printFunders(fundMe);
        vm.stopBroadcast();
        console.log("contract owner=", owner);
    }

    function run() external {
        address contractAddress = DevOpsTools.get_most_recent_deployment("FundMe", block.chainid);
        getFundMeInfo(contractAddress);
    }
}
