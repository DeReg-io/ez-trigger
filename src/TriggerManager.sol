// SPDX-License-Identifier: GPL-3.0-only
pragma solidity 0.8.15;

import {Owned} from "solmate/auth/Owned.sol";
import {ITriggerable} from "./interfaces/ITriggerable.sol";

/// @author philogy <https://github.com/philogy>
contract TriggerManager is Owned {
    address public trigger;

    event TriggerChanged(address indexed prevTrigger, address indexed newTrigger);

    error NotTrigger();

    constructor(address _initialOwner) Owned(_initialOwner) {}

    function setTrigger(address _newTrigger) external onlyOwner {
        emit TriggerChanged(trigger, _newTrigger);
        trigger = _newTrigger;
    }

    function executeTrigger(ITriggerable _target) external {
        if (msg.sender != trigger) revert NotTrigger();
        _target.executeEmergencyTrigger();
    }
}
