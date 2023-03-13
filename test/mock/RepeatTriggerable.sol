// SPDX-License-Identifier: GPL-3.0-only
pragma solidity 0.8.15;

import {Triggerable} from "src/Triggerable.sol";

/// @author philogy <https://github.com/philogy>
contract RepeatTriggerable is Triggerable {
    uint256 public triggeredCount;

    event Triggered(uint256 count);

    constructor(bytes memory _deregInitUUID) Triggerable(_deregInitUUID) {}

    function _onTrigger() internal override {
        unchecked {
            emit Triggered(triggeredCount++);
        }
    }
}
