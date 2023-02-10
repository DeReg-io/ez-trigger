// SPDX-License-Identifier: GPL-3.0-only
pragma solidity 0.8.15;

import {Test} from "forge-std/Test.sol";
import {TriggerManager} from "../src/TriggerManager.sol";
import {SimpleTriggerable} from "./mock/SimpleTriggerable.sol";

/// @author philogy <https://github.com/philogy>
contract TriggerableTest is Test {
    address triggerOwner = makeAddr("TRIGGER_OWNER");
    address trigger = makeAddr("FIRST_TRIGGER");
    address attacker = makeAddr("ATTACKER");

    TriggerManager internal constant TRIGGER_MANAGER = TriggerManager(0x7FFf218ae66A6d63540d87b09F5537f6588122df);
    SimpleTriggerable triggerable;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    event TriggerChanged(address indexed prevTrigger, address indexed newTrigger);

    function setUp() public {
        vm.etch(address(TRIGGER_MANAGER), type(TriggerManager).runtimeCode);
        vm.store(address(TRIGGER_MANAGER), bytes32(0x0), bytes32(uint256(uint160(triggerOwner))));
        vm.store(address(TRIGGER_MANAGER), bytes32(uint256(0x1)), bytes32(uint256(uint160(trigger))));
        assertEq(TRIGGER_MANAGER.trigger(), trigger);
        triggerable = new SimpleTriggerable();

        assertFalse(triggerable.wasTriggered());
    }

    function test_fuzzing_deployment(address _owner, address _trigger) public {
        vm.expectEmit(true, true, true, true);
        emit OwnershipTransferred(address(0), _owner);
        vm.expectEmit(true, true, true, true);
        emit TriggerChanged(address(0), _trigger);
        TriggerManager tm = new TriggerManager(_owner, _trigger);
        assertEq(tm.owner(), _owner);
        assertEq(tm.trigger(), _trigger);
    }

    function test_fuzzing_ownerCanSetTrigger(address _newTrigger) public {
        vm.expectEmit(true, true, true, true);
        emit TriggerChanged(TRIGGER_MANAGER.trigger(), _newTrigger);
        vm.prank(TRIGGER_MANAGER.owner());
        TRIGGER_MANAGER.setTrigger(_newTrigger);
        assertEq(TRIGGER_MANAGER.trigger(), _newTrigger);
    }

    function testTriggerCanTrigger() public {
        vm.prank(trigger);
        TRIGGER_MANAGER.executeTriggerOf(address(triggerable));
        assertTrue(triggerable.wasTriggered());
    }

    function testOwnerCanTrigger() public {
        vm.prank(triggerOwner);
        TRIGGER_MANAGER.executeTriggerOf(address(triggerable));
        assertTrue(triggerable.wasTriggered());
    }

    function testNonTriggerCannotTrigger() public {
        vm.prank(attacker);
        vm.expectRevert(TriggerManager.NotAuthorizedTrigger.selector);
        TRIGGER_MANAGER.executeTriggerOf(address(triggerable));
    }

    function testNonOwnerCannotSetTrigger() public {
        vm.prank(attacker);
        vm.expectRevert("UNAUTHORIZED");
        TRIGGER_MANAGER.setTrigger(makeAddr("BAD_TRIGGER"));
    }
}
