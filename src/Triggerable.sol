// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

import {ITriggerable} from "./interfaces/ITriggerable.sol";

/// @author philogy <https://github.com/philogy>
abstract contract Triggerable is ITriggerable {
    // TODO: Set deployed trigger address
    address internal constant _DEREG_TRIGGER = 0x7FFf218ae66A6d63540d87b09F5537f6588122df;

    error UnauthorizedTrigger();

    function executeEmergencyTrigger() external {
        if (msg.sender != _DEREG_TRIGGER) revert UnauthorizedTrigger();
        _onEmergencyTrigger();
    }

    function _onEmergencyTrigger() internal virtual;
}
