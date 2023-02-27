// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

import {Pausable} from "@oz/security/Pausable.sol";
import {Triggerable} from "../Triggerable.sol";

/// @author philogy <https://github.com/philogy>
abstract contract TriggerablePausable is Pausable, Triggerable {
    constructor(bytes32 _deregInitID) Triggerable(_deregInitID) {}

    function _onTrigger() internal virtual override {
        _pause();
    }
}
