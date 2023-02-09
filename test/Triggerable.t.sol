// SPDX-License-Identifier: GPL-3.0-only
pragma solidity 0.8.15;

import {Test} from "forge-std/Test.sol";
import {TriggerManager} from "../src/TriggerManager.sol";

/// @author philogy <https://github.com/philogy>
contract TriggerableTest is Test {
    address triggerOwner = makeAddr("TRIGGER_OWNER");
    address trigger = makeAddr("FIRST_TRIGGER");

    TriggerManager internal constant TRIGGER_MANAGER = TriggerManager(0x7FFf218ae66A6d63540d87b09F5537f6588122df);

    function setUp() public {
        vm.etch(address(TRIGGER_MANAGER), type(TriggerManager).runtimeCode);
        emit log_named_address("TRIGGER_MANAGER.owner()", TRIGGER_MANAGER.owner());
    }

    function testEmpty() public {}
}
