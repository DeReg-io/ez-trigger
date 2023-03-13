// SPDX-License-Identifier: GPL-3.0-only
pragma solidity 0.8.15;

import {Triggerable} from "src/Triggerable.sol";

/// @author philogy <https://github.com/philogy>
contract RepeatTriggerable is Triggerable("4f2c4196-a82b-4b33-8f8d-ef477b8f3b41") {
    uint256 public triggeredCount;

    event Triggered(uint256 count);

    function _onTrigger() internal override {
        unchecked {
            emit Triggered(triggeredCount++);
        }
    }
}
