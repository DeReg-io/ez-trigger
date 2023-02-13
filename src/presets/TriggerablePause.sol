// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

import {Pausable} from "@oz/security/Pausable.sol";
import {Triggerable} from "../Triggerable.sol";

/// @author philogy <https://github.com/philogy>
abstract contract TriggerablePause is Pausable, Triggerable {
    function _onEmergencyTrigger() internal virtual override {
        _pause();
    }
}
