// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {ITriggerable} from "./interfaces/ITriggerable.sol";
import {UUIDLib} from "./utils/UUIDLib.sol";
import {DEREG_TRIGGER_MANAGER_V0_2} from "./interfaces/ITriggerableConstants.sol";

/// @author philogy <https://github.com/philogy>
abstract contract RevokableTriggerable is ITriggerable {
    bytes32 private immutable __COMPACT_DEREG_USER_UUID;
    address private __triggerManager;

    error UnauthorizedTrigger();

    /**
     * @dev Sets the contract's `DEREG_OWNER_UUID` and initial authorized trigger address.
     */
    constructor(bytes memory uuid) {
        __COMPACT_DEREG_USER_UUID = UUIDLib.toCompact(uuid);
        // Set initial default trigger.
        __triggerManager = DEREG_TRIGGER_MANAGER_V0_2;
    }

    /**
     * @dev Unpack stored UUID and return. 
     * @return The contract's set UUID in the expected format including dashes.
     */
    function DEREG_OWNER_UUID() external view returns (bytes memory) {
        return UUIDLib.fromCompact(__COMPACT_DEREG_USER_UUID);
    }

    /**
     * @return The address that's currently authorized to call `executeTrigger()`.
     */
    function _triggerManager() internal view returns (address) {
        return __triggerManager;
    }

    /**
     * @dev Checks whether the caller is authorized to execute the trigger and calls the internal
     * `_onTrigger` method.
     */
    function executeTrigger() external {
        if (msg.sender != __triggerManager) revert UnauthorizedTrigger();
        _onTrigger();
    }

    function _onTrigger() internal virtual;

    /**
     * @dev Changes the address that's authorized to call `executeTrigger()` to `newTrigger`.
     * @param newTrigger Address of the new account authorized to call `executeTrigger()`.
     */
    function _updateTrigger(address newTrigger) internal {
        __triggerManager = newTrigger;
    }

    /**
     * @dev Disables the ability for the `executeTrigger()` to be called by setting the "trigger
     * manager" to the `0xdead` address.
     */
    function _disableTrigger() internal {
        __triggerManager = address(0xdead);
    }
}
