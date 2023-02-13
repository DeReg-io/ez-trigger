// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

import {Pausable} from "@oz/security/Pausable.sol";
import {Ownable} from "@oz/access/Ownable.sol";
import {TriggerablePause} from "../../src/presets/TriggerablePause.sol";

/// @author philogy <https://github.com/philogy>
contract Pausing is Pausable, Ownable, TriggerablePause {
    function directPause() external onlyOwner {
        _pause();
    }

    function unpause() external onlyOwner {
        _unpause();
    }
}
