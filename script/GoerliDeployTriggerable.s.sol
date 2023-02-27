// SPDX-License-Identifier: GPL-3.0-only
pragma solidity 0.8.15;

import {Script} from "forge-std/Script.sol";
import {Test} from "forge-std/Test.sol";
import {RepeatTriggerable} from "../test/mock/RepeatTriggerable.sol";

/// @author philogy <https://github.com/philogy>
contract GoerliDeployTriggerableScript is Script, Test {
    function run() external {
        uint256 managerDeployKey = vm.envUint("WORK_KEY");

        vm.startBroadcast(managerDeployKey);

        RepeatTriggerable triggerable = new RepeatTriggerable(vm.envBytes32("INIT_ID"));

        emit log_named_address("address(triggerable)", address(triggerable));

        vm.stopBroadcast();
    }
}
