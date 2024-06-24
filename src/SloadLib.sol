import "./interfaces/IL1Blocks.sol";

address constant L1SLOAD_PRECOMPILE = 0x0000000000000000000000000000000000000101;

address constant L1BLOCKS_PRECOMPILE = 0x5300000000000000000000000000000000000001;

library SloadLib {
    function latestL1BlockNumber() public view returns (uint256) {
        uint256 l1BlockNum = IL1Blocks(L1BLOCKS_PRECOMPILE).latestBlockNumber();
        return l1BlockNum;
    }

    function retrieveFromL1(address target, bytes32 slot) internal returns (bytes memory ret) {
        uint256 l1BlockNum = IL1Blocks(L1BLOCKS_PRECOMPILE).latestBlockNumber();
        bytes memory input = abi.encodePacked(l1BlockNum, target, slot);
        bool success;
        (success, ret) = L1SLOAD_PRECOMPILE.call(input);
        require(success, "SloadLib: retrieveFromL1 failed");
    }
}
