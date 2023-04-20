// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

import {Pausable} from "@oz/security/Pausable.sol";
import {Ownable} from "@oz/access/Ownable.sol";
import {Triggerable} from "../../src/Triggerable.sol";

/// @author philogy <https://github.com/philogy>
contract Pausing is Pausable, Ownable, Triggerable {
    constructor(bytes memory _deregInitUUID) Triggerable(_deregInitUUID) {}

    function directPause() external onlyOwner {
        _pause();
    }

    function unpause() external onlyOwner {
        _unpause();
    }

    function _onTrigger() internal override {
        _pause();
    }
}
