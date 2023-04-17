// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {ITriggerable} from "./interfaces/ITriggerable.sol";
import {UUIDLib} from "./utils/UUIDLib.sol";
import {DEREG_TRIGGER_MANAGER_V0_2} from "./interfaces/ITriggerableConstants.sol";

/// @author philogy <https://github.com/philogy>
abstract contract Triggerable is ITriggerable {
    bytes32 private immutable __COMPACT_DEREG_USER_UUID;

    error UnauthorizedTrigger();

    constructor(bytes memory _deregInitUUID) {
        __COMPACT_DEREG_USER_UUID = UUIDLib.toCompact(_deregInitUUID);
    }

    function DEREG_OWNER_UUID() external view returns (bytes memory) {
        return UUIDLib.fromCompact(__COMPACT_DEREG_USER_UUID);
    }

    function executeTrigger() external {
        if (msg.sender != DEREG_TRIGGER_MANAGER_V0_2) revert UnauthorizedTrigger();
        _onTrigger();
    }

    function _onTrigger() internal virtual;
}
