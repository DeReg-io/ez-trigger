// SPDX-License-Identifier: GPL-3.0-only
pragma solidity 0.8.15;

import {Owned} from "solmate/auth/Owned.sol";
import {ITriggerable} from "../interfaces/ITriggerable.sol";

/// @author philogy <https://github.com/philogy>
contract TriggerManager is Owned {
    address public trigger;

    event TriggerChanged(address indexed prevTrigger, address indexed newTrigger);

    error NotAuthorizedTrigger();

    constructor(address initialOwner, address initialTrigger) Owned(initialOwner) {
        emit TriggerChanged(address(0), trigger = initialTrigger);
    }

    function setTrigger(address newTrigger) external onlyOwner {
        emit TriggerChanged(trigger, newTrigger);
        trigger = newTrigger;
    }

    function executeTriggerOf(address target) external {
        if (msg.sender != trigger && msg.sender != owner) revert NotAuthorizedTrigger();
        ITriggerable(target).executeTrigger();
    }
}
