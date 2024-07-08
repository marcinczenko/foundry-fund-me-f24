// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../../src/FundMe.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";

contract FundMeTest is Test {
    FundMe fundMe;
    DeployFundMe deployFundMe;

    address immutable USER = makeAddr("user");
    uint256 constant SEND_VALUE = 0.1 ether;
    uint256 constant INITIAL_BALANCE = 1 ether;

    modifier funded() {
        vm.prank(USER);
        fundMe.fund{value: SEND_VALUE}();
        _;
    }

    function setUp() external {
        deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();
        vm.deal(USER, INITIAL_BALANCE);
    }

    function testMinimalDollarIsFive() public view {
        uint256 minDollar = fundMe.MINIMUM_USD();
        assertEq(minDollar, 5 * 10 ** 18);
    }

    function testOwnerIsDeployer() public view {
        address owner = fundMe.getOwner();
        assertEq(owner, msg.sender);
    }

    function testPriceFeedVersionIsAccurate() public view {
        uint256 version = fundMe.getVersion();
        assertEq(version, 4);
    }

    function testFundFailsWithoutEnoughEther() public {
        vm.expectRevert("You need to spend more ETH!");
        fundMe.fund();
    }

    function testFundUpdatesTheFunders() public funded {
        assertEq(fundMe.getAddressToAmountFunded(USER), SEND_VALUE);
    }

    function testFundAddsFunderToRegisteredFunders() public funded {
        address funder = fundMe.getFunder(0);
        assertEq(funder, USER);
    }

    function testThereAreNoDuplicateFunders() public funded {
        vm.prank(USER);
        fundMe.fund{value: SEND_VALUE}();
        vm.startPrank(fundMe.getOwner());
        uint256 numberOfFunders = fundMe.getNumberOfFunders();
        address[] memory funders = fundMe.getFunders();
        vm.stopPrank();
        console.log("--------- funders (start) ---------");
        for (uint256 i = 0; i < funders.length; i++) {
            console.log(funders[i]);
        }
        console.log("--------- funders (end) ---------");
        assertEq(numberOfFunders, 1);
    }

    function testOnlyOwnerCanWithdraw() public funded {
        vm.prank(USER);
        vm.expectRevert();
        fundMe.withdraw();
    }

    function testWithdrawWithASingleFunder() public funded {
        uint256 startingOwnerBalance = fundMe.getOwner().balance;
        uint256 startinFundMeBalance = address(fundMe).balance;

        vm.prank(fundMe.getOwner());
        fundMe.withdraw();

        uint256 endingOwnerBalance = fundMe.getOwner().balance;
        uint256 endingFundMeBalance = address(fundMe).balance;
        assertEq(endingFundMeBalance, 0);
        assertEq(endingOwnerBalance, startingOwnerBalance + startinFundMeBalance);
    }

    function testWithdrawFromMultipleFunders() public {
        address funder1 = makeAddr("funder1");
        vm.deal(funder1, INITIAL_BALANCE);
        address funder2 = makeAddr("funder2");
        vm.deal(funder2, INITIAL_BALANCE);
        address funder3 = makeAddr("funder3");
        vm.deal(funder3, INITIAL_BALANCE);

        vm.prank(funder1);
        fundMe.fund{value: SEND_VALUE}();
        vm.prank(funder2);
        fundMe.fund{value: SEND_VALUE}();
        vm.prank(funder3);
        fundMe.fund{value: SEND_VALUE}();

        uint256 startingOwnerBalance = fundMe.getOwner().balance;
        uint256 startinFundMeBalance = address(fundMe).balance;

        vm.prank(fundMe.getOwner());
        fundMe.withdraw();

        uint256 endingOwnerBalance = fundMe.getOwner().balance;
        uint256 endingFundMeBalance = address(fundMe).balance;
        assertEq(endingFundMeBalance, 0);
        assertEq(endingOwnerBalance, startingOwnerBalance + startinFundMeBalance);
    }

    function antotherTestWithdrawingFromManyFunders() public funded {
        uint160 numberOfFunders = 10;
        uint160 startingFunderIndex = 1;

        for (uint160 i = startingFunderIndex; i < numberOfFunders; i++) {
            hoax(address(i), SEND_VALUE);
            fundMe.fund{value: SEND_VALUE}();
        }

        uint256 startingOwnerBalance = fundMe.getOwner().balance;
        uint256 startinFundMeBalance = address(fundMe).balance;

        vm.startPrank(fundMe.getOwner());
        fundMe.withdraw();
        vm.stopPrank();

        assertEq(address(fundMe).balance, 0);
        assertEq(fundMe.getOwner().balance, startingOwnerBalance + startinFundMeBalance);
    }
}
