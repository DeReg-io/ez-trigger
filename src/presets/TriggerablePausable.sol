// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Pausable} from "@oz/security/Pausable.sol";
import {Triggerable} from "../Triggerable.sol";

/// @author philogy <https://github.com/philogy>
/// @dev A mixin that'll execute OpenZeppelin's `_pause` when triggered.
abstract contract TriggerablePausable is Pausable, Triggerable {
    constructor(bytes memory _deregInitUUID) Triggerable(_deregInitUUID) {}

    function _onTrigger() internal virtual override {
        _pause();
    }
}
