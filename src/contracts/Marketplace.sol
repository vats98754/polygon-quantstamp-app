// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.3.0/contracts/token/ERC721/IERC721.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.3.0/contracts/token/ERC721/IERC721Receiver.sol";

contract Marketplace is IERC721Receiver {
    struct Asset {
        uint256 id;
        address owner;
        string name;
        string description;
        uint256 price;
        bool isListed;
    }

    mapping(uint256 => Asset) public assets;
    uint256 public assetCount;

    mapping(address => mapping(uint256 => bool)) public userAssets;
    mapping(address => uint256[]) public userAssetIds;

    event AssetListed(uint256 id, address owner, string name, uint256 price);
    event AssetSold(uint256 id, address seller, address buyer, uint256 price);

    // ERC721 contract reference
    IERC721 private nftContract;

    constructor(address _nftContract) {
        nftContract = IERC721(_nftContract);
    }

    function listAsset(uint256 _tokenId, string memory _name, string memory _description, uint256 _price) external {
        require(nftContract.ownerOf(_tokenId) == msg.sender, "You don't own this asset");
        require(!_isAssetListed(_tokenId), "Asset is already listed");

        assetCount++;
        assets[assetCount] = Asset(assetCount, msg.sender, _name, _description, _price, true);

        // Transfer asset to the marketplace contract
        nftContract.safeTransferFrom(msg.sender, address(this), _tokenId);

        userAssets[msg.sender][_tokenId] = true;
        userAssetIds[msg.sender].push(_tokenId);

        emit AssetListed(assetCount, msg.sender, _name, _price);
    }

    function buyAsset(uint256 _assetId) external payable {
        require(_isAssetListed(_assetId), "Asset is not available for sale");
        require(msg.value >= assets[_assetId].price, "Insufficient funds");

        address payable seller = payable(assets[_assetId].owner);
        uint256 price = assets[_assetId].price;

        // Transfer the asset to the buyer
        nftContract.safeTransferFrom(address(this), msg.sender, _assetId);

        // Update asset ownership and listing status
        assets[_assetId].owner = msg.sender;
        assets[_assetId].isListed = false;

        // Transfer funds to the seller
        seller.transfer(price);

        emit AssetSold(_assetId, seller, msg.sender, price);
    }

    // ERC721Receiver function to handle incoming asset transfers
    function onERC721Received(
        address,
        address,
        uint256,
        bytes calldata
    ) external pure override returns (bytes4) {
        return this.onERC721Received.selector;
    }

    // Internal function to check if an asset is listed
    function _isAssetListed(uint256 _assetId) internal view returns (bool) {
        return assets[_assetId].isListed;
    }
}
