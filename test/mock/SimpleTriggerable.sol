// SPDX-License-Identifier: GPL-3.0-only
pragma solidity 0.8.15;

import {Triggerable} from "src/Triggerable.sol";

/// @author philogy <https://github.com/philogy>
contract SimpleTriggerable is Triggerable {
    bool public wasTriggered;

    function _onTrigger() internal override {
        wasTriggered = true;
    }
}
