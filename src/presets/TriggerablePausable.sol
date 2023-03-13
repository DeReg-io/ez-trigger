// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

import {Pausable} from "@oz/security/Pausable.sol";
import {Triggerable} from "../Triggerable.sol";

/// @author philogy <https://github.com/philogy>
abstract contract TriggerablePausable is Pausable, Triggerable {
    constructor(bytes memory _deregInitUUID) Triggerable(_deregInitUUID) {}

    function _onTrigger() internal virtual override {
        _pause();
    }
}
