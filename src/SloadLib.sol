import "./interfaces/IL1Block.sol";

address constant L1SLOAD_PRECOMPILE = 0x0000000000000000000000000000000000000101;

address constant L1BLOCKS_PRECOMPILE = 0x5300000000000000000000000000000000000001;
uint256 constant NUMBER_SLOT = 0;

library SloadLib {
    function latestL1BlockNumber() public view returns (uint256) {
        uint256 l1BlockNum = IL1Blocks(L1BLOCKS_PRECOMPILE).latestBlockNumber();
        return l1BlockNum;
    }

    function retrieveFromL1(address target) internal returns (uint256 l1Number) {
        uint256 l1BlockNum = IL1Blocks(L1BLOCKS_PRECOMPILE).latestBlockNumber();
        bytes memory input = abi.encodePacked(l1BlockNum, target, NUMBER_SLOT);
        bool success;
        bytes memory ret;
        (success, ret) = L1SLOAD_PRECOMPILE.call(input);
        if (success) {
            (l1Number) = abi.decode(ret, (uint256));
        } else {
            revert("L1SLOAD failed");
        }
    }
}
