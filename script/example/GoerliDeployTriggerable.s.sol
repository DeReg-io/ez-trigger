// SPDX-License-Identifier: GPL-3.0-only
pragma solidity 0.8.15;

import {Script} from "forge-std/Script.sol";
import {Test} from "forge-std/Test.sol";
import {RepeatTriggerable} from "./RepeatTriggerable.sol";

/// @author philogy <https://github.com/philogy>
contract GoerliDeployTriggerableScript is Script, Test {
    function run() external {
        uint256 managerDeployKey = vm.envUint("DEPLOY_PRIV_KEY");

        vm.startBroadcast(managerDeployKey);

        RepeatTriggerable triggerable = new RepeatTriggerable();

        emit log_named_address("address(triggerable)", address(triggerable));

        vm.stopBroadcast();
    }
}
