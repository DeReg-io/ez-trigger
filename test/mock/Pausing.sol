// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

import {Pausable} from "@oz/security/Pausable.sol";
import {Ownable} from "@oz/access/Ownable.sol";
import {TriggerablePausable} from "../../src/presets/TriggerablePausable.sol";

/// @author philogy <https://github.com/philogy>
contract Pausing is Pausable, Ownable, TriggerablePausable {
    constructor(bytes memory _deregInitUUID) TriggerablePausable(_deregInitUUID) {}

    function directPause() external onlyOwner {
        _pause();
    }

    function unpause() external onlyOwner {
        _unpause();
    }
}
