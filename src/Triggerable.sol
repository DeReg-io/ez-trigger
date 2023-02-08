// SPDX-License-Identifier: GPL-3.0-only
pragma solidity 0.8.15;

import {ITriggerable} from "./interfaces/ITriggerable.sol";

/// @author philogy <https://github.com/philogy>
abstract contract Triggerable is ITriggerable {
    // TODO: Set deployed trigger address
    address internal constant _DEREG_TRIGGER = 0x0000000000000000000000000000000000000000;

    function trigger() external {
        require(msg.sender == _DEREG_TRIGGER, "GCBv1: Unauthorized trigger");
        _onEmergencyTrigger();
    }

    function _onEmergencyTrigger() internal virtual;
}
