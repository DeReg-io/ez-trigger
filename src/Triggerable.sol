// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

import {ITriggerable} from "./interfaces/ITriggerable.sol";
import {UUIDLib} from "./utils/UUIDLib.sol";

/// @author philogy <https://github.com/philogy>
abstract contract Triggerable is ITriggerable {
    address internal constant _DEREG_TRIGGER = 0x7FFf218ae66A6d63540d87b09F5537f6588122df;

    bytes32 private immutable __COMPACT_DEREG_USER_UUID;

    error UnauthorizedTrigger();

    constructor(bytes memory _deregInitUUID) {
        __COMPACT_DEREG_USER_UUID = UUIDLib.toCompact(_deregInitUUID);
    }

    function DEREG_OWNER_UUID() external view returns (bytes memory) {
        return UUIDLib.fromCompact(__COMPACT_DEREG_USER_UUID);
    }

    function executeTrigger() external {
        if (msg.sender != _DEREG_TRIGGER) revert UnauthorizedTrigger();
        _onTrigger();
    }

    function _onTrigger() internal virtual;
}
