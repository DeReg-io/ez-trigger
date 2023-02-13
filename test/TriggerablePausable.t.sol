// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

import {BaseTriggerableTest} from "./base/BaseTriggerableTest.sol";
import {Pausing} from "./mock/Pausing.sol";

/// @author philogy <https://github.com/philogy>
contract TriggerablePausableTest is BaseTriggerableTest {
    Pausing pausing;

    address owner = makeAddr("PAUSING_OWNER");

    function setUp() public {
        vm.prank(owner);
        pausing = new Pausing();
        assertEq(pausing.owner(), owner);
        assertFalse(pausing.paused());
    }

    function testOwnerCanPause() public {
        vm.prank(owner);
        pausing.directPause();
        assertTrue(pausing.paused());
    }

    function testNotOwnerCannotPause() public {
        vm.prank(attacker);
        vm.expectRevert("Ownable: caller is not the owner");
        pausing.directPause();
    }

    function testTriggerCanPause() public {
        vm.prank(trigger);
        TRIGGER_MANAGER.executeTriggerOf(address(pausing));
        assertTrue(pausing.paused());
    }
}
