// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

import {Test} from "forge-std/Test.sol";
import {Triggerable} from "../../src/Triggerable.sol";
import {TriggerManager} from "../../src/infra/TriggerManager.sol";

/// @author philogy <https://github.com/philogy>
abstract contract BaseTriggerableTest is Test {
    address triggerOwner = makeAddr("TRIGGER_OWNER");
    address trigger = makeAddr("FIRST_TRIGGER");
    address attacker = makeAddr("ATTACKER");

    TriggerManager internal constant TRIGGER_MANAGER = TriggerManager(0x7FFf218ae66A6d63540d87b09F5537f6588122df);

    bytes internal DEFAULT_UUID = "feffeac9-6d7f-d949-4d84-e07b38af3e5d";

    constructor() {
        vm.etch(address(TRIGGER_MANAGER), type(TriggerManager).runtimeCode);
        vm.store(address(TRIGGER_MANAGER), bytes32(0x0), bytes32(uint256(uint160(triggerOwner))));
        vm.store(address(TRIGGER_MANAGER), bytes32(uint256(0x1)), bytes32(uint256(uint160(trigger))));
    }
}
